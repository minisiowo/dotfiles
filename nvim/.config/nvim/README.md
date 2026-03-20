# My Neovim Config

Osobista konfiguracja Neovima oparta o `lazy.nvim`, z modularnym podzialem na male pliki i bez zbednych wrapperow.

## Zalozenia

- `init.lua` bootstrappuje `lazy.nvim`
- podstawowe opcje i globalne keymapy sa w `lua/options.lua`
- pluginy i feature'y siedza w `lua/plugins/`
- autokomendy sa w `lua/autocmds.lua`
- poprawki, ktore musza wejsc po zaladowaniu pluginow, sa w `after/plugin/`

## Wymagania

- Neovim `0.11+`
- `git`
- patched font / Nerd Font
- `tmux` opcjonalnie, dla `vim-tmux-navigator`
- Omarchy opcjonalnie, jesli chcesz ladowac motyw z `~/.config/omarchy/current/theme/neovim.lua`

Narzedzia instalowane przez `mason.nvim`:

- `lua-language-server`
- `json-lsp`
- `rust-analyzer`
- `typescript-language-server`
- `html-lsp`
- `css-lsp`
- `emmet-language-server`
- `tinymist`
- `roslyn`
- `prettierd`
- `eslint_d`

Narzedzia systemowe uzywane poza Masonem:

- `rustup`, `cargo`, `rustfmt`, `clippy`
- `node` oraz package manager (`npm`, `pnpm`, `yarn` albo `bun`)
- `cargo-tauri` i zaleznosci systemowe wymagane przez Tauri v2

## Start

```bash
nvim
```

Synchronizacja pluginow:

```bash
nvim --headless "+Lazy! sync" +qa
```

Podstawowy smoke test:

```bash
nvim --headless "+qa"
```

Healthcheck:

```bash
nvim --headless "+checkhealth" +qa
```

## Struktura

```text
.
├── init.lua
├── lazy-lock.json
├── README.md
├── after/
│   └── plugin/
│       ├── project_workflow.lua
│       └── transparency.lua
└── lua/
    ├── autocmds.lua
    ├── options.lua
    ├── project_workflow.lua
    └── plugins/
        ├── colorizer.lua
        ├── comment.lua
        ├── completions_blink.lua
        ├── flash.lua
        ├── formatting.lua
        ├── git.lua
        ├── lazydev.lua
        ├── lsp-config.lua
        ├── lualine.lua
        ├── nvim-autopairs.lua
        ├── roslyn.lua
        ├── snacks.lua
        ├── theme.lua
        ├── tmux-navigator.lua
        ├── treesitter.lua
        ├── typst-preview.lua
        └── which-key.lua
```

## Najwazniejsze rzeczy

### Snacks

- `<leader>e` - explorer
- `<leader>ff` - find files
- `<leader>fg` - grep
- `<leader>fb` - buffers
- `<leader>fh` - help
- `<leader>tt` - terminal

### LSP / code

- `K` - hover
- `<leader>gd` - definicja
- `<leader>gr` - referencje
- `<leader>ca` - code action
- `<leader>lf` - format biezacego pliku
- `<leader>ll` - lint dla aktualnego pliku, a dla Rust `cargo clippy`

### Diagnostyka i nawigacja po bledach

- `]d` - nastepna diagnostyka
- `[d` - poprzednia diagnostyka
- `]e` / `[e` - przechodzenie tylko po errorach
- `]w` / `[w` - przechodzenie tylko po warningach
- aktualna linia pokazuje tresc diagnostyki inline dzieki `virtual_lines`

Praktyczny workflow:

- `]d` / `[d` kiedy chcesz szybko przejsc po problemach w aktualnym pliku
- `K` kiedy chcesz od razu sprawdzic typ, dokumentacje albo szczegoly symbolu pod kursorem
- `<leader>gd` kiedy chcesz wejsc do implementacji
- `<leader>gr` kiedy chcesz zobaczyc wszystkie uzycia symbolu
- `<leader>ca` kiedy LSP podpowiada szybka poprawke
- `<leader>fg` kiedy chcesz znalezc cos szerzej w projekcie, a nie tylko przez LSP

### Workflow Rust / Tauri / frontend

- `<leader>tc` - `cargo check`
- `<leader>tl` - `cargo clippy`
- `<leader>tT` - `cargo test`
- `<leader>td` - `cargo tauri dev`
- `<leader>tb` - `cargo tauri build`
- `<leader>tv` - frontend dev server wykryty z lockfile

### Bufory i okna

- `H` - poprzedni bufor
- `L` - nastepny bufor
- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` - przechodzenie miedzy splitami

### Splity

- `<leader>sh` - nowy split poziomy
- `<leader>sv` - nowy split pionowy
- `<leader>s=` - wyrownanie rozmiarow splitow
- `<leader>sH` / `<leader>sL` - zmniejsz / zwieksz szerokosc
- `<leader>sJ` / `<leader>sK` - zmniejsz / zwieksz wysokosc

## Co jest gdzie

- `lua/plugins/lsp-config.lua` - Mason oraz konfiguracja LSP dla Lua, JSON, Rust, JS, HTML, CSS i Emmeta
- `lua/plugins/formatting.lua` - reczne formatowanie i linting
- `lua/plugins/treesitter.lua` - parsery Treesitter i textobjects
- `lua/options.lua` - podstawowe opcje, mapy buforow, splitow i nawigacji okien
- `lua/project_workflow.lua` - wykrywanie roota projektu i komendy terminalowe dla Rust/Tauri/Vite
- `after/plugin/project_workflow.lua` - keymapy do formatowania, lintingu i taskow projektowych
- `after/plugin/transparency.lua` - poprawki highlightow po zaladowaniu motywu

## Uwagi

- Formatowanie jest reczne, nie ma `format on save`.
- Workflow Tauri zaklada Tauri v2 i frontend oparty o Vite + JavaScript.
- Frontendowy dev server wybiera `pnpm`, `yarn`, `bun` albo `npm` na podstawie lockfile w katalogu projektu.
