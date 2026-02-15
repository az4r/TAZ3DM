(defun c:taz_s_edit_attributes ( / dcl_id key )

  ;; Pobranie nazwy obiektu (Twoja zmienna)
  (setq taz_s_attribs_object_name
        (cdr (assoc 5 (entget (entlast))))
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
      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr1\"))
      (set (read key) (get_tile \"attr1\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr2\"))
      (set (read key) (get_tile \"attr2\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr3\"))
      (set (read key) (get_tile \"attr3\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr4\"))
      (set (read key) (get_tile \"attr4\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr5\"))
      (set (read key) (get_tile \"attr5\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr6\"))
      (set (read key) (get_tile \"attr6\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr7\"))
      (set (read key) (get_tile \"attr7\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr8\"))
      (set (read key) (get_tile \"attr8\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr9\"))
      (set (read key) (get_tile \"attr9\"))

      (setq key (strcat \"taz_s_\" taz_s_attribs_object_name \"_attr10\"))
      (set (read key) (get_tile \"attr10\"))

      (done_dialog 1)
   )"
)

  (action_tile "cancel" "(done_dialog 0)")

  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)
