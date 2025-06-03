vim.keymap.set("n", "<leader>co", ":e /home/robert/.config/nvim/init.lua<CR>", { desc = "[C]onfig [O]pen" })

vim.api.nvim_create_user_command("OC", "e /home/robert/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("OpenConfig", "e /home/robert/.config/nvim/init.lua", {})
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
local job_id = 0
--Run File in term
vim.keymap.set("n", "<leader>rc", function()
	local filepath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local filename = filepath:match("([^/]+)$")
	vim.api.nvim_command("write!")
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	job_id = vim.bo.channel
	local runcmd = "node"
	vim.fn.chansend(job_id, string.format("%s %s \r\n", runcmd, filename))
end)

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custon-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- Move selected lines down in visual mode and reselect
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Move selected lines up in visual mode and reselect
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines while maintaining the cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll down while keeping the cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Scroll up while keeping the cursor centered
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search forward and center the search result
vim.keymap.set("n", "n", "nzzzv")

-- Search backward and center the search result
vim.keymap.set("n", "N", "Nzzzv")

-- Restart the LSP server
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Paste in visual mode while keeping the original copied content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Copy to system clipboard in normal and visual modes
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>P", [["+P]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>P", [["+p]])

-- Delete without yanking to the default register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Remap Ctrl+c in insert mode to act as Escape
-- vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable the Q command (useful if accidentally pressed)
vim.keymap.set("n", "Q", "<nop>")

-- -- Open a new tmux window and run the tmux-sessionizer script
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format the current buffer using LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Navigate to the next and previous quickfix list entries while centering the view
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Navigate to the next and previous location list entries while centering the view
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace the word under the cursor globally, with interactive completion
vim.keymap.set("n", "<leader>fr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--
-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- Insert Go-style error handling snippets
vim.keymap.set("n", "<leader>cl", "iconsole.log()<Left>")
-- vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
-- vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

-- Open the Neovim packer configuration file
vim.keymap.set("n", "<leader>vpp", "<cmd>Lazy<CR>")
-- Source the current file (reload it in Neovim)
vim.keymap.set("n", "<leader>aa", function()
	vim.cmd("so")
end)
