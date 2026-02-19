(defun c:taz_s_create_beam ( / taz_s_dcl_id )

  ;; --- DOMYŚLNE WARTOŚCI JEŚLI ZMIENNE NIE ISTNIEJĄ ---
  (if (not taz_s_category) (setq taz_s_category "Dwuteowniki"))
  (if (not taz_s_family)   (setq taz_s_family   "HEA"))
  (if (not taz_s_type)     (setq taz_s_type     "100"))

  ;; --- WCZYTANIE DCL ---
  (setq taz_s_dcl_id (load_dialog "taz_s_create_beam.dcl"))
  (if (not (new_dialog "taz_s_create_beam" taz_s_dcl_id))
    (progn (alert "Nie mogę otworzyć DCL!") (exit))
  )

  ;; --- FUNKCJA UZUPEŁNIAJĄCA LISTĘ RODZIN ---
  (defun taz_s_fill_family_list (taz_s_cat_val / taz_s_lst)
    (cond
      ((= taz_s_cat_val "Dwuteowniki") (setq taz_s_lst '("HEA" "HEB")))
      ((= taz_s_cat_val "Ceowniki")    (setq taz_s_lst '("UPE" "UPN")))
      (t                                (setq taz_s_lst '()))
    )
    (start_list "taz_s_fam")
    (mapcar 'add_list taz_s_lst)
    (end_list)
  )

  ;; --- FUNKCJA UZUPEŁNIAJĄCA LISTĘ TYPÓW ---
  (defun taz_s_fill_type_list (taz_s_cat_val taz_s_fam_val / taz_s_lst)
    (cond
      ((and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEA"))
        (setq taz_s_lst '("100" "200"))
      )
      ((and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEB"))
        (setq taz_s_lst '("300" "400"))
      )
      ((and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPE"))
        (setq taz_s_lst '("500" "600"))
      )
      ((and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPN"))
        (setq taz_s_lst '("700" "800"))
      )
      (t (setq taz_s_lst '()))
    )
    (start_list "taz_s_typ")
    (mapcar 'add_list taz_s_lst)
    (end_list)
  )

  ;; --- UZUPEŁNIENIE LISTY KATEGORII ---
  (start_list "taz_s_cat")
  (mapcar 'add_list '("Dwuteowniki" "Ceowniki"))
  (end_list)

  ;; --- USTAWIENIE POCZĄTKOWYCH WARTOŚCI ---
  (set_tile "taz_s_cat"
            (itoa (vl-position taz_s_category '("Dwuteowniki" "Ceowniki"))))

  (taz_s_fill_family_list taz_s_category)

  (set_tile "taz_s_fam"
            (itoa (vl-position taz_s_family
                    (if (= taz_s_category "Dwuteowniki")
                      '("HEA" "HEB")
                      '("UPE" "UPN")
                    ))))

  (taz_s_fill_type_list taz_s_category taz_s_family)

  (set_tile "taz_s_typ"
            (itoa (vl-position taz_s_type
                    (cond
                      ((and (= taz_s_category "Dwuteowniki") (= taz_s_family "HEA"))
                        '("100" "200"))
                      ((and (= taz_s_category "Dwuteowniki") (= taz_s_family "HEB"))
                        '("300" "400"))
                      ((and (= taz_s_category "Ceowniki")    (= taz_s_family "UPE"))
                        '("500" "600"))
                      ((and (= taz_s_category "Ceowniki")    (= taz_s_family "UPN"))
                        '("700" "800"))
                    ))))

  ;; --- REAKCJA NA ZMIANĘ KATEGORII ---
  (action_tile "taz_s_cat"
    "(setq taz_s_category
           (nth (atoi $value) '(\"Dwuteowniki\" \"Ceowniki\")))

     (taz_s_fill_family_list taz_s_category)

     (setq taz_s_family
           (nth 0 (if (= taz_s_category \"Dwuteowniki\")
                     '(\"HEA\" \"HEB\")
                     '(\"UPE\" \"UPN\"))))

     (set_tile \"taz_s_fam\" \"0\")

     (taz_s_fill_type_list taz_s_category taz_s_family)

     (setq taz_s_type
           (nth 0 (cond
                    ((= taz_s_family \"HEA\") '(\"100\" \"200\"))
                    ((= taz_s_family \"HEB\") '(\"300\" \"400\"))
                    ((= taz_s_family \"UPE\") '(\"500\" \"600\"))
                    ((= taz_s_family \"UPN\") '(\"700\" \"800\"))
                  )))

     (set_tile \"taz_s_typ\" \"0\")
    "
  )

  ;; --- REAKCJA NA ZMIANĘ RODZINY ---
  (action_tile "taz_s_fam"
    "(setq taz_s_family
           (nth (atoi $value)
                (if (= taz_s_category \"Dwuteowniki\")
                  '(\"HEA\" \"HEB\")
                  '(\"UPE\" \"UPN\"))))

     (taz_s_fill_type_list taz_s_category taz_s_family)

     (setq taz_s_type
           (nth 0 (cond
                    ((= taz_s_family \"HEA\") '(\"100\" \"200\"))
                    ((= taz_s_family \"HEB\") '(\"300\" \"400\"))
                    ((= taz_s_family \"UPE\") '(\"500\" \"600\"))
                    ((= taz_s_family \"UPN\") '(\"700\" \"800\"))
                  )))

     (set_tile \"taz_s_typ\" \"0\")
    "
  )

  ;; --- REAKCJA NA ZMIANĘ TYPU ---
  (action_tile "taz_s_typ"
    "(setq taz_s_type
           (nth (atoi $value)
                (cond
                  ((= taz_s_family \"HEA\") '(\"100\" \"200\"))
                  ((= taz_s_family \"HEB\") '(\"300\" \"400\"))
                  ((= taz_s_family \"UPE\") '(\"500\" \"600\"))
                  ((= taz_s_family \"UPN\") '(\"700\" \"800\"))
                )))"
  )

  ;; --- PRZYCISK OK ---
  (action_tile "ok" "(done_dialog 1)")

  ;; --- PRZYCISK ANULUJ ---
  (action_tile "anuluj" "(done_dialog 0)")

  ;; --- URUCHOMIENIE OKNA ---
  (if (= (start_dialog) 1)
    (progn
      (princ "\nWybrane wartości:")
      (princ (strcat "\nKategoria: " taz_s_category))
      (princ (strcat "\nRodzina:   " taz_s_family))
      (princ (strcat "\nTyp:       " taz_s_type))
    )
    (princ "\nAnulowano.")
  )

  (unload_dialog taz_s_dcl_id)
  (princ)
)
