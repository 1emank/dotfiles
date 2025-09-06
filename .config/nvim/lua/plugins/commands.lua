local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

command('PrintLua', function(opts)
    local result = vim.fn.split(tostring(loadstring(opts.args)()), '\n')
    local line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, line, line, false, result)
end, { nargs = 1 })

return {}
