#include <atomic>
#include <bee/lua/binding.h>
#include <bee/utility/lockqueue.h>
#include <bee/utility/semaphore.h>
#include <functional>
#include <lua.hpp>
#include <map>
#include <queue>
#include <string>
#include <thread>

extern "C" {
#include <lua-seri.h>
}

namespace bee::lua_thread {
    
#if !defined(BEE_THREAD_MODULE)

extern "C" int luaopen_bee(lua_State* L);
extern "C" int luaopen_bee_filesystem(lua_State* L);
extern "C" int luaopen_bee_filewatch(lua_State* L);
extern "C" int luaopen_bee_platform(lua_State* L);
extern "C" int luaopen_bee_serialization(lua_State* L);
extern "C" int luaopen_bee_socket(lua_State* L);
extern "C" int luaopen_bee_subprocess(lua_State* L);
BEE_LUA_API int luaopen_bee_thread(lua_State* L);
extern "C" int luaopen_bee_time(lua_State* L);
#if defined(_WIN32)
extern "C" int luaopen_bee_registry(lua_State* L);
extern "C" int luaopen_bee_unicode(lua_State* L);
extern "C" int luaopen_bee_wmi(lua_State* L);
#endif

static luaL_Reg CMODULE[] = {
    {"bee", luaopen_bee},
    {"bee.filesystem", luaopen_bee_filesystem},
    {"bee.filewatch", luaopen_bee_filewatch},
    {"bee.platform", luaopen_bee_platform},
    {"bee.serialization", luaopen_bee_serialization},
    {"bee.socket", luaopen_bee_socket},
    {"bee.subprocess", luaopen_bee_subprocess},
    {"bee.thread", luaopen_bee_thread},
    {"bee.time", luaopen_bee_time},
#if defined(_WIN32)
    {"bee.registry", luaopen_bee_registry},
    {"bee.unicode", luaopen_bee_unicode},
    {"bee.wmi", luaopen_bee_wmi},
#endif
    {NULL, NULL},
};

#define BEE_THREAD_MODULE CMODULE

#endif

    class channel : public lockqueue<void*> {
    public:
        typedef lockqueue<void*> mybase;

        void push(void* data) {
            mybase::push(data);
            sem.signal();
        }
        void blocked_pop(void*& data) {
            for (;;) {
                if (mybase::pop(data)) {
                    return;
                }
                sem.wait();
            }
        }
        template <class Rep, class Period>
        bool timed_pop(void*& data, const std::chrono::duration<Rep, Period>& timeout) {
            auto now = std::chrono::steady_clock::now();
            if (mybase::pop(data)) {
                return true;
            }
            if (!sem.wait_for(timeout)) {
                return false;
            }
            while (!mybase::pop(data)) {
                if (!sem.wait_until(now + timeout)) {
                    return false;
                }
            }
            return true;
        }

    private:
        semaphore sem;
    };

    class channelmgr {
    public:
        channelmgr() {
            channels.emplace(std::make_pair("errlog", new channel));
        }
        bool create(const std::string& name) {
            std::unique_lock<std::mutex> lk(mutex);
            auto                         it = channels.find(name);
            if (it != channels.end()) {
                return false;
            }
            channels.emplace(std::make_pair(name, new channel));
            return true;
        }
        void clear() {
            std::unique_lock<std::mutex> lk(mutex);
            auto                         it = channels.find("errlog");
            if (it != channels.end()) {
                auto errlog = it->second;
                channels.clear();
                channels.emplace(std::make_pair("errlog", std::move(errlog)));
            }
            else {
                channels.clear();
            }
        }
        std::shared_ptr<channel> query(const std::string& name) {
            std::unique_lock<std::mutex> lk(mutex);
            auto                         it = channels.find(name);
            if (it != channels.end()) {
                return it->second;
            }
            return nullptr;
        }

    private:
        std::map<std::string, std::shared_ptr<channel>> channels;
        std::mutex                                      mutex;
    };

    struct boxchannel {
        std::shared_ptr<channel> c;
        boxchannel(std::shared_ptr<channel> c_) : c(c_) {}
    };

    struct luathread : public std::thread {
        template <typename Fn>
        luathread(int id, Fn&& f)
            : std::thread(std::forward<Fn>(f))
            , _id(id) {}
        int _id;
    };

    static channelmgr       g_channel;
    static std::atomic<int> g_thread_id = 0;
    static int       THREADID;

