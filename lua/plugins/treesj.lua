-- Tree-sitter-aware structural split/join
return {
  'Wansmer/treesj',
  ft = 'lua',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false,
    max_join_length = 160,
  },
}
-- vim: ts=2 sts=2 sw=2 et
