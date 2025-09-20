local center = {
    {
        desc = ' New File',
        icon = ' ',
        key = 'n',
        action = 'ene | startinsert',
    },
    {
        desc = ' Find File',
        icon = ' ',
        key = 'f',
        action = 'Telescope find_files',
    },
    {
        desc = ' Recent Files',
        icon = ' ',
        key = 'r',
        action = 'Telescope oldfiles',
    },
    {
        desc = ' Find Text',
        icon = ' ',
        key = 'g',
        action = 'Telescope live_grep',
    },
    {
        desc = ' Config',
        icon = ' ',
        key = 'c',
        action = function()
            local old_dir = vim.fn.getcwd()
            vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))
            vim.cmd('Telescope live_grep')
            vim.api.nvim_set_current_dir(old_dir)
        end,
    },
    {
        desc = ' Explore',
        icon = '󰥨 ',
        key = 'e', -- 
        action = 'Telescope file_browser',
    },
    {
        desc = ' Lazy',
        icon = '󰒲 ',
        key = 'l',
        action = 'Lazy',
    },
    {
        desc = ' Update Lazy',
        icon = '󰒲 ',
        key = 'u',
        action = 'Lazy sync',
    },
    {
        desc = ' Quit',
        icon = ' ',
        key = 'q',
        action = function() vim.api.nvim_input('<cmd>qa<cr>') end,
    },
}
local vert_size = table.maxn(center)

local footer = function()
    local stats = require('lazy').stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    return {
        '⚡ Neovim loaded '
            .. stats.loaded
            .. '/'
            .. stats.count
            .. ' plugins in '
            .. ms
            .. 'ms',
        'CWD: ' .. vim.fn.getcwd(),
    }
end
vert_size = vert_size + 2

local header = {
    [[███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
    [[████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
    [[██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
    [[██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
    [[██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
    [[╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
    '',
}
vert_size = vert_size + table.maxn(header)

local upper_padding =
    math.floor((vim.api.nvim_win_get_height(0) - vert_size) / 3)

for _ = 1, upper_padding do
    table.insert(header, 1, '')
end

local function dashboard_opts()
    local options = {
        theme = 'doom',
        hide = {
            -- this is taken care of by lualine
            -- enabling this messes up the actual
            -- laststatus setting after loading a file
            statusline = true,
            tabline = true,
            winbar = true,
        },
        config = { header = header, center = center, footer = footer },
    }

    for _, button in ipairs(options.config.center) do
        button.desc = button.desc .. ' ' .. string.rep('·', 43 - #button.desc)
        button.key_format = ' [%s]'
    end

    if vim.o.filetype == 'lazy' then
        vim.api.nvim_create_autocmd('WinClosed', {
            pattern = tostring(vim.api.nvim_get_current_win()),
            once = true,
            callback = function()
                vim.schedule(
                    function()
                        vim.api.nvim_exec_autocmds('UIEnter', {
                            group = 'dashboard',
                        })
                    end
                )
            end,
        })
    end

    return options
end

return {
    'nvimdev/dashboard-nvim',
    lazy = false,
    -- dependencies = {
    --     'nvim-telescope/telescope.nvim',
    --     'nvim-lua/plenary.nvim' ,
    -- },
    opts = dashboard_opts,
}
