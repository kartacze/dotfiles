local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- Quality of life improvements
	-- Just take a close look to this
    use 'norcalli/nvim_utils'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'glepnir/lspsaga.nvim'
    use 'onsails/lspkind-nvim'
    use 'kosayoda/nvim-lightbulb'
    use 'mfussenegger/nvim-jdtls'
	  use "ray-x/lsp_signature.nvim"
	-- use 'kabouzeid/nvim-lspinstall'

    -- Autocomplete
    use 'hrsh7th/nvim-compe'
    use 'mattn/emmet-vim'
    use 'hrsh7th/vim-vsnip'
    use 'xabikos/vscode-javascript'
    use 'dsznajder/vscode-es7-javascript-react-snippets'
    use 'rust-lang/vscode-rust'

    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-treesitter/playground'
    use 'p00f/nvim-ts-rainbow'
    use {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}

	-- Icons
	use 'kyazdani42/nvim-web-devicons'
	use 'ryanoasis/vim-devicons'
	use 'morhetz/gruvbox'

	-- Lines
	use 'romgrk/barbar.nvim'
	use 'glepnir/galaxyline.nvim'

    -- Telescope
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-media-files.nvim'

	-- Explorer
	use 'kyazdani42/nvim-tree.lua'

    -- Git
    use 'TimUntersberger/neogit'
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'f-person/git-blame.nvim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'

	-- General plugins
	use 'windwp/nvim-autopairs'
	use 'kevinhwang91/nvim-bqf'
	use 'mhinz/vim-startify'
	use 'liuchengxu/vim-which-key'
	use 'voldikss/vim-floaterm'
  use 'terrortylor/nvim-comment'
	use 'cohama/lexima.vim'

	use 'JoosepAlviste/nvim-ts-context-commentstring'

end)
