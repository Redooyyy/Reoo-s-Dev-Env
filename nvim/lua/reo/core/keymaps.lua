vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

--competitist
keymap.set("n", "<leader>cr", "<cmd>CompetiTest run<CR>", { desc = "Run test cases" }) --run test cases--
keymap.set("n", "<leader>cs", "<cmd>CompetiTest show_ui<CR>", { desc = "Re-open ui" }) --re open ui--
keymap.set("n", "<leader>ct", "<cmd>CompetiTest add_testcase<CR>", { desc = "Add test cases" }) --Add test cases--
keymap.set("n", "<leader>ce", "<cmd>CompetiTest edit_testcase<CR>", { desc = "edit test cases" }) --edit test cases--
keymap.set("n", "<leader>dt", "<cmd>CompetiTest receive testcase<CR>", { desc = "Download testcase" }) --receive test cases--
keymap.set("n", "<leader>dp", "<cmd>CompetiTest receive problem<CR>", { desc = "Download problem" }) --download problem--
keymap.set("n", "<leader>dc", "<cmd>CompetiTest receive contest<CR>", { desc = "download contest" }) --download contest--

--run code--
keymap.set("n", "<leader>rc", "<cmd>RunCode<CR>", { desc = "Run code" }) --Run code--
