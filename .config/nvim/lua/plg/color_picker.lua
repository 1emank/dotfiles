local opts = { noremap = true, silent = true }

return {
    'ziontee113/color-picker.nvim',
    keys = {
        { '<C-c>', '<cmd>PickColor<cr>', mode = 'n', unpack(opts) },
        { '<C-c>', '<cmd>PickColorInsert<cr>', mode = 'i', unpack(opts) },
    },
    opts = {
        icons = { '+', '-' },
        border = 'none',
    },
}
