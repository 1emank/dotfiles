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
                variable = '#6666ff',
                keyword = '#ff0000',
            },
        },
    }
    require('github-theme').setup({
        options = {
            hide_end_of_buffer = false,
            styles = {
                comments = 'italic',
                keywords = 'bold',
                types = 'italic,bold',
            },
        },
    })
    vim.g.THEMES = {
        light = 'github_light_default',
        dark = 'github_dark_default',
    }
    -- vim.cmd('colorscheme github_dark')
    vim.cmd('colorscheme ' .. vim.g.THEMES[vim.g.THEME])
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
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 9998,
    config = theme_config,
}
