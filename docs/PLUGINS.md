# Guida ai plugin

Riferimento di tutti i plugin della configurazione: cosa fanno, come si usano,
con quali tasti. Il leader è **Spazio**.

Ogni plugin vive in un file sotto `lua/plugins/` (i due dello stack LSP sotto
`lua/plugins/lsp/`). lazy.nvim importa automaticamente tutti i file di quelle
cartelle: per rimuovere un plugin basta cancellare il suo file; per aggiungerne
uno si crea un file che ritorna la spec. Le versioni esatte sono bloccate in
`lazy-lock.json` (vedi README per il workflow tra le due macchine).

> Suggerimento: premi `Spazio` e aspetta mezzo secondo — which-key mostra un
> popup con tutti i tasti disponibili, raggruppati.

---

## Indice

1. [Infrastruttura](#infrastruttura)
2. [Aspetto](#aspetto)
3. [Navigazione file e finestre](#navigazione-file-e-finestre)
4. [Editing](#editing)
5. [Treesitter](#treesitter)
6. [LSP e completamento](#lsp-e-completamento)
7. [Formattazione e linting](#formattazione-e-linting)
8. [Git](#git)
9. [Diagnostica e TODO](#diagnostica-e-todo)
10. [Sessioni](#sessioni)
11. [Terminale e REPL](#terminale-e-repl)
12. [Undo](#undo)

---

## Infrastruttura

### lazy.nvim (folke/lazy.nvim)
Il plugin manager. Si auto-installa al primo avvio (`lua/config/lazy.lua`).

| Comando | Cosa fa |
| --- | --- |
| `:Lazy` | UI: stato dei plugin (`x` rimuove, `I` installa, `U` aggiorna) |
| `:Lazy update` | aggiorna i plugin e riscrive `lazy-lock.json` (farlo su UNA macchina) |
| `:Lazy restore` | porta i plugin alle versioni del lockfile (farlo sull'ALTRA) |
| `:Lazy sync` | install + clean + update |

### plenary.nvim (nvim-lua/plenary.nvim)
Libreria di funzioni Lua usata da telescope, harpoon, todo-comments, lazygit.
Nessuna interazione diretta.

### nvim-web-devicons (nvim-tree/nvim-web-devicons)
Le icone dei filetype (richiede un Nerd Font nel terminale). Usato da
nvim-tree, lualine, bufferline, telescope, trouble.

### mini.nvim (echasnovski/mini.nvim)
Suite di moduli indipendenti. È arrivato come dipendenza di render-markdown;
in `lua/plugins/mini.lua` attiviamo:

- **mini.move** — sposta righe (normal) o selezioni (visual) con `Alt+h/j/k/l`,
  reindentando automaticamente. In Ghostty serve `macos-option-as-alt = true`.
- **mini.splitjoin** — `<leader>j` alterna argomenti/liste tra una riga sola e
  multiriga (es. la firma di una funzione).

`mini.ai` è volutamente spento: i textobject li fornisce
nvim-treesitter-textobjects (vedi [Editing](#editing)).

### snacks.nvim (folke/snacks.nvim)
Sostituisce dressing.nvim (archiviato dall'autore). Attivati solo due moduli:

- **input** — box moderno per `vim.ui.input` (es. `<leader>rn` rename LSP);
- **picker con `ui_select`** — menu per `vim.ui.select` (es. `<leader>ca`
  code action). Telescope resta il picker principale per file/grep.

### which-key.nvim (folke/which-key.nvim)
Premuto un tasto prefisso (es. `Spazio`), dopo 500 ms mostra il popup con i
completamenti possibili e i nomi dei gruppi. È la "documentazione viva" delle
keymap: se non ricordi un tasto, parti da `Spazio` e leggi.

---

## Aspetto

### tokyonight.nvim (folke/tokyonight.nvim)
Il colorscheme (variante `night`), con palette personalizzata per avvicinarsi
ai colori di Ghostty (`lua/plugins/colorscheme.lua`).

### lualine.nvim (nvim-lualine/lualine.nvim)
La statusline in basso: modalità, branch git, diagnostica, encoding, filetype.
Mostra anche un contatore arancione quando lazy ha aggiornamenti disponibili.

### bufferline.nvim (akinsho/bufferline.nvim)
La barra in alto con un "tab" per ogni **buffer** aperto (non per tab vim).
Navigazione tra buffer: `:bnext` / `:bprev` o click.

### alpha-nvim (goolord/alpha-nvim)
La dashboard all'avvio (logo NEOVIM + scorciatoie: nuovo file, explorer,
find file, grep, restore session, quit).

### indent-blankline.nvim (lukas-reineke/indent-blankline.nvim)
Le linee verticali `┊` che marcano i livelli di indentazione.

### render-markdown.nvim (MeanderingProgrammer/render-markdown.nvim)
Rende i file markdown "belli" direttamente nel buffer: heading colorati,
checkbox, tabelle, codice. Si attiva da solo nei file `.md`.
`:RenderMarkdown toggle` per spegnerlo/riaccenderlo.

---

## Navigazione file e finestre

### nvim-tree.lua (nvim-tree/nvim-tree.lua)
File explorer laterale (35 colonne, indent marker, ignora `.DS_Store`).

| Tasto | Cosa fa |
| --- | --- |
| `<leader>ee` | apri/chiudi explorer |
| `<leader>ef` | apri l'explorer sul file corrente |
| `<leader>ec` | collassa le cartelle |
| `<leader>er` | refresh |

Dentro l'albero: `Invio` apre, `a` crea, `d` cancella, `r` rinomina, `x`/`c`/`p`
taglia/copia/incolla, `g?` mostra tutti i tasti.

### telescope.nvim (nvim-telescope/telescope.nvim)
Fuzzy finder per tutto: file, testo, simboli LSP, TODO. Con l'estensione
nativa fzf (compilata con `make`) per l'ordinamento veloce.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>ff` | trova file nella cwd |
| `<leader>fr` | file recenti |
| `<leader>fs` | grep live nella cwd (richiede ripgrep) |
| `<leader>fc` | grep della parola sotto il cursore |
| `<leader>ft` | cerca i TODO/FIXME (todo-comments) |

Dentro il picker (insert mode): `<C-j>`/`<C-k>` su/giù, `<C-q>` manda i
risultati selezionati nella quickfix, `Esc` chiude.
Usato anche dalle keymap LSP (`gd`, `gR`, `gi`, `gt`, `<leader>D`).

### harpoon (ThePrimeagen/harpoon, branch harpoon2)
La "cintura degli attrezzi": marchi i 3–4 file su cui stai lavorando e ci
salti con un tasto, senza passare da fuzzy finder o bufferline.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>a` | aggiungi il file corrente alla lista |
| `<C-e>` | apri/chiudi il menu della lista (editabile come un buffer) |
| `<leader>1`…`<leader>4` | salta al file 1…4 |

La lista è per-progetto (per cwd) e persiste tra le sessioni.

### flash.nvim (folke/flash.nvim)
Salto rapido in qualunque punto visibile: premi `s` + 2 caratteri del punto
dove vuoi andare, appaiono le label, premi la label e ci sei. Funziona anche
tra split diversi e come motion per gli operatori (`ds<char><char><label>`
cancella fino a quel punto).

| Tasto | Modalità | Cosa fa |
| --- | --- | --- |
| `s` | normal, visual, operator | flash jump |
| `S` | normal, operator | seleziona nodi treesitter (espandi con `;`/`,`) |
| `r` | operator | remote: applica l'operatore altrove senza muovere il cursore |
| `<C-s>` | command (durante `/`) | attiva/disattiva le label nella ricerca |

**Nota**: `s` prima era di substitute.nvim, che ora vive su `gs` (vedi sotto).

### vim-tmux-navigator (christoomey/vim-tmux-navigator)
`<C-h/j/k/l>` per muoversi tra split di Neovim E pannelli tmux con gli stessi
tasti, senza pensare a dove sei.

### vim-maximizer (szw/vim-maximizer)
`<leader>sm` massimizza lo split corrente; ripremuto lo riporta alle
dimensioni originali. Utile per concentrarsi su un file senza chiudere gli
altri split.

---

## Editing

### nvim-surround (kylechui/nvim-surround)
Gestione di parentesi/virgolette/tag attorno al testo.

| Tasto | Esempio |
| --- | --- |
| `ys{motion}{char}` | `ysiw"` → mette `"` attorno alla parola |
| `ds{char}` | `ds(` → toglie le parentesi |
| `cs{old}{new}` | `cs'"` → cambia apici in virgolette |
| `S{char}` (visual) | circonda la selezione |

### substitute.nvim (gbprod/substitute.nvim)
Sostituisce un testo con il contenuto del registro, senza passare da `viwp`.

| Tasto | Cosa fa |
| --- | --- |
| `gs{motion}` | sostituisci il motion col registro (es. `gsiw`) |
| `gss` | sostituisci la riga intera |
| `gs$` | sostituisci fino a fine riga (operatore + motion) |
| `gs` (visual) | sostituisci la selezione |

### Comment.nvim (numToStr/Comment.nvim)
| Tasto | Cosa fa |
| --- | --- |
| `gcc` | commenta/decommenta la riga |
| `gc{motion}` / `gc` (visual) | commenta il motion o la selezione |
| `gbc` / `gb` (visual) | commento a blocco |

### nvim-autopairs (windwp/nvim-autopairs)
Chiude automaticamente `( [ { " '` mentre scrivi, con consapevolezza
treesitter (es. niente pair dentro le stringhe lua). Integrato con nvim-cmp:
confermando una funzione aggiunge le `()`.

### nvim-ts-autotag (windwp/nvim-ts-autotag)
Nei file HTML/JSX/PHP chiude automaticamente i tag (`<div>` → `</div>`) e
rinominando il tag di apertura aggiorna quello di chiusura.

### nvim-treesitter-textobjects (branch main)
Textobject e movimenti sintattici, basati sull'albero treesitter.

| Tasto | Cosa fa |
| --- | --- |
| `af` / `if` | seleziona/opera su una funzione intera / solo il corpo |
| `ac` / `ic` | una classe intera / solo il corpo |
| `aa` / `ia` | un argomento con la virgola / senza |
| `]f` / `[f` | prossima / precedente funzione |
| `]c` / `[c` | prossima / precedente classe |

Esempi: `daf` cancella la funzione, `vif` seleziona il corpo, `cia` cambia
l'argomento. Con `lookahead` attivo funzionano anche se il cursore è prima
dell'oggetto.

### mini.move e mini.splitjoin
Vedi [mini.nvim](#mininvim-echasnovskimininvim) sopra.

### nvim-origami (chrisgrieser/nvim-origami)
Folding "che non dà fastidio": fold da LSP con fallback treesitter, file
sempre aperti all'avvio (`foldlevel 99`), foldtext con il conteggio righe.
`h` su una riga piegata la apre, `l` la chiude (oltre ai classici `za`, `zM`,
`zR`). Le pieghe si sospendono durante la ricerca.

---

## Treesitter

### nvim-treesitter (branch main)
Parser sintattici per highlighting e indentazione precisi. Il branch `main`
(riscrittura richiesta da Neovim 0.12) installa i parser in modo asincrono al
primo avvio e richiede la CLI `tree-sitter` ≥ 0.25 (su Homebrew:
`brew install tree-sitter-cli`, NON `tree-sitter` che è solo la libreria).

Parser installati: lua, vim, python, r, haskell, html, css, js/ts/tsx, php,
sql, json, yaml, toml, markdown, bash, gitcommit, diff e altri
(lista in `lua/plugins/nvimtreesitter.lua`).

| Comando | Cosa fa |
| --- | --- |
| `:TSUpdate` | aggiorna i parser |
| `:checkhealth nvim-treesitter` | diagnosi |

---

## LSP e completamento

### mason.nvim (williamboman/mason.nvim)
Installa e gestisce i binari esterni (language server, formatter, linter)
in `~/.local/share/nvim/mason`, scaricando quelli giusti per l'architettura
(arm64 sul MacBook, x86_64 sull'iMac). `:Mason` apre la UI.

### mason-lspconfig + mason-tool-installer
Installano automaticamente al primo avvio:

- **LSP**: lua_ls, pyright (Python), r_language_server, html, cssls,
  emmet_ls, ts_ls (JS/TS), intelephense (PHP), sqlls
- **Formatter**: prettier, stylua, isort, black, php-cs-fixer,
  sql-formatter, air (R)
- **Linter**: ruff (Python), eslint_d

Solo i server nella lista di `automatic_enable` vengono accesi
(`lua/plugins/lsp/mason.lua`).

### nvim-lspconfig (neovim/nvim-lspconfig)
Configurazione dei server (API `vim.lsp.config` di Neovim 0.11). Le keymap si
attivano quando un server si aggancia al buffer:

| Tasto | Cosa fa |
| --- | --- |
| `gd` / `gD` | vai a definizione / dichiarazione |
| `gR` | tutti i riferimenti (telescope) |
| `gi` / `gt` | implementazioni / type definition |
| `K` | documentazione hover |
| `<leader>ca` | code action (normal e visual) |
| `<leader>rn` | rename simbolo in tutto il progetto |
| `<leader>d` / `<leader>D` | diagnostica riga / buffer |
| `[d` / `]d` | diagnostica precedente / successiva |
| `<leader>rs` | riavvia il server |

Extra: lua_ls riconosce la globale `vim`; emmet attivo anche nei file PHP.

**Pyright + venv**: se nella root del progetto c'è una cartella `.venv/` o
`venv/`, pyright usa automaticamente quel Python per risolvere gli import —
non serve attivare il venv prima di aprire nvim. Se il venv sta altrove, la
via robusta è un `pyrightconfig.json` nel progetto con
`{ "venvPath": ".", "venv": "nome-cartella" }`.

### nvim-lsp-file-operations (antosha417/nvim-lsp-file-operations)
Quando rinomini/sposti un file da nvim-tree, aggiorna gli import nei file che
lo referenziano (via LSP). Invisibile finché non serve.

### nvim-cmp (hrsh7th/nvim-cmp) + sorgenti
Il motore di autocompletamento. Sorgenti in ordine di priorità: LSP,
snippet (LuaSnip), parole del buffer, path del filesystem.

| Tasto (insert) | Cosa fa |
| --- | --- |
| `<C-j>` / `<C-k>` | voce successiva / precedente |
| `<CR>` | conferma (solo se hai selezionato esplicitamente) |
| `<C-Space>` | forza il menu |
| `<C-e>` | chiudi il menu |
| `<C-f>` / `<C-b>` | scorri la documentazione |

- **LuaSnip + friendly-snippets**: motore snippet + raccolta pronta stile
  VS Code (es. digitare `for` in Python e confermare espande il costrutto).
- **lspkind**: le iconcine per tipo di voce (funzione, variabile, …) nel menu.

---

## Formattazione e linting

### conform.nvim (stevearc/conform.nvim)
Format-on-save per tutti i linguaggi configurati, con fallback all'LSP se non
c'è un formatter dedicato. Mappa: prettier (web/JSON/YAML/MD), stylua (lua),
isort+black (python), php-cs-fixer, sql-formatter, air (R).

| Tasto | Cosa fa |
| --- | --- |
| `<leader>mp` | formatta il file (o la selezione in visual) |

### nvim-lint (mfussenegger/nvim-lint)
Linting asincrono su apertura/salvataggio/uscita da insert: eslint_d per
JS/TS/React/Svelte, ruff per Python. I risultati appaiono come diagnostica
normale (quindi anche in Trouble). La config salta i linter il cui binario
non è installato, quindi niente errori ENOENT se un tool manca.

Ruff è un binario unico (non un venv Python), quindi non risente degli
aggiornamenti di Python come faceva pylint. Non controlla gli import
(`import numpy` ecc.): quello lo fa già pyright, che con il rilevamento
automatico del venv (vedi sotto) risolve i pacchetti del progetto.

Per silenziare regole di stile crea un `pyproject.toml`/`ruff.toml` nel
progetto (es. `[tool.ruff.lint] ignore = ["D100", "D103"]` per le docstring).

| Tasto | Cosa fa |
| --- | --- |
| `<leader>l` | rilancia il lint sul file |

---

## Git

### gitsigns.nvim (lewis6991/gitsigns.nvim)
Segni delle modifiche nel gutter (+ ~ -) e operazioni sui singoli hunk.

| Tasto | Cosa fa |
| --- | --- |
| `]h` / `[h` | prossimo / precedente hunk |
| `<leader>hs` / `<leader>hr` | stage / reset dell'hunk (anche in visual) |
| `<leader>hS` / `<leader>hR` | stage / reset dell'intero buffer |
| `<leader>hu` | toglie l'hunk dallo stage (stage_hunk è un toggle) |
| `<leader>hp` | preview dell'hunk |
| `<leader>hb` | blame della riga (completo) |
| `<leader>hB` | blame inline permanente on/off |
| `<leader>hd` / `<leader>hD` | diff contro index / contro HEAD~ |
| `ih` (textobject) | seleziona l'hunk (es. `vih`) |

### lazygit.nvim (kdheepak/lazygit.nvim)
Apre lazygit (TUI git completa: stage, commit, push, rebase, log) in una
finestra flottante. Richiede il binario `lazygit` installato.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>lg` | apri lazygit nella cwd |

---

## Diagnostica e TODO

### trouble.nvim (folke/trouble.nvim)
Pannello unico per diagnostica, quickfix e TODO, più comodo delle liste native.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>xw` | diagnostica di tutto il workspace |
| `<leader>xd` | diagnostica del buffer corrente |
| `<leader>xq` | quickfix list |
| `<leader>xl` | location list |
| `<leader>xt` | tutti i TODO del progetto |

### todo-comments.nvim (folke/todo-comments.nvim)
Evidenzia `TODO:`, `FIXME:`, `HACK:`, `WARN:`, `NOTE:` nei commenti e li rende
navigabili.

| Tasto | Cosa fa |
| --- | --- |
| `]t` / `[t` | prossimo / precedente TODO nel buffer |
| `<leader>ft` | cerca i TODO con telescope |
| `<leader>xt` | TODO in trouble |

---

## Sessioni

### auto-session (rmagatti/auto-session)
Salva e ripristina sessioni (file aperti, split, cwd) per directory. Il
ripristino automatico è spento: si fa a mano (anche dalla dashboard).
Nessuna sessione per home, Downloads, Documents, Desktop.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>wr` | ripristina la sessione per la cwd |
| `<leader>ws` | salva la sessione |

---

## Terminale e REPL

### toggleterm.nvim (akinsho/toggleterm.nvim)
Terminali persistenti richiamabili con un tasto: il processo resta vivo
quando nascondi la finestra.

| Tasto / Comando | Cosa fa |
| --- | --- |
| `<C-\>` | apri/nascondi il terminale flottante (anche da dentro il terminale) |
| `:2ToggleTerm` | apri un secondo terminale |
| `:TermExec cmd="..."` | esegui un comando in un toggleterm |
| `:PP` | comando custom: salva ed esegue il file Python corrente in un toggleterm verticale |

Ricorda: `<C-\><C-n>` porta un terminale in normal mode per scrollare.

### iron.nvim (Vigemus/iron.nvim)
REPL interattivo per Python, R e shell: mandi righe/paragrafi/selezioni a una
sessione viva invece di rieseguire tutto il file. Si carica aprendo un file
python/r/sh. Prefisso: `<leader>i`.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>ir` | apri/chiudi il REPL per il filetype corrente |
| `<leader>iR` | riavvia il REPL |
| `<leader>il` | manda la riga corrente |
| `<leader>iv` (visual) | manda la selezione |
| `<leader>ip` | manda il paragrafo |
| `<leader>iu` | manda tutto fino al cursore |
| `<leader>if` | manda l'intero file |
| `<leader>i<CR>` | invia un Invio al REPL |
| `<leader>ix` | interrompi (Ctrl-C) |
| `<leader>ic` | pulisci lo schermo del REPL |
| `<leader>iq` | chiudi il REPL |

Per R è il flusso classico "manda al console" di RStudio; per Python usa il
bracketed paste, quindi indentazioni e blocchi passano correttamente.

---

## Undo

### undotree (mbbill/undotree)
Visualizza l'albero completo della history di undo — inclusi i rami che con
`u`/`<C-r>` non raggiungeresti mai — con diff di ogni stato. Grazie a
`undofile` (attivo in `core/options.lua`) la history sopravvive alla chiusura
del file: puoi recuperare lo stato di ieri.

| Tasto | Cosa fa |
| --- | --- |
| `<leader>u` | apri/chiudi il pannello |

Nel pannello: `J`/`K` si muovono tra gli stati applicandoli, `Invio` applica
lo stato selezionato, `D` mostra il diff.

---

## Tasti a rischio di confusione (promemoria)

- `s` = **flash** (jump), non più substitute → substitute è su `gs`
- `S` in **visual** = nvim-surround (circonda); in **normal** = flash treesitter
- `<C-e>` in **normal** = menu harpoon; in **insert** = chiudi menu cmp
- `<leader>h*` = git hunk (gitsigns); harpoon usa `<leader>a` e `<leader>1..4`
- `<C-j>/<C-k>` in **insert/picker** = navigazione menu (cmp/telescope);
  `<C-h/j/k/l>` in **normal** = navigazione split/tmux
