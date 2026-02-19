(defun c:taz_s_edit_attributes
  ( / taz_s_dcl_id
       taz_s_key
       taz_s_attribs_selection
       taz_s_attribs_count
       taz_s_attribs_object_name
       taz_s_attribs_count_index
       taz_s_attribs_object
       taz_s_attribs_object_value
       taz_s_attribs_object_first_value
       taz_s_attribs_object_mixed
  )

  ;; ---------------------------------------------------------
  ;; SELEKCJA OBIEKTÓW
  ;; ---------------------------------------------------------

  (setq taz_s_attribs_selection (ssget "_I"))

  (if (not taz_s_attribs_selection)
    (setq taz_s_attribs_selection (ssget "_+.:E:S" '((0 . "*"))))
  )

  (if (not taz_s_attribs_selection)
    (progn
      (alert "Nie wybrano obiektu.")
      (exit)
    )
  )

  (setq taz_s_attribs_count (sslength taz_s_attribs_selection))

  (setq taz_s_attribs_object_name
        (cdr (assoc 5 (entget (ssname taz_s_attribs_selection 0)))))

  ;; ---------------------------------------------------------
  ;; FUNKCJA POBIERAJĄCA WSPÓLNĄ WARTOŚĆ ATRYBUTU
  ;; ---------------------------------------------------------

  (defun taz_s_get_common_value (taz_s_attr_name)

    (setq taz_s_attribs_count_index 0)
    (setq taz_s_attribs_object_first_value nil)
    (setq taz_s_attribs_object_mixed nil)

    (while (< taz_s_attribs_count_index taz_s_attribs_count)

      (setq taz_s_attribs_object
            (ssname taz_s_attribs_selection taz_s_attribs_count_index))

      (setq taz_s_attribs_object_name
            (cdr (assoc 5 (entget taz_s_attribs_object))))

      (setq taz_s_attribs_object_value
            (eval (read
                    (strcat "taz_s_"
                            taz_s_attribs_object_name
                            "_"
                            taz_s_attr_name))))

      (if (not taz_s_attribs_object_first_value)
        (setq taz_s_attribs_object_first_value taz_s_attribs_object_value)
        (if (/= taz_s_attribs_object_first_value taz_s_attribs_object_value)
          (setq taz_s_attribs_object_mixed T)
        )
      )

      (setq taz_s_attribs_count_index
            (1+ taz_s_attribs_count_index))
    )

    (if taz_s_attribs_object_mixed
      "*ROZNE*"
      taz_s_attribs_object_first_value
    )
  )

  ;; ---------------------------------------------------------
  ;; Wczytanie DCL
  ;; ---------------------------------------------------------

  (setq taz_s_dcl_id (load_dialog "taz_s_edit_attributes.dcl"))

  (if (not (new_dialog "taz_s_edit_attributes_dialog" taz_s_dcl_id))
    (progn
      (alert "Nie mogę otworzyć DCL")
      (exit)
    )
  )

  ;; ---------------------------------------------------------
  ;; Ustawienie wartości w polach
  ;; ---------------------------------------------------------

  (set_tile "taz_s_attr1"  (taz_s_get_common_value "attr1"))
  (set_tile "taz_s_attr2"  (taz_s_get_common_value "attr2"))
  (set_tile "taz_s_attr3"  (taz_s_get_common_value "attr3"))
  (set_tile "taz_s_attr4"  (taz_s_get_common_value "attr4"))
  (set_tile "taz_s_attr5"  (taz_s_get_common_value "attr5"))
  (set_tile "taz_s_attr6"  (taz_s_get_common_value "attr6"))
  (set_tile "taz_s_attr7"  (taz_s_get_common_value "attr7"))
  (set_tile "taz_s_attr8"  (taz_s_get_common_value "attr8"))
  (set_tile "taz_s_attr9"  (taz_s_get_common_value "attr9"))
  (set_tile "taz_s_attr10" (taz_s_get_common_value "attr10"))

  ;; ---------------------------------------------------------
  ;; Zapis wartości po kliknięciu OK
  ;; ---------------------------------------------------------

  (action_tile
    "accept"
    "(progn
        (setq taz_s_attribs_count_index 0)

        (while (< taz_s_attribs_count_index taz_s_attribs_count)

          (setq taz_s_attribs_object
                (ssname taz_s_attribs_selection taz_s_attribs_count_index))

          (setq taz_s_attribs_object_name
                (cdr (assoc 5 (entget taz_s_attribs_object))))

          ;; Atrybut 1
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr1\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr1\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 2
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr2\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr2\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 3
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr3\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr3\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 4
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr4\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr4\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 5
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr5\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr5\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 6
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr6\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr6\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 7
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr7\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr7\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 8
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr8\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr8\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 9
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr9\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr9\"))
                 taz_s_attribs_object_value)
          )

          ;; Atrybut 10
          (setq taz_s_attribs_object_value (get_tile \"taz_s_attr10\"))
          (if (/= taz_s_attribs_object_value \"*ROZNE*\")
            (set (read (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr10\"))
                 taz_s_attribs_object_value)
          )

          (setq taz_s_attribs_count_index
                (1+ taz_s_attribs_count_index))
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
  (unload_dialog taz_s_dcl_id)
  (princ)
)
