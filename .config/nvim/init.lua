-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

---@diagnostic disable: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

if os.getenv('THEME') == 'light'
then vim.g.THEME = 'light'
else vim.g.THEME = 'dark'
end
vim.g.HISTORY_DIR = vim.fn.stdpath('config') .. '/history'

local lua_dir = vim.fn.readdir( vim.fn.stdpath('config') .. '/lua' )
local imports = {}
for i = 1, #lua_dir do
    table.insert( imports,
        { import = vim.fn.split(lua_dir[i], '.lua')[1] }
    )
end

require('lazy').setup({
    spec = imports,
    defaults = { lazy = true },
    install = { colorscheme = { 'github_dark_default' } },
    checker = { enabled = true },
})
