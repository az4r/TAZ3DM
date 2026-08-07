;; =====================================================================================
;; ZESTAWIENIE STALI
;; Tworzy tabele z lista profili WIDOCZNYCH w danym przypadku (X / Y / Z)
;; obok geometrii tego przypadku.
;;
;; Widocznosc elementu ustalana jest tak samo jak przy tworzeniu etykiet
;; w taz_s_intersect_pairs (kopia bryly tnacej + -INTERFERE wzgledem oryginalu).
;; Dlatego ta funkcja MUSI byc wywolana PRZED taz_s_intersect_pairs w danej
;; iteracji petli (bo taz_s_intersect_pairs na koncu kasuje taz_s_cutting_ename).
;;
;; Dane profilu/dlugosci/materialu pobierane sa z globalnych zmiennych
;; wczytanych z taz_s_beam_data.txt (musza byc juz zaladowane - load w skrypcie
;; glownym, tak jak dotychczas).
;;
;; Tabela jest rysowana plasko (w plaszczyznie X-Y przy zoffset), a nastepnie
;; obracana ROTATE3D dokladnie tak samo jak etykiety w taz_s_intersect_pairs
;; (przypadek X: obrot wokol osi X o 90; przypadek Y: obrot wokol osi Y o 90,
;; potem wokol osi X o 90; przypadek Z: bez obrotu). Dzieki temu tabela ladu
;; sie w tej samej plaszczyznie co etykiety w danym przypadku.
;; =====================================================================================

;; ---------------------------------------------------------------------
;; KONFIGURACJA - do latwej zmiany
;; ---------------------------------------------------------------------

;; UWAGA: zakladam ze material jest zapisany pod attr8. Jesli w Twoim
;; pliku txt material jest pod innym numerem atrybutu - zmien ponizej.
(setq taz_s_st_material_attr_no "8")

;; wysokosci tekstu
(setq taz_s_st_h_head 250)
(setq taz_s_st_h_txt  125)

;; szerokosci kolumn
(setq taz_s_st_col_profil   1200.0)
(setq taz_s_st_col_dlugosc   800.0)
(setq taz_s_st_col_material  800.0)
(setq taz_s_st_col_ilosc     500.0)

;; wysokosci wierszy
(setq taz_s_st_row_h  400.0)
(setq taz_s_st_head_h 700.0)

;; warstwa na ktorej rysowana jest tabela (ta sama co etykiety)
(setq taz_s_st_layer "taz_s_labels")

;; tolerancja porownania dlugosci przy laczeniu wierszy (te same jednostki co rysunek)
(setq taz_s_st_len_tol 0.1)


;; ---------------------------------------------------------------------
;; POMOCNICZA: linia (uzywana do siatki tabeli)
;; Kazda utworzona encja jest dopisywana do taz_s_st_created_ss,
;; zeby na koncu mozna bylo obrocic cala tabele jednym ROTATE3D.
;; ---------------------------------------------------------------------

(defun taz_s_st_line (taz_s_st_p1 taz_s_st_p2)
  (entmake
    (list
      (cons 0 "LINE")
      (cons 8 taz_s_st_layer)
      (cons 10 taz_s_st_p1)
      (cons 11 taz_s_st_p2)
    )
  )
  (if taz_s_st_created_ss
    (ssadd (entlast) taz_s_st_created_ss)
  )
)

;; ---------------------------------------------------------------------
;; POMOCNICZA: wpis tekstowy do komorki (wysrodkowany)
;; ---------------------------------------------------------------------

(defun taz_s_st_write_cell (taz_s_st_txt taz_s_st_x taz_s_st_y taz_s_st_z taz_s_st_h)
  (entmake
    (list
      (cons 0 "TEXT")
      (cons 8 taz_s_st_layer)
      (cons 7 "Standard")
      (cons 10 (list taz_s_st_x taz_s_st_y taz_s_st_z))
      (cons 40 taz_s_st_h)
      (cons 1 taz_s_st_txt)
      (cons 72 1)   ;; center
      (cons 73 2)   ;; middle
      (cons 11 (list taz_s_st_x taz_s_st_y taz_s_st_z))
    )
  )
  (if taz_s_st_created_ss
    (ssadd (entlast) taz_s_st_created_ss)
  )
)

;; ---------------------------------------------------------------------
;; POMOCNICZA: sprawdz czy dany oryginalny element jest widoczny
;; w biezacym przypadku (przecina sie z bryla tnaca).
;; Logika identyczna jak w taz_s_intersect_pairs.
;; ---------------------------------------------------------------------

