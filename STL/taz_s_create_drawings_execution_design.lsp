(defun c:taz_s_create_drawings_execution_design ()
  
  (taz_s_current_settings_save)
  (taz_s_unlock_all_layers)
  
  ;; ---------------------------------
  ;; WIDOK TYMCZASOWY - ZAPIS / NADPISANIE
  ;; ---------------------------------
  (command "-VIEW" "_S" "taz_s_temp_view")

  ;; ---------------------------------------------------------
  ;; UCS TYMCZASOWY - ZAPIS / NADPISANIE
  ;; ---------------------------------------------------------

  (setq taz_s_ucs_exist (tblsearch "UCS" "taz_s_ucs_temp"))

  (if taz_s_ucs_exist
    (progn
      (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp2")
      (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp2")
      (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp2")
    )
    (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
  )

  (command "_.UCS" "_W")
    
  ;; ---------------------------------------------------------
  ;; ZOOM
  ;; ---------------------------------------------------------
  
  (command "_LINE" '(-50 -50 0) '(50 50 0) "")
  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" (entlast) "")
  (entdel (entlast))
  (command "_ZOOM" "_SCALE" "1000X")
  (command "REGEN")
  
  ;; ---------------------------------
  ;; OFFSET START
  ;; ---------------------------------

  (setq taz_s_layout_start 100000.0)

  ;; ---------------------------------
  ;; OFFSET KOLEJNYCH RZUTNI
  ;; ---------------------------------

  (setq taz_s_layout_step 10000.0)

  ;; ---------------------------------
  ;; AKTUALNA POZYCJA RZUTNI
  ;; ---------------------------------

  (setq taz_s_layout_x taz_s_layout_start)

  ;; ---------------------------------
  ;; WCZYTANIE DANYCH
  ;; ---------------------------------

  (setq taz_s_x_data taz_s_axis_data_x)
  (setq taz_s_y_data taz_s_axis_data_y)
  (setq taz_s_z_data taz_s_axis_data_z)

  ;; ---------------------------------
  ;; PARAMETRY OZNACZEŃ OSI
  ;; ---------------------------------

  (setq taz_s_axis_overhang 1500.0)  ;; wystanie linii osi poniżej Zmin / poza krawędź
  (setq taz_s_axis_circle_r  250.0)  ;; promień kółka oznaczenia
  (setq taz_s_axis_text_h    175.0)  ;; wysokość tekstu w kółku

  ;; ---------------------------------
  ;; FUNKCJE POMOCNICZE
  ;; ---------------------------------

  (defun taz_s_get_dist ()
    (setq taz_s_i 1)
    (setq taz_s_len (strlen taz_s_row))
    (while (and (<= taz_s_i taz_s_len)
                (/= (substr taz_s_row taz_s_i 1) "]"))
      (setq taz_s_i (+ taz_s_i 1))
    )
    (setq taz_s_i (+ taz_s_i 3))
    (setq taz_s_val (atof (substr taz_s_row taz_s_i)))
  )

  (defun taz_s_get_name ()
    (setq taz_s_i 2)
    (setq taz_s_res "")
    (while (/= (substr taz_s_row taz_s_i 1) "]")
      (setq taz_s_res (strcat taz_s_res (substr taz_s_row taz_s_i 1)))
      (setq taz_s_i (+ taz_s_i 1))
    )
  )

  (defun taz_s_min ()
    (setq taz_s_m (car taz_s_list))
    (setq taz_s_list (cdr taz_s_list))
    (while taz_s_list
      (if (< (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list)))
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  (defun taz_s_max ()
    (setq taz_s_m (car taz_s_list))
    (setq taz_s_list (cdr taz_s_list))
    (while taz_s_list
      (if (> (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list)))
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  (defun taz_s_center_point (taz_s_p1 taz_s_p3)
    (list
      (/ (+ (car taz_s_p1) (car taz_s_p3)) 2.0)
      (/ (+ (cadr taz_s_p1) (cadr taz_s_p3)) 2.0)
      (/ (+ (caddr taz_s_p1) (caddr taz_s_p3)) 2.0)
    )
  )

  ;; ---------------------------------
  ;; FUNKCJA RYSOWANIA OZNACZENIA OSI
  ;; Dla przekrojów X i Y (pionowych).
  ;;
  ;; Parametry:
  ;;   taz_s_da_ax      - pozycja X osi
  ;;   taz_s_da_ay      - pozycja Y osi
  ;;   taz_s_da_z_top   - górny koniec linii osi (Zmax)
  ;;   taz_s_da_z_bot   - dolny koniec linii osi (Zmin - overhang)
  ;;   taz_s_da_name    - nazwa osi
  ;;   taz_s_da_rot     - "X" lub "Y": określa pre-obrót kółka/tekstu
  ;;                      odwrotny do późniejszego ROTATE3D rzutni
  ;;
  ;; Zwraca ss wszystkich nowych encji.
  ;; ---------------------------------

  (defun taz_s_draw_axis (taz_s_da_ax taz_s_da_ay taz_s_da_z_top taz_s_da_z_bot
                          taz_s_da_name taz_s_da_rot
                          / taz_s_da_e_before taz_s_da_e_mid taz_s_da_ax_ss
                            taz_s_da_e_cur taz_s_da_cpt taz_s_da_circ_ss)

    (setq taz_s_da_e_before (entlast))
    (setq taz_s_da_cpt (list taz_s_da_ax taz_s_da_ay taz_s_da_z_bot))

    ;; linia osi: pionowo wzdłuż Z w WCS
    (command "_LINE"
      taz_s_da_cpt
      (list taz_s_da_ax taz_s_da_ay taz_s_da_z_top)
      "")

    ;; znacznik po linii, przed kółkiem i tekstem
    (setq taz_s_da_e_mid (entlast))

    ;; kółko i tekst w WCS przy końcu dolnym linii
    (command "_CIRCLE" taz_s_da_cpt taz_s_axis_circle_r)
    (command "_TEXT" "_J" "MC"
      taz_s_da_cpt taz_s_axis_text_h 0 taz_s_da_name)

    ;; zbierz tylko kółko i tekst do osobnego ss
    (setq taz_s_da_circ_ss (ssadd))
    (setq taz_s_da_e_cur (entnext taz_s_da_e_mid))
    (while taz_s_da_e_cur
      (ssadd taz_s_da_e_cur taz_s_da_circ_ss)
      (setq taz_s_da_e_cur (entnext taz_s_da_e_cur))
    )

    ;; lokalny pre-obrót kółka i tekstu wokół końca linii —
    ;; odwrotny do późniejszego ROTATE3D rzutni
    (cond
      ((= taz_s_da_rot "X")
        (if (> (sslength taz_s_da_circ_ss) 0)
          (command "ROTATE3D" taz_s_da_circ_ss "" "_X" taz_s_da_cpt "-90")
        )
      )
      ((= taz_s_da_rot "Y")
        (if (> (sslength taz_s_da_circ_ss) 0)
          (command "ROTATE3D" taz_s_da_circ_ss "" "_Y" taz_s_da_cpt "90")
        )
      )
    )

    ;; zbierz wszystkie nowe encje (linia + kółko + tekst)
    (setq taz_s_da_ax_ss (ssadd))
    (if taz_s_da_e_before
      (setq taz_s_da_e_cur (entnext taz_s_da_e_before))
      (setq taz_s_da_e_cur (entnext))
    )
    (while taz_s_da_e_cur
      (ssadd taz_s_da_e_cur taz_s_da_ax_ss)
      (setq taz_s_da_e_cur (entnext taz_s_da_e_cur))
    )
    taz_s_da_ax_ss
  )

  ;; ---------------------------------
  ;; FUNKCJA RYSOWANIA OZNACZENIA OSI DLA PRZEKROJÓW Z (poziomych)
  ;;
  ;; Parametry:
  ;;   taz_s_daz_ax   - pozycja X punktu startowego (na krawędzi prostokąta)
  ;;   taz_s_daz_ay   - pozycja Y punktu startowego (na krawędzi prostokąta)
  ;;   taz_s_daz_z    - poziom Z przekroju
  ;;   taz_s_daz_dir  - kierunek wystania linii: "X-" lub "Y-"
  ;;                    "X-" → linia wystawia w kierunku -X (krawędź xmin, dla osi z x_data)
  ;;                    "Y-" → linia wystawia w kierunku -Y (krawędź ymin, dla osi z y_data)
  ;;   taz_s_daz_name - nazwa osi
  ;;
  ;; Linia leży w płaszczyźnie XY (Z=const), kółko i tekst też — brak ROTATE.
  ;; Zwraca ss wszystkich nowych encji.
  ;; ---------------------------------

  (defun taz_s_draw_axis_z (taz_s_daz_ax taz_s_daz_ay taz_s_daz_z
                             taz_s_daz_dir taz_s_daz_name
                             / taz_s_daz_e_before taz_s_daz_e_cur
                               taz_s_daz_ax_ss taz_s_daz_pt_start
                               taz_s_daz_pt_end)

    (setq taz_s_daz_e_before (entlast))
    (setq taz_s_daz_pt_start (list taz_s_daz_ax taz_s_daz_ay taz_s_daz_z))

    ;; punkt końcowy linii — w kierunku -X lub -Y o długość overhang
    (cond
      ((= taz_s_daz_dir "X-")
        (setq taz_s_daz_pt_end
          (list (- taz_s_daz_ax taz_s_axis_overhang) taz_s_daz_ay taz_s_daz_z))
      )
      ((= taz_s_daz_dir "Y-")
        (setq taz_s_daz_pt_end
          (list taz_s_daz_ax (- taz_s_daz_ay taz_s_axis_overhang) taz_s_daz_z))
      )
    )

    ;; linia pozioma w płaszczyźnie XY
    (command "_LINE" taz_s_daz_pt_start taz_s_daz_pt_end "")

    ;; kółko i tekst na końcu linii (w tej samej płaszczyźnie XY)
    (command "_CIRCLE" taz_s_daz_pt_end taz_s_axis_circle_r)
    (command "_TEXT" "_J" "MC"
      taz_s_daz_pt_end taz_s_axis_text_h 0 taz_s_daz_name)

    ;; zbierz wszystkie nowe encje
    (setq taz_s_daz_ax_ss (ssadd))
    (if taz_s_daz_e_before
      (setq taz_s_daz_e_cur (entnext taz_s_daz_e_before))
      (setq taz_s_daz_e_cur (entnext))
    )
    (while taz_s_daz_e_cur
      (ssadd taz_s_daz_e_cur taz_s_daz_ax_ss)
      (setq taz_s_daz_e_cur (entnext taz_s_daz_e_cur))
    )
    taz_s_daz_ax_ss
  )

  ;; ---------------------------------
  ;; X VALUES
  ;; ---------------------------------

  (setq taz_s_xvals '())
  (setq taz_s_tmp taz_s_x_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_xvals (append taz_s_xvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; Y VALUES
  ;; ---------------------------------

  (setq taz_s_yvals '())
  (setq taz_s_tmp taz_s_y_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_yvals (append taz_s_yvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; Z VALUES
  ;; ---------------------------------

  (setq taz_s_zvals '())
  (setq taz_s_tmp taz_s_z_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_zvals (append taz_s_zvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; MIN / MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals) (taz_s_min) (setq taz_s_xmin taz_s_m)
  (setq taz_s_list taz_s_yvals) (taz_s_max) (setq taz_s_xmax taz_s_m)

  (setq taz_s_list taz_s_xvals) (taz_s_min) (setq taz_s_ymin taz_s_m)
  (setq taz_s_list taz_s_xvals) (taz_s_max) (setq taz_s_ymax taz_s_m)

  (setq taz_s_list taz_s_zvals) (taz_s_min) (setq taz_s_zmin taz_s_m)
  (setq taz_s_list taz_s_zvals) (taz_s_max) (setq taz_s_zmax taz_s_m)

  ;; ---------------------------------
  ;; WARSTWY
  ;; ---------------------------------

  (if (not (tblsearch "LAYER" "taz_s_execution_design"))
    (command "_LAYER" "_M" "taz_s_execution_design" "_C" "30" "" "")
  )
  (if (not (tblsearch "LAYER" "taz_s_sections"))
    (command "_LAYER" "_M" "taz_s_sections" "_C" "1" "" "")
  )
  (if (not (tblsearch "LAYER" "taz_s_sections_temp"))
    (command "_LAYER" "_M" "taz_s_sections_temp" "_C" "3" "" "")
  )

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTW
  ;; ---------------------------------

  (foreach taz_s_lay '("taz_s_execution_design" "taz_s_sections" "taz_s_sections_temp")
    (setq taz_s_ss (ssget "X" (list (cons 8 taz_s_lay))))
    (if taz_s_ss (command "ERASE" taz_s_ss ""))
  )

  ;; ---------------------------------
  ;; OBIEKTY MODELU
  ;; ---------------------------------

  (setq taz_s_model_ss (ssget "X"))

  ;; =========================================================
  ;; X  (przekroje prostopadłe do osi X — płaszczyzna Y=const)
  ;; =========================================================

  (setq taz_s_tmp taz_s_x_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (taz_s_get_name)
    (setq taz_s_name taz_s_res)
    (setq taz_s_y taz_s_val)

    (setq taz_s_p1 (list taz_s_xmin taz_s_y taz_s_zmin))
    (setq taz_s_p2 (list taz_s_xmax taz_s_y taz_s_zmin))
    (setq taz_s_p3 (list taz_s_xmax taz_s_y taz_s_zmax))
    (setq taz_s_p4 (list taz_s_xmin taz_s_y taz_s_zmax))
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; OZNACZENIA OSI — przekrój X → rot "X"
    (setvar "CLAYER" "taz_s_sections")
    (setq taz_s_xtmp taz_s_y_data)
    (setq taz_s_axis_ss_list (ssadd))
    (while taz_s_xtmp
      (setq taz_s_row (car taz_s_xtmp))
      (taz_s_get_dist)
      (taz_s_get_name)
      (setq taz_s_ax_name taz_s_res)
      (setq taz_s_ax_x taz_s_val)
      (setq taz_s_one_axis_ss
        (taz_s_draw_axis
          taz_s_ax_x taz_s_y
          taz_s_zmax (- taz_s_zmin taz_s_axis_overhang)
          taz_s_ax_name "X"
        )
      )
      (setq taz_s_k 0)
      (while (< taz_s_k (sslength taz_s_one_axis_ss))
        (ssadd (ssname taz_s_one_axis_ss taz_s_k) taz_s_axis_ss_list)
        (setq taz_s_k (+ taz_s_k 1))
      )
      (setq taz_s_xtmp (cdr taz_s_xtmp))
    )

    (if taz_s_rect_ss
      (command "ROTATE3D" taz_s_rect_ss "" "_X" taz_s_center "90")
    )
    (if taz_s_section_ss
      (command "ROTATE3D" taz_s_section_ss "" "_X" taz_s_center "90")
    )
    (if (> (sslength taz_s_axis_ss_list) 0)
      (command "ROTATE3D" taz_s_axis_ss_list "" "_X" taz_s_center "90")
    )

    (setq taz_s_title_pt
      (list (car taz_s_center) (+ (cadr taz_s_center) 10000.0) (caddr taz_s_center))
    )
    (setvar "CLAYER" "taz_s_execution_design")
    (command "TEXT" "_J" "MC" taz_s_title_pt 700.0 0 (strcat "SECTION " taz_s_name))

    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if (> (sslength taz_s_axis_ss_list) 0)
      (command "MOVE" taz_s_axis_ss_list "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (command "MOVE" (entlast) "" taz_s_center (list taz_s_layout_x 0 0))

    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    (setq taz_s_layout_x (+ taz_s_layout_x taz_s_layout_step))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

;; =========================================================
  ;; Y  (przekroje prostopadłe do osi Y — płaszczyzna X=const)
  ;; =========================================================

  (setq taz_s_tmp taz_s_y_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (taz_s_get_name)
    (setq taz_s_name taz_s_res)
    (setq taz_s_x taz_s_val)

    (setq taz_s_p1 (list taz_s_x taz_s_ymin taz_s_zmin))
    (setq taz_s_p2 (list taz_s_x taz_s_ymax taz_s_zmin))
    (setq taz_s_p3 (list taz_s_x taz_s_ymax taz_s_zmax))
    (setq taz_s_p4 (list taz_s_x taz_s_ymin taz_s_zmax))
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; OZNACZENIA OSI — przekrój Y → rot "Y"
    (setvar "CLAYER" "taz_s_sections")
    (setq taz_s_xtmp taz_s_x_data)
    (setq taz_s_axis_ss_list (ssadd))
    (while taz_s_xtmp
      (setq taz_s_row (car taz_s_xtmp))
      (taz_s_get_dist)
      (taz_s_get_name)
      (setq taz_s_ax_name taz_s_res)
      (setq taz_s_ax_y taz_s_val)
      (setq taz_s_one_axis_ss
        (taz_s_draw_axis
          taz_s_x taz_s_ax_y
          taz_s_zmax (- taz_s_zmin taz_s_axis_overhang)
          taz_s_ax_name "Y"
        )
      )
      (setq taz_s_k 0)
      (while (< taz_s_k (sslength taz_s_one_axis_ss))
        (ssadd (ssname taz_s_one_axis_ss taz_s_k) taz_s_axis_ss_list)
        (setq taz_s_k (+ taz_s_k 1))
      )
      (setq taz_s_xtmp (cdr taz_s_xtmp))
    )

    (if taz_s_rect_ss
      (command "ROTATE3D" taz_s_rect_ss "" "_Y" taz_s_center "-90")
    )
    (if taz_s_section_ss
      (command "ROTATE3D" taz_s_section_ss "" "_Y" taz_s_center "-90")
    )
    (if (> (sslength taz_s_axis_ss_list) 0)
      (command "ROTATE3D" taz_s_axis_ss_list "" "_Y" taz_s_center "-90")
    )

    (setq taz_s_title_pt
      (list (car taz_s_center) (+ (cadr taz_s_center) 10000.0) (caddr taz_s_center))
    )
    (setvar "CLAYER" "taz_s_execution_design")
    (command "TEXT" "_J" "MC" taz_s_title_pt 700.0 0 (strcat "SECTION " taz_s_name))

    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if (> (sslength taz_s_axis_ss_list) 0)
      (command "MOVE" taz_s_axis_ss_list "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (command "MOVE" (entlast) "" taz_s_center (list taz_s_layout_x 0 0))

    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    (setq taz_s_layout_x (+ taz_s_layout_x taz_s_layout_step))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; =========================================================
  ;; Z  (przekroje poziome — płaszczyzna Z=const)
  ;;
  ;; Oznaczenia osi leżą w płaszczyźnie XY przekroju:
  ;;   - osie z x_data: linia wystawia w kierunku -X od krawędzi xmin
  ;;   - osie z y_data: linia wystawia w kierunku -Y od krawędzi ymin
  ;; Brak ROTATE3D — wszystko już w dobrej płaszczyźnie.
  ;; =========================================================

  (setq taz_s_tmp taz_s_z_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (taz_s_get_name)
    (setq taz_s_name taz_s_res)
    (setq taz_s_z taz_s_val)

    (setq taz_s_p1 (list taz_s_xmin taz_s_ymin taz_s_z))
    (setq taz_s_p2 (list taz_s_xmax taz_s_ymin taz_s_z))
    (setq taz_s_p3 (list taz_s_xmax taz_s_ymax taz_s_z))
    (setq taz_s_p4 (list taz_s_xmin taz_s_ymax taz_s_z))
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; OZNACZENIA OSI — poziome, w płaszczyźnie XY, bez ROTATE
    (setvar "CLAYER" "taz_s_sections")
    (setq taz_s_axis_ss_list (ssadd))

    ;; Osie z x_data — linia wystawia w -X od krawędzi xmin
    ;; Punkt startowy: (xmin, pozycja_Y_osi, z)
    (setq taz_s_xtmp taz_s_x_data)
    (while taz_s_xtmp
      (setq taz_s_row (car taz_s_xtmp))
      (taz_s_get_dist)
      (taz_s_get_name)
      (setq taz_s_ax_name taz_s_res)
      (setq taz_s_ax_y taz_s_val)
      (setq taz_s_one_axis_ss
        (taz_s_draw_axis_z
          taz_s_xmin taz_s_ax_y taz_s_z
          "X-"
          taz_s_ax_name
        )
      )
      (setq taz_s_k 0)
      (while (< taz_s_k (sslength taz_s_one_axis_ss))
        (ssadd (ssname taz_s_one_axis_ss taz_s_k) taz_s_axis_ss_list)
        (setq taz_s_k (+ taz_s_k 1))
      )
      (setq taz_s_xtmp (cdr taz_s_xtmp))
    )

    ;; Osie z y_data — linia wystawia w -Y od krawędzi ymin
    ;; Punkt startowy: (pozycja_X_osi, ymin, z)
    (setq taz_s_xtmp taz_s_y_data)
    (while taz_s_xtmp
      (setq taz_s_row (car taz_s_xtmp))
      (taz_s_get_dist)
      (taz_s_get_name)
      (setq taz_s_ax_name taz_s_res)
      (setq taz_s_ax_x taz_s_val)
      (setq taz_s_one_axis_ss
        (taz_s_draw_axis_z
          taz_s_ax_x taz_s_ymin taz_s_z
          "Y-"
          taz_s_ax_name
        )
      )
      (setq taz_s_k 0)
      (while (< taz_s_k (sslength taz_s_one_axis_ss))
        (ssadd (ssname taz_s_one_axis_ss taz_s_k) taz_s_axis_ss_list)
        (setq taz_s_k (+ taz_s_k 1))
      )
      (setq taz_s_xtmp (cdr taz_s_xtmp))
    )

    ;; Z NIE MA ROTATE

    (setq taz_s_title_pt
      (list (car taz_s_center) (+ (cadr taz_s_center) 10000.0) (caddr taz_s_center))
    )
    (setvar "CLAYER" "taz_s_execution_design")
    (command "TEXT" "_J" "MC" taz_s_title_pt 700.0 0 (strcat "SECTION " taz_s_name))

    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if (> (sslength taz_s_axis_ss_list) 0)
      (command "MOVE" taz_s_axis_ss_list "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (command "MOVE" (entlast) "" taz_s_center (list taz_s_layout_x 0 0))

    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    (setq taz_s_layout_x (+ taz_s_layout_x taz_s_layout_step))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------------------------------
  ;; PRZYWRÓCENIE POPRZEDNIEGO UCS
  ;; ---------------------------------------------------------
  
  (if taz_s_ucs_exist
    (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
    (princ)
  )
  
  ;; ---------------------------------------------------------
  ;; PRZYWRÓCENIE POPRZEDNIEGO WIDOKU
  ;; ---------------------------------------------------------
  
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")
  
  (taz_s_lock_all_layers)
  (taz_s_current_settings_restore)
  
  (princ)
)