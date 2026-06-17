# Personal Neovim Configuration

Personal Neovim configuration for day-to-day editing workflow.
- Includes Lua-based configuration, `lazy.nvim` plugin management, LSP support, Git tooling, search/navigation helpers, and AI-assisted editing integrations
- small collection of quality-of-life adjustments

Frequent refactors and changes are common.

## Requirements

- Neovim 0.12+
- `git`
- `make` and a C compiler for native plugin builds
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) for Telescope search
- [`fd`](https://github.com/sharkdp/fd) recommended for shell/file workflows
- [`jq`](https://jqlang.github.io/jq/) for JSONL pretty-view support
- A Nerd Font, enabled in `init.lua` with `vim.g.have_nerd_font = true`
- Optional language/tool runtimes depending on the files being edited, such as `node`, `npm`, `go`, or `python`

## Installation

Back up any existing Neovim config first.

```sh
git clone <this-repo-url> "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs plugins. Use `:Lazy` to inspect, update, or sync plugin state.

## Repository Layout

```text
init.lua                  Entry point
lua/options.lua           Core editor options
lua/keymaps.lua           Global keymaps
lua/autocommands.lua      Autocommands and custom behaviors
lua/filetypes.lua         Custom filetype detection
lua/lazy-bootstrap.lua    Plugin manager bootstrap
lua/lazy-plugins.lua      Top-level plugin imports
lua/plugins/              Individual plugin specs
lazy-lock.json            Locked plugin revisions
```

## Included Plugins

Plugin revisions are locked in `lazy-lock.json`. The track column lists the configured version, pinned commit, or branch currently used.

### Core and Configuration

| Plugin | Track | Description |
| --- | --- | --- |
| `folke/lazy.nvim` | `main` | Plugin manager |
| `folke/which-key.nvim` | `main` | Keymap discovery popup |
| `nvim-tree/nvim-web-devicons` | `master` | Filetype icons |

### LSP, Formatting, and Diagnostics

| Plugin | Track | Description |
| --- | --- | --- |
| `neovim/nvim-lspconfig` | `master` | LSP server configuration |
| `mason-org/mason.nvim` | `main` | Tool installer UI |
| `mason-org/mason-lspconfig.nvim` | `main` | Mason LSP bridge |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | `main` | Automatic tool installs |
| `folke/lazydev.nvim` | `main` | Lua config development |
| `j-hui/fidget.nvim` | `main` | LSP progress display |
| `stevearc/conform.nvim` | `master` | Formatting integration |
| `NMAC427/guess-indent.nvim` | `main` | Detect buffer indentation |
| `folke/trouble.nvim` | `main` | Diagnostics and symbols panel |

Configured language servers include `yamlls`, `tombi`, `jsonls`, `bashls`, `basedpyright`, `terraformls`, `copilot`, `ts_ls`, and `lua_ls`. Mason also installs `stylua` and `prettier`.

### Completion, Snippets, and AI Assistance

| Plugin | Track | Description |
| --- | --- | --- |
| `saghen/blink.cmp` | `1.*` | Completion engine |
| `xzbdmw/colorful-menu.nvim` | `master` | Rich completion labels |
| `L3MON4D3/LuaSnip` | `2.*` | Snippet engine |
| `rafamadriz/friendly-snippets` | `main` | Community snippets |
| `supermaven-inc/supermaven-nvim` | `main` | AI completion provider |
| `huijiro/blink-cmp-supermaven` | `main` | Supermaven completion source |
| `saghen/blink.compat` | `2.*` | Compatibility completion source |
| `folke/sidekick.nvim` | pinned `6b69c42` | AI CLI integration |

### Search, Navigation, and Structure

| Plugin | Track | Description |
| --- | --- | --- |
| `nvim-telescope/telescope.nvim` | `master` | Fuzzy finder |
| `nvim-telescope/telescope-fzf-native.nvim` | `main` | Native FZF sorter |
| `nvim-telescope/telescope-ui-select.nvim` | `master` | Telescope select UI |
| `nvim-neo-tree/neo-tree.nvim` | `v3.x` | File tree explorer |
| `nvim-treesitter/nvim-treesitter` | `main` | Syntax parsing |
| `nvim-treesitter/nvim-treesitter-textobjects` | `main` | Treesitter textobjects |
| `alexghergh/nvim-tmux-navigation` | `main` | Neovim/tmux pane movement |
| `nvim-lua/plenary.nvim` | `master` | Lua utility library |
| `folke/snacks.nvim` | `main` | Enhanced input and picker |

### Git Workflow

| Plugin | Track | Description |
| --- | --- | --- |
| `lewis6991/gitsigns.nvim` | `main` | Git signs and hunks |
| `kdheepak/lazygit.nvim` | `main` | LazyGit inside Neovim |
| `sindrets/diffview.nvim` | `main` | Git diff views |
| `FabijanZulj/blame.nvim` | `main` | Inline blame display |
| `tpope/vim-fugitive` | `master` | Git command support |
| `ThePrimeagen/git-worktree.nvim` | `master` | Git worktree switching |
| `isak102/telescope-git-file-history.nvim` | `master` | File history picker |

### UI, Theme, and Visuals

| Plugin | Track | Description |
| --- | --- | --- |
| `folke/tokyonight.nvim` | `main` | Color scheme |
| `xiyaowong/transparent.nvim` | `main` | Transparent background toggle |
| `nvim-lualine/lualine.nvim` | `master` | Statusline |
| `echasnovski/mini.nvim` | `main` | Editing utility modules |
| `lukas-reineke/indent-blankline.nvim` | `master` | Indentation guides |
| `brenoprata10/nvim-highlight-colors` | `main` | Inline color previews |
| `MeanderingProgrammer/render-markdown.nvim` | `main` | Rendered Markdown view |
| `karb94/neoscroll.nvim` | `master` | Smooth scrolling |
| `folke/noice.nvim` | `main` | Command/message UI |
| `MunifTanjim/nui.nvim` | `main` | UI component library |
| `rcarriga/nvim-notify` | `master` | Notification UI |

### Editing Utilities

| Plugin | Track | Description |
| --- | --- | --- |
| `mbbill/undotree` | `master` | Undo history tree |
| `folke/todo-comments.nvim` | `main` | Highlight TODO comments |
| `allworldg/doc-highlight` | `master` | Document symbol highlighting |
| `ThePrimeagen/vim-be-good` | `master` | Vim motion practice |

## Custom Functionality

### Editing and Buffers

- Relative and absolute line numbers enabled by default.
- System clipboard integration is enabled after UI startup.
- Persistent undo is enabled.
- JSONL buffers get `<leader>bj` to open a pretty-printed `jq` view in a new tab.
- `<leader>yd`, `<leader>yp`, and `<leader>yf` yank the current date, absolute path, or file reference.
- `<leader>tv` toggles common boolean-like values such as `true`/`false`, `yes`/`no`, and `on`/`off`.

### Navigation and Layout

- Neo-tree uses `\` for file reveal and `|` for Git status view.
- Neo-tree has custom `h`/`l` behavior for parent/child directory navigation.
- Undotree temporarily hides Neo-tree and restores it when closed.
- Terminal windows can be widened and restored with `<leader>tw` or terminal-mode `<C-_>`.
- tmux and Neovim pane navigation share `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>`.

### Search and Git

- Telescope searches include hidden files while excluding `.git` where appropriate.
- Telescope has shortcuts for files, grep, buffers, diagnostics, help, keymaps, and Neovim config files.
- Gitsigns provides hunk navigation, staging, reset, previews, blame, and diffs.
- LazyGit refreshes Neo-tree after leaving its buffer.

### LSP and Tooling

- Mason ensures configured language servers and formatters are installed.
- LSP diagnostics use custom signs, rounded floats, severity sorting, and virtual text.
- LSP attach maps use Neovim's `gr*` conventions for rename, actions, references, definitions, and type definitions.
- LSP progress is forwarded to terminals that support progress reporting, including tmux-aware escaping.

### AI and External CLI Workflow

- Sidekick integrates installed AI CLIs into Neovim.
- `<leader>aa` opens a `pi` Sidekick terminal using a login shell.
- `<leader>at`, `<leader>af`, `<leader>av`, and `<leader>al` send context to the active Sidekick CLI.
- Supermaven is configured as an AI completion source through `blink.cmp`, with inline completion disabled.

### Filetype Detection

Custom filetype detection is included for:

- Docker Compose YAML files
- GitLab CI YAML files
- Helm template and values YAML files

## Keymap Groups

The leader key is `<Space>`. Major groups are documented through `which-key`:

| Prefix | Group |
| --- | --- |
| `<leader>S` | Sessions |
| `<leader>s` | Search |
| `<leader>t` | Toggles |
| `<leader>g` | Git |
| `<leader>b` | Buffers |
| `<leader>y` | Yank helpers |
| `<leader>x` | Trouble |
| `<leader>a` | AI / Sidekick |
| `gr` | LSP actions |

## Maintenance Notes

- Run `:Lazy sync` to install or update plugins from the lockfile.
- Run `:Lazy update` to update plugin revisions, then commit `lazy-lock.json`.
- Run `:Mason` to inspect installed language servers and formatters.
- Run `:checkhealth` when debugging Neovim, provider, plugin, or LSP issues.
