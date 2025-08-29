local function message(msg)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { msg })

    local width = vim.fn.strdisplaywidth(msg)
    local height = 1

    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) * 0.5,
        row = (vim.o.lines - height) * 0.9,
        style = 'minimal',
        -- border = "rounded"
    }

    local win = vim.api.nvim_open_win(buf, false, opts)

    vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, 3000)
end

---@module "telescope.builtin"
local t = require('telescope')

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        keys = {
            { '<leader>ff', t.find_files, desc = 'Telescope find files' },
            { '<leader>fb', t.buffers, desc = 'Telescope buffers' },
            { '<leader>fh', t.help_tags, desc = 'Telescope help tags' },
            { '<leader>fc', t.commands, desc = 'Telescope commands' },
            { '<leader>fr', t.command_history, desc = 'Telescope history' },
            { '<leader>fg', t.live_grep , desc = 'Telescope live_grep', },
        },
    }
}
