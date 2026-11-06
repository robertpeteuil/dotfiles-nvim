vim.treesitter.start(0, 'devicetree')
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
