
-- General mappings
require('config')
require('plugins')
require('colorscheme')
require('settings')
require('keymappings')


-- LSP
require('lsp')
require('lsp.js-ts-ls')
require('lsp.yaml-ls')
require('lsp.json-ls')
require('lsp.lua-ls')
require('lsp.bash-ls')
require('lsp.efm-general-ls')


-- Plugins


-- require('nv-lspinstall')
require('nv-barbar')
require('nv-nvimtree')
require('nv-galaxyline')
require('nv-compe')
require('nv-dashboard')
require('nv-telescope')
require('nv-treesitter')
require('nv-nvimtree')
require('nv-gitblame')
require('nv-gitsigns')
require('nv-lspkind')
require('nv-lightbulb')

require('nv-utils')




-- Which Key (Hope to replace with Lua plugin someday)
-- nvcode
vim.cmd('source ~/.config/nvim/vimscript/nv-whichkey/init.vim')






