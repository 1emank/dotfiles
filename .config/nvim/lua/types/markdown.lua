vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.md',
    once = true,
    callback = function() require('render-markdown').setup() end,
})

return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            opts = {},
        },
        'echasnovski/mini.icons',
    },
    opts = {},
}
