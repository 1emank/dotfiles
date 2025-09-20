local blink_build
if vim.fn.executable('rustup') == 1 then
    blink_build = 'cargo +nightly build --release'
else
    blink_build = nil
end

return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        event = 'InsertEnter',
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = 'lazydev',
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    {
        'saghen/blink.cmp',
        event = 'InsertEnter',
        build = blink_build,
        version = '*',
        opts = {
            sources = {
                -- add lazydev to your completion providers
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
        },
    },
}
