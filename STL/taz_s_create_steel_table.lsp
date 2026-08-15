;; =====================================================================================
;; ZESTAWIENIE STALI
;; Tworzy tabele z lista profili WIDOCZNYCH w danym przypadku (X / Y / Z)
;; obok geometrii tego przypadku.
;;
;; WYDAJNOSC: ta wersja NIE robi wlasnego testu -INTERFERE. Widocznosc
;; elementow jest ustalana JEDEN RAZ, w taz_s_intersect_pairs (w skrypcie
;; taz_s_create_drawings_execution_design.lsp), ktora zbiera uchwyty
;; widocznych elementow do globalnej listy taz_s_visible_handles. Tabela
;; dostaje juz gotowa liste - dzieki temu -INTERFERE liczy sie tylko raz
;; na element/przypadek, a nie dwa razy.
;;
;; Dlatego KOLEJNOSC WYWOLANIA w petli glownej musi byc:
;;   1. taz_s_intersect_pairs (zbiera taz_s_visible_handles)
;;   2. taz_s_create_steel_table (korzysta z taz_s_visible_handles)
;;
;; Dane profilu/dlugosci/materialu pobierane sa z globalnych zmiennych
;; wczytanych z taz_s_beam_data.txt (musza byc juz zaladowane - load w skrypcie
;; glownym, tak jak dotychczas).
;;
;; Pole powierzchni przekroju (kolumna "Powierzchnia") pobierane jest przez
;; wywolanie wlasciwej funkcji taz_s_section_..._draw_parametres_..., ktora
;; jako efekt uboczny ustawia globalna zmienna taz_s_section_area. Wywolanie
;; to nadpisuje przy okazji taz_s_h/taz_s_b/taz_s_tw/... - jest to bezpieczne
;; TYLKO dlatego, ze taz_s_create_steel_table wywolywane jest w petli glownej
;; PRZED jakimkolwiek dalszym rysowaniem przekroju w tej samej iteracji.
;; taz_s_family/taz_s_type/taz_s_category sa zapisywane i przywracane po
;; odczycie, dla bezpieczenstwa.
;;
;; Kolumna "Objetosc": dlugosc jest w mm, powierzchnia w cm2. Zeby dostac m3:
;;   dlugosc_m  = dlugosc_mm / 1000
;;   pole_m2    = powierzchnia_cm2 / 10000
;;   objetosc_m3 = dlugosc_m * pole_m2 = dlugosc_mm * powierzchnia_cm2 / 10000000
;;
;; Kolumna "Waga": objetosc_m3 * taz_s_unit_weight_steel (ciezar objetosciowy
;; stali w kg/m3, zmienna juz istniejaca w projekcie) = waga w kg.
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

;; wymiary bazowe tabeli dla skali 1:1
;; rzeczywiste wymiary sa wyliczane w taz_s_create_steel_table
;; przez pomnozenie ponizszych wartosci przez taz_s_annotation_scale

;; wysokosci tekstu 1:1
(setq taz_s_st_base_h_head 5.0)
(setq taz_s_st_base_h_txt  2.5)

;; szerokosci kolumn 1:1
(setq taz_s_st_base_col_profil       26.0)
(setq taz_s_st_base_col_dlugosc      24.0)
(setq taz_s_st_base_col_material     20.0)
(setq taz_s_st_base_col_powierzchnia 32.0)
(setq taz_s_st_base_col_objetosc     26.0)
(setq taz_s_st_base_col_waga         20.0)
(setq taz_s_st_base_col_ilosc        18.0)
(setq taz_s_st_base_col_waga_calkowita 32.0)

;; wysokosci wierszy 1:1
(setq taz_s_st_base_row_h  8.0)
(setq taz_s_st_base_head_h 14.0)

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
;; POMOCNICZA: odczyt pola powierzchni przekroju (taz_s_section_area)
;;
;; Odtwarza taz_s_family / taz_s_type / taz_s_category z atrybutow
;; elementu, wywoluje wlasciwa funkcje taz_s_section_..._draw_parametres_...,
;; ktora ustawia taz_s_section_area (czysta arytmetyka, bez zadnych
;; komend CAD - szybkie), a nastepnie PRZYWRACA poprzednie wartosci
;; taz_s_family/taz_s_type/taz_s_category.
;; ---------------------------------------------------------------------

