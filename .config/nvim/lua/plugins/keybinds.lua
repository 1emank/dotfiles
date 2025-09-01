--- Since there are multiple modes, and you may want to do the similar
--- actions between them with the same keybinds, to reduce the necessary
--- text, the multimode function to assign keybinds works like:
--- set( '<input>',
---     { 'modes', 'result', 'optional description' },
---     { 'modes', 'result' },
---     ...
---  )
--- The human logic is:
---     '<input>' in modes 'XY' results in 'A', in mode 'Z' results in 'B',
---     etc, etc ...
---
--- 'n' -> normal
--- 'i' -> insert
--- 'v' -> visual
--- 't' -> terminal
--- 'x' -> visual linea
--- 's' -> select
---@param input string
---@param ... { [1]: string, [2]: string | function, [3]?: string }
local function set_multimode(input, ...)
    local tables = { ... }
    for i = 1, #tables do
        local mode, result, desc = unpack(tables[i])
        local mode_table = {}
        for j = 1, #mode do
            mode_table[j] = mode:sub(j, j)
        end
        vim.keymap.set(mode_table, input, result, { desc = desc })
    end
end

local set = vim.keymap.set
-- set(mode, input, result)

vim.g.mapleader = ' '

---Moves the focus to the window in the desired direction. "dir" must be
---one of [hjkl]
---@param dir string
---@return function
local function move_win(dir)
    return function()
        local target_win = vim.fn.win_getid(vim.fn.winnr(dir))
        if target_win ~= 0 then vim.api.nvim_set_current_win(target_win) end
    end
end

local function term_to_normal()
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true),
        'n',
        true
    )
end

set_multimode('<C-h>', { 'nvxi', move_win('h'), 'Move to left window' })
set_multimode('<C-j>', { 'nvxi', move_win('j'), 'Move to lower window' })
set_multimode('<C-k>', { 'nvxi', move_win('k'), 'Move to upper window' })
set_multimode('<C-l>', { 'nvxi', move_win('l'), 'Move to right window' })
set_multimode('+', { 'n', '$' }, { 'v', '$h', 'End of line' })
set_multimode('gd', { 'n', vim.lsp.buf.definition, 'Go to definition' })

set('t', '<Esc>', term_to_normal)

return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            preset = 'helix',
            delay = 200,
            win = {
                padding = { 0, 0 },
                border = false,
                title = false,
            },
        },
        keys = { --what is dis?
            {
                '<leader>?',
                function() require('which-key').show({ global = false }) end,
                desc = 'Buffer Local Keymaps (which-key)',
            },
        },
    },
}
