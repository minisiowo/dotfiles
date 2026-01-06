# Przewodnik po konfiguracji TMUX

Dokumentacja oparta na aktualnym pliku konfiguracyjnym `tmux.conf`.

## 1. Czym jest TMUX?
TMUX (Terminal Multiplexer) to narzędzie, które pozwala "rozmnożyć" jedno okno terminala na wiele niezależnych sesji, okien i paneli. Działa jako serwer w tle, co oznacza, że nawet jeśli zamkniesz emulator terminala (np. Alacritty, Kitty) lub zerwie Ci się połączenie SSH, Twoje programy wewnątrz TMUX-a nadal działają i możesz do nich wrócić.

## 2. Podstawowe pojęcia (Hierarchia)
Zrozumienie tej hierarchii jest kluczowe dla efektywnej pracy:

*   **Sesja (Session):** Najwyższy poziom. Zbiór okien dedykowany konkretnemu zadaniu (np. jedna sesja dla projektu "Frontend", druga dla "Backend"). Sesje są izolowane od siebie, ale można się między nimi łatwo przełączać.
*   **Okno (Window):** Odpowiednik "karty" (tab) w przeglądarce internetowej. Zajmuje cały widoczny ekran terminala. W ramach jednej sesji możesz mieć wiele okien.
*   **Panel (Pane):** Podział wewnątrz okna. Ekran można podzielić na mniejsze prostokąty (np. kod po lewej, terminal po prawej). Wszystkie panele w oknie są widoczne jednocześnie.

---

## 3. Klawisz Główny (Prefix)
Większość komend w TMUX wymaga wciśnięcia kombinacji wstępnej, zwanej **Prefixem**.

**Twój Prefix:** `Ctrl` + `b`

Aby wykonać komendę (np. otworzyć nowe okno), najpierw wciskasz `Ctrl+b`, puszczasz te klawisze, a następnie wciskasz klawisz właściwej funkcji (np. `c`).

---

## 4. Zarządzanie Panelami (Panes)
Twoja konfiguracja ułatwia dzielenie ekranu i nawigację.

### Tworzenie paneli
*   **Podział poziomy** (obok siebie): `Prefix` + `\`
*   **Podział pionowy** (góra/dół): `Prefix` + `-`
    *   *Nowe panele otwierają się w tej samej ścieżce (katalogu), co aktualny panel.*

### Nawigacja (vim-tmux-navigator)
Dzięki pluginowi możesz poruszać się między panelami używając `Ctrl` (bez prefixu):
*   `Ctrl` + `h` (lewo)
*   `Ctrl` + `j` (dół)
*   `Ctrl` + `k` (góra)
*   `Ctrl` + `l` (prawo)

### Rozmiar i Zoom
*   `Prefix` + `h` / `j` / `k` / `l`: Zmiana rozmiaru panelu (o 5 jednostek).
*   `Prefix` + `m`: **Zoom** (maksymalizacja panelu na cały ekran). Ponowne użycie przywraca widok podziału.

---

## 5. Zarządzanie Oknami (Windows)
*   **Nowe okno:** `Prefix` + `c`
*   **Zmiana nazwy okna:** `Prefix` + `,`
*   **Przełączanie okien:**
    *   `Prefix` + `1`, `2`... (numeracja od 1)
    *   `Prefix` + `n` (następne) / `p` (poprzednie)
    *   `Prefix` + `w` (lista wszystkich okien i sesji)

---

## 6. Zarządzanie Sesjami i Popupy
Twoja konfiguracja zawiera potężne skrypty w pływających oknach (Popups).

*   **Nowa sesja:** `Prefix` + `Ctrl+n`  
    Pyta o nazwę i tworzy nową, czystą sesję.
*   **Przełącz sesję:** `Prefix` + `Ctrl+j`  
    Wyświetla listę sesji w `fzf`. Najszybsza metoda nawigacji między projektami.
*   **Zmień nazwę sesji:** `Prefix` + `Ctrl+e`
*   **Pływający terminal:** `Prefix` + `Ctrl+t`  
    Otwiera tymczasowy terminal na wierzchu (overlay). Idealny do szybkich komend gitowych bez wychodzenia z edytora.

---

## 7. Tryb Kopiowania (Copy Mode)
Skonfigurowany w stylu VI (`mode-keys vi`) ze wsparciem dla schowka systemowego.

1.  **Wejście:** `Prefix` + `[`
2.  **Nawigacja:** Strzałki lub `h/j/k/l`.
3.  **Zaznaczanie:** Wciśnij `v`, aby zacząć zaznaczać tekst.
4.  **Kopiowanie:** Wciśnij `y`. Tekst trafi do schowka systemowego (dzięki `wl-copy`).
5.  **Wklejenie:** `Prefix` + `P` (lub standardowe `Ctrl+V` systemu, jeśli terminal to obsługuje).

---

## 8. Pluginy i Inne

### Zainstalowane pluginy (TPM)
*   `vim-tmux-navigator`: Integracja nawigacji z Vimem.
*   `tmux-resurrect` / `tmux-continuum`: Zapisywanie i przywracanie stanu sesji (nawet po restarcie komputera).
*   `minimal-tmux-status`: Minimalistyczny pasek statusu.

### Przydatne komendy
*   **Przeładuj config:** `Prefix` + `r` (użyj po edycji `tmux.conf`).
*   **Instalacja pluginów:** `Prefix` + `I` (duże i) - jeśli dodasz nowe pluginy do pliku.
*   **Wymuś zapis sesji:** `Prefix` + `Ctrl+s`
*   **Wymuś przywrócenie sesji:** `Prefix` + `Ctrl+r`

---

## ⚡ Cheatsheet (Skrócona ściąga)

| Akcja | Skrót (po Ctrl+b) | Uwagi |
| :--- | :--- | :--- |
| **Podział poziomy** | `\` | Zamiast standardowego `%` |
| **Podział pionowy** | `-` | Zamiast standardowego `"` |
| **Nowe okno** | `c` | |
| **Zoom panelu** | `m` | Toggle (włącz/wyłącz) |
| **Nawigacja** | `Ctrl + h/j/k/l` | **Bez prefixu!** |
| **Szukaj sesji** | `Ctrl + j` | Wymaga prefixu |
| **Nowa sesja** | `Ctrl + n` | Wymaga prefixu |
| **Pływający term** | `Ctrl + t` | Wymaga prefixu |
| **Przeładuj config** | `r` | |
