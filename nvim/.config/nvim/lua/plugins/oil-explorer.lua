return {
  {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      dependencies = { { "echasnovski/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      -- minus to launch
      keys = {
          { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      }
      -- PODSTAWOWE SKRÓTY W OIL:
      -- <Enter> - otwórz plik lub wejdź do katalogu
      -- - - przejdź do katalogu nadrzędnego  
      -- _ - przejdź do katalogu roboczego (cwd)
      -- g? - pokaż pomoc z wszystkimi skrótami
      --
      -- PODZIAŁ OKIEN:
      -- <C-s> - otwórz w pionowym podziale
      -- <C-h> - otwórz w poziomym podziale
      -- <C-t> - otwórz w nowej zakładce
      -- <C-p> - podgląd pliku (bez otwierania)
      -- <C-c> - zamknij Oil
      -- 
      -- OPERACJE NA PLIKACH (Oil działa jak zwykły bufor):
      -- i/a - tryb edycji - zmień nazwę pliku bezpośrednio
      -- dd - usuń plik/katalog (usuń linię)
      -- yy + p - kopiuj plik (skopiuj linię i wklej z nową nazwą)
      -- o - dodaj nową linię (nowy plik/katalog)
      -- :w - zapisz wszystkie zmiany (wykonaj operacje)
      --
      -- WIDOK I SORTOWANIE:
      -- g. - pokaż/ukryj ukryte pliki (zaczynające się od .)
      -- gs - zmień sposób sortowania
      -- <C-l> - odśwież widok
      --
      -- DODATKOWE:
      -- gx - otwórz plik w domyślnej aplikacji systemowej
      -- g\ - przełącz widok kosza (trash)
      -- ` - cd do katalogu
      -- ~ - cd do katalogu (tab scope)
      --
      -- KOMENDY:
      -- :Oil - otwórz Oil w bieżącym katalogu
      -- :Oil /path/to/dir - otwórz Oil w konkretnym katalogu
      -- :e . - otwórz katalog (Oil przejmie kontrolę)
      -- :Oil --float - otwórz Oil w floating window
  }
}
