local command = vim.api.nvim_create_user_command
-- vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
--     pattern = "",
--     callback = function(ev)
--         print(string.format('event fired: %s', vim.inspect(ev)))
--     end
-- })

command('PrintLua', function(opts)
    local result = vim.fn.split(tostring(loadstring(opts.args)()), '\n')
    local line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, line, line, false, result)
end, { nargs = 1 })

return {}
