return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
	},
	build = "make tiktoken", -- Only on MacOS or Linux
	config = function()
		local copilot = require("CopilotChat")
		copilot.setup({
			model = "gpt-4.1",
			temperature = 0.2,
			sticky = "#buffers",
		})

		vim.keymap.set("n", "<leader>cc", copilot.toggle, { desc = "Toggle Copilot Chat" })
		vim.keymap.set("v", "<leader>cc", copilot.open, { desc = "Open Copilot Chat" })
	end,
}
