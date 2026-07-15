# Configurazione Neovim

Configurazione personale, usata su due macchine:

- MacBook Air M3 (arm64)
- iMac Intel (x86_64)

La config è identica sulle due macchine: tutto ciò che dipende dall'architettura
(binari Mason, parser treesitter, telescope-fzf-native) viene installato/compilato
localmente in `~/.local/share/nvim` e non passa da questa repo.

📖 **[Guida ai plugin](docs/PLUGINS.md)** — cosa fa ogni plugin e con quali tasti.

## Prerequisiti

Da installare su **entrambe** le macchine (con Homebrew: prefix `/opt/homebrew` su
Apple Silicon, `/usr/local` su Intel):

| Tool | Perché serve |
| --- | --- |
| `neovim` ≥ 0.11 | API `vim.lsp.config`, treesitter branch `main` |
| `tree-sitter-cli` | installazione parser (attenzione: la formula `tree-sitter` installa solo la libreria, la CLI è `tree-sitter-cli`) |
| Xcode Command Line Tools | compilazione parser treesitter e telescope-fzf-native |
| `ripgrep` | `Telescope live_grep` |
| `lazygit` | plugin lazygit.nvim |
| `node` | pyright, ts_ls, prettier, eslint_d, ... |
| `python3` | black, isort, pylint |
| `php` | intelephense, php-cs-fixer |
| `R` + pacchetto `languageserver` | r_language_server |
| un Nerd Font nel terminale | icone (devicons, lualine, alpha) |

```bash
brew install neovim tree-sitter-cli ripgrep lazygit node python php r
Rscript -e 'install.packages("languageserver")'
```

## Setup di una macchina nuova

```bash
git clone <questa-repo> ~/.config/nvim
nvim
```

Al primo avvio lazy.nvim si auto-installa, clona i plugin **alle versioni del
lockfile** e Mason scarica LSP/formatter/linter per l'architettura corrente.

## Tenere allineate le due macchine

Il file `lazy-lock.json` è versionato apposta:

1. Aggiorna i plugin su **una sola** macchina (`:Lazy update`), verifica che tutto
   funzioni e committa il lockfile aggiornato.
2. Sull'altra macchina fai `git pull` e poi `:Lazy restore` (**non** `:Lazy update`),
   che porta i plugin esattamente ai commit del lockfile.

## Troubleshooting

- **`attempt to call field 'install' (a nil value)` da nvim-treesitter**: la copia
  locale del plugin è rimasta sul vecchio branch `master`. Fix:
  `rm -rf ~/.local/share/nvim/lazy/nvim-treesitter`, riapri nvim, `:Lazy restore`.
- **`You have local changes in .../lazy/<plugin>`**: clone locale sporco. Fix:
  `rm -rf` della cartella del plugin e `:Lazy restore` (oppure `x` + `I` nella UI
  di lazy).
- **I parser treesitter non si installano**: verifica `tree-sitter --version`
  (serve ≥ 0.25) e che la CLI sia nel PATH; dentro nvim:
  `:echo exepath('tree-sitter')`.
