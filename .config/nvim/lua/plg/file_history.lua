return {
    'dawsers/file-history.nvim',
    dependencies = {
        'folke/snacks.nvim',
    },
    keys = {
        {
            '<leader>hb',
            function() require('file_history').backup() end,
            silent = true,
            desc = 'named backup for file',
        },
        {
            '<leader>hh',
            function() require('file_history').history() end,
            silent = true,
            desc = 'local history of file',
        },
        {
            '<leader>hf',
            function() require('file_history').files() end,
            silent = true,
            desc = 'local history files in repo',
        },
        {
            '<leader>hq',
            function() require('file_history').query() end,
            silent = true,
            desc = 'local history query',
        },
    },
    opts = {
        backup_dir = '~/.config/nvim/history',
        git_cmd = 'git',
        hostname = nil,
        key_bindings = {
            open_buffer_diff_tab = '<M-d>',
            open_file_diff_tab = '<M-d>',
            revert_to_selected = '<C-r>',
            toggle_incremental = '<M-l>',
            delete_history = '<M-d>',
            purge_history = '<M-p>',
        },
    },
}
