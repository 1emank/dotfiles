local from_repo = false
local local_repo = vim.fn.expand('~/repos/nvim/shelly')
local origin = 'git@github.com:1emank/shelly.git'

local spec = {
    opts = {
        default = 'bash',
        { 'python3', name = 'Python' },
        { { 'tmux', 'new-session', '-A', '-s', 'main' }, name = 'Tmux' },
    },
    keys = {
        { '<leader>so', '<cmd>Shelly overview<cr>', desc = 'Shelly overview' },
        {
            '<leader>ss',
            function() require('shelly').default() end,
            desc = 'Toggle default shell'
        },
        {
            '<leader>sp',
            function() require('shelly').by_name('Python') end,
            desc = 'Toggle Python shell'
        },
        {
            '<leader>st',
            function() require('shelly').by_index(2) end,
            desc = 'Toggle Tmux shell'
        },
        {
            '<leader>sh',
            function() require('shelly').hide() end,
            desc = 'Hide shell'
        },
    },
}

if from_repo
then table.insert(spec, 1, origin)
---@diagnostic disable-next-line: undefined-field
elseif (vim.uv or vim.loop).fs_stat(local_repo)
then spec['dir'] = local_repo
else spec = {}
end

return spec
