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

local function theme_config()
    -- Default options
    -- require('github-theme').setup({
    --     options = {
    --         -- Compiled file's destination location
    --         compile_path = vim.fn.stdpath('cache') .. '/github-theme',
    --         compile_file_suffix = '_compiled', -- Compiled file suffix
    --         hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
    --         hide_nc_statusline = true, -- Override the underline style for non-active statuslines
    --         transparent = false, -- Disable setting bg (make neovim's background transparent)
    --         terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    --         dim_inactive = false, -- Non focused panes set to alternative background
    --         module_default = true, -- Default enable value for modules
    --         styles = { -- Style to be applied to different syntax groups
    --             comments = 'NONE', -- Value is any valid attr-list value `:help attr-list`
    --             functions = 'NONE',
    --             keywords = 'NONE',
    --             variables = 'NONE',
    --             conditionals = 'NONE',
    --             constants = 'NONE',
    --             numbers = 'NONE',
    --             operators = 'NONE',
    --             strings = 'NONE',
    --             types = 'NONE',
    --         },
    --         inverse = { -- Inverse highlight for different types
    --             match_paren = false,
    --             visual = false,
    --             search = false,
    --         },
    --         darken = { -- Darken floating windows and sidebar-like windows
    --             floats = true,
    --             sidebars = {
    --                 enable = true,
    --                 list = {}, -- Apply dark background to specific windows
    --             },
    --         },
    --         modules = { -- List of various plugins and additional options
    --             -- ...
    --         },
    --     },
    --     palettes = {},
    --     specs = {},
    --     groups = {},
    -- })

    local override = require('github-theme.override')
    override.specs = {
        github_dark_default = {
            syntax = {
                string = '#ff6666',
                variable = '#4d4dff',
                keyword = '#ff0000',
            },
        },
    }
    require('github-theme').setup({
        options = {
            hide_end_of_buffer = false,
            styles = {
                comments = 'italic',
                keywords = 'italic,bold',
                types = 'italic,bold',
            },
        },
    })
    -- vim.cmd('colorscheme github_dark')
    vim.cmd('colorscheme github_dark_default')
    -- vim.cmd('colorscheme github_dark_dimmed')
    -- vim.cmd('colorscheme github_dark_high_contrast')
    -- vim.cmd('colorscheme github_dark_colorblind') -- beta
    -- vim.cmd('colorscheme github_dark_tritanopia') -- beta
    -- vim.cmd('colorscheme github_light')
    -- vim.cmd('colorscheme github_light_default')
    -- vim.cmd('colorscheme github_light_high_contrast')
    -- vim.cmd('colorscheme github_light_colorblind') -- beta
    -- vim.cmd('colorscheme github_light_tritanopia') -- beta
end

return {
    {
        'nvimdev/dashboard-nvim',
        lazy = true,
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        opts = dashboard_opts,
    },
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,
        priority = 9998,
        config = theme_config,
    },
}
