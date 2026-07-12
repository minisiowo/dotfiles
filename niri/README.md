# Niri

Konfiguracja Niri zarządzana przez GNU Stow.

## Pliki

- `.config/niri/config.kdl` — główna konfiguracja Niri
- `.config/niri/noctalia.kdl` — kolory/motyw generowane przez Noctalia
- `.local/bin/screenrecord-toggle` — helper do przełączania nagrywania ekranu

## Instalacja

Z katalogu głównego dotfiles:

```bash
stow niri
```

## Najważniejsze skróty niestandardowe

- `Mod + Shift + S` — zrzut zaznaczonego obszaru do schowka
- `Mod + Print` — przełącz nagrywanie ekranu z dźwiękiem pulpitu
- `Mod + Ctrl + Print` — przełącz nagrywanie ekranu bez dodatkowego audio
- `Mod + Shift + Print` — przełącz nagrywanie ekranu z dźwiękiem pulpitu i mikrofonem
- `Mod + Space` — Vicinae
- `Mod + Alt + V` — historia schowka w Vicinae
- `Mod + Alt + B` — wyszukiwanie zakładek Raindrop w Vicinae

## Walidacja

```bash
niri validate -c ~/.config/niri/config.kdl
```
