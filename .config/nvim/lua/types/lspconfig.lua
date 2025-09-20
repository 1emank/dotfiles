vim.lsp.config['lua_ls'] = {
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
}

local function config()
    vim.lsp.enable({
        'lua_ls',
        'bashls',
        'pyright',
        'rust_analyzer',
        'clangd',
    })
end

return {
    'neovim/nvim-lspconfig',
    event = 'InsertEnter',
    config = config,
}