(defun taz_s_st_is_visible (taz_s_st_cut_ename taz_s_st_orig_ent taz_s_st_zoffset)

  (setvar "CLAYER" "taz_s_editing_layer")

  ;; kopiuj bryle tnaca na miejsce oryginalu (bez zoffset)
  (setq taz_s_st_cut_tmp_ss (ssadd))
  (ssadd taz_s_st_cut_ename taz_s_st_cut_tmp_ss)
  (command "COPY" taz_s_st_cut_tmp_ss "" "0,0,0" (list 0 0 (- taz_s_st_zoffset)))
  (setq taz_s_st_cut_tmp_ent (entlast))

  (setq taz_s_st_before_ss (ssget "X" (list (cons 8 "taz_s_editing_layer"))))
  (setq taz_s_st_before_cnt (if taz_s_st_before_ss (sslength taz_s_st_before_ss) 0))

  (setq taz_s_st_if_set1 (ssadd))
  (ssadd taz_s_st_cut_tmp_ent taz_s_st_if_set1)
  (setq taz_s_st_if_set2 (ssadd))
  (ssadd taz_s_st_orig_ent taz_s_st_if_set2)

  (command "-INTERFERE" taz_s_st_if_set1 "" taz_s_st_if_set2 "" "Y")
  (command)
  (command)
  (command)

  (setq taz_s_st_after_ss (ssget "X" (list (cons 8 "taz_s_editing_layer"))))
  (setq taz_s_st_after_cnt (if taz_s_st_after_ss (sslength taz_s_st_after_ss) 0))

  (setq taz_s_st_result nil)
  (if (> taz_s_st_after_cnt taz_s_st_before_cnt)
    (progn
      (setq taz_s_st_result T)
      (if taz_s_st_after_ss
        (command "ERASE" taz_s_st_after_ss "")
      )
    )
  )

  (entdel taz_s_st_cut_tmp_ent)

  taz_s_st_result
)

;; ---------------------------------------------------------------------
;; POMOCNICZE: odczyt danych elementu po handlu (z taz_s_beam_data.txt)
;; ---------------------------------------------------------------------

(defun taz_s_st_get_profile_text (taz_s_st_h)
  (setq taz_s_st_family (eval (read (strcat "taz_s_" taz_s_st_h "_attr6"))))
  (setq taz_s_st_type   (eval (read (strcat "taz_s_" taz_s_st_h "_attr7"))))
  (setq taz_s_st_txt (strcat taz_s_st_family " " taz_s_st_type))
  (if (or (= taz_s_st_family "LR") (= taz_s_st_family "LN"))
    (setq taz_s_st_txt (strcat "L " taz_s_st_type))
  )
  taz_s_st_txt
)

(defun taz_s_st_get_length (taz_s_st_h)
  (setq taz_s_st_p1 (eval (read (strcat "taz_s_" taz_s_st_h "_sweep_p1"))))
  (setq taz_s_st_p2 (eval (read (strcat "taz_s_" taz_s_st_h "_sweep_p2"))))
  (distance taz_s_st_p1 taz_s_st_p2)
)

(defun taz_s_st_get_material (taz_s_st_h)
  (setq taz_s_st_sym
    (read (strcat "taz_s_" taz_s_st_h "_attr" taz_s_st_material_attr_no))
  )
  (if (boundp taz_s_st_sym)
    (eval taz_s_st_sym)
    ""
  )
)

;; ---------------------------------------------------------------------
;; RYSOWANIE SIATKI TABELI
;; ---------------------------------------------------------------------

