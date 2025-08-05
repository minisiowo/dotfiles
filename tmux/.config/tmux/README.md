## ✅ `README.md` – Tmux Config (Dominik)

### 📦 TPM (Plugin Manager)

Plik automatycznie:

* sprawdza, czy TPM jest zainstalowany (`~/.config/tmux/plugins/tpm`)
* instaluje go przy pierwszym uruchomieniu

Pluginy w użyciu:

* `tpm` – plugin manager
* `vim-tmux-navigator` – płynna nawigacja między vim a tmux
* `tmux-resurrect` – zapis i przywracanie sesji
* `tmux-continuum` – auto-save co 15 min
* `minimal-tmux-status` – prosty pasek statusu

---

### 🧠 Podział organizacyjny Tmux

* **Session** = osobny projekt lub kontekst (`java`, `dotfiles`, `work`)
* **Window** = "karta" w sesji (`editor`, `git`, `server`)
* **Pane** = podział ekranu (np. vim obok logów)

---

### ⌨️ Klawisze i skróty

#### 📁 Ogólne

| Skrót           | Działanie                              |
| --------------- | -------------------------------------- |
| `Ctrl + b`, `r` | Przeładuj config (`reload`)            |
| `Ctrl + b`, `?` | Lista wszystkich skrótów (`list-keys`) |
| `Ctrl + b`, `m` | Zoom/odzoom panelu                     |

---

#### 📦 Sesje

| Skrót             | Działanie                              |
| ----------------- | -------------------------------------- |
| `Ctrl + b`, `s`   | Wybór sesji z listy (`choose-session`) |
| `Ctrl + b`, `C-n` | Nowa sesja przez popup (`read`)        |
| `Ctrl + b`, `C-j` | Przełącz sesję przez `fzf` w popupie   |
| `Ctrl + b`, `C-e` | Zmień nazwę bieżącej sesji (popup)     |

---

#### 🗂 Okna

| Skrót               | Działanie                            |
| ------------------- | ------------------------------------ |
| `Ctrl + b`, `w`     | Wybór okna z listy (`choose-window`) |
| `Ctrl + b`, `c`     | Nowe okno (w tym samym katalogu)     |
| `Ctrl + b`, `n`     | Następne okno                        |
| `Ctrl + b`, `p`     | Poprzednie okno                      |
| `Ctrl + b`, `1`-`9` | Skok do okna wg numeru               |

---

#### 🧱 Panele

| Skrót                 | Działanie                    |
| --------------------- | ---------------------------- |
| `Ctrl + b`, `-`       | Podział pionowy (góra/dół)   |
| `Ctrl + b`, `\`       | Podział poziomy (lewo/prawo) |
| `Ctrl + b`, `h/j/k/l` | Zmiana rozmiaru panelu       |
| `Ctrl + b`, `o`       | Przełącz między panelami     |

---

#### 📋 Tryb kopiowania

| Skrót                    | Działanie                      |
| ------------------------ | ------------------------------ |
| `Ctrl + b`, `[`          | Wejście w tryb kopiowania (vi) |
| `v` (w trybie copy-mode) | Zaznacz tekst                  |
| `y` (w trybie copy-mode) | Kopiuj do `wl-copy`            |
| `Ctrl + b`, `P`          | Wklej z bufora                 |

---

#### 💻 Popup terminale

| Skrót             | Co robi                              |
| ----------------- | ------------------------------------ |
| `Ctrl + b`, `C-t` | Otwiera popup z nowym `bash`         |
| `Ctrl + b`, `C-m` | Uruchamia `java Main.java` w popupie |

---

### 📌 Inne

* Numeracja okien i paneli zaczyna się od `1`
* Historia terminala: `1 000 000` linii
* True-color (24-bit) i systemowy schowek: włączone
* `ESC` działa natychmiast (escape-time 0)

---

### 🔧 TPM – instalacja pluginów

Uruchom tmuxa i wciśnij:

```
Ctrl + b, Shift + I
```

Instaluje pluginy zdefiniowane w `@plugin`.

---

Potrzebujesz też wersji po polsku? Albo wersji w stylu cheat-sheet `.pdf` / `.md`?
