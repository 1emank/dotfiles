---@alias Command {
    ---[1]?: string | table<string>,
    ---["name"]?: string,
    ---["keys"]: string,
---}

---@type table<Command>
local shells = {
    {
        keys = '<leader>ss'
    },
    {
        'bash', keys = '<leader>sb'
    },
    {
        'python3', name = 'Python', keys = '<leader>sp'
    },
    {
        { 'tmux', 'new-session', '-A', '-s', 'main' },
        name = 'Tmux', keys = '<leader>sm'
    },
}

local from_repo = true
local local_repo = '~/repos/nvim/shelly'
local origin = 'git@github.com:1emank/shelly.git'
local spec = {
    opts = { shells = shells },
    keys = {
        { '<leader>tt', '<cmd>Shelly overview<cr>' },
    }
}

---@diagnostic disable-next-line: undefined-field
if from_repo then
    table.insert(spec, 1, origin)
elseif (vim.uv or vim.loop).fs_stat(local_repo) then
    spec['dir'] = local_repo
else
    spec = {}
end

return spec
