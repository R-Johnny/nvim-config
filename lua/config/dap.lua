local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

vim = vim

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			require("dapui").setup()
			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup()

			local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						js_debug_path .. "/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			dap.configurations.javascript = {
				{
					name = "Launch current file (Node)",
					type = "pwa-node",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					console = "integratedTerminal",
				},
				{
					name = "Attach to process",
					type = "pwa-node",
					request = "attach",
					processId = require("dap.utils").pick_process,
					cwd = vim.fn.getcwd(),
				},
			}
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF5555", bold = true })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#FFB86C", bold = true })
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#50FA7B", bold = true })
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴", -- or "🐞", "", "🟥", etc.
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "󰜴",
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "✖",
				texthl = "DiagnosticSignHint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟥", -- 👈 your conditional breakpoint icon
				texthl = "DiagnosticSignWarn",
				linehl = "",
				numhl = "",
			})
			-- Automatically open/close DAP-UI when debugging starts/stops
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Keymaps
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F12>", dap.restart)
			vim.keymap.set("n", "<F11>", function()
				require("dap").terminate()
			end, { desc = "Stop debugger" })

			vim.keymap.set("n", "<Leader>b", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })

			vim.keymap.set("n", "<Leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set conditional breakpoint" })

			vim.keymap.set("n", "<Leader>?", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Hover variable values" })

			vim.keymap.set("n", "<Leader>u", dapui.toggle, { desc = "Toggle DAP UI" })
		end,
	},
}
