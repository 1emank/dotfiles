local command = vim.api.nvim_create_user_command
-- vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
--     pattern = "",
--     callback = function(ev)
--         print(string.format('event fired: %s', vim.inspect(ev)))
--     end
-- })

print('hi from commands')

return {}