    static std::string checkstring(lua_State* L, int idx) {
        size_t      len = 0;
        const char* buf = luaL_checklstring(L, idx, &len);
        return std::string(buf, len);
    }

    static int lchannel_push(lua_State* L) {
        boxchannel* bc = (boxchannel*)getObject(L, 1, "channel");
        void*       buffer = seri_pack(L, 1, NULL);
        bc->c->push(buffer);
        return 0;
    }

    static int lchannel_bpop(lua_State* L) {
        boxchannel* bc = (boxchannel*)getObject(L, 1, "channel");
        void*       data;
        bc->c->blocked_pop(data);
        return seri_unpackptr(L, data);
    }

    static int lchannel_pop(lua_State* L) {
        boxchannel* bc = (boxchannel*)getObject(L, 1, "channel");
        void*       data;
        lua_settop(L, 2);
        lua_Number sec = lua_tonumber(L, 2);
        if (sec == 0) {
            if (!bc->c->pop(data)) {
                lua_pushboolean(L, 0);
                return 1;
            }
        }
        else {
            if (!bc->c->timed_pop(data, std::chrono::duration<double>(sec))) {
                lua_pushboolean(L, 0);
                return 1;
            }
        }
        lua_pushboolean(L, 1);
        return 1 + seri_unpackptr(L, data);
    }

    static int lchannel_gc(lua_State* L) {
        boxchannel* bc = (boxchannel*)getObject(L, 1, "channel");
        bc->~boxchannel();
        return 0;
    }

    static int lnewchannel(lua_State* L) {
        std::string name = checkstring(L, 1);
        if (!g_channel.create(name)) {
            return luaL_error(L, "Duplicate channel '%s'", name.c_str());
        }
        return 0;
    }

    static int lchannel(lua_State* L) {
        std::string              name = checkstring(L, 1);
        std::shared_ptr<channel> c = g_channel.query(name);
        if (!c) {
            return luaL_error(L, "Can't query channel '%s'", name.c_str());
        }

        boxchannel* bc = (boxchannel*)lua_newuserdatauv(L, sizeof(boxchannel), 0);
        new (bc) boxchannel(c);
        if (newObject(L, "channel")) {
            luaL_Reg mt[] = {
                {"push", lchannel_push},
                {"pop", lchannel_pop},
                {"bpop", lchannel_bpop},
                {"__gc", lchannel_gc},
                {NULL, NULL},
            };
            luaL_setfuncs(L, mt, 0);
            lua_pushvalue(L, -1);
            lua_setfield(L, -2, "__index");
        }
        lua_setmetatable(L, -2);
        return 1;
    }

    static int lsleep(lua_State* L) {
        lua_Number sec = luaL_checknumber(L, 1);
        std::this_thread::sleep_for(std::chrono::duration<double>(sec));
        return 0;
    }

    struct thread_args {
        std::string   source;
        int           id;
        lua_CFunction param;
        thread_args(std::string&& src, int id_, lua_CFunction f)
            : source(std::forward<std::string>(src)), id(id_), param(f) {}
    };

    static int gen_threadid() {
        for (;;) {
            int id = g_thread_id;
            if (g_thread_id.compare_exchange_weak(id, id + 1)) {
                id++;
                return id;
            }
        }
    }

    static int require_cmodule(lua_State *L) {
        const char* name = (const char*)lua_touserdata(L, 1);
        lua_CFunction f = (lua_CFunction)lua_touserdata(L, 2);
        luaL_requiref(L, name, f, 0);
        return 0;
    }
    static int require_function(lua_State* L, const char* name, lua_CFunction f) {
        lua_pushcfunction(L, require_cmodule);
        lua_pushlightuserdata(L, (void*)name);
        lua_pushlightuserdata(L, (void*)f);
        if (lua_pcall(L, 2, 0, 0) != LUA_OK) {
            lua_pop(L, 1);
            return 1;
        }
        return 0;
    }
    static int require_all(lua_State* L, const luaL_Reg* l) {
        for (; l->name != NULL; l++) {
            require_function(L, l->name, l->func);
        }
        return 0;
    }

