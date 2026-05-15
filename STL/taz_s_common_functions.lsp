;; ---------------------------------------------------------
;; taz_s_path
;; Zwraca aktualną ścieżkę do katalogu danych projektu.
;; Zawsze liczy na bieżąco z DWGPREFIX i DWGNAME.
;; ---------------------------------------------------------
(defun taz_s_path ()
  (strcat
    (getvar "DWGPREFIX")
    (substr (getvar "DWGNAME") 1 (- (strlen (getvar "DWGNAME")) 4))
    "/"
  )
)

;; ---------------------------------------------------------
;; taz_s_cleanup_data_file
;; Czyści plik który został przypisany do zmiennej
;; taz_s_data_file wewnątrz katalogu danych projektu.
;; ---------------------------------------------------------

(defun taz_s_cleanup_data_file ()

  (setq taz_s_cl_file taz_s_data_file)

  ;; --- WCZYTAJ WSZYSTKIE LINIE ---
  (setq taz_s_cl_f (open taz_s_cl_file "r"))
  (setq taz_s_cl_all_lines (list))
  (setq taz_s_cl_line (read-line taz_s_cl_f))
  (while taz_s_cl_line
    (setq taz_s_cl_all_lines (append taz_s_cl_all_lines (list taz_s_cl_line)))
    (setq taz_s_cl_line (read-line taz_s_cl_f))
  )
  (close taz_s_cl_f)

  ;; --- ODWROC LISTE ---
  (setq taz_s_cl_reversed (reverse taz_s_cl_all_lines))

  ;; --- PRZEJDZ OD KONCA ---
  (setq taz_s_cl_seen (list))
  (setq taz_s_cl_result (list))
  (setq taz_s_cl_i 0)

  (while (< taz_s_cl_i (length taz_s_cl_reversed))

    (setq taz_s_cl_line (nth taz_s_cl_i taz_s_cl_reversed))

    (if (= (substr taz_s_cl_line 1 6) "(setq ")
      (progn
        ;; Wyciagnij nazwe zmiennej - szukaj spacji bez vl
        (setq taz_s_cl_rest (substr taz_s_cl_line 7))
        (setq taz_s_cl_sp nil)
        (setq taz_s_cl_j 1)
        (while (and (not taz_s_cl_sp) (<= taz_s_cl_j (strlen taz_s_cl_rest)))
          (if (= (substr taz_s_cl_rest taz_s_cl_j 1) " ")
            (setq taz_s_cl_sp taz_s_cl_j)
          )
          (setq taz_s_cl_j (1+ taz_s_cl_j))
        )
        (setq taz_s_cl_varname (substr taz_s_cl_rest 1 (1- taz_s_cl_sp)))

        ;; Jesli zmienna nie byla jeszcze widziana - dodaj do wyniku
        (if (not (member taz_s_cl_varname taz_s_cl_seen))
          (progn
            (setq taz_s_cl_seen (append taz_s_cl_seen (list taz_s_cl_varname)))
            (setq taz_s_cl_result (append taz_s_cl_result (list taz_s_cl_line)))
          )
        )
      )
    )

    (setq taz_s_cl_i (1+ taz_s_cl_i))
  )

  ;; --- ODWROC WYNIK ---
  (setq taz_s_cl_result (reverse taz_s_cl_result))

  ;; --- ZAPISZ DO PLIKU ---
  (setq taz_s_cl_f (open taz_s_cl_file "w"))
  (setq taz_s_cl_i 0)
  (while (< taz_s_cl_i (length taz_s_cl_result))
    (write-line (nth taz_s_cl_i taz_s_cl_result) taz_s_cl_f)
    (setq taz_s_cl_i (1+ taz_s_cl_i))
  )
  (close taz_s_cl_f)

)