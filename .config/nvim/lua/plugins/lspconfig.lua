vim.lsp.enable({
    'bashls',
    'lua_ls',
    'pyright',
    'rust_analyzer',
})

vim.diagnostic.config({
    -- virtual_lines = true,
    virtual_text = true,
    underline = true,
    signs = true,
})

return {
    {
        'neovim/nvim-lspconfig',
        enabled = true,
        config = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                            special = { reload = 'require' },
                        },
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            -- library = {
                            --   [vim.fn.stdpath("data") .. "/lazy/neovim/lua"] = true,
                            --   [vim.fn.stdpath("config")] = true,
                            -- },
                            library = vim.api.nvim_get_runtime_file('', true),
                            maxPreload = 10000,
                            preloadFileSize = 10000,
                        },
                        completion = { callSnippet = 'Replace' },
                    },
                },
            })
        end,
    },
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
}
