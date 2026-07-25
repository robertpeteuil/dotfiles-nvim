-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        opts = {
          ui = {
            -- enable Mason float border, colors set in theme file tokyonight.lua
            border = 'rounded',
          },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('personal-lsp-attach', { clear = true }),
        callback = function(event)
          -- Helper function to add LSP Suffix to hotkey description
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            -- vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc .. ' (LSP)' })
          end

          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, 're[n]ame')

          -- Execute a code action, when cursor on top of LSP error or suggestion
          map('gra', vim.lsp.buf.code_action, 'goto code [a]ction', { 'n', 'x' })

          -- Find references for word under cursor
          map('grr', require('telescope.builtin').lsp_references, 'goto [r]eferences')

          -- Jump to the implementation of word under cursor
          --  Useful if language allows type declaration without implementation
          map('gri', require('telescope.builtin').lsp_implementations, 'goto [i]mplementation')

          -- Jump to definition of word under cursor (<C-t> jumps back)
          --  where variable declared or function defined
          map('grd', require('telescope.builtin').lsp_definitions, 'goto [d]efinition')

          -- Jump to declaration (not definition)
          --  ex: in C, the header
          map('grD', vim.lsp.buf.declaration, 'goto [D]eclaration')

          -- Fuzzy find symbols in current document
          map('gO', require('telescope.builtin').lsp_document_symbols, '[O]pen document symbols')

          -- Fuzzy find symbols in current workspace
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'open [W]orkspace symbols')

          -- Jump to type definition of word under cursor
          map('grt', require('telescope.builtin').lsp_type_definitions, 'goto [t]ype Definition')

          -- Autocommands to highlight/clear references of word under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('personal-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('personal-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'personal-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- toggle inlay hints if language server supports
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'toggle [h]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
        },
        tombi = {},
        jsonls = {},

        bashls = {
          filetypes = { 'bash', 'sh', 'zsh' },
          settings = {
            bashIde = {
              globPattern = '*@(.sh|.inc|.bash|.command|.zsh)',
            },
          },
        },

        basedpyright = {},

        terraformls = {},

        ts_ls = {},

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              format = {
                enable = true,
                -- EmmyLuaCodeStyle defaults used when a workspace does not
                -- provide higher-priority settings in .editorconfig.
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = '2',
                  tab_width = '2',
                  quote_style = 'single',
                  continuation_indent = '2',
                  max_line_length = '160',
                  end_of_line = 'lf',
                  trailing_table_separator = 'keep',
                  call_arg_parentheses = 'keep',
                  space_around_table_field_list = 'true',
                  space_before_function_open_parenthesis = 'false',
                  space_before_function_call_open_parenthesis = 'false',
                  space_before_closure_open_parenthesis = 'false',
                  space_before_function_call_single_arg = 'always',
                  space_inside_function_call_parentheses = 'false',
                  space_inside_function_param_list_parentheses = 'false',
                  space_inside_square_brackets = 'false',
                  space_around_table_append_operator = 'true',
                  space_before_inline_comment = '1',
                  space_after_comment_dash = 'false',
                  space_around_math_operator = 'true',
                  space_after_comma = 'true',
                  space_after_comma_in_for_statement = 'true',
                  space_around_concat_operator = 'true',
                  space_around_assign_operator = 'true',
                  align_call_args = 'false',
                  align_function_params = 'false',
                  align_continuous_assign_statement = 'false',
                  align_continuous_rect_table_field = 'false',
                  align_if_branch = 'false',
                  align_array_table = 'false',
                  align_continuous_similar_call_args = 'false',
                  align_continuous_inline_comment = 'false',
                  align_chain_expr = 'none',
                  line_space_after_if_statement = 'keep',
                  line_space_after_do_statement = 'keep',
                  line_space_after_while_statement = 'keep',
                  line_space_after_repeat_statement = 'keep',
                  line_space_after_for_statement = 'keep',
                  line_space_after_local_or_assign_statement = 'keep',
                  line_space_after_function_statement = 'keep',
                  line_space_after_expression_statement = 'keep',
                  line_space_after_comment = 'keep',
                  line_space_around_block = 'keep',
                  break_all_list_when_line_exceed = 'false',
                  auto_collapse_lines = 'false',
                  break_before_braces = 'false',
                  end_statement_with_semicolon = 'keep',
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- ignore Lua_LS `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        -- Previously used LS
        -- copilot = {
        --   settings = {
        --     telemetry = {
        --       telemetryLevel = 'off',
        --     },
        --   },
        -- },
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prettier',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table, installed above
        -- Servers are configured and enabled explicitly below. This also keeps
        -- formatter-only tools such as StyLua from starting in LSP mode.
        -- IMPORTANT: A future Mason-installed LSP must be added to `servers`
        -- above before it will be enabled.
        automatic_enable = false,
      }

      -- New style lsp config / enable  20260525
      for name, server in pairs(servers) do
        -- handle capability overrides
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
