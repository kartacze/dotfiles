vim.api.nvim_set_keymap('n', '<C-n>', ':BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':BufferPrevious<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-n>', ':BufferMoveNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-p>', ':BufferMovePrevious<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>d', ':BufferClose<CR>', { noremap = true, silent = true })
