(defun c:taz_s_edit_attributes ( / dcl_id key )

  ;; ---------------------------------------------------------
  ;; SELEKCJA OBIEKTÓW
  ;; ---------------------------------------------------------

  ;; Pobranie obiektów: najpierw sprawdź zaznaczenie, jeśli brak – poproś użytkownika
  (setq taz_s_attribs_selection (ssget "_I"))

  (if (not taz_s_attribs_selection)
    (setq taz_s_attribs_selection (ssget "_+.:E:S" '((0 . "*"))))
  )

  ;; Jeśli nadal brak selekcji → przerwij
  (if (not taz_s_attribs_selection)
    (progn
      (alert "Nie wybrano obiektu.")
      (exit)
    )
  )

  ;; Pobranie liczby obiektów
  (setq taz_s_attribs_count (sslength taz_s_attribs_selection))

  ;; Pobranie nazwy pierwszego obiektu (do wyświetlenia w oknie)
  (setq taz_s_attribs_object_name
        (cdr (assoc 5 (entget (ssname taz_s_attribs_selection 0))))
  )

  ;; ---------------------------------------------------------
  ;; FUNKCJA: pobieranie wspólnej wartości atrybutu
  ;; ---------------------------------------------------------

  (defun taz_s_get_common_value (attr)
    ;; Zwraca wspólną wartość lub "*rozne*"
    (setq taz_s_attribs_count_index 0)
    (setq taz_s_attribs_object_first_value nil)
    (setq taz_s_attribs_object_mixed nil)

    (while (< taz_s_attribs_count_index taz_s_attribs_count)

      ;; Pobranie encji
      (setq taz_s_attribs_object
            (ssname taz_s_attribs_selection taz_s_attribs_count_index))

      ;; Pobranie nazwy obiektu
      (setq taz_s_attribs_object_name
            (cdr (assoc 5 (entget taz_s_attribs_object))))

      ;; Pobranie wartości atrybutu
      (setq taz_s_attribs_object_value
            (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_" attr))))

      ;; Porównanie
      (if (not taz_s_attribs_object_first_value)
        (setq taz_s_attribs_object_first_value taz_s_attribs_object_value)
        (if (/= taz_s_attribs_object_first_value taz_s_attribs_object_value)
          (setq taz_s_attribs_object_mixed T)
        )
      )

      (setq taz_s_attribs_count_index (1+ taz_s_attribs_count_index))
    )

    (if taz_s_attribs_object_mixed "*rozne*" taz_s_attribs_object_first_value)
  )

  ;; ---------------------------------------------------------
  ;; Wczytanie DCL
  ;; ---------------------------------------------------------

  (setq dcl_id (load_dialog "taz_s_edit_attributes.dcl"))
  (if (not (new_dialog "taz_s_edit_attributes" dcl_id))
    (progn (alert "Nie mogę otworzyć DCL") (exit))
  )

  ;; ---------------------------------------------------------
  ;; Ustawienie wartości w polach DCL
  ;; ---------------------------------------------------------

  (set_tile "attr1"  (taz_s_get_common_value "attr1"))
  (set_tile "attr2"  (taz_s_get_common_value "attr2"))
  (set_tile "attr3"  (taz_s_get_common_value "attr3"))
  (set_tile "attr4"  (taz_s_get_common_value "attr4"))
  (set_tile "attr5"  (taz_s_get_common_value "attr5"))
  (set_tile "attr6"  (taz_s_get_common_value "attr6"))
  (set_tile "attr7"  (taz_s_get_common_value "attr7"))
  (set_tile "attr8"  (taz_s_get_common_value "attr8"))
  (set_tile "attr9"  (taz_s_get_common_value "attr9"))
  (set_tile "attr10" (taz_s_get_common_value "attr10"))

  ;; ---------------------------------------------------------
  ;; Zapis wartości po kliknięciu OK
  ;; ---------------------------------------------------------

  (action_tile "accept"
  "(progn
      (setq taz_s_attribs_count_index 0)

      (while (< taz_s_attribs_count_index taz_s_attribs_count)

        ;; Pobranie encji
        (setq taz_s_attribs_object
              (ssname taz_s_attribs_selection taz_s_attribs_count_index))

        ;; Pobranie nazwy obiektu
        (setq taz_s_attribs_object_name
              (cdr (assoc 5 (entget taz_s_attribs_object))))

        ;; Atrybut 1
        (setq taz_s_attribs_object_value (get_tile \"attr1\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr1\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 2
        (setq taz_s_attribs_object_value (get_tile \"attr2\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr2\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 3
        (setq taz_s_attribs_object_value (get_tile \"attr3\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr3\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 4
        (setq taz_s_attribs_object_value (get_tile \"attr4\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr4\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 5
        (setq taz_s_attribs_object_value (get_tile \"attr5\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr5\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 6
        (setq taz_s_attribs_object_value (get_tile \"attr6\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr6\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 7
        (setq taz_s_attribs_object_value (get_tile \"attr7\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr7\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 8
        (setq taz_s_attribs_object_value (get_tile \"attr8\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr8\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 9
        (setq taz_s_attribs_object_value (get_tile \"attr9\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr9\"))
               taz_s_attribs_object_value)
        )

        ;; Atrybut 10
        (setq taz_s_attribs_object_value (get_tile \"attr10\"))
        (if (/= taz_s_attribs_object_value \"*rozne*\")
          (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr10\"))
               taz_s_attribs_object_value)
        )

        (setq taz_s_attribs_count_index (1+ taz_s_attribs_count_index))
      )

      (done_dialog 1)
   )"
  )

  ;; ---------------------------------------------------------
  ;; ANULUJ
  ;; ---------------------------------------------------------

  (action_tile "cancel" "(done_dialog 0)")

  ;; ---------------------------------------------------------
  ;; START + UNLOAD
  ;; ---------------------------------------------------------

  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)
