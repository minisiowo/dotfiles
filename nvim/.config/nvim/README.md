# My Neovim Config

Moja osobista konfiguracja Neovima oparta o `lazy.nvim`, z motywem ladowanym z Omarchy.

To nie jest "framework config", tylko raczej maly, modularny setup:
- podstawowe opcje i keymapy sa w jednym miejscu
- kazdy wiekszy feature/plugin ma osobny plik w `lua/plugins/`
- motyw jest pobierany z aktualnie wybranego motywu Omarchy
- kilka rzeczy jest dostosowanych do mojego workflow, np. `Snacks`, `bufferline`, `tmux`, `jdtls`

## Glowne zalozenia

- prosta struktura plikow
- jeden plik = jeden obszar odpowiedzialnosci
- bez zbednych wrapperow i nadmiarowej abstrakcji
- konfiguracja ma byc latwa do przegladania i rozwijania po czasie

## Wymagania

- Neovim `0.11+`
- `git`
- patched font / Nerd Font
- `tmux` - opcjonalnie, ale przydatny do integracji z `vim-tmux-navigator`
- Omarchy - jesli chcesz korzystac z motywu ladowanego z `~/.config/omarchy/current/theme/neovim.lua`

Dodatkowo czesc funkcji zalezy od narzedzi instalowanych przez `mason.nvim`, np.:
- `lua-language-server`
- `json-lsp`
- `tinymist`
- `jdtls`
- `roslyn`

## Start

Uruchom po prostu:

```bash
nvim
```

Jesli pluginy nie sa jeszcze zainstalowane albo chcesz je zsynchronizowac:

```bash
nvim --headless "+Lazy! sync" +qa
```

A zeby sprawdzic ogolny stan srodowiska:

```bash
nvim --headless "+checkhealth" +qa
```

## Jak dziala start konfiguracji

Punkt wejscia to `init.lua`.

Podczas startu dzieje sie to:
1. bootstrap `lazy.nvim`
2. zaladowanie `lua/options.lua`
3. zaladowanie wszystkich plugin specs z `lua/plugins/`
4. zaladowanie autokomend z `lua/autocmds.lua`

Czyli najkrocej:
- `options.lua` = podstawowe ustawienia i glowne keymapy
- `plugins/*.lua` = pluginy i feature'y
- `autocmds.lua` = logika zdarzen
- `after/plugin/` = poprawki, ktore musza wejsc po pluginach / colorscheme

## Struktura katalogow

```text
.
├── init.lua
├── lazy-lock.json
├── README.md
├── after/
│   └── plugin/
│       └── transparency.lua
└── lua/
    ├── autocmds.lua
    ├── options.lua
    ├── jdtls/
    │   └── jdtls_setup.lua
    └── plugins/
        ├── bufferline.lua
        ├── snacks.lua
        ├── lsp-config.lua
        ├── completions_blink.lua
        ├── treesitter.lua
        ├── git.lua
        ├── flash.lua
        ├── lualine.lua
        ├── comment.lua
        ├── nvim-autopairs.lua
        ├── tmux-navigator.lua
        ├── which-key.lua
        ├── lazydev.lua
        ├── roslyn.lua
        ├── typst-preview.lua
        ├── colorizer.lua
        ├── omarchy-theme.lua
        └── omarchy-hotreload.lua
```

## Co jest gdzie

### `init.lua`

Glowny punkt wejscia. Bootstrapping `lazy.nvim` i zaladowanie reszty konfiguracji.

### `lua/options.lua`

Tutaj sa:
- leader keys
- podstawowe opcje UI
- clipboard
- diagnostyka
- glowne keymapy uzytkowe

To jest plik, od ktorego zwykle warto zaczac przegladanie konfiguracji.

### `lua/autocmds.lua`

Tutaj siedza autokomendy, np.:
- uruchamianie `jdtls` dla plikow Java
- automatyczne wyrownanie splitow po zmianie rozmiaru okna
- mapowanie `.axaml` na `xml`
- wylaczenie automatycznego kontynuowania komentarzy przy nowej linii

### `lua/plugins/`

