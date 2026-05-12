# Dotfiles

Konfiguracje są ułożone pod GNU Stow: każdy katalog na pierwszym poziomie jest osobnym pakietem, np. `tmux`, `nvim`, `zsh`, `pi`.

## Pi

Globalna konfiguracja Pi jest w `pi/.pi/agent/` i po `stow pi` trafia do `~/.pi/agent/`.

Zawiera:
- `settings.json` — domyślny provider/model, poziom thinking i paczki Pi (`pi-mcp-adapter`, `pi-subagents`)
- `mcp.json` — konfigurację MCP z `CONTEXT7_API_KEY` branym ze środowiska
- `extensions/codex-usage.ts` — status użycia Codex w stopce Pi
- `prompts/*.md` — szablony `athena`, `hermes`, `agents-network`

Instalacja:

```bash
stow pi
```

Nie trzymamy tu sekretów i runtime: `auth.json`, sesji, cache, historii uruchomień oraz lokalnie instalowanych paczek.

# Konfiguracja TMUX

## Instalacja menedżera wtyczek TPM

1. Upewnij się, że TMUX jest zainstalowany w systemie.
2. Sklonuj repozytorium TPM do katalogu konfiguracyjnego:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

3. Zainstaluj wtyczki w aktywnej sesji TMUX:
   - Użyj kombinacji klawiszy: `Ctrl + B` (kombinacja bind), następnie `Shift + I`
   - Poczekaj na zakończenie instalacji wszystkich skonfigurowanych wtyczek

## Notatki ...

- `nwg-look` może łatwo ogarnąć kursor myszy, który zgadza się w większości apek na Hyprland
