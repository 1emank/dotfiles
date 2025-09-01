---@alias Command {
    ---[1]?: string | table<string>,
    ---["name"]?: string,
    ---["keys"]: string,
---}

---@type table<Command>
local shells = {
    {
        keys = '<leader>ss'
    },
    {
        'bash', keys = '<leader>sb'
    },
    {
        'python3', name = 'Python', keys = '<leader>sp'
    },
    {
        { 'tmux', 'new-session', '-A', '-s', 'main' },
        name = 'Tmux', keys = '<leader>sm'
    },
}

return {
    dir = '~/repos/nvim/shelly',
    -- '1emank/shelly',
    opts = {
        shells = shells,
    },
    keys = {
        { '<leader>tt', '<cmd>Shelly overview<cr>' },
    }
}
