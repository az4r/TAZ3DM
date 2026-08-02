;; ============================================================
;; TAZ_S_DELETE_BEAM.LSP
;;
;; Co robi:
;;  1. Pobiera zaznaczony obiekt (bryla 3D) i jego uchwyt (handle)
;;  2. Wczytuje plik taz_s_data_file (taz_s_beam_data.txt)
;;  3. Odnajduje na rysunku wszystkie bryly 3D na warstwie
;;     "taz_s_beam" (tak jak w taz_s_rebuild_data)
;;  4. Czysci plik i zapisuje go od nowa - ale POMIJA wpisy
;;     dotyczace bryly, ktora zaznaczylismy do usuniecia
;;  5. Na koniec usuwa (entdel) zaznaczona bryle z rysunku
;; ============================================================

(defun c:taz_s_delete_beam ()

  (taz_s_current_settings_save)

  ;; ---------------------------------------------------------
  ;; SCIEZKA DO PLIKU DANYCH
  ;; ---------------------------------------------------------

  (setq taz_s_data_file
    (strcat (taz_s_path) "taz_s_beam_data.txt"))

  ;; ---------------------------------------------------------
  ;; POBIERZ ZAZNACZENIE
  ;; ---------------------------------------------------------

  (setq taz_s_delete_selection (ssget "_I"))

  ;; jesli zaznaczono wiecej niz jeden obiekt -> wymus wybor jednego
  (if (and taz_s_delete_selection
           (> (sslength taz_s_delete_selection) 1))
    (progn
      (sssetfirst nil nil)
      (setq taz_s_delete_selection (ssget "_+.:E:S"))
    )
  )

  ;; jesli brak selekcji -> popros o wskazanie
  (if (null taz_s_delete_selection)
    (setq taz_s_delete_selection (ssget "_+.:E:S"))
  )

  ;; jesli nadal brak selekcji -> zakoncz
  (if (null taz_s_delete_selection)
    (progn
      (print "Nie wybrano obiektu.")
      (taz_s_current_settings_restore)
      (exit)
    )
  )

  ;; pobierz obiekt
  (setq taz_s_delete_object (ssname taz_s_delete_selection 0))

  ;; sprawdz typ
  (if (/= (cdr (assoc 0 (entget taz_s_delete_object))) "3DSOLID")
    (progn
      (print "Wybrany obiekt nie jest bryla 3D.")
      (taz_s_current_settings_restore)
      (exit)
    )
  )

  ;; pobierz uchwyt (handle) obiektu do usuniecia
  (setq taz_s_delete_object_handle
        (cdr (assoc 5 (entget taz_s_delete_object))))

  ;; ---------------------------------------------------------
  ;; WCZYTAJ BAZE - w pamieci zostana ostatnie/aktualne wartosci
  ;; ---------------------------------------------------------

  (load taz_s_data_file)

  ;; ---------------------------------------------------------
  ;; SZUKAMY WSZYSTKICH BRYL 3D NA WARSTWIE taz_s_beam
  ;; ---------------------------------------------------------

  (setq taz_s_selection_set (ssget "_X" '((0 . "3DSOLID") (8 . "taz_s_beam"))))

  (if (= taz_s_selection_set nil)

    (princ "\nNie znaleziono zadnych bryl 3D na warstwie taz_s_beam.")

    (progn

      ;; -- otwieramy plik do zapisu, tryb "w" czysci cala zawartosc --
      (setq taz_s_output_file (open taz_s_data_file "w"))

      (setq taz_s_ok_count 0)
      (setq taz_s_selection_count (sslength taz_s_selection_set))
      (setq taz_s_selection_index 0)

      (while (< taz_s_selection_index taz_s_selection_count)

        (setq taz_s_entity_name (ssname taz_s_selection_set taz_s_selection_index))
        (setq taz_s_entity_data (entget taz_s_entity_name))
        (setq taz_s_entity_handle (cdr (assoc 5 taz_s_entity_data)))

        ;; -- pomijamy bryle, ktora usuwamy --
        (if (/= taz_s_entity_handle taz_s_delete_object_handle)
          (progn

            ;; -- pobieramy z pamieci aktualne wartosci tej bryly --
            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr1")))
            (setq taz_s_current_attr1 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr2")))
            (setq taz_s_current_attr2 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr3")))
            (setq taz_s_current_attr3 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr4")))
            (setq taz_s_current_attr4 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr5")))
            (setq taz_s_current_attr5 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr6")))
            (setq taz_s_current_attr6 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr7")))
            (setq taz_s_current_attr7 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr8")))
            (setq taz_s_current_attr8 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr9")))
            (setq taz_s_current_attr9 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_attr10")))
            (setq taz_s_current_attr10 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_section_angle")))
            (setq taz_s_current_section_angle (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_section_position")))
            (setq taz_s_current_section_position (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_sweep_p1")))
            (setq taz_s_current_sweep_p1 (eval taz_s_var_symbol))

            (setq taz_s_var_symbol (read (strcat "taz_s_" taz_s_entity_handle "_sweep_p2")))
            (setq taz_s_current_sweep_p2 (eval taz_s_var_symbol))

            ;; -- zapisujemy komplet danych tej bryly do pliku --
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr1 \"" taz_s_current_attr1 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr2 \"" taz_s_current_attr2 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr3 \"" taz_s_current_attr3 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr4 \"" taz_s_current_attr4 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr5 \"" taz_s_current_attr5 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr6 \"" taz_s_current_attr6 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr7 \"" taz_s_current_attr7 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr8 \"" taz_s_current_attr8 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr9 \"" taz_s_current_attr9 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_attr10 \"" taz_s_current_attr10 "\")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_section_angle " (itoa taz_s_current_section_angle) ")") taz_s_output_file)
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_section_position " (itoa taz_s_current_section_position) ")") taz_s_output_file)

            (setq taz_s_p1x (car taz_s_current_sweep_p1))
            (setq taz_s_p1y (cadr taz_s_current_sweep_p1))
            (setq taz_s_p1z (caddr taz_s_current_sweep_p1))
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_sweep_p1 (list " (rtos taz_s_p1x 2 6) " " (rtos taz_s_p1y 2 6) " " (rtos taz_s_p1z 2 6) "))") taz_s_output_file)

            (setq taz_s_p2x (car taz_s_current_sweep_p2))
            (setq taz_s_p2y (cadr taz_s_current_sweep_p2))
            (setq taz_s_p2z (caddr taz_s_current_sweep_p2))
            (write-line (strcat "(setq taz_s_" taz_s_entity_handle "_sweep_p2 (list " (rtos taz_s_p2x 2 6) " " (rtos taz_s_p2y 2 6) " " (rtos taz_s_p2z 2 6) "))") taz_s_output_file)

            (setq taz_s_ok_count (+ taz_s_ok_count 1))
          )
          ;; ELSE - to jest bryla usuwana, jej wpisow nie zapisujemy
        )

        (setq taz_s_selection_index (+ taz_s_selection_index 1))
      )

      (close taz_s_output_file)

      (princ (strcat "\nZapisano dane dla: " (itoa taz_s_ok_count) " bryl (pominieto usuwana)."))
    )
  )

  ;; ---------------------------------------------------------
  ;; USUN BRYLE Z RYSUNKU
  ;; ---------------------------------------------------------

  (command "_LAYER" "_U" "taz_s_beam" "")
  (if (and taz_s_delete_object (entget taz_s_delete_object))
    (entdel taz_s_delete_object)
  )
  (command "_LAYER" "_LO" "taz_s_beam" "")

  ;; ---------------------------------------------------------
  ;; SPRZATANIE ZMIENNYCH
  ;; ---------------------------------------------------------

  (setq taz_s_delete_selection nil)
  (setq taz_s_delete_object nil)
  (setq taz_s_delete_object_handle nil)

  (taz_s_current_settings_restore)

  (princ)
)
(princ)
