----------------------------Leader Key----------------------------

vim.g.mapleader = " "

----------------------------Plugins----------------------------

local plugins = {
{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
--{'hrsh7th/nvim-cmp'},
{'williamboman/mason.nvim'}, {'williamboman/mason-lspconfig.nvim'},
{'neovim/nvim-lspconfig'},
--{'hrsh7th/cmp-nvim-lsp'},
{'L3MON4D3/LuaSnip'},
{"EdenEast/nightfox.nvim"},
{'nvim-treesitter/nvim-treesitter'},
{'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = {'nvim-lua/plenary.nvim'}},
{'mfussenegger/nvim-dap'},
{'nvim-neotest/nvim-nio'},
{'rcarriga/nvim-dap-ui', dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'}},
{'leoluz/nvim-dap-go'},
{'theHamsta/nvim-dap-virtual-text'},
{'akinsho/toggleterm.nvim', version = "*", config = true},
}

local opts = {}

----------------------------Plugin Manager----------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, opts)

----------------------------Plugin Options----------------------------


----------------------------Lsp Zero----------------------------

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

----------------------------Treesitter Highlighting----------------------------

require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  },
}

----------------------------Mason Lsp Manager----------------------------

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
  ensure_installed = { "lua_ls", "tsserver", "cssls", "html", "rust_analyzer", "pyright", "svelte"},
})

require('lspconfig').lua_ls.setup({})
require('lspconfig').svelte.setup({})
require('lspconfig').tsserver.setup({})
require('lspconfig').cssls.setup({})
require('lspconfig').html.setup({})
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').gopls.setup({})
require('lspconfig').pyright.setup({})


----------------------------Themes----------------------------

vim.cmd("colorscheme carbonfox")

----------------------------Dap Debugger----------------------------

require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup({
    show_stop_reason = true,
    only_first_definition = false,
})
require("toggleterm").setup{
    open_mapping = '<Leader>t'
}

----------------------------Keymaps----------------------------

vim.keymap.set({'i'}, 'jk', '<Esc>')
vim.opt.relativenumber = true
vim.opt.clipboard:append("unnamedplus") --Makes copy in nvim go to real clip board

--Make tabs 4 spaces
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

----------------------------Telescope Keymaps----------------------------

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>f', builtin.find_files, {})
vim.keymap.set('n', '<Leader>g', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<Leader>b', builtin.buffers, {})

----------------------------Dap Keymaps----------------------------

local dap = require('dap')
vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<Leader>dc', dap.continue, {})
vim.keymap.set('n', '<Leader>dsi', dap.step_into, {})
vim.keymap.set('n', '<Leader>dso', dap.step_over, {})

vim.keymap.set('n', '<Leader>ui', ":lua require('dapui').open({reset = true})<CR>", {})
vim.keymap.set('n', '<Leader>uc', ":lua require('dapui').close()<CR>", {})

--------------------------------------------------------