(defun taz_s_st_get_area (taz_s_st_h)

  (setq taz_s_st_area_family (eval (read (strcat "taz_s_" taz_s_st_h "_attr6"))))
  (setq taz_s_st_area_type   (eval (read (strcat "taz_s_" taz_s_st_h "_attr7"))))

  ;; zapamietaj biezacy stan (jesli w ogole byl ustawiony)
  (setq taz_s_st_saved_family   (if (boundp 'taz_s_family)   taz_s_family   nil))
  (setq taz_s_st_saved_type     (if (boundp 'taz_s_type)     taz_s_type     nil))
  (setq taz_s_st_saved_category (if (boundp 'taz_s_category) taz_s_category nil))

  (setq taz_s_family taz_s_st_area_family)
  (setq taz_s_type   taz_s_st_area_type)

  (cond
    ((or (= taz_s_family "HEA")
         (= taz_s_family "HEB")
         (= taz_s_family "IPE")
         (= taz_s_family "IPN"))
     (setq taz_s_category "Dwuteowniki"))
    ((or (= taz_s_family "UPE")
         (= taz_s_family "UPN"))
     (setq taz_s_category "Ceowniki"))
    ((or (= taz_s_family "LR")
         (= taz_s_family "LN"))
     (setq taz_s_category "Katowniki"))
    ((or (= taz_s_family "SHS")
         (= taz_s_family "RHS")
         (= taz_s_family "CHS"))
     (setq taz_s_category "Rury"))
  )

  (setq taz_s_section_area nil)

  (cond
    ((= taz_s_family "HEA") (taz_s_section_ibeam_draw_parametres_hea))
    ((= taz_s_family "HEB") (taz_s_section_ibeam_draw_parametres_heb))
    ((= taz_s_family "IPE") (taz_s_section_ibeam_draw_parametres_ipe))
    ((= taz_s_family "IPN") (taz_s_section_ibeam_draw_parametres_ipn))
    ((= taz_s_family "UPE") (taz_s_section_cbeam_draw_parametres_upe))
    ((= taz_s_family "UPN") (taz_s_section_cbeam_draw_parametres_upn))
    ((= taz_s_family "LR")  (taz_s_section_lbeam_draw_parametres_katownik_rownoramienny))
    ((= taz_s_family "LN")  (taz_s_section_lbeam_draw_parametres_katownik_nierownoramienny))
    ((= taz_s_family "SHS") (taz_s_section_hsbeam_draw_parametres_rura_kwadratowa))
    ((= taz_s_family "RHS") (taz_s_section_hsbeam_draw_parametres_rura_prostokatna))
    ((= taz_s_family "CHS") (taz_s_section_hsbeam_draw_parametres_rura_okragla))
  )

  (setq taz_s_st_area_result taz_s_section_area)

  ;; przywroc poprzedni stan
  (setq taz_s_family   taz_s_st_saved_family)
  (setq taz_s_type     taz_s_st_saved_type)
  (setq taz_s_category taz_s_st_saved_category)

  (if taz_s_st_area_result
    taz_s_st_area_result
    0.0
  )
)

;; ---------------------------------------------------------------------
;; POMOCNICZA: objetosc w m3
;; taz_s_st_length_mm - dlugosc w mm, taz_s_st_area_cm2 - powierzchnia w cm2
;; ---------------------------------------------------------------------

(defun taz_s_st_get_volume (taz_s_st_length_mm taz_s_st_area_cm2)
  (/ (* taz_s_st_length_mm taz_s_st_area_cm2) 10000000.0)
)

;; ---------------------------------------------------------------------
;; POMOCNICZA: waga w kg
;; taz_s_st_volume_m3 - objetosc w m3, korzysta z taz_s_unit_weight_steel
;; (ciezar objetosciowy stali w kg/m3, zmienna juz istniejaca w projekcie)
;; ---------------------------------------------------------------------

(defun taz_s_st_get_weight (taz_s_st_volume_m3)
  (* taz_s_st_volume_m3 taz_s_unit_weight_steel)
)

;; ---------------------------------------------------------------------
;; RYSOWANIE SIATKI TABELI
;; ---------------------------------------------------------------------

(defun taz_s_st_draw_grid (taz_s_st_top taz_s_st_w taz_s_st_h
                            taz_s_st_head_h taz_s_st_row_h taz_s_st_nrows
                            taz_s_st_colwidths taz_s_st_merge_bottom_rows)

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
  ;; dla IZO w koncowych wierszach komorki od Profil do Waga sa scalone,
  ;; wiec wewnetrzne podzialy tych kolumn koncza sie nad tymi wierszami
  (setq taz_s_st_x taz_s_st_x0)
  (setq taz_s_st_col_index 0)
  (setq taz_s_st_col_count (length taz_s_st_colwidths))
  (foreach taz_s_st_cw taz_s_st_colwidths
    (setq taz_s_st_col_index (1+ taz_s_st_col_index))
    (setq taz_s_st_x (+ taz_s_st_x taz_s_st_cw))
    (taz_s_st_line
      (list taz_s_st_x (- taz_s_st_y0 taz_s_st_head_h) taz_s_st_z0)
      (list taz_s_st_x
        (if (and (> taz_s_st_merge_bottom_rows 0)
                 (< taz_s_st_col_index (- taz_s_st_col_count 1)))
          (+ (- taz_s_st_y0 taz_s_st_h)
             (* taz_s_st_merge_bottom_rows taz_s_st_row_h))
          (- taz_s_st_y0 taz_s_st_h)
        )
        taz_s_st_z0
      )
    )
  )

  (princ)
)

;; ---------------------------------------------------------------------
;; POMOCNICZA: rozpoznanie przypadku IZO
;; ---------------------------------------------------------------------

(defun taz_s_st_is_izo_case (taz_s_st_case / taz_s_st_case_upper)
  (if (= (type taz_s_st_case) 'STR)
    (progn
      (setq taz_s_st_case_upper (strcase taz_s_st_case))
      (= taz_s_st_case_upper "IZO")
    )
    (= taz_s_st_case 'IZO)
  )
)

;; ---------------------------------------------------------------------
;; RYSOWANIE TABELI Z DANYCH (naglowek + naglowki kolumn + wiersze)
;; ---------------------------------------------------------------------

(defun taz_s_st_draw_table (taz_s_st_rows taz_s_st_ins_pt taz_s_st_case)

  (setq taz_s_st_x0 (car   taz_s_st_ins_pt))
  (setq taz_s_st_y0 (cadr  taz_s_st_ins_pt))
  (setq taz_s_st_z0 (caddr taz_s_st_ins_pt))

  (setq taz_s_st_table_w
    (+ taz_s_st_col_profil taz_s_st_col_dlugosc taz_s_st_col_material
       taz_s_st_col_powierzchnia taz_s_st_col_objetosc taz_s_st_col_waga taz_s_st_col_ilosc
       (if (taz_s_st_is_izo_case taz_s_st_case) taz_s_st_col_waga_calkowita 0.0))
  )

  (setq taz_s_st_nrows (length taz_s_st_rows))
  ;; tylko IZO dostaje trzy dodatkowe, koncowe wiersze podsumowania
  (setq taz_s_st_grid_nrows
    (+ taz_s_st_nrows (if (taz_s_st_is_izo_case taz_s_st_case) 3 0))
  )
  (setq taz_s_st_table_h (+ taz_s_st_head_h taz_s_st_row_h (* taz_s_st_grid_nrows taz_s_st_row_h)))
  
  ;; punkt wstawienia = lewy-dolny rog tabeli (odkomentować jeżeli chce my lewy dolny zamiast prawego górnego)
  ;; dalsze rysowanie korzysta z lewego-gornego rogu
  ;;(setq taz_s_st_y0 (+ taz_s_st_y0 taz_s_st_table_h))

  ;; ---- naglowek "ZESTAWIENIE STALI" ----
  (taz_s_st_write_cell "ZESTAWIENIE STALI"
    (+ taz_s_st_x0 (/ taz_s_st_table_w 2.0))
    (- taz_s_st_y0 (/ taz_s_st_head_h 2.0))
    taz_s_st_z0
    taz_s_st_h_head)

  ;; ---- naglowki kolumn ----
  (setq taz_s_st_row_y (- taz_s_st_y0 taz_s_st_head_h (/ taz_s_st_row_h 2.0)))
  (setq taz_s_st_col_x taz_s_st_x0)

  (taz_s_st_write_cell "Profil"       (+ taz_s_st_col_x (/ taz_s_st_col_profil 2.0))       taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_profil))
  (taz_s_st_write_cell "Ilosc [szt.]"        (+ taz_s_st_col_x (/ taz_s_st_col_ilosc 2.0))        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_ilosc))
  (taz_s_st_write_cell "Material"     (+ taz_s_st_col_x (/ taz_s_st_col_material 2.0))     taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_material))
  (taz_s_st_write_cell "Dlugosc [mm]"      (+ taz_s_st_col_x (/ taz_s_st_col_dlugosc 2.0))      taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_dlugosc))
  (taz_s_st_write_cell "Powierzchnia [cm2]" (+ taz_s_st_col_x (/ taz_s_st_col_powierzchnia 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_powierzchnia))
  (taz_s_st_write_cell "Objetosc [m3]"     (+ taz_s_st_col_x (/ taz_s_st_col_objetosc 2.0))     taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
  (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_objetosc))
  (taz_s_st_write_cell "Waga [kg]"         (+ taz_s_st_col_x (/ taz_s_st_col_waga 2.0))         taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

  ;; dodatkowa kolumna tylko dla przypadku IZO
  (if (taz_s_st_is_izo_case taz_s_st_case)
    (progn
      (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_waga))
      (taz_s_st_write_cell "Waga calkowita [kg]"
        (+ taz_s_st_col_x (/ taz_s_st_col_waga_calkowita 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    )
  )

  ;; ---- wiersze danych ----
  ;; taz_s_st_row = (profil dlugosc material powierzchnia objetosc waga ilosc)
  (setq taz_s_st_row_y (- taz_s_st_y0 taz_s_st_head_h taz_s_st_row_h (/ taz_s_st_row_h 2.0)))
  (setq taz_s_st_total_weight 0.0)

  (foreach taz_s_st_row taz_s_st_rows
    (setq taz_s_st_col_x taz_s_st_x0)

    (taz_s_st_write_cell (nth 0 taz_s_st_row)
      (+ taz_s_st_col_x (/ taz_s_st_col_profil 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_profil))

    (taz_s_st_write_cell (itoa (nth 6 taz_s_st_row))
      (+ taz_s_st_col_x (/ taz_s_st_col_ilosc 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_ilosc))

    (taz_s_st_write_cell (nth 2 taz_s_st_row)
      (+ taz_s_st_col_x (/ taz_s_st_col_material 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_material))

    (taz_s_st_write_cell (rtos (nth 1 taz_s_st_row) 2 0)
      (+ taz_s_st_col_x (/ taz_s_st_col_dlugosc 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_dlugosc))

    (taz_s_st_write_cell (rtos (nth 3 taz_s_st_row) 2 2)
      (+ taz_s_st_col_x (/ taz_s_st_col_powierzchnia 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_powierzchnia))

    (taz_s_st_write_cell (rtos (nth 4 taz_s_st_row) 2 6)
      (+ taz_s_st_col_x (/ taz_s_st_col_objetosc 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_objetosc))

    (taz_s_st_write_cell (rtos (nth 5 taz_s_st_row) 2 2)
      (+ taz_s_st_col_x (/ taz_s_st_col_waga 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

    ;; Waga calkowita = Ilosc * Waga, tylko dla IZO
    (if (taz_s_st_is_izo_case taz_s_st_case)
      (progn
        (setq taz_s_st_row_total_weight (* (nth 6 taz_s_st_row) (nth 5 taz_s_st_row)))
        (setq taz_s_st_total_weight (+ taz_s_st_total_weight taz_s_st_row_total_weight))
        (setq taz_s_st_col_x (+ taz_s_st_col_x taz_s_st_col_waga))
        (taz_s_st_write_cell (rtos taz_s_st_row_total_weight 2 2)
          (+ taz_s_st_col_x (/ taz_s_st_col_waga_calkowita 2.0)) taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
      )
    )

    (setq taz_s_st_row_y (- taz_s_st_row_y taz_s_st_row_h))
  )

  ;; ---- ostatni wiersz podsumowania, tylko dla IZO ----
  (if (taz_s_st_is_izo_case taz_s_st_case)
    (progn
      (setq taz_s_st_summary_left_w (- taz_s_st_table_w taz_s_st_col_waga_calkowita))

      ;; scalona komorka od Profil do Waga
      (taz_s_st_write_cell "Waga konstrukcji [kg]"
        (+ taz_s_st_x0 (/ taz_s_st_summary_left_w 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

      ;; suma kolumny Waga calkowita
      (taz_s_st_write_cell (rtos taz_s_st_total_weight 2 2)
        (+ taz_s_st_x0 taz_s_st_summary_left_w (/ taz_s_st_col_waga_calkowita 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

      ;; przejscie do kolejnego wiersza podsumowania
      (setq taz_s_st_row_y (- taz_s_st_row_y taz_s_st_row_h))

      ;; scalona komorka od Profil do Waga
      (taz_s_st_write_cell "Naddatek na polaczenia [%]"
        (+ taz_s_st_x0 (/ taz_s_st_summary_left_w 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

      ;; wartosc parametru taz_s_additional_mass
      (taz_s_st_write_cell (rtos taz_s_additional_mass 2 2)
        (+ taz_s_st_x0 taz_s_st_summary_left_w (/ taz_s_st_col_waga_calkowita 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

      ;; przejscie do kolejnego wiersza podsumowania
      (setq taz_s_st_row_y (- taz_s_st_row_y taz_s_st_row_h))

      ;; waga naddatku = waga konstrukcji * naddatek [%] / 100
      (setq taz_s_st_additional_weight
        (* taz_s_st_total_weight (/ taz_s_additional_mass 100.0))
      )

      ;; waga calkowita konstrukcji = waga konstrukcji + waga naddatku
      (setq taz_s_st_total_structure_weight
        (+ taz_s_st_total_weight taz_s_st_additional_weight)
      )

      ;; scalona komorka od Profil do Waga
      (taz_s_st_write_cell "Waga calkowita konstrukcji [kg]"
        (+ taz_s_st_x0 (/ taz_s_st_summary_left_w 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)

      ;; obliczona waga calkowita konstrukcji
      (taz_s_st_write_cell (rtos taz_s_st_total_structure_weight 2 2)
        (+ taz_s_st_x0 taz_s_st_summary_left_w (/ taz_s_st_col_waga_calkowita 2.0))
        taz_s_st_row_y taz_s_st_z0 taz_s_st_h_txt)
    )
  )

  ;; ---- siatka tabeli ----
  (taz_s_st_draw_grid
    (list taz_s_st_x0 taz_s_st_y0 taz_s_st_z0)
    taz_s_st_table_w
    taz_s_st_table_h
    taz_s_st_head_h
    taz_s_st_row_h
    taz_s_st_grid_nrows
    (if (taz_s_st_is_izo_case taz_s_st_case)
      (list taz_s_st_col_profil taz_s_st_col_ilosc taz_s_st_col_material taz_s_st_col_dlugosc
            taz_s_st_col_powierzchnia taz_s_st_col_objetosc taz_s_st_col_waga taz_s_st_col_waga_calkowita)
      (list taz_s_st_col_profil taz_s_st_col_ilosc taz_s_st_col_material taz_s_st_col_dlugosc
            taz_s_st_col_powierzchnia taz_s_st_col_objetosc taz_s_st_col_waga)
    )
    (if (taz_s_st_is_izo_case taz_s_st_case) 3 0)
  )

  (princ)
)

;; =======================================================================================
;; GLOWNA FUNKCJA: taz_s_create_steel_table
;;
;; Parametry:
;;   taz_s_st_visible_handles - lista uchwytow (string) elementow widocznych
;;                          w tym przypadku - pochodzi z taz_s_visible_handles,
;;                          ustawionej przez taz_s_intersect_pairs. WYMAGANE
;;                          zeby taz_s_intersect_pairs bylo wywolane wczesniej
;;                          w tej samej iteracji petli.
;;   taz_s_st_ins_pt      - punkt wstawienia (lewy-gorny rog naglowka tabeli),
;;                          np. (list (+ taz_s_xmax 5000) taz_s_y taz_s_zoffset)
;;   taz_s_st_case        - "X" / "Y" / "Z" / "IZO" - decyduje o obrocie tabeli do
;;                          plaszczyzny etykiet danego przypadku (tak jak
;;                          w taz_s_intersect_pairs; "IZO" zachowuje geometrie jak "Z"
;;                          i dodaje kolumne "Waga calkowita [kg]"
;; =======================================================================================

(defun taz_s_create_steel_table (taz_s_st_visible_handles taz_s_st_ins_pt taz_s_st_case)

  ;; skalowanie tabeli zgodnie ze skala wybrana w taz_s_annotation_scale
  ;; (wartosci bazowe powyzej odpowiadaja skali 1:1)
  (if (boundp 'taz_s_annotation_scale)
    (setq taz_s_st_scale taz_s_annotation_scale)
    (setq taz_s_st_scale 1.0)
  )

  (setq taz_s_st_h_head          (* taz_s_st_base_h_head          taz_s_st_scale))
  (setq taz_s_st_h_txt           (* taz_s_st_base_h_txt           taz_s_st_scale))
  (setq taz_s_st_col_profil      (* taz_s_st_base_col_profil      taz_s_st_scale))
  (setq taz_s_st_col_dlugosc     (* taz_s_st_base_col_dlugosc     taz_s_st_scale))
  (setq taz_s_st_col_material    (* taz_s_st_base_col_material    taz_s_st_scale))
  (setq taz_s_st_col_powierzchnia (* taz_s_st_base_col_powierzchnia taz_s_st_scale))
  (setq taz_s_st_col_objetosc    (* taz_s_st_base_col_objetosc    taz_s_st_scale))
  (setq taz_s_st_col_waga        (* taz_s_st_base_col_waga        taz_s_st_scale))
  (setq taz_s_st_col_ilosc       (* taz_s_st_base_col_ilosc       taz_s_st_scale))
  (setq taz_s_st_col_waga_calkowita (* taz_s_st_base_col_waga_calkowita taz_s_st_scale))
  (setq taz_s_st_row_h           (* taz_s_st_base_row_h           taz_s_st_scale))
  (setq taz_s_st_head_h          (* taz_s_st_base_head_h          taz_s_st_scale))

  (setq taz_s_st_rows '())  ;; lista: (profil dlugosc material powierzchnia objetosc waga ilosc)

  (foreach taz_s_st_h taz_s_st_visible_handles
    (setq taz_s_st_profile  (taz_s_st_get_profile_text taz_s_st_h))
    (setq taz_s_st_length   (taz_s_st_get_length taz_s_st_h))
    (setq taz_s_st_material (taz_s_st_get_material taz_s_st_h))
    (setq taz_s_st_area     (taz_s_st_get_area taz_s_st_h))
    (setq taz_s_st_volume   (taz_s_st_get_volume taz_s_st_length taz_s_st_area))
    (setq taz_s_st_weight   (taz_s_st_get_weight taz_s_st_volume))

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
              (nth 3 taz_s_st_row)
              (nth 4 taz_s_st_row)
              (nth 5 taz_s_st_row)
              (1+ (nth 6 taz_s_st_row))
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
          (list (list taz_s_st_profile taz_s_st_length taz_s_st_material taz_s_st_area taz_s_st_volume taz_s_st_weight 1))
        )
      )
    )
  )

  (if taz_s_st_rows
    (progn
      ;; nowy, pusty zbior - do niego trafia kazda encja tabeli (linie + teksty)
      (setq taz_s_st_created_ss (ssadd))

      (taz_s_st_draw_table taz_s_st_rows taz_s_st_ins_pt taz_s_st_case)

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
