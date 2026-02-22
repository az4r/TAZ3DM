; taz_s_create_beam_toporny_cmd.lsp
; Wersja toporna: wszystko globalne, każdy warunek osobnym IF-em.
; Uruchamianie tylko przez polecenie: c:taz_s_create_beam

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
      (progn
        (add_list "HEA")
        (add_list "HEB")
      )
    )

    (if (= taz_s_cat_val "Ceowniki")
      (progn
        (add_list "UPE")
        (add_list "UPN")
      )
    )

    (end_list)
  )

  ;; ---------------------------
  ;; Funkcja uzupełniająca listę typów
  ;; ---------------------------
  (defun taz_s_fill_type_list (taz_s_cat_val taz_s_fam_val /)
    (start_list "taz_s_typ")

    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEA"))
      (progn (add_list "100") (add_list "200"))
    )

    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEB"))
      (progn (add_list "300") (add_list "400"))
    )

    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPE"))
      (progn (add_list "500") (add_list "600"))
    )

    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPN"))
      (progn (add_list "700") (add_list "800"))
    )

    (end_list)
  )

  ;; ---------------------------
  ;; Lista kategorii
  ;; ---------------------------
  (start_list "taz_s_cat")
  (add_list "Dwuteowniki")
  (add_list "Ceowniki")
  (end_list)

  ;; ---------------------------
  ;; Ustawienie początkowych wartości TILE
  ;; ---------------------------

  ;; Kategoria
  (if (= taz_s_tmp_category "Dwuteowniki") (set_tile "taz_s_cat" "0"))
  (if (= taz_s_tmp_category "Ceowniki")    (set_tile "taz_s_cat" "1"))

  ;; Rodziny
  (taz_s_fill_family_list taz_s_tmp_category)

  (if (= taz_s_tmp_family "HEA") (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "HEB") (set_tile "taz_s_fam" "1"))
  (if (= taz_s_tmp_family "UPE") (set_tile "taz_s_fam" "0"))
  (if (= taz_s_tmp_family "UPN") (set_tile "taz_s_fam" "1"))

  ;; Typy
  (taz_s_fill_type_list taz_s_tmp_category taz_s_tmp_family)

  (if (and (= taz_s_tmp_family "HEA") (= taz_s_tmp_type "100")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "HEA") (= taz_s_tmp_type "200")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "HEB") (= taz_s_tmp_type "300")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "HEB") (= taz_s_tmp_type "400")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "UPE") (= taz_s_tmp_type "500")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "UPE") (= taz_s_tmp_type "600")) (set_tile "taz_s_typ" "1"))

  (if (and (= taz_s_tmp_family "UPN") (= taz_s_tmp_type "700")) (set_tile "taz_s_typ" "0"))
  (if (and (= taz_s_tmp_family "UPN") (= taz_s_tmp_type "800")) (set_tile "taz_s_typ" "1"))

  ;; ============================================================
  ;; NOWE FUNKCJE OBSŁUGI ZMIAN TILE
  ;; ============================================================

  (defun taz_s_on_cat_change ( / )
    (if (= $value "0") (setq taz_s_tmp_category "Dwuteowniki"))
    (if (= $value "1") (setq taz_s_tmp_category "Ceowniki"))

    (start_list "taz_s_fam")
    (if (= taz_s_tmp_category "Dwuteowniki")
      (progn (add_list "HEA") (add_list "HEB")))
    (if (= taz_s_tmp_category "Ceowniki")
      (progn (add_list "UPE") (add_list "UPN")))
    (end_list)

    (if (= taz_s_tmp_category "Dwuteowniki") (setq taz_s_tmp_family "HEA"))
    (if (= taz_s_tmp_category "Ceowniki")    (setq taz_s_tmp_family "UPE"))

    (set_tile "taz_s_fam" "0")

    (start_list "taz_s_typ")
    (if (= taz_s_tmp_family "HEA") (progn (add_list "100") (add_list "200")))
    (if (= taz_s_tmp_family "HEB") (progn (add_list "300") (add_list "400")))
    (if (= taz_s_tmp_family "UPE") (progn (add_list "500") (add_list "600")))
    (if (= taz_s_tmp_family "UPN") (progn (add_list "700") (add_list "800")))
    (end_list)

    (setq taz_s_tmp_type "100")
    (set_tile "taz_s_typ" "0")
  )

  (defun taz_s_on_fam_change ( / )
    (if (= (get_tile "taz_s_cat") "0")
      (progn
        (if (= $value "0") (setq taz_s_tmp_family "HEA"))
        (if (= $value "1") (setq taz_s_tmp_family "HEB"))
      )
    )

    (if (= (get_tile "taz_s_cat") "1")
      (progn
        (if (= $value "0") (setq taz_s_tmp_family "UPE"))
        (if (= $value "1") (setq taz_s_tmp_family "UPN"))
      )
    )

    (start_list "taz_s_typ")
    (if (= taz_s_tmp_family "HEA") (progn (add_list "100") (add_list "200")))
    (if (= taz_s_tmp_family "HEB") (progn (add_list "300") (add_list "400")))
    (if (= taz_s_tmp_family "UPE") (progn (add_list "500") (add_list "600")))
    (if (= taz_s_tmp_family "UPN") (progn (add_list "700") (add_list "800")))
    (end_list)

    (setq taz_s_tmp_type "100")
    (set_tile "taz_s_typ" "0")
  )

  (defun taz_s_on_typ_change ( / )
    (if (= $value "0") (setq taz_s_tmp_type "100"))
    (if (= $value "1") (setq taz_s_tmp_type "200"))
  )

  ;; ============================================================
  ;; PODPIĘCIE FUNKCJI DO TILE — BEZ STRINGÓW
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

