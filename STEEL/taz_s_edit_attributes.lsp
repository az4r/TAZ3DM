(defun c:taz_s_edit_attributes ( / dcl_id key )

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

  ;; Wczytanie DCL
  (setq dcl_id (load_dialog "taz_s_edit_attributes.dcl"))
  (if (not (new_dialog "taz_s_edit_attributes" dcl_id))
    (progn (alert "Nie mogę otworzyć DCL") (exit))
  )

  ;; -----------------------------
  ;; Ustawienie wartości w polach
  ;; -----------------------------
  (set_tile "attr1"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1"))))
  (set_tile "attr2"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2"))))
  (set_tile "attr3"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3"))))
  (set_tile "attr4"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4"))))
  (set_tile "attr5"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5"))))
  (set_tile "attr6"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6"))))
  (set_tile "attr7"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7"))))
  (set_tile "attr8"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8"))))
  (set_tile "attr9"  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9"))))
  (set_tile "attr10" (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10"))))

  ;; -----------------------------
  ;; Zapis wartości po kliknięciu OK
  ;; -----------------------------
  (action_tile "accept"
  "(progn
      ;; Pętla po wszystkich obiektach w selekcji
      (setq taz_s_attribs_count_index 0)
      (while (< taz_s_attribs_count_index taz_s_attribs_count)

        ;; Pobranie encji
        (setq taz_s_attribs_object (ssname taz_s_attribs_selection taz_s_attribs_count_index))

        ;; Pobranie nazwy obiektu
        (setq taz_s_attribs_object_name (cdr (assoc 5 (entget taz_s_attribs_object))))

        ;; Zapis wartości
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr1\")) (get_tile \"attr1\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr2\")) (get_tile \"attr2\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr3\")) (get_tile \"attr3\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr4\")) (get_tile \"attr4\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr5\")) (get_tile \"attr5\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr6\")) (get_tile \"attr6\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr7\")) (get_tile \"attr7\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr8\")) (get_tile \"attr8\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr9\")) (get_tile \"attr9\"))
        (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr10\")) (get_tile \"attr10\"))

        ;; Następny obiekt
        (setq taz_s_attribs_count_index (1+ taz_s_attribs_count_index))
      )

      (done_dialog 1)
   )"
  )


  (action_tile "cancel" "(done_dialog 0)")

  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)
