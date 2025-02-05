return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 47,
                side = "right",
            },
            renderer = {
                group_empty = true,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                }
            }
        })

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        vim.keymap.set('n', '<leader>e', vim.cmd.NvimTreeToggle)
    end
}
