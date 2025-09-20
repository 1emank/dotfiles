return {
    'folke/which-key.nvim',
    event = 'InsertEnter',
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
}
