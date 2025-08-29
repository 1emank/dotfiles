return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = true,
            build = ':TSUpdate',
            opts = {},
        },
        'echasnovski/mini.icons',
    },
    opts = {},
}
