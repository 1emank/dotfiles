return {
    {
        'folke/trouble.nvim',
        opts = {
            autoclose = true,
        },
        cmd = 'Trouble',
        keys = {
            {
                '<leader>xx',
                '<cmd>Trouble diagnostics toggle<cr>',
                desc = 'Diagnostics (Trouble)',
            },
            {
                '<leader>xX',
                '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                desc = 'Buffer Diagnostics (Trouble)',
            },
            {
                '<leader>cs',
                '<cmd>Trouble symbols toggle focus=false<cr>',
                desc = 'Symbols (Trouble)',
            },
            {
                '<leader>cl',
                '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                desc = 'LSP Definitions / references / ... (Trouble)',
            },
            {
                '<leader>xL',
                '<cmd>Trouble loclist toggle<cr>',
                desc = 'Location List (Trouble)',
            },
            {
                '<leader>xQ',
                '<cmd>Trouble qflist toggle<cr>',
                desc = 'Quickfix List (Trouble)',
            },
        },
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            preset = 'helix',
            delay = 200,
            win = {
                padding = { 0, 0 },
                border = false,
                title = false,
            },
        },
        keys = { --what is dis?
            {
                '<leader>?',
                function() require('which-key').show({ global = false }) end,
                desc = 'Buffer Local Keymaps (which-key)',
            },
        },
    },
}
