-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = nixCats('have_nerd_font')

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs / indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrapping and whitespace
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- UI / behavior
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 50
vim.opt.inccommand = 'split'

-- Search behavior
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Filesystem / security
vim.g.netrw_liststyle = 3
vim.o.exrc = true
vim.o.secure = true

-- Undo / clipboard
vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'
