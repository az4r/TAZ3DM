(defun taz_s_start ()

  ;; warstwy
  (if (tblsearch "LAYER" "taz_s_beam")
    (princ)
    (command "_layer" "_M" "taz_s_beam" "_C" "145" "" "")
  )
  (if (tblsearch "LAYER" "taz_s_plate")
    (princ)
    (command "_layer" "_M" "taz_s_plate" "_C" "30" "" "")
  )
  (if (tblsearch "LAYER" "taz_s_axes")
    (princ)
    (command "_layer" "_M" "taz_s_axes" "_C" "109" "" "")
  )

  (command "_layer" "_S" "0" "")

  ;; Jeśli model nie jest pusty — projekt już zapisany, nic nie rób
  (if (ssget "_X" '((410 . "Model")))
    (princ)

    ;; Model pusty — nowy projekt, pytamy użytkownika o katalog
    (progn

      ;; Użytkownik wskazuje katalog gdzie ma być zapisany projekt
      (setq taz_s_chosen_dir (getfiled "Wskaż katalog projektu" "" "dwg" 9))

      ;; Jeśli anulował — przerywamy
      (if (not taz_s_chosen_dir)
        (princ)

        (progn

          ;; *** JEDYNA ZMIANA: pobieramy sam katalog + dodajemy "/" ***
          (setq taz_s_chosen_dir
            (strcat (vl-filename-directory taz_s_chosen_dir) "/")
          )


          ;; Nazwa aktualnie otwartego rysunku (bez rozszerzenia)
          (setq taz_s_dwgname
            (substr (getvar "DWGNAME") 1 (- (strlen (getvar "DWGNAME")) 4))
          )

          ;; Pełne ścieżki docelowe
          (setq taz_s_target_dwg
            (strcat taz_s_chosen_dir taz_s_dwgname ".dwg")
          )
          (setq taz_s_target_dir
            (strcat taz_s_chosen_dir taz_s_dwgname)
          )

          ;; Jeśli istnieje stary plik dwg o tej nazwie — usuń go
          (if (findfile taz_s_target_dwg)
            (vl-file-delete taz_s_target_dwg)
          )

          ;; Jeśli istnieje stary katalog danych — wyczyść go z plików
          (if (vl-file-directory-p taz_s_target_dir)
            (foreach taz_s_f (vl-directory-files taz_s_target_dir nil 1)
              (vl-file-delete (strcat taz_s_target_dir "/" taz_s_f))
            )
            ;; Katalog nie istnieje — utwórz go
            (vl-mkdir taz_s_target_dir)
          )

          ;; Zapisz rysunek we wskazanym katalogu
          (command "_SAVEAS" "" taz_s_target_dwg)

        )
      )
    )
  )
)

(taz_s_start)