Kazdy plik odpowiada za konkretny obszar:
- `snacks.lua` - explorer, picker, terminal, input, notifier
- `bufferline.lua` - karty otwartych buforow
- `lsp-config.lua` - LSP + Mason
- `completions_blink.lua` - autouzupelnianie
- `treesitter.lua` - Treesitter i textobjects
- `git.lua` - Fugitive i Gitsigns
- `flash.lua` - szybka nawigacja po buforze
- `lualine.lua` - statusline
- itd.

Zasada jest prosta: jesli szukasz zachowania zwiazanego z pluginem, najpierw sprawdz odpowiedni plik w `lua/plugins/`.

### `lua/jdtls/jdtls_setup.lua`

Specjalna konfiguracja dla Javy. Nie jest uruchamiana przez zwykle `vim.lsp.enable(...)`, tylko osobno przez autocmd dla `FileType=java`.

### `after/plugin/transparency.lua`

Poprawki highlightow po zaladowaniu motywu i pluginow.

Tutaj ustawiana jest przezroczystosc dla:
- `Normal`
- `NormalFloat`
- `Pmenu`
- czesci grup pluginowych

To wazne, bo niektore elementy UI wygladaja poprawnie dopiero po tych override'ach.

## Motyw i Omarchy

Motyw nie jest trzymany bezposrednio w tej konfiguracji.

Zamiast tego:
- `lua/plugins/omarchy-theme.lua` laduje spec motywu z:
  - `~/.config/omarchy/current/theme/neovim.lua`
- z tego pliku wyciagany jest wlasciwy colorscheme
- potem colorscheme jest aplikowany lokalnie, bez zaleznosci od `LazyVim`

Dodatkowo:
- `lua/plugins/omarchy-hotreload.lua` obsluguje ponowne przeladowanie motywu po `LazyReload`
- po przeladowaniu odswiezane sa highlighty i re-source'owana jest transparentnosc

To rozwiazanie jest wygodne, ale trzeba pamietac, ze motyw zalezy od zewnetrznego pliku poza repo.

## Najwazniejsze funkcje i jak z nich korzystac

## Explorer i wyszukiwanie

Za to odpowiada `Snacks`.

### Explorer

- `<leader>e` - otworz / przelacz explorer

Explorer:
- zastepuje `netrw`
- pokazuje od razu ukryte pliki
- pokazuje tez pliki ignorowane przez git

### Wyszukiwanie

- `<leader>ff` - znajdz pliki
- `<leader>fg` - live grep
- `<leader>fb` - otwarte bufory
- `<leader>fh` - help tags

## Karty / otwarte pliki

Za "karty jak w innych edytorach" odpowiada `bufferline.nvim`.

To nie sa natywne tabpage Neovima, tylko wizualizacja otwartych buforow.

### Nawigacja

- `H` - poprzednia karta
- `L` - nastepna karta
- `<leader>bp` - wybor konkretnej karty litera
- `<leader>bc` - zamkniecie biezacej karty / bufora

Zalozenie jest takie:
- otwierasz pliki normalnie
- bufferline pokazuje je jako karty
- do przechodzenia uzywasz `H` i `L`

## Terminal

- `<leader>tt` - otworz terminal przez `Snacks.terminal`

## Powiadomienia i input

### Powiadomienia

- `<leader>nh` - historia powiadomien
- `<leader>nd` - schowaj aktywne powiadomienia

### Input

`Snacks.input` przejmuje `vim.ui.input()`, wiec jesli plugin lub wlasny kod poprosi o wpisanie tekstu, pojawi sie okno input od `Snacks`.

## Komentowanie

Za komentowanie odpowiada `Comment.nvim`.

Najwazniejsze domyslne mapy:
- `gcc` - zakomentuj / odkomentuj aktualna linie
- `gc` + ruch / obiekt tekstowy - komentowanie zakresu

Dodatkowo autokomenda wylacza automatyczne kontynuowanie komentarza przy nowej linii.

## Nawigacja i skoki

Za szybkie skakanie odpowiada `flash.nvim`.

### Najwazniejsze mapy

- `zk` - szybki skok
- `zK` - skok po Treesitterze
- `zr` - remote flash
- `zR` - treesitter search

## Splity i tmux

### Nawigacja po splitach

- `<C-h>` - lewo
- `<C-j>` - dol
- `<C-k>` - gora
- `<C-l>` - prawo

Jesli pracujesz w tmuxie, te same mapy wspolpracuja tez z `vim-tmux-navigator`.

