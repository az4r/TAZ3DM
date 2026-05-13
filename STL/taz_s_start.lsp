(defun taz_s_start()

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

  ;; katalogi
  (setq taz_s_maindir (strcat (getvar "DWGPREFIX") "TAZ"))
  (setq taz_s_tmpdir  (strcat (getvar "DWGPREFIX") "TAZ/TMP"))
  (setq taz_s_dwgname (substr (getvar "DWGNAME") 1 (- (strlen (getvar "DWGNAME")) 4)))
  (setq taz_s_dwgdir  (strcat taz_s_tmpdir "/" taz_s_dwgname))

  ;; tworzenie katalogów
  (if (vl-file-directory-p taz_s_maindir)
    (princ)
    (vl-mkdir taz_s_maindir)
  )

  (if (vl-file-directory-p taz_s_tmpdir)
    (princ)
    (vl-mkdir taz_s_tmpdir)
  )

  ;; jeśli Model nie jest pusty to nic nie rób
  (if (ssget "_X" '((410 . "Model")))
    (princ)

    ;; jeśli pusty
    (progn

      ;; usuń starą kopię jeśli istnieje
      (if (findfile (strcat taz_s_tmpdir "/" taz_s_dwgname ".dwg"))
        (progn
          (vl-file-delete (strcat taz_s_tmpdir "/" taz_s_dwgname ".dwg"))
          (foreach taz_s_dwgdirfiles (vl-directory-files taz_s_dwgdir nil 1) (vl-file-delete (strcat taz_s_dwgdir "/" taz_s_dwgdirfiles)))
        )
      )

      ;; zapisz kopię
      (command "_SAVEAS" "" (strcat taz_s_tmpdir "/" taz_s_dwgname ".dwg"))

      ;; utwórz katalog projektu
      (vl-mkdir (strcat taz_s_tmpdir "/" taz_s_dwgname))
    )
  )
)

(taz_s_start)