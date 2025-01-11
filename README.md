# Instalacja i konfiguracja Neovim

## Wymagania wstępne

Aby zapewnić prawidłowe działanie Neovim, należy zainstalować następujące komponenty:

- **Python** - zalecana instalacja poprzez Miniconda:

  - Pobierz instalator ze strony [https://docs.anaconda.com/miniconda/](https://docs.anaconda.com/miniconda/)
  - Postępuj zgodnie z instrukcjami instalacji dla Twojego systemu operacyjnego

- **Node.js** - niezbędny do obsługi wielu przydatnych wtyczek:

  - Pobierz najnowszą wersję LTS ze strony [https://nodejs.org/](https://nodejs.org/)
  - Przeprowadź standardową instalację

- **GCC (GNU Compiler Collection)** - na systemie Fedora:
  ```bash
  sudo dnf install gcc
  ```

# Konfiguracja TMUX

## Instalacja menedżera wtyczek TPM

1. Sklonuj repozytorium TPM do katalogu konfiguracyjnego:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

2. Zainstaluj wtyczki w aktywnej sesji TMUX:
   - Użyj kombinacji klawiszy: `Ctrl + Space`, następnie `Shift + I`
   - Poczekaj na zakończenie instalacji wszystkich skonfigurowanych wtyczek

Wszystkie komponenty są teraz gotowe do użycia.