Dodatkowo:
- `<C-\\>` - poprzedni panel tmuxa

## LSP i kod

Glowna konfiguracja LSP siedzi w `lua/plugins/lsp-config.lua`.

### Najwazniejsze mapy

- `K` - hover
- `<leader>gd` - go to definition
- `<leader>gr` - references
- `<leader>ca` - code action
- `<leader>lf` - format buffer

### Serwery wlaczane standardowo

- `lua_ls`
- `tinymist`
- `jsonls`

### Java

Java jest obslugiwana osobno przez `nvim-jdtls`.

### C#

C# jest obslugiwany przez `roslyn.nvim`.

## Autouzupelnianie

Za completion odpowiada `blink.cmp`.

Zrodla:
- `lazydev`
- `lsp`
- `path`
- `snippets`
- `buffer`

Dokumentacja podpowiedzi nie otwiera sie automatycznie, bo jest to wylaczone celowo.

## Treesitter

Treesitter odpowiada za:
- highlight skladni
- incremental selection
- textobjects

### Incremental selection

- `<leader>ss`
- `<leader>si`
- `<leader>sc`
- `<leader>sd`

### Textobjects

- `af` / `if` - function outer / inner
- `ac` / `ic` - class outer / inner
- `as` - local scope

## Git

Za git odpowiadaja dwa pluginy:
- `vim-fugitive`
- `gitsigns.nvim`

### Co daja

- `gitsigns` pokazuje zmiany w signcolumn
- `fugitive` daje klasyczne komendy typu `:Git`

Nie ma tutaj rozbudowanych wlasnych map gitowych - workflow opiera sie glownie na standardowych komendach pluginow.

## Statusline

Za dolny pasek odpowiada `lualine`.

Pokazuje m.in.:
- nazwe pliku
- branch
- diff
- filetype
- diagnostics

## Dodatkowe przydatne mapy

- `<leader>o` - zapisz i zsource'uj biezacy plik
- `<leader>vl` - zaznacz zawartosc linii bez wciecia
- `<Esc>` - wyczysc highlight wyszukiwania

## Discoverability

`which-key.nvim` jest wlaczony, wiec po wcisnieciu `leader` zobaczysz podpowiedzi dostepnych map.

## Plugin inventory

### UI / nawigacja

- `snacks.nvim`
- `bufferline.nvim`
- `which-key.nvim`
- `vim-tmux-navigator`
- `flash.nvim`
- `lualine.nvim`
- `nvim-colorizer.lua`

### Edycja

- `Comment.nvim`
- `nvim-autopairs`
- `nvim-treesitter`
- `nvim-treesitter-textobjects`

### LSP / completion

- `mason.nvim`
- `mason-tool-installer.nvim`
- `nvim-lspconfig`
- `blink.cmp`
- `friendly-snippets`
- `lazydev.nvim`

### Git

- `vim-fugitive`
- `gitsigns.nvim`

### Jezykowe / specjalne

- `nvim-jdtls`
- `roslyn.nvim`
- `typst-preview.nvim`

### Motyw

- motyw ladowany z Omarchy
- lokalny adapter `omarchy-theme.lua`
- hot reload motywu w `omarchy-hotreload.lua`

## Jak rozwijac te konfiguracje

Najprostsza zasada:
- nowy plugin = nowy plik w `lua/plugins/`
- globalne opcje i ogolne mapy = `lua/options.lua`
- logika zdarzen = `lua/autocmds.lua`
- highlight / poprawki po zaladowaniu motywu = `after/plugin/`

Dzieki temu po czasie latwo znalezc:
- gdzie jest plugin
- gdzie jest keymapa
- gdzie jest motyw
- gdzie sa autokomendy

## Testowanie zmian

Po zmianach dobrze sprawdzic:

```bash
nvim --headless +qa
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth" +qa
```

A potem zrobic krotki test reczny w `nvim`, zwlaszcza jesli zmiana dotyczy:
- UI
- LSP
- motywu
- terminala
- explorera

## Uwagi

- konfiguracja zalezy czesciowo od zewnetrznego pliku motywu Omarchy
- `jdtls` ma lokalnie ustawiona sciezke do Javy
- czesc komentarzy i opisow jest po polsku, bo to prywatna konfiguracja
