return {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    keys = {
        {
            '<leader>qd',
            function() require('persistence').stop() end,
            desc = 'Persistence stop',
        },
        {
            '<leader>ql',
            function() require('persistence').load({ last = true }) end,
            desc = 'Persistence load last',
        },
        {
            '<leader>qS',
            function() require('persistence').select() end,
            desc = 'Persistence select',
        },
        {
            '<leader>qs',
            function() require('persistence').load() end,
            desc = 'Persistence load',
        },
    },
    opts = {},
}
