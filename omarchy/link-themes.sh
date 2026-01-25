#!/bin/bash
# link-themes.sh - Bezpiecznie linkuje motywy z tego katalogu do konfiguracji omarchy

# Ustal absolutną ścieżkę do katalogu, w którym znajduje się ten skrypt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/omarchy/themes"

# Utwórz katalog docelowy jeśli nie istnieje
if [ ! -d "$TARGET_DIR" ]; then
    echo "Tworzę katalog docelowy: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

echo "Linkowanie motywów z: $SCRIPT_DIR"
echo "Do katalogu: $TARGET_DIR"
echo "---"

# Iteruj po wszystkich podkatalogach w folderze skryptu
for theme_path in "$SCRIPT_DIR"/*/; do
    # Sprawdź czy glob coś znalazł (w przypadku braku podkatalogów)
    [ -d "$theme_path" ] || continue

    # Wyciągnij samą nazwę katalogu (nazwę motywu)
    theme_name=$(basename "$theme_path")
    
    # Ścieżka docelowa linku
    target_path="$TARGET_DIR/$theme_name"

    echo "Przetwarzam: $theme_name"

    # Sprawdź czy w miejscu docelowym coś już istnieje
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ -L "$target_path" ]; then
            # Jeśli to symlink, sprawdź gdzie wskazuje
            current_link=$(readlink -f "$target_path")
            # Usuń końcowy slash ze ścieżek dla pewności porównania
            clean_theme_path=${theme_path%/}
            
            if [ "$current_link" == "$clean_theme_path" ]; then
                echo "  [OK] Już zlinkowany poprawnie."
                continue
            else
                echo "  [AKTUALIZACJA] Link wskazuje gdzie indziej. Aktualizuję."
                rm "$target_path"
            fi
        elif [ -d "$target_path" ]; then
            # Jeśli to zwykły katalog, zrób backup
            timestamp=$(date +%Y%m%d_%H%M%S)
            backup_name="${target_path}.bak_${timestamp}"
            echo "  [BACKUP] Znaleziono istniejący katalog. Kopia zapasowa: $(basename "$backup_name")"
            mv "$target_path" "$backup_name"
        else
            # Jeśli to plik
            echo "  [UWAGA] Znaleziono plik o tej nazwie. Zmieniam nazwę na .bak"
            mv "$target_path" "${target_path}.bak"
        fi
    fi

    # Utwórz symlink
    ln -s "${theme_path%/}" "$target_path"
    echo "  [UTWORZONO] -> Link gotowy."
done

echo "---"
echo "Zakończono!"
