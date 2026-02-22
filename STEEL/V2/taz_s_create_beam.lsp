; taz_s_create_beam_toporny_cmd.lsp
; Wersja rozszerzona o Kątowniki i Rury

(defun c:taz_s_create_beam ( / taz_s_dcl_id )

  ;; ---------------------------
  ;; DOMYŚLNE WARTOŚCI (jeśli brak)
  ;; ---------------------------
  (if (not taz_s_category) (setq taz_s_category "Dwuteowniki"))
  (if (not taz_s_family)   (setq taz_s_family   "HEA"))
  (if (not taz_s_type)     (setq taz_s_type     "100"))

  ;; ---------------------------
  ;; ZMIENNE TYMCZASOWE
  ;; ---------------------------
  (setq taz_s_tmp_category taz_s_category)
  (setq taz_s_tmp_family   taz_s_family)
  (setq taz_s_tmp_type     taz_s_type)

  ;; ---------------------------
  ;; Wczytanie DCL
  ;; ---------------------------
  (setq taz_s_dcl_id (load_dialog "taz_s_create_beam.dcl"))
  (if (not (new_dialog "taz_s_create_beam" taz_s_dcl_id))
    (progn
      (alert "Nie mogę otworzyć DCL!")
      (exit)
    )
  )

  ;; ---------------------------
  ;; Funkcja uzupełniająca listę rodzin
  ;; ---------------------------
  (defun taz_s_fill_family_list (taz_s_cat_val /)
    (start_list "taz_s_fam")

    (if (= taz_s_cat_val "Dwuteowniki")
      (progn (add_list "HEA") (add_list "HEB"))
    )

    (if (= taz_s_cat_val "Ceowniki")
      (progn (add_list "UPE") (add_list "UPN"))
    )

    (if (= taz_s_cat_val "Kątowniki")
      (progn
        (add_list "Kątownik równoramienny")
        (add_list "Kątownik nierównoramienny")
      )
    )

    (if (= taz_s_cat_val "Rury")
      (progn
        (add_list "Rura kwadratowa")
        (add_list "Rura prostokątna")
        (add_list "Rura okrągła")
      )
    )

    (end_list)
  )

  ;; ---------------------------
  ;; Funkcja uzupełniająca listę typów
  ;; ---------------------------
  (defun taz_s_fill_type_list (taz_s_cat_val taz_s_fam_val /)
    (start_list "taz_s_typ")

    ;; DWUTEOWNIKI
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEA"))
      (progn (add_list "100") (add_list "200"))
    )
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEB"))
      (progn (add_list "300") (add_list "400"))
    )

    ;; CEOWNIKI
    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPE"))
      (progn (add_list "500") (add_list "600"))
    )
    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPN"))
      (progn (add_list "700") (add_list "800"))
    )

    ;; KĄTOWNIKI
    (if (and (= taz_s_cat_val "Kątowniki") (= taz_s_fam_val "Kątownik równoramienny"))
      (progn (add_list "40x40x4") (add_list "50x50x4"))
    )
    (if (and (= taz_s_cat_val "Kątowniki") (= taz_s_fam_val "Kątownik nierównoramienny"))
      (progn (add_list "60x70x4") (add_list "80x90x4"))
    )

    ;; RURY
    (if (and (= taz_s_cat_val "Rury") (= taz_s_fam_val "Rura kwadratowa"))
      (progn (add_list "60x4") (add_list "100x4"))
    )
    (if (and (= taz_s_cat_val "Rury") (= taz_s_fam_val "Rura prostokątna"))
      (progn (add_list "40x20x4") (add_list "50x40x4"))
    )
    (if (and (= taz_s_cat_val "Rury") (= taz_s_fam_val "Rura okrągła"))
      (progn (add_list "42.4x2.9") (add_list "26.9x2.3"))
    )

    (end_list)
  )

  ;; ---------------------------
  ;; Lista kategorii
  ;; ---------------------------
  (start_list "taz_s_cat")
    (add_list "Dwuteowniki")
    (add_list "Ceowniki")
    (add_list "Kątowniki")
    (add_list "Rury")
  (end_list)

  ;; ---------------------------
  ;; Ustawienie początkowych wartości TILE
  ;; ---------------------------

  ;; Kategoria
  (if (= taz_s_tmp_category "Dwuteowniki") (set_tile "taz_s_cat" "0"))
  (if (= taz_s_tmp_category "Ceowniki")    (set_tile "taz_s_cat" "1"))
  (if (= taz_s_tmp_category "Kątowniki")   (set_tile "taz_s_cat" "2"))
  (if (= taz_s_tmp_category "Rury")        (set_tile "taz_s_cat" "3"))

  ;; Rodziny
  (taz_s_fill_family_list taz_s_tmp_category)

  (if (= taz_s_tmp_family "HEA") (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "HEB") (set_tile "taz_s_fam" "1"))
  (if (= taz_s_tmp_family "UPE") (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "UPN") (set_tile "taz_s_fam" "1"))

  (if (= taz_s_tmp_family "Kątownik równoramienny")    (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "Kątownik nierównoramienny") (set_tile "taz_s_fam" "1"))

  (if (= taz_s_tmp_family "Rura kwadratowa")   (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "Rura prostokątna")  (set_tile "taz_s_fam" "1"))
  (if (= taz_s_tmp_family "Rura okrągła")      (set_tile "taz_s_fam" "2"))

  ;; Typy
  (taz_s_fill_type_list taz_s_tmp_category taz_s_tmp_family)

  ;; DWUTEOWNIKI
  (if (and (= taz_s_tmp_family "HEA") (= taz_s_tmp_type "100")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "HEA") (= taz_s_tmp_type "200")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "HEB") (= taz_s_tmp_type "300")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "HEB") (= taz_s_tmp_type "400")) (set_tile "taz_s_typ" "1"))

  ;; CEOWNIKI
  (if (and (= taz_s_tmp_family "UPE") (= taz_s_tmp_type "500")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "UPE") (= taz_s_tmp_type "600")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "UPN") (= taz_s_tmp_type "700")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "UPN") (= taz_s_tmp_type "800")) (set_tile "taz_s_typ" "1"))

  ;; KĄTOWNIKI
  (if (and (= taz_s_tmp_family "Kątownik równoramienny") (= taz_s_tmp_type "40x40x4")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "Kątownik równoramienny") (= taz_s_tmp_type "50x50x4")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "Kątownik nierównoramienny") (= taz_s_tmp_type "60x70x4")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "Kątownik nierównoramienny") (= taz_s_tmp_type "80x90x4")) (set_tile "taz_s_typ" "1"))

  ;; RURY
  (if (and (= taz_s_tmp_family "Rura kwadratowa") (= taz_s_tmp_type "60x4")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "Rura kwadratowa") (= taz_s_tmp_type "100x4")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "Rura prostokątna") (= taz_s_tmp_type "40x20x4")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "Rura prostokątna") (= taz_s_tmp_type "50x40x4")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "Rura okrągła") (= taz_s_tmp_type "42.4x2.9")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "Rura okrągła") (= taz_s_tmp_type "26.9x2.3")) (set_tile "taz_s_typ" "1"))

  ;; ============================================================
  ;; OBSŁUGA ZMIAN TILE
  ;; ============================================================

  (defun taz_s_on_cat_change ( / )
    (if (= $value "0") (setq taz_s_tmp_category "Dwuteowniki"))
    (if (= $value "1") (setq taz_s_tmp_category "Ceowniki"))
    (if (= $value "2") (setq taz_s_tmp_category "Kątowniki"))
    (if (= $value "3") (setq taz_s_tmp_category "Rury"))

    (taz_s_fill_family_list taz_s_tmp_category)

    (cond
      ((= taz_s_tmp_category "Dwuteowniki") (setq taz_s_tmp_family "HEA"))
      ((= taz_s_tmp_category "Ceowniki")    (setq taz_s_tmp_family "UPE"))
      ((= taz_s_tmp_category "Kątowniki")   (setq taz_s_tmp_family "Kątownik równoramienny"))
      ((= taz_s_tmp_category "Rury")        (setq taz_s_tmp_family "Rura kwadratowa"))
    )

    (set_tile "taz_s_fam" "0")

    (taz_s_fill_type_list taz_s_tmp_category taz_s_tmp_family)
    (setq taz_s_tmp_type "100")
    (set_tile "taz_s_typ" "0")
  )

  (defun taz_s_on_fam_change ( / fam_index )
    (setq fam_index (atoi $value))

    (cond
      ;; Dwuteowniki
      ((= (get_tile "taz_s_cat") "0")
        (if (= fam_index 0) (setq taz_s_tmp_family "HEA"))
        (if (= fam_index 1) (setq taz_s_tmp_family "HEB"))
      )

      ;; Ceowniki
      ((= (get_tile "taz_s_cat") "1")
        (if (= fam_index 0) (setq taz_s_tmp_family "UPE"))
        (if (= fam_index 1) (setq taz_s_tmp_family "UPN"))
      )

      ;; Kątowniki
      ((= (get_tile "taz_s_cat") "2")
        (if (= fam_index 0) (setq taz_s_tmp_family "Kątownik równoramienny"))
        (if (= fam_index 1) (setq taz_s_tmp_family "Kątownik nierównoramienny"))
      )

      ;; Rury
      ((= (get_tile "taz_s_cat") "3")
        (if (= fam_index 0) (setq taz_s_tmp_family "Rura kwadratowa"))
        (if (= fam_index 1) (setq taz_s_tmp_family "Rura prostokątna"))
        (if (= fam_index 2) (setq taz_s_tmp_family "Rura okrągła"))
      )
    )

    (taz_s_fill_type_list taz_s_tmp_category taz_s_tmp_family)
    (setq taz_s_tmp_type "100")
    (set_tile "taz_s_typ" "0")
  )

  (defun taz_s_on_typ_change ( / )
    (setq taz_s_tmp_type
      (nth (atoi $value)
        (cond
          ((= taz_s_tmp_family "HEA") '("100" "200"))
          ((= taz_s_tmp_family "HEB") '("300" "400"))
          ((= taz_s_tmp_family "UPE") '("500" "600"))
          ((= taz_s_tmp_family "UPN") '("700" "800"))

          ((= taz_s_tmp_family "Kątownik równoramienny") '("40x40x4" "50x50x4"))
          ((= taz_s_tmp_family "Kątownik nierównoramienny") '("60x70x4" "80x90x4"))

          ((= taz_s_tmp_family "Rura kwadratowa") '("60x4" "100x4"))
          ((= taz_s_tmp_family "Rura prostokątna") '("40x20x4" "50x40x4"))
          ((= taz_s_tmp_family "Rura okrągła") '("42.4x2.9" "26.9x2.3"))
        )
      )
    )
  )

  ;; ============================================================
  ;; PODPIĘCIE FUNKCJI DO TILE
  ;; ============================================================

  (action_tile "taz_s_cat" "(taz_s_on_cat_change)")
  (action_tile "taz_s_fam" "(taz_s_on_fam_change)")
  (action_tile "taz_s_typ" "(taz_s_on_typ_change)")

  ;; ---------------------------
  ;; Przycisk OK — zapisujemy zmienne
  ;; ---------------------------
  (action_tile "ok"
    "(progn
       (setq taz_s_category taz_s_tmp_category)
       (setq taz_s_family   taz_s_tmp_family)
       (setq taz_s_type     taz_s_tmp_type)
       (done_dialog 1)
     )"
  )

  ;; ---------------------------
  ;; Przycisk Anuluj — nic nie zapisujemy
  ;; ---------------------------
  (action_tile "anuluj"
    "(done_dialog 0)"
  )

  ;; ---------------------------
  ;; Uruchomienie dialogu
  ;; ---------------------------
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

