-- Example configuations here: https://github.com/mattn/efm-langserver
-- lua
local luaFormat = {
    formatCommand = "lua-format -i --no-keep-simple-function-one-line --column-limit=120",
    formatStdin = true
}
-- JavaScript/React/TypeScript
local prettier = {formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}", formatStdin = true}
-- local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
}

local shellcheck = {
    LintCommand = 'shellcheck -f gcc -x',
    lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}
}

local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}

local markdownlint = {
    -- TODO default to global lintrc
    -- lintcommand = 'markdownlint -s -c ./markdownlintrc',
    lintCommand = 'markdownlint -s',
    lintStdin = true,
    lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'}
}

local denofmt = {
  formatCommand = "cat ${INPUT} | deno fmt -",
  formatStdin = true,
}

local markdownPandocFormat = {formatCommand = 'pandoc -f markdown -t gfm -sp --tab-stop=2', formatStdin = true}

local lspconfig = require"lspconfig"

local languages = {
    lua = {luaFormat},
    javascriptreact = { prettier, eslint},
    javascript = { prettier, eslint },
    typescript = { eslint, prettier },
    typescriptreact = { eslint, prettier },
		json = { prettier },
}

on_attach = function(client)
  client.resolved_capabilities.rename = false
  client.resolved_capabilities.hover = false
  client.resolved_capabilities.document_formatting = true
  client.resolved_capabilities.completion = false
end


-- lspconfig.efm.setup {
--     init_options = {documentFormatting = true, codeAction = true },
-- 	root_dir = lspconfig.util.root_pattern("yarn.lock", "lerna.json", ".git"),
-- }

lspconfig.efm.setup {
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(languages),
    init_options = {documentFormatting = true, codeAction = true },
    settings = {
      rootMarkers = { ".git/" },
      languages = languages,
    },
}

-- autoformat
vim.cmd('autocmd BufWritePre *.js lua vim.lsp.buf.formatting()')
-- Also find way to toggle format on save
-- maybe this will help: https://superuser.com/questions/439078/how-to-disable-autocmd-or-augroup-in-vim
