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
        (add_list "IPE")
        (add_list "IPN")
      )
    )

    (if (= taz_s_cat_val "Ceowniki")
      (progn
        (add_list "UPE")
        (add_list "UPN")
      )
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

    ;; Dwuteowniki - HEA pełna lista
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEA"))
      (progn
        (add_list "100") (add_list "120") (add_list "140") (add_list "160")
        (add_list "180") (add_list "200") (add_list "220") (add_list "240")
        (add_list "260") (add_list "280") (add_list "300") (add_list "320")
        (add_list "340") (add_list "360") (add_list "400") (add_list "450")
        (add_list "500") (add_list "550") (add_list "600") (add_list "650")
        (add_list "700") (add_list "800") (add_list "900") (add_list "1000")
      )
    )

    ;; Dwuteowniki - HEB pełna lista
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "HEB"))
      (progn
        (add_list "100") (add_list "120") (add_list "140") (add_list "160")
        (add_list "180") (add_list "200") (add_list "220") (add_list "240")
        (add_list "260") (add_list "280") (add_list "300") (add_list "320")
        (add_list "340") (add_list "360") (add_list "400") (add_list "450")
        (add_list "500") (add_list "550") (add_list "600") (add_list "650")
        (add_list "700") (add_list "800") (add_list "900") (add_list "1000")
      )
    )

    ;; Dwuteowniki - IPE pełna lista (uzupełniona wg PDF)
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "IPE"))
      (progn
        (add_list "80") (add_list "100") (add_list "120") (add_list "140")
        (add_list "160") (add_list "180") (add_list "200") (add_list "220")
        (add_list "240") (add_list "270") (add_list "300") (add_list "330")
        (add_list "360") (add_list "400") (add_list "450") (add_list "500")
        (add_list "550") (add_list "600")
        (add_list "750x137") (add_list "750x147") (add_list "750x173") (add_list "750x196")
      )
    )

    ;; Dwuteowniki - IPN pełna lista wg EN 10365
    (if (and (= taz_s_cat_val "Dwuteowniki") (= taz_s_fam_val "IPN"))
      (progn
        (add_list "80") (add_list "100") (add_list "120") (add_list "140")
        (add_list "160") (add_list "180") (add_list "200") (add_list "220")
        (add_list "240") (add_list "260") (add_list "280") (add_list "300")
        (add_list "320") (add_list "340") (add_list "360") (add_list "380")
        (add_list "400") (add_list "450") (add_list "500") (add_list "550")
        (add_list "600")
      )
    )

    ;; Ceowniki
    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPE"))
      (progn (add_list "500") (add_list "600"))
    )
    (if (and (= taz_s_cat_val "Ceowniki") (= taz_s_fam_val "UPN"))
      (progn (add_list "700") (add_list "800"))
    )

    ;; Kątowniki
    (if (and (= taz_s_cat_val "Kątowniki") (= taz_s_fam_val "Kątownik równoramienny"))
      (progn (add_list "40x40x4") (add_list "50x50x4"))
    )
    (if (and (= taz_s_cat_val "Kątowniki") (= taz_s_fam_val "Kątownik nierównoramienny"))
      (progn (add_list "60x70x4") (add_list "80x90x4"))
    )

    ;; Rury
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

  ;; Dwuteowniki families mapping
  (if (= taz_s_tmp_category "Dwuteowniki")
    (progn
      (if (= taz_s_tmp_family "HEA") (set_tile "taz_s_fam" "0"))
      (if (= taz_s_tmp_family "HEB") (set_tile "taz_s_fam" "1"))
      (if (= taz_s_tmp_family "IPE") (set_tile "taz_s_fam" "2"))
      (if (= taz_s_tmp_family "IPN") (set_tile "taz_s_fam" "3"))
    )
  )

  ;; Ceowniki mapping
  (if (= taz_s_tmp_category "Ceowniki")
    (progn
      (if (= taz_s_tmp_family "UPE") (set_tile "taz_s_fam" "0"))
      (if (= taz_s_tmp_family "UPN") (set_tile "taz_s_fam" "1"))
    )
  )

  ;; Kątowniki mapping
  (if (= taz_s_tmp_category "Kątowniki")
    (progn
      (if (= taz_s_tmp_family "Kątownik równoramienny") (set_tile "taz_s_fam" "0"))
      (if (= taz_s_tmp_family "Kątownik nierównoramienny") (set_tile "taz_s_fam" "1"))
    )
  )

  ;; Rury mapping
  (if (= taz_s_tmp_category "Rury")
    (progn
      (if (= taz_s_tmp_family "Rura kwadratowa") (set_tile "taz_s_fam" "0"))
      (if (= taz_s_tmp_family "Rura prostokątna") (set_tile "taz_s_fam" "1"))
      (if (= taz_s_tmp_family "Rura okrągła") (set_tile "taz_s_fam" "2"))
    )
  )

  ;; Typy
  (taz_s_fill_type_list taz_s_tmp_category taz_s_tmp_family)

  ;; Ustawienie początkowego indeksu typu w zależności od rodziny
  ;; ZAMIANA zagnieżdżonych IF-ów na osobne, niezależne IF-y (bardziej topornie i czytelnie)
  (cond
    ;; Dwuteowniki HEA - ustawienie indeksu w zależności od taz_s_tmp_type
    ((= taz_s_tmp_family "HEA")
     (if (= taz_s_tmp_type "100") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "120") (set_tile "taz_s_typ" "1"))
     (if (= taz_s_tmp_type "140") (set_tile "taz_s_typ" "2"))
     (if (= taz_s_tmp_type "160") (set_tile "taz_s_typ" "3"))
     (if (= taz_s_tmp_type "180") (set_tile "taz_s_typ" "4"))
     (if (= taz_s_tmp_type "200") (set_tile "taz_s_typ" "5"))
     (if (= taz_s_tmp_type "220") (set_tile "taz_s_typ" "6"))
     (if (= taz_s_tmp_type "240") (set_tile "taz_s_typ" "7"))
     (if (= taz_s_tmp_type "260") (set_tile "taz_s_typ" "8"))
     (if (= taz_s_tmp_type "280") (set_tile "taz_s_typ" "9"))
     (if (= taz_s_tmp_type "300") (set_tile "taz_s_typ" "10"))
     (if (= taz_s_tmp_type "320") (set_tile "taz_s_typ" "11"))
     (if (= taz_s_tmp_type "340") (set_tile "taz_s_typ" "12"))
     (if (= taz_s_tmp_type "360") (set_tile "taz_s_typ" "13"))
     (if (= taz_s_tmp_type "400") (set_tile "taz_s_typ" "14"))
     (if (= taz_s_tmp_type "450") (set_tile "taz_s_typ" "15"))
     (if (= taz_s_tmp_type "500") (set_tile "taz_s_typ" "16"))
     (if (= taz_s_tmp_type "550") (set_tile "taz_s_typ" "17"))
     (if (= taz_s_tmp_type "600") (set_tile "taz_s_typ" "18"))
     (if (= taz_s_tmp_type "650") (set_tile "taz_s_typ" "19"))
     (if (= taz_s_tmp_type "700") (set_tile "taz_s_typ" "20"))
     (if (= taz_s_tmp_type "800") (set_tile "taz_s_typ" "21"))
     (if (= taz_s_tmp_type "900") (set_tile "taz_s_typ" "22"))
     (if (= taz_s_tmp_type "1000") (set_tile "taz_s_typ" "23"))
     (if (and (not (= taz_s_tmp_type "100")) (not (= taz_s_tmp_type "120")) (not (= taz_s_tmp_type "140"))
              (not (= taz_s_tmp_type "160")) (not (= taz_s_tmp_type "180")) (not (= taz_s_tmp_type "200"))
              (not (= taz_s_tmp_type "220")) (not (= taz_s_tmp_type "240")) (not (= taz_s_tmp_type "260"))
              (not (= taz_s_tmp_type "280")) (not (= taz_s_tmp_type "300")) (not (= taz_s_tmp_type "320"))
              (not (= taz_s_tmp_type "340")) (not (= taz_s_tmp_type "360")) (not (= taz_s_tmp_type "400"))
              (not (= taz_s_tmp_type "450")) (not (= taz_s_tmp_type "500")) (not (= taz_s_tmp_type "550"))
              (not (= taz_s_tmp_type "600")) (not (= taz_s_tmp_type "650")) (not (= taz_s_tmp_type "700"))
              (not (= taz_s_tmp_type "800")) (not (= taz_s_tmp_type "900")) (not (= taz_s_tmp_type "1000")))
       (progn (setq taz_s_tmp_type "100") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Dwuteowniki HEB - ustawienie indeksu w zależności od taz_s_tmp_type
    ((= taz_s_tmp_family "HEB")
     (if (= taz_s_tmp_type "100") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "120") (set_tile "taz_s_typ" "1"))
     (if (= taz_s_tmp_type "140") (set_tile "taz_s_typ" "2"))
     (if (= taz_s_tmp_type "160") (set_tile "taz_s_typ" "3"))
     (if (= taz_s_tmp_type "180") (set_tile "taz_s_typ" "4"))
     (if (= taz_s_tmp_type "200") (set_tile "taz_s_typ" "5"))
     (if (= taz_s_tmp_type "220") (set_tile "taz_s_typ" "6"))
     (if (= taz_s_tmp_type "240") (set_tile "taz_s_typ" "7"))
     (if (= taz_s_tmp_type "260") (set_tile "taz_s_typ" "8"))
     (if (= taz_s_tmp_type "280") (set_tile "taz_s_typ" "9"))
     (if (= taz_s_tmp_type "300") (set_tile "taz_s_typ" "10"))
     (if (= taz_s_tmp_type "320") (set_tile "taz_s_typ" "11"))
     (if (= taz_s_tmp_type "340") (set_tile "taz_s_typ" "12"))
     (if (= taz_s_tmp_type "360") (set_tile "taz_s_typ" "13"))
     (if (= taz_s_tmp_type "400") (set_tile "taz_s_typ" "14"))
     (if (= taz_s_tmp_type "450") (set_tile "taz_s_typ" "15"))
     (if (= taz_s_tmp_type "500") (set_tile "taz_s_typ" "16"))
     (if (= taz_s_tmp_type "550") (set_tile "taz_s_typ" "17"))
     (if (= taz_s_tmp_type "600") (set_tile "taz_s_typ" "18"))
     (if (= taz_s_tmp_type "650") (set_tile "taz_s_typ" "19"))
     (if (= taz_s_tmp_type "700") (set_tile "taz_s_typ" "20"))
     (if (= taz_s_tmp_type "800") (set_tile "taz_s_typ" "21"))
     (if (= taz_s_tmp_type "900") (set_tile "taz_s_typ" "22"))
     (if (= taz_s_tmp_type "1000") (set_tile "taz_s_typ" "23"))
     (if (and (not (= taz_s_tmp_type "100")) (not (= taz_s_tmp_type "120")) (not (= taz_s_tmp_type "140"))
              (not (= taz_s_tmp_type "160")) (not (= taz_s_tmp_type "180")) (not (= taz_s_tmp_type "200"))
              (not (= taz_s_tmp_type "220")) (not (= taz_s_tmp_type "240")) (not (= taz_s_tmp_type "260"))
              (not (= taz_s_tmp_type "280")) (not (= taz_s_tmp_type "300")) (not (= taz_s_tmp_type "320"))
              (not (= taz_s_tmp_type "340")) (not (= taz_s_tmp_type "360")) (not (= taz_s_tmp_type "400"))
              (not (= taz_s_tmp_type "450")) (not (= taz_s_tmp_type "500")) (not (= taz_s_tmp_type "550"))
              (not (= taz_s_tmp_type "600")) (not (= taz_s_tmp_type "650")) (not (= taz_s_tmp_type "700"))
              (not (= taz_s_tmp_type "800")) (not (= taz_s_tmp_type "900")) (not (= taz_s_tmp_type "1000")))
       (progn (setq taz_s_tmp_type "100") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Dwuteowniki IPE - pełne mapowanie indeksów (zgodnie z listą powyżej)
    ((= taz_s_tmp_family "IPE")
     (if (= taz_s_tmp_type "80") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "100") (set_tile "taz_s_typ" "1"))
     (if (= taz_s_tmp_type "120") (set_tile "taz_s_typ" "2"))
     (if (= taz_s_tmp_type "140") (set_tile "taz_s_typ" "3"))
     (if (= taz_s_tmp_type "160") (set_tile "taz_s_typ" "4"))
     (if (= taz_s_tmp_type "180") (set_tile "taz_s_typ" "5"))
     (if (= taz_s_tmp_type "200") (set_tile "taz_s_typ" "6"))
     (if (= taz_s_tmp_type "220") (set_tile "taz_s_typ" "7"))
     (if (= taz_s_tmp_type "240") (set_tile "taz_s_typ" "8"))
     (if (= taz_s_tmp_type "270") (set_tile "taz_s_typ" "9"))
     (if (= taz_s_tmp_type "300") (set_tile "taz_s_typ" "10"))
     (if (= taz_s_tmp_type "330") (set_tile "taz_s_typ" "11"))
     (if (= taz_s_tmp_type "360") (set_tile "taz_s_typ" "12"))
     (if (= taz_s_tmp_type "400") (set_tile "taz_s_typ" "13"))
     (if (= taz_s_tmp_type "450") (set_tile "taz_s_typ" "14"))
     (if (= taz_s_tmp_type "500") (set_tile "taz_s_typ" "15"))
     (if (= taz_s_tmp_type "550") (set_tile "taz_s_typ" "16"))
     (if (= taz_s_tmp_type "600") (set_tile "taz_s_typ" "17"))
     (if (= taz_s_tmp_type "750x137") (set_tile "taz_s_typ" "18"))
     (if (= taz_s_tmp_type "750x147") (set_tile "taz_s_typ" "19"))
     (if (= taz_s_tmp_type "750x173") (set_tile "taz_s_typ" "20"))
     (if (= taz_s_tmp_type "750x196") (set_tile "taz_s_typ" "21"))
     (if (and (not (= taz_s_tmp_type "80")) (not (= taz_s_tmp_type "100")) (not (= taz_s_tmp_type "120"))
              (not (= taz_s_tmp_type "140")) (not (= taz_s_tmp_type "160")) (not (= taz_s_tmp_type "180"))
              (not (= taz_s_tmp_type "200")) (not (= taz_s_tmp_type "220")) (not (= taz_s_tmp_type "240"))
              (not (= taz_s_tmp_type "270")) (not (= taz_s_tmp_type "300")) (not (= taz_s_tmp_type "330"))
              (not (= taz_s_tmp_type "360")) (not (= taz_s_tmp_type "400")) (not (= taz_s_tmp_type "450"))
              (not (= taz_s_tmp_type "500")) (not (= taz_s_tmp_type "550")) (not (= taz_s_tmp_type "600"))
              (not (= taz_s_tmp_type "750x137")) (not (= taz_s_tmp_type "750x147")) (not (= taz_s_tmp_type "750x173"))
              (not (= taz_s_tmp_type "750x196")))
       (progn (setq taz_s_tmp_type "80") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Dwuteowniki IPN pełne mapowanie wg EN 10365
    ((= taz_s_tmp_family "IPN")
      (if (= taz_s_tmp_type "80")  (set_tile "taz_s_typ" "0"))
      (if (= taz_s_tmp_type "100") (set_tile "taz_s_typ" "1"))
      (if (= taz_s_tmp_type "120") (set_tile "taz_s_typ" "2"))
      (if (= taz_s_tmp_type "140") (set_tile "taz_s_typ" "3"))
      (if (= taz_s_tmp_type "160") (set_tile "taz_s_typ" "4"))
      (if (= taz_s_tmp_type "180") (set_tile "taz_s_typ" "5"))
      (if (= taz_s_tmp_type "200") (set_tile "taz_s_typ" "6"))
      (if (= taz_s_tmp_type "220") (set_tile "taz_s_typ" "7"))
      (if (= taz_s_tmp_type "240") (set_tile "taz_s_typ" "8"))
      (if (= taz_s_tmp_type "260") (set_tile "taz_s_typ" "9"))
      (if (= taz_s_tmp_type "280") (set_tile "taz_s_typ" "10"))
      (if (= taz_s_tmp_type "300") (set_tile "taz_s_typ" "11"))
      (if (= taz_s_tmp_type "320") (set_tile "taz_s_typ" "12"))
      (if (= taz_s_tmp_type "340") (set_tile "taz_s_typ" "13"))
      (if (= taz_s_tmp_type "360") (set_tile "taz_s_typ" "14"))
      (if (= taz_s_tmp_type "380") (set_tile "taz_s_typ" "15"))
      (if (= taz_s_tmp_type "400") (set_tile "taz_s_typ" "16"))
      (if (= taz_s_tmp_type "450") (set_tile "taz_s_typ" "17"))
      (if (= taz_s_tmp_type "500") (set_tile "taz_s_typ" "18"))
      (if (= taz_s_tmp_type "550") (set_tile "taz_s_typ" "19"))
      (if (= taz_s_tmp_type "600") (set_tile "taz_s_typ" "20"))
      (if (not (member taz_s_tmp_type
            '("80" "100" "120" "140" "160" "180" "200" "220" "240"
              "260" "280" "300" "320" "340" "360" "380" "400"
              "450" "500" "550" "600")))
        (progn (setq taz_s_tmp_type "80") (set_tile "taz_s_typ" "0"))
      )
    )

    ;; Ceowniki UPE
    ((= taz_s_tmp_family "UPE")
     (if (= taz_s_tmp_type "500") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "600") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "500")) (not (= taz_s_tmp_type "600")))
       (progn (setq taz_s_tmp_type "500") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Ceowniki UPN
    ((= taz_s_tmp_family "UPN")
     (if (= taz_s_tmp_type "700") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "800") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "700")) (not (= taz_s_tmp_type "800")))
       (progn (setq taz_s_tmp_type "700") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Kątownik równoramienny
    ((= taz_s_tmp_family "Kątownik równoramienny")
     (if (= taz_s_tmp_type "40x40x4") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "50x50x4") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "40x40x4")) (not (= taz_s_tmp_type "50x50x4")))
       (progn (setq taz_s_tmp_type "40x40x4") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Kątownik nierównoramienny
    ((= taz_s_tmp_family "Kątownik nierównoramienny")
     (if (= taz_s_tmp_type "60x70x4") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "80x90x4") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "60x70x4")) (not (= taz_s_tmp_type "80x90x4")))
       (progn (setq taz_s_tmp_type "60x70x4") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Rura kwadratowa
    ((= taz_s_tmp_family "Rura kwadratowa")
     (if (= taz_s_tmp_type "60x4") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "100x4") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "60x4")) (not (= taz_s_tmp_type "100x4")))
       (progn (setq taz_s_tmp_type "60x4") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Rura prostokątna
    ((= taz_s_tmp_family "Rura prostokątna")
     (if (= taz_s_tmp_type "40x20x4") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "50x40x4") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "40x20x4")) (not (= taz_s_tmp_type "50x40x4")))
       (progn (setq taz_s_tmp_type "40x20x4") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Rura okrągła
    ((= taz_s_tmp_family "Rura okrągła")
     (if (= taz_s_tmp_type "42.4x2.9") (set_tile "taz_s_typ" "0"))
     (if (= taz_s_tmp_type "26.9x2.3") (set_tile "taz_s_typ" "1"))
     (if (and (not (= taz_s_tmp_type "42.4x2.9")) (not (= taz_s_tmp_type "26.9x2.3")))
       (progn (setq taz_s_tmp_type "42.4x2.9") (set_tile "taz_s_typ" "0"))
     )
    )

    ;; Domyślnie pierwszy typ (bez rozpoznania rodziny)
    (T
     (setq taz_s_tmp_type "100")
     (set_tile "taz_s_typ" "0")
    )
  )

  ;; ---------------------------
  ;; Reakcje na zmianę kategorii
  ;; ---------------------------
  (action_tile "taz_s_cat"
    "(progn
       (if (= $value \"0\") (setq taz_s_tmp_category \"Dwuteowniki\"))
       (if (= $value \"1\") (setq taz_s_tmp_category \"Ceowniki\"))
       (if (= $value \"2\") (setq taz_s_tmp_category \"Kątowniki\"))
       (if (= $value \"3\") (setq taz_s_tmp_category \"Rury\"))

       (start_list \"taz_s_fam\")
       (if (= taz_s_tmp_category \"Dwuteowniki\")
         (progn (add_list \"HEA\") (add_list \"HEB\") (add_list \"IPE\") (add_list \"IPN\")))
       (if (= taz_s_tmp_category \"Ceowniki\")
         (progn (add_list \"UPE\") (add_list \"UPN\")))
       (if (= taz_s_tmp_category \"Kątowniki\")
         (progn (add_list \"Kątownik równoramienny\") (add_list \"Kątownik nierównoramienny\")))
       (if (= taz_s_tmp_category \"Rury\")
         (progn (add_list \"Rura kwadratowa\") (add_list \"Rura prostokątna\") (add_list \"Rura okrągła\")))
       (end_list)

       (if (= taz_s_tmp_category \"Dwuteowniki\") (setq taz_s_tmp_family \"HEA\"))
       (if (= taz_s_tmp_category \"Ceowniki\")    (setq taz_s_tmp_family \"UPE\"))
       (if (= taz_s_tmp_category \"Kątowniki\")   (setq taz_s_tmp_family \"Kątownik równoramienny\"))
       (if (= taz_s_tmp_category \"Rury\")        (setq taz_s_tmp_family \"Rura kwadratowa\"))

       (set_tile \"taz_s_fam\" \"0\")

       (start_list \"taz_s_typ\")
       (if (= taz_s_tmp_family \"HEA\") (progn
         (add_list \"100\") (add_list \"120\") (add_list \"140\") (add_list \"160\")
         (add_list \"180\") (add_list \"200\") (add_list \"220\") (add_list \"240\")
         (add_list \"260\") (add_list \"280\") (add_list \"300\") (add_list \"320\")
         (add_list \"340\") (add_list \"360\") (add_list \"400\") (add_list \"450\")
         (add_list \"500\") (add_list \"550\") (add_list \"600\") (add_list \"650\")
         (add_list \"700\") (add_list \"800\") (add_list \"900\") (add_list \"1000\")
       ))
       (if (= taz_s_tmp_family \"HEB\") (progn
         (add_list \"100\") (add_list \"120\") (add_list \"140\") (add_list \"160\")
         (add_list \"180\") (add_list \"200\") (add_list \"220\") (add_list \"240\")
         (add_list \"260\") (add_list \"280\") (add_list \"300\") (add_list \"320\")
         (add_list \"340\") (add_list \"360\") (add_list \"400\") (add_list \"450\")
         (add_list \"500\") (add_list \"550\") (add_list \"600\") (add_list \"650\")
         (add_list \"700\") (add_list \"800\") (add_list \"900\") (add_list \"1000\")
       ))
       (if (= taz_s_tmp_family \"IPE\") (progn
         (add_list \"80\") (add_list \"100\") (add_list \"120\") (add_list \"140\")
         (add_list \"160\") (add_list \"180\") (add_list \"200\") (add_list \"220\")
         (add_list \"240\") (add_list \"270\") (add_list \"300\") (add_list \"330\")
         (add_list \"360\") (add_list \"400\") (add_list \"450\") (add_list \"500\")
         (add_list \"550\") (add_list \"600\") (add_list \"750x137\") (add_list \"750x147\")
         (add_list \"750x173\") (add_list \"750x196\")
       ))
        (if (= taz_s_tmp_family \"IPN\") (progn
         (add_list \"80\") (add_list \"100\") (add_list \"120\") (add_list \"140\")
         (add_list \"160\") (add_list \"180\") (add_list \"200\") (add_list \"220\")
         (add_list \"240\") (add_list \"260\") (add_list \"280\") (add_list \"300\")
         (add_list \"320\") (add_list \"340\") (add_list \"360\") (add_list \"380\")
         (add_list \"400\") (add_list \"450\") (add_list \"500\") (add_list \"550\")
         (add_list \"600\")
       ))
       (if (= taz_s_tmp_family \"UPE\") (progn (add_list \"500\") (add_list \"600\")))
       (if (= taz_s_tmp_family \"UPN\") (progn (add_list \"700\") (add_list \"800\")))
       (if (= taz_s_tmp_family \"Kątownik równoramienny\") (progn (add_list \"40x40x4\") (add_list \"50x50x4\")))
       (if (= taz_s_tmp_family \"Kątownik nierównoramienny\") (progn (add_list \"60x70x4\") (add_list \"80x90x4\")))
       (if (= taz_s_tmp_family \"Rura kwadratowa\") (progn (add_list \"60x4\") (add_list \"100x4\")))
       (if (= taz_s_tmp_family \"Rura prostokątna\") (progn (add_list \"40x20x4\") (add_list \"50x40x4\")))
       (if (= taz_s_tmp_family \"Rura okrągła\") (progn (add_list \"42.4x2.9\") (add_list \"26.9x2.3\")))
       (end_list)

       ;; ustaw pierwszy typ ręcznie w zależności od rodziny (bez funkcji pomocniczej)
       (if (= taz_s_tmp_family \"HEA\") (progn (setq taz_s_tmp_type \"100\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"HEB\") (progn (setq taz_s_tmp_type \"100\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"IPE\") (progn (setq taz_s_tmp_type \"80\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"IPN\") (progn (setq taz_s_tmp_type \"260\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"UPE\") (progn (setq taz_s_tmp_type \"500\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"UPN\") (progn (setq taz_s_tmp_type \"700\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Kątownik równoramienny\") (progn (setq taz_s_tmp_type \"40x40x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Kątownik nierównoramienny\") (progn (setq taz_s_tmp_type \"60x70x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura kwadratowa\") (progn (setq taz_s_tmp_type \"60x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura prostokątna\") (progn (setq taz_s_tmp_type \"40x20x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura okrągła\") (progn (setq taz_s_tmp_type \"42.4x2.9\") (set_tile \"taz_s_typ\" \"0\")))
     )"
  )

  ;; ---------------------------
  ;; Reakcje na zmianę rodziny
  ;; ---------------------------
  (action_tile "taz_s_fam"
    "(progn
       ;; Mapowanie indeksu rodziny w zależności od aktualnej kategorii
       (if (= (get_tile \"taz_s_cat\") \"0\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_family \"HEA\"))
           (if (= $value \"1\") (setq taz_s_tmp_family \"HEB\"))
           (if (= $value \"2\") (setq taz_s_tmp_family \"IPE\"))
           (if (= $value \"3\") (setq taz_s_tmp_family \"IPN\"))
         )
       )
       (if (= (get_tile \"taz_s_cat\") \"1\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_family \"UPE\"))
           (if (= $value \"1\") (setq taz_s_tmp_family \"UPN\"))
         )
       )
       (if (= (get_tile \"taz_s_cat\") \"2\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_family \"Kątownik równoramienny\"))
           (if (= $value \"1\") (setq taz_s_tmp_family \"Kątownik nierównoramienny\"))
         )
       )
       (if (= (get_tile \"taz_s_cat\") \"3\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_family \"Rura kwadratowa\"))
           (if (= $value \"1\") (setq taz_s_tmp_family \"Rura prostokątna\"))
           (if (= $value \"2\") (setq taz_s_tmp_family \"Rura okrągła\"))
         )
       )

       (start_list \"taz_s_typ\")
       (if (= taz_s_tmp_family \"HEA\") (progn
         (add_list \"100\") (add_list \"120\") (add_list \"140\") (add_list \"160\")
         (add_list \"180\") (add_list \"200\") (add_list \"220\") (add_list \"240\")
         (add_list \"260\") (add_list \"280\") (add_list \"300\") (add_list \"320\")
         (add_list \"340\") (add_list \"360\") (add_list \"400\") (add_list \"450\")
         (add_list \"500\") (add_list \"550\") (add_list \"600\") (add_list \"650\")
         (add_list \"700\") (add_list \"800\") (add_list \"900\") (add_list \"1000\")
       ))
       (if (= taz_s_tmp_family \"HEB\") (progn
         (add_list \"100\") (add_list \"120\") (add_list \"140\") (add_list \"160\")
         (add_list \"180\") (add_list \"200\") (add_list \"220\") (add_list \"240\")
         (add_list \"260\") (add_list \"280\") (add_list \"300\") (add_list \"320\")
         (add_list \"340\") (add_list \"360\") (add_list \"400\") (add_list \"450\")
         (add_list \"500\") (add_list \"550\") (add_list \"600\") (add_list \"650\")
         (add_list \"700\") (add_list \"800\") (add_list \"900\") (add_list \"1000\")
       ))
       (if (= taz_s_tmp_family \"IPE\") (progn
         (add_list \"80\") (add_list \"100\") (add_list \"120\") (add_list \"140\")
         (add_list \"160\") (add_list \"180\") (add_list \"200\") (add_list \"220\")
         (add_list \"240\") (add_list \"270\") (add_list \"300\") (add_list \"330\")
         (add_list \"360\") (add_list \"400\") (add_list \"450\") (add_list \"500\")
         (add_list \"550\") (add_list \"600\") (add_list \"750x137\") (add_list \"750x147\")
         (add_list \"750x173\") (add_list \"750x196\")
       ))
       (if (= taz_s_tmp_family \"IPN\") (progn
         (add_list \"80\") (add_list \"100\") (add_list \"120\") (add_list \"140\")
         (add_list \"160\") (add_list \"180\") (add_list \"200\") (add_list \"220\")
         (add_list \"240\") (add_list \"260\") (add_list \"280\") (add_list \"300\")
         (add_list \"320\") (add_list \"340\") (add_list \"360\") (add_list \"380\")
         (add_list \"400\") (add_list \"450\") (add_list \"500\") (add_list \"550\")
         (add_list \"600\")
       ))
       (if (= taz_s_tmp_family \"UPE\") (progn (add_list \"500\") (add_list \"600\")))
       (if (= taz_s_tmp_family \"UPN\") (progn (add_list \"700\") (add_list \"800\")))
       (if (= taz_s_tmp_family \"Kątownik równoramienny\") (progn (add_list \"40x40x4\") (add_list \"50x50x4\")))
       (if (= taz_s_tmp_family \"Kątownik nierównoramienny\") (progn (add_list \"60x70x4\") (add_list \"80x90x4\")))
       (if (= taz_s_tmp_family \"Rura kwadratowa\") (progn (add_list \"60x4\") (add_list \"100x4\")))
       (if (= taz_s_tmp_family \"Rura prostokątna\") (progn (add_list \"40x20x4\") (add_list \"50x40x4\")))
       (if (= taz_s_tmp_family \"Rura okrągła\") (progn (add_list \"42.4x2.9\") (add_list \"26.9x2.3\")))
       (end_list)

       ;; ustaw pierwszy typ ręcznie w zależności od rodziny (bez funkcji pomocniczej)
       (if (= taz_s_tmp_family \"HEA\") (progn (setq taz_s_tmp_type \"100\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"HEB\") (progn (setq taz_s_tmp_type \"100\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"IPE\") (progn (setq taz_s_tmp_type \"80\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"IPN\") (progn (setq taz_s_tmp_type \"260\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"UPE\") (progn (setq taz_s_tmp_type \"500\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"UPN\") (progn (setq taz_s_tmp_type \"700\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Kątownik równoramienny\") (progn (setq taz_s_tmp_type \"40x40x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Kątownik nierównoramienny\") (progn (setq taz_s_tmp_type \"60x70x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura kwadratowa\") (progn (setq taz_s_tmp_type \"60x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura prostokątna\") (progn (setq taz_s_tmp_type \"40x20x4\") (set_tile \"taz_s_typ\" \"0\")))
       (if (= taz_s_tmp_family \"Rura okrągła\") (progn (setq taz_s_tmp_type \"42.4x2.9\") (set_tile \"taz_s_typ\" \"0\")))
     )"
  )

  ;; ---------------------------
  ;; Reakcje na zmianę typu
  ;; ---------------------------
  (action_tile "taz_s_typ"
    "(progn
       ;; Ustawienie taz_s_tmp_type w zależności od aktualnej rodziny i indeksu typu
       (if (= taz_s_tmp_family \"HEA\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_type \"100\"))
           (if (= $value \"1\") (setq taz_s_tmp_type \"120\"))
           (if (= $value \"2\") (setq taz_s_tmp_type \"140\"))
           (if (= $value \"3\") (setq taz_s_tmp_type \"160\"))
           (if (= $value \"4\") (setq taz_s_tmp_type \"180\"))
           (if (= $value \"5\") (setq taz_s_tmp_type \"200\"))
           (if (= $value \"6\") (setq taz_s_tmp_type \"220\"))
           (if (= $value \"7\") (setq taz_s_tmp_type \"240\"))
           (if (= $value \"8\") (setq taz_s_tmp_type \"260\"))
           (if (= $value \"9\") (setq taz_s_tmp_type \"280\"))
           (if (= $value \"10\") (setq taz_s_tmp_type \"300\"))
           (if (= $value \"11\") (setq taz_s_tmp_type \"320\"))
           (if (= $value \"12\") (setq taz_s_tmp_type \"340\"))
           (if (= $value \"13\") (setq taz_s_tmp_type \"360\"))
           (if (= $value \"14\") (setq taz_s_tmp_type \"400\"))
           (if (= $value \"15\") (setq taz_s_tmp_type \"450\"))
           (if (= $value \"16\") (setq taz_s_tmp_type \"500\"))
           (if (= $value \"17\") (setq taz_s_tmp_type \"550\"))
           (if (= $value \"18\") (setq taz_s_tmp_type \"600\"))
           (if (= $value \"19\") (setq taz_s_tmp_type \"650\"))
           (if (= $value \"20\") (setq taz_s_tmp_type \"700\"))
           (if (= $value \"21\") (setq taz_s_tmp_type \"800\"))
           (if (= $value \"22\") (setq taz_s_tmp_type \"900\"))
           (if (= $value \"23\") (setq taz_s_tmp_type \"1000\"))
         )
       )
       (if (= taz_s_tmp_family \"HEB\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_type \"100\"))
           (if (= $value \"1\") (setq taz_s_tmp_type \"120\"))
           (if (= $value \"2\") (setq taz_s_tmp_type \"140\"))
           (if (= $value \"3\") (setq taz_s_tmp_type \"160\"))
           (if (= $value \"4\") (setq taz_s_tmp_type \"180\"))
           (if (= $value \"5\") (setq taz_s_tmp_type \"200\"))
           (if (= $value \"6\") (setq taz_s_tmp_type \"220\"))
           (if (= $value \"7\") (setq taz_s_tmp_type \"240\"))
           (if (= $value \"8\") (setq taz_s_tmp_type \"260\"))
           (if (= $value \"9\") (setq taz_s_tmp_type \"280\"))
           (if (= $value \"10\") (setq taz_s_tmp_type \"300\"))
           (if (= $value \"11\") (setq taz_s_tmp_type \"320\"))
           (if (= $value \"12\") (setq taz_s_tmp_type \"340\"))
           (if (= $value \"13\") (setq taz_s_tmp_type \"360\"))
           (if (= $value \"14\") (setq taz_s_tmp_type \"400\"))
           (if (= $value \"15\") (setq taz_s_tmp_type \"450\"))
           (if (= $value \"16\") (setq taz_s_tmp_type \"500\"))
           (if (= $value \"17\") (setq taz_s_tmp_type \"550\"))
           (if (= $value \"18\") (setq taz_s_tmp_type \"600\"))
           (if (= $value \"19\") (setq taz_s_tmp_type \"650\"))
           (if (= $value \"20\") (setq taz_s_tmp_type \"700\"))
           (if (= $value \"21\") (setq taz_s_tmp_type \"800\"))
           (if (= $value \"22\") (setq taz_s_tmp_type \"900\"))
           (if (= $value \"23\") (setq taz_s_tmp_type \"1000\"))
         )
       )
       (if (= taz_s_tmp_family \"IPE\")
         (progn
           (if (= $value \"0\") (setq taz_s_tmp_type \"80\"))
           (if (= $value \"1\") (setq taz_s_tmp_type \"100\"))
           (if (= $value \"2\") (setq taz_s_tmp_type \"120\"))
           (if (= $value \"3\") (setq taz_s_tmp_type \"140\"))
           (if (= $value \"4\") (setq taz_s_tmp_type \"160\"))
           (if (= $value \"5\") (setq taz_s_tmp_type \"180\"))
           (if (= $value \"6\") (setq taz_s_tmp_type \"200\"))
           (if (= $value \"7\") (setq taz_s_tmp_type \"220\"))
           (if (= $value \"8\") (setq taz_s_tmp_type \"240\"))
           (if (= $value \"9\") (setq taz_s_tmp_type \"270\"))
           (if (= $value \"10\") (setq taz_s_tmp_type \"300\"))
           (if (= $value \"11\") (setq taz_s_tmp_type \"330\"))
           (if (= $value \"12\") (setq taz_s_tmp_type \"360\"))
           (if (= $value \"13\") (setq taz_s_tmp_type \"400\"))
           (if (= $value \"14\") (setq taz_s_tmp_type \"450\"))
           (if (= $value \"15\") (setq taz_s_tmp_type \"500\"))
           (if (= $value \"16\") (setq taz_s_tmp_type \"550\"))
           (if (= $value \"17\") (setq taz_s_tmp_type \"600\"))
           (if (= $value \"18\") (setq taz_s_tmp_type \"750x137\"))
           (if (= $value \"19\") (setq taz_s_tmp_type \"750x147\"))
           (if (= $value \"20\") (setq taz_s_tmp_type \"750x173\"))
           (if (= $value \"21\") (setq taz_s_tmp_type \"750x196\"))
         )
       )
       (if (= taz_s_tmp_family \"IPN\")
         (progn
           (if (= $value \"0\")  (setq taz_s_tmp_type \"80\"))
           (if (= $value \"1\")  (setq taz_s_tmp_type \"100\"))
           (if (= $value \"2\")  (setq taz_s_tmp_type \"120\"))
           (if (= $value \"3\")  (setq taz_s_tmp_type \"140\"))
           (if (= $value \"4\")  (setq taz_s_tmp_type \"160\"))
           (if (= $value \"5\")  (setq taz_s_tmp_type \"180\"))
           (if (= $value \"6\")  (setq taz_s_tmp_type \"200\"))
           (if (= $value \"7\")  (setq taz_s_tmp_type \"220\"))
           (if (= $value \"8\")  (setq taz_s_tmp_type \"240\"))
           (if (= $value \"9\")  (setq taz_s_tmp_type \"260\"))
           (if (= $value \"10\") (setq taz_s_tmp_type \"280\"))
           (if (= $value \"11\") (setq taz_s_tmp_type \"300\"))
           (if (= $value \"12\") (setq taz_s_tmp_type \"320\"))
           (if (= $value \"13\") (setq taz_s_tmp_type \"340\"))
           (if (= $value \"14\") (setq taz_s_tmp_type \"360\"))
           (if (= $value \"15\") (setq taz_s_tmp_type \"380\"))
           (if (= $value \"16\") (setq taz_s_tmp_type \"400\"))
           (if (= $value \"17\") (setq taz_s_tmp_type \"450\"))
           (if (= $value \"18\") (setq taz_s_tmp_type \"500\"))
           (if (= $value \"19\") (setq taz_s_tmp_type \"550\"))
           (if (= $value \"20\") (setq taz_s_tmp_type \"600\"))
         )
       )

       (if (= taz_s_tmp_family \"UPE\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"500\")) (if (= $value \"1\") (setq taz_s_tmp_type \"600\")))
       )
       (if (= taz_s_tmp_family \"UPN\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"700\")) (if (= $value \"1\") (setq taz_s_tmp_type \"800\")))
       )

       (if (= taz_s_tmp_family \"Kątownik równoramienny\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"40x40x4\")) (if (= $value \"1\") (setq taz_s_tmp_type \"50x50x4\")))
       )
       (if (= taz_s_tmp_family \"Kątownik nierównoramienny\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"60x70x4\")) (if (= $value \"1\") (setq taz_s_tmp_type \"80x90x4\")))
       )

       (if (= taz_s_tmp_family \"Rura kwadratowa\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"60x4\")) (if (= $value \"1\") (setq taz_s_tmp_type \"100x4\")))
       )
       (if (= taz_s_tmp_family \"Rura prostokątna\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"40x20x4\")) (if (= $value \"1\") (setq taz_s_tmp_type \"50x40x4\")))
       )
       (if (= taz_s_tmp_family \"Rura okrągła\")
         (progn (if (= $value \"0\") (setq taz_s_tmp_type \"42.4x2.9\")) (if (= $value \"1\") (setq taz_s_tmp_type \"26.9x2.3\")))
       )
     )"
  )

  ;; ---------------------------
  ;; Przycisk OK — zapisujemy zmienne (tylko globalne)
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

;; koniec pliku
