local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local timer = (vim.uv or vim.loop).new_timer

local function lua_expr_to_file(opts)
    local lines =
        vim.fn.split(vim.inspect(loadstring('return ' .. opts.args)()), '\n')
    vim.api.nvim_put(lines, 'l', true, true)
end
command('LuaExprToFile', lua_expr_to_file, { nargs = 1 })
command('Letf', lua_expr_to_file, { nargs = 1 })

local function lua_output_to_file(opts)
    local out = vim.fn.execute('lua ' .. opts.args)
    local lines = vim.split(out, '\n', { plain = true, trimempty = true })
    vim.api.nvim_put(lines, 'l', true, true)
end
command('LuaOutputToFile', lua_output_to_file, { nargs = 1 })
command('Lotf', lua_output_to_file, { nargs = 1 })

command(
    'LightMode',
    function() vim.cmd('colorscheme ' .. vim.g.LIGHT_MODE) end,
    {}
)
command(
    'DarkMode',
    function() vim.cmd('colorscheme ' .. vim.g.DARK_MODE) end,
    {}
)

autocmd('VimEnter', {
    callback = function()
        local cmd = {
            'find',
            vim.g.HISTORY_DIR,
            '-type',
            'f',
            '-mtime',
            '+30',
            '-delete',
        }

        vim.fn.jobstart(cmd, {
            on_stderr = function(_, data, _)
                if data and #data > 0 and data[1] ~= "" then
                    vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
                end
            end,
        })
    end,
})

timer():start(
    180000, 180000,
    vim.schedule_wrap(function ()
        local buffer_id = vim.api.nvim_get_current_buf()
        local buftype = vim.bo[buffer_id].buftype

        if vim.bo[buffer_id].modified
            and buftype == ""
            and not vim.opt.ro:get()
            and vim.bo[buffer_id].modifiable
        then
            vim.cmd("silent write")
        end
    end)
)

return {}
