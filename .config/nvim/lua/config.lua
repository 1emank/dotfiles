vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.undofile = true

-- indent-related
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.breakindent = true -- keep indent in wrapped lines

-- for search "/"
vim.o.ignorecase = true
vim.o.smartcase = true

-- limit text
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.colorcolumn = '80'
vim.o.tw = 79
vim.o.winwidth = 85

-- auto save swap file after {} miliseconds idle
vim.o.updatetime = 200
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.mouse = 'a'
vim.o.showmode = true

vim.o.list = true
vim.opt.fillchars:append({ eob = '·' })
vim.opt.listchars = {
    tab = '| ',
    trail = '·',
    nbsp = '_',
}

vim.o.scrolloff = 7
vim.o.cmdheight = 1

vim.o.foldmethod = 'indent'
vim.o.foldlevel = 999
vim.o.foldenable = true

return {}