(defun taz_s_st_draw_grid (taz_s_st_top taz_s_st_w taz_s_st_h
                            taz_s_st_head_h taz_s_st_row_h taz_s_st_nrows
                            taz_s_st_colwidths)

  (setq taz_s_st_x0 (car   taz_s_st_top))
  (setq taz_s_st_y0 (cadr  taz_s_st_top))
  (setq taz_s_st_z0 (caddr taz_s_st_top))

  ;; ramka zewnetrzna
  (taz_s_st_line (list taz_s_st_x0 taz_s_st_y0 taz_s_st_z0)
                  (list (+ taz_s_st_x0 taz_s_st_w) taz_s_st_y0 taz_s_st_z0))
  (taz_s_st_line (list (+ taz_s_st_x0 taz_s_st_w) taz_s_st_y0 taz_s_st_z0)
                  (list (+ taz_s_st_x0 taz_s_st_w) (- taz_s_st_y0 taz_s_st_h) taz_s_st_z0))
  (taz_s_st_line (list (+ taz_s_st_x0 taz_s_st_w) (- taz_s_st_y0 taz_s_st_h) taz_s_st_z0)
                  (list taz_s_st_x0 (- taz_s_st_y0 taz_s_st_h) taz_s_st_z0))
  (taz_s_st_line (list taz_s_st_x0 (- taz_s_st_y0 taz_s_st_h) taz_s_st_z0)
                  (list taz_s_st_x0 taz_s_st_y0 taz_s_st_z0))

  ;; linia pod naglowkiem "ZESTAWIENIE STALI"
  (taz_s_st_line (list taz_s_st_x0 (- taz_s_st_y0 taz_s_st_head_h) taz_s_st_z0)
                  (list (+ taz_s_st_x0 taz_s_st_w) (- taz_s_st_y0 taz_s_st_head_h) taz_s_st_z0))

  ;; linie poziome (naglowki kolumn + kazdy wiersz danych)
  (setq taz_s_st_y (- taz_s_st_y0 taz_s_st_head_h))
  (repeat (1+ taz_s_st_nrows)
    (setq taz_s_st_y (- taz_s_st_y taz_s_st_row_h))
    (taz_s_st_line (list taz_s_st_x0 taz_s_st_y taz_s_st_z0)
                    (list (+ taz_s_st_x0 taz_s_st_w) taz_s_st_y taz_s_st_z0))
  )

  ;; linie pionowe kolumn (od naglowkow kolumn do dolu tabeli)
  (setq taz_s_st_x taz_s_st_x0)
  (foreach taz_s_st_cw taz_s_st_colwidths
    (setq taz_s_st_x (+ taz_s_st_x taz_s_st_cw))
    (taz_s_st_line (list taz_s_st_x (- taz_s_st_y0 taz_s_st_head_h) taz_s_st_z0)
                    (list taz_s_st_x (- taz_s_st_y0 taz_s_st_h) taz_s_st_z0))
  )

  (princ)
)

;; ---------------------------------------------------------------------
;; RYSOWANIE TABELI Z DANYCH (naglowek + naglowki kolumn + wiersze)
;; ---------------------------------------------------------------------