    static int thread_luamain(lua_State* L) {
        lua_pushboolean(L, 1);
        lua_setfield(L, LUA_REGISTRYINDEX, "LUA_NOENV");
        luaL_openlibs(L);
        void*        ud = lua_touserdata(L, 1);
        thread_args* args = (thread_args*)ud;
        lua_pushinteger(L, args->id);
        lua_rawsetp(L, LUA_REGISTRYINDEX, &THREADID);
#if defined(BEE_THREAD_MODULE)
        require_all(L, BEE_THREAD_MODULE);
#endif
#if LUA_VERSION_NUM >= 504
        lua_gc(L, LUA_GCGEN, 0, 0);
#endif
        if (luaL_loadbuffer(L, args->source.data(), args->source.size(), args->source.c_str()) != LUA_OK) {
            delete args;
            return lua_error(L);
        }
        lua_CFunction f = args->param;
        delete args;
        if (f == NULL) {
            lua_call(L, 0, 0);
        }
        else {
            lua_pushcfunction(L, f);
            lua_call(L, 1, 0);
        }
        return 0;
    }

    static int msghandler(lua_State* L) {
        const char* msg = lua_tostring(L, 1);
        if (msg == NULL) {
            if (luaL_callmeta(L, 1, "__tostring") && lua_type(L, -1) == LUA_TSTRING)
                return 1;
            else
                msg = lua_pushfstring(L, "(error object is a %s value)", luaL_typename(L, 1));
        }
        luaL_traceback(L, L, msg, 1);
        return 1;
    }

    static void thread_main(void* ud) {
        lua_State* L = luaL_newstate();
        lua_pushcfunction(L, msghandler);
        lua_pushcfunction(L, thread_luamain);
        lua_pushlightuserdata(L, ud);
        if (lua_pcall(L, 1, 0, 1) != LUA_OK) {
            std::shared_ptr<channel> errlog = g_channel.query("errlog");
            if (errlog) {
                size_t      sz;
                const char* str = lua_tolstring(L, -1, &sz);
                void*       errmsg = seri_packstring(str, (int)sz);
                errlog->push(errmsg);
            }
            else {
                printf("thread error : %s", lua_tostring(L, -1));
            }
        }
        lua_close(L);
    }

    static int lthread(lua_State* L) {
        std::string   source = checkstring(L, 1);
        lua_CFunction f = NULL;
        if (!lua_isnoneornil(L, 2)) {
            if (!lua_iscfunction(L, 2) || lua_getupvalue(L, 2, 1) != NULL) {
                return luaL_error(L, "2nd param should be a C function without upvalue");
            }
            f = lua_tocfunction(L, 2);
        }
        LUA_TRY;
        int id = gen_threadid();
        thread_args* args = new thread_args(std::move(source), id, f);
        luathread* thread = new luathread(id, std::bind(thread_main, args));
        lua_pushlightuserdata(L, thread);
        return 1;
        LUA_TRY_END;
    }

    static int lreset(lua_State* L) {
        lua_rawgetp(L, LUA_REGISTRYINDEX, &THREADID);
        int threadid = (int)lua_tointeger(L, -1);
        lua_pop(L, 1);
        if (threadid != 0) {
            return luaL_error(L, "reset must call from main thread");
        }
        g_channel.clear();
        g_thread_id = 0;
        return 0;
    }

    static int lwait(lua_State* L) {
        luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
        luathread* thread = (luathread*)lua_touserdata(L, 1);
        if (thread->joinable()) {
            thread->join();
        }
        thread->~luathread();
        return 0;
    }

    static int lgetid(lua_State* L) {
        luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
        luathread* thread = (luathread*)lua_touserdata(L, 1);
        lua_pushinteger(L, thread->_id);
        return 1;
    }

    static void init_threadid(lua_State* L) {
        if (lua_rawgetp(L, LUA_REGISTRYINDEX, &THREADID) != LUA_TNIL) {
            return;
        }
        lua_pop(L, 1);

        lua_pushinteger(L, 0);
        lua_pushvalue(L, -1);
        lua_rawsetp(L, LUA_REGISTRYINDEX, &THREADID);
    }

    static int luaopen(lua_State* L) {
        luaL_Reg lib[] = {
            {"sleep", lsleep},
            {"thread", lthread},
            {"newchannel", lnewchannel},
            {"channel", lchannel},
            {"reset", lreset},
            {"wait", lwait},
            {"getid", lgetid},
            {NULL, NULL},
        };
        lua_newtable(L);
        luaL_setfuncs(L, lib, 0);
        init_threadid(L);
        lua_setfield(L, -2, "id");
        return 1;
    }
}

DEFINE_LUAOPEN(thread)
