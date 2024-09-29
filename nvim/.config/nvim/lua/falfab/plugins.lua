vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer manager itself
    use("wbthomason/packer.nvim")

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        requires = { { "nvim-lua/plenary.nvim" } },
    })

    -- Color scheme
    use({
        "neanias/everforest-nvim",
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup()
        end,
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })

    -- Fugitive
    use("tpope/vim-fugitive")

    -- Coc LSP
    use({ "neoclide/coc.nvim", branch = "release" })

    -- Comment line commands
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Nvim tree
    use("nvim-tree/nvim-tree.lua")

    -- Vim devicons
    use("nvim-tree/nvim-web-devicons")

    -- Git status
    use("lewis6991/gitsigns.nvim")

    -- Vim-tmux navigator
    use("christoomey/vim-tmux-navigator")

    -- Tabs
    use("romgrk/barbar.nvim")

    -- Lazygit
    use({
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        requires = {
            "nvim-lua/plenary.nvim",
    },
})
end)
