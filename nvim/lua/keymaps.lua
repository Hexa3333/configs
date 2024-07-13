-- A recap might help
-- MASTER THESE

local opts = { noremap = true, silent = true }
-- noremap: no recurse map, silent: don't output in the bar

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation: Using Ctrl+h/j/k/l
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Create windows: Using Ctrl+n(vertical) or Ctrl+b(horizontal)
keymap("n", "<C-n>", ":vsplit<CR>", opts)
keymap("n", "<C-b>", ":split<CR>", opts)

-- Explorer
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize windows: Ctrl+arrowkeys
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers: Alt+j(prev) or Alt+k(next)
keymap("n", "<A-k>", ":bnext<CR>", opts)
keymap("n", "<A-j>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode while moving a text
-- Shift+leftarrow or Shift+rightarrow (a similar thing applies in normal mode for single lines)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", opts)

-- cancel visual mode
keymap("v", "jk", "<ESC>", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- WRITE/QUIT
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("n", "<C-q>", ":q<CR>", opts)



-- (Deleting cuts)
-- KEEP YOUR CLIPBOARD AFTER PASTING OVER
keymap("v", "p", '"_dP', opts)