(defun taz_s_st_draw_table (taz_s_st_rows taz_s_st_ins_pt)

  (setq taz_s_st_x0 (car   taz_s_st_ins_pt))
  (setq taz_s_st_y0 (cadr  taz_s_st_ins_pt))
  (setq taz_s_st_z0 (caddr taz_s_st_ins_pt))

  (setq taz_s_st_table_w
    (+ taz_s_st_col_profil taz_s_st_col_dlugosc taz_s_st_col_material taz_s_st_col_ilosc)
  )

  (setq taz_s_st_nrows (length taz_s_st_rows))
  (setq taz_s_st_table_h (+ taz_s_st_head_h taz_s_st_row_h (* taz_s_st_nrows taz_s_st_row_h)))

  ;; ---- naglowek "ZESTAWIENIE STALI" ----
  (taz_s_st_write_cell "ZESTAWIENIE STALI"
    (+ taz_s_st_x0 (/ taz_s_st_table_w 2.0))
    (- taz_s_st_y0 (/ taz_s_st_head_h 2.0))
    taz_s_st_z0
    taz_s_st_h_head)

  ;; ---- naglowki kolumn ----
  (setq taz_s_st_row_y (- taz_s_st_y0 taz_s_st_head_h (/ taz_s_st_row_h 2.0)))
  (setq taz_s_st_col_x taz_s_st_x0)

  (taz_s_st_write_cell "Profil"   (+ taz_s_st_col_x (/ taz_s_st_col_profil 2.0))   taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_profil))
  (taz_s_st_write_cell "Dlugosc"  (+ taz_s_st_col_x (/ taz_s_st_col_dlugosc 2.0))  taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_dlugosc))
  (taz_s_st_write_cell "Material" (+ taz_s_st_col_x (/ taz_s_st_col_material 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_material))
  (taz_s_st_write_cell "Ilosc"    (+ taz_s_st_col_x (/ taz_s_st_col_ilosc 2.0))    taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

  ;; ---- wiersze danych ----
  (setq taz_s_st_row_y (- taz_s_st_y0 taz_s_st_head_h taz_s_st_row_h (/ taz_s_st_row_h 2.0)))

  (foreach taz_s_st_row taz_s_st_rows
    (setq taz_s_st_col_x taz_s_st_x0)

    (taz_s_st_write_cell (nth 0 taz_s_st_row)
      (+ taz_s_st_col_x (/ taz_s_st_col_profil 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_profil))

    (taz_s_st_write_cell (rtos (nth 1 taz_s_st_row) 2 0)
      (+ taz_s_st_col_x (/ taz_s_st_col_dlugosc 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_dlugosc))

    (taz_s_st_write_cell (nth 2 taz_s_st_row)
      (+ taz_s_st_col_x (/ taz_s_st_col_material 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_material))

    (taz_s_st_write_cell (itoa (nth 3 taz_s_st_row))
      (+ taz_s_st_col_x (/ taz_s_st_col_ilosc 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

    (setq taz_s_st_row_y (- taz_s_st_row_y taz_s_st_row_h))
  )

  ;; ---- siatka tabeli ----
  (taz_s_st_draw_grid
    (list taz_s_st_x0 taz_s_st_y0 taz_s_st_z0)
    taz_s_st_table_w
    taz_s_st_table_h
    taz_s_st_head_h
    taz_s_st_row_h
    taz_s_st_nrows
    (list taz_s_st_col_profil taz_s_st_col_dlugosc taz_s_st_col_material taz_s_st_col_ilosc)
  )

  (princ)
)

;; =======================================================================================
;; GLOWNA FUNKCJA: taz_s_create_steel_table
;;
;; Parametry:
;;   taz_s_st_cut_ename  - ename bryly tnacej biezacego przypadku
;;                          (taz_s_cutting_ename z petli glownej, PRZED skasowaniem
;;                          przez taz_s_intersect_pairs!)
;;   taz_s_st_orig_list   - lista wszystkich enames oryginalu (taz_s_orig_enames)
;;   taz_s_st_zoffset     - zoffset biezacego przypadku (taz_s_zoffset)
;;   taz_s_st_ins_pt      - punkt wstawienia (lewy-gorny rog naglowka tabeli),
;;                          np. (list (+ taz_s_xmax 5000) taz_s_y taz_s_zoffset)
;;   taz_s_st_case        - "X" / "Y" / "Z" - decyduje o obrocie tabeli do
;;                          plaszczyzny etykiet danego przypadku (tak jak
;;                          w taz_s_intersect_pairs)
;; =======================================================================================

(defun taz_s_create_steel_table (taz_s_st_cut_ename taz_s_st_orig_list taz_s_st_zoffset taz_s_st_ins_pt taz_s_st_case)

  (setq taz_s_st_rows '())  ;; lista: (profil dlugosc material ilosc)

  (foreach taz_s_st_ent taz_s_st_orig_list
    (if (taz_s_st_is_visible taz_s_st_cut_ename taz_s_st_ent taz_s_st_zoffset)
      (progn
        (setq taz_s_st_h        (cdr (assoc 5 (entget taz_s_st_ent))))
        (setq taz_s_st_profile  (taz_s_st_get_profile_text taz_s_st_h))
        (setq taz_s_st_length   (taz_s_st_get_length taz_s_st_h))
        (setq taz_s_st_material (taz_s_st_get_material taz_s_st_h))

        ;; szukaj czy juz mamy wiersz o tym samym profilu / dlugosci / materiale
        (setq taz_s_st_found nil)
        (setq taz_s_st_newrows '())

        (foreach taz_s_st_row taz_s_st_rows
          (if (and (not taz_s_st_found)
                   (= (nth 0 taz_s_st_row) taz_s_st_profile)
                   (equal (nth 1 taz_s_st_row) taz_s_st_length taz_s_st_len_tol)
                   (= (nth 2 taz_s_st_row) taz_s_st_material)
              )
            (progn
              (setq taz_s_st_row
                (list
                  (nth 0 taz_s_st_row)
                  (nth 1 taz_s_st_row)
                  (nth 2 taz_s_st_row)
                  (1+ (nth 3 taz_s_st_row))
                )
              )
              (setq taz_s_st_found T)
            )
          )
          (setq taz_s_st_newrows (append taz_s_st_newrows (list taz_s_st_row)))
        )
        (setq taz_s_st_rows taz_s_st_newrows)

        (if (not taz_s_st_found)
          (setq taz_s_st_rows
            (append taz_s_st_rows
              (list (list taz_s_st_profile taz_s_st_length taz_s_st_material 1))
            )
          )
        )
      )
    )
  )

  (if taz_s_st_rows
    (progn
      ;; nowy, pusty zbior - do niego trafia kazda encja tabeli (linie + teksty)
      (setq taz_s_st_created_ss (ssadd))

      (taz_s_st_draw_table taz_s_st_rows taz_s_st_ins_pt)

      ;; ---- obrot calej tabeli do plaszczyzny etykiet danego przypadku ----
      ;; identyczna logika jak przy obrocie etykiet w taz_s_intersect_pairs
      (cond
        ((= taz_s_st_case "X")
         (command "_.ROTATE3D" taz_s_st_created_ss "" "X" taz_s_st_ins_pt "90")
        )
        ((= taz_s_st_case "Y")
         (command "_.ROTATE3D" taz_s_st_created_ss "" "Y" taz_s_st_ins_pt "90")
         (command "_.ROTATE3D" taz_s_st_created_ss "" "X" taz_s_st_ins_pt "90")
        )
        ;; przypadek "Z" - bez obrotu, plaszczyzna pozioma juz jest wlasciwa
      )

      (setq taz_s_st_created_ss nil)
    )
  )

  (princ)
)
