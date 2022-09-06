local opt = vim.opt

-- Indent
opt.shiftwidth = 2
opt.softtabstop = -1 -- automatically set to shiftwidth's value
opt.expandtab = true

-- line numbers
opt.number = true
opt.relativenumber = true

-- switch between relative & absolute on insert.
-- thanks to https://jeffkreeftmeijer.com/vim-number/
vim.cmd [[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]]
