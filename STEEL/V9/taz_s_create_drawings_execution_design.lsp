(defun c:taz_s_create_drawings_execution_design ()
  
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

  ;; ---------------------------------
  ;; FUNKCJA ŚRODKA PROSTOKĄTA
  ;; ---------------------------------

  (defun taz_s_center_point (taz_s_p1 taz_s_p3)
    (list
      (/ (+ (car taz_s_p1) (car taz_s_p3)) 2.0)
      (/ (+ (cadr taz_s_p1) (cadr taz_s_p3)) 2.0)
      (/ (+ (caddr taz_s_p1) (caddr taz_s_p3)) 2.0)
    )
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
  ;; X
  ;; =========================================================

  (setq taz_s_tmp taz_s_x_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_y taz_s_val)

    ;; PUNKTY
    (setq taz_s_p1 (list taz_s_xmin taz_s_y taz_s_zmin))
    (setq taz_s_p2 (list taz_s_xmax taz_s_y taz_s_zmin))
    (setq taz_s_p3 (list taz_s_xmax taz_s_y taz_s_zmax))
    (setq taz_s_p4 (list taz_s_xmin taz_s_y taz_s_zmax))

    ;; ŚRODEK PROSTOKĄTA
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    ;; PROSTOKĄT
    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    ;; SECTION
    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; ROTATE WZGLĘDEM ŚRODKA
    (if taz_s_rect_ss
      (command "ROTATE3D" taz_s_rect_ss "" "_X" taz_s_center "90")
    )
    (if taz_s_section_ss
      (command "ROTATE3D" taz_s_section_ss "" "_X" taz_s_center "90")
    )

    ;; MOVE Z BAZĄ W ŚRODKU
    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )

    ;; WARSTWA DOCELOWA
    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    ;; NEXT POSITION
    (setq taz_s_layout_x (+ taz_s_layout_x taz_s_layout_step))

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; =========================================================
  ;; Y
  ;; =========================================================

  (setq taz_s_tmp taz_s_y_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_x taz_s_val)

    ;; PUNKTY
    (setq taz_s_p1 (list taz_s_x taz_s_ymin taz_s_zmin))
    (setq taz_s_p2 (list taz_s_x taz_s_ymax taz_s_zmin))
    (setq taz_s_p3 (list taz_s_x taz_s_ymax taz_s_zmax))
    (setq taz_s_p4 (list taz_s_x taz_s_ymin taz_s_zmax))

    ;; ŚRODEK PROSTOKĄTA
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    ;; PROSTOKĄT
    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    ;; SECTION
    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; ROTATE WZGLĘDEM ŚRODKA
    (if taz_s_rect_ss
      (command "ROTATE3D" taz_s_rect_ss "" "_Y" taz_s_center "-90")
    )
    (if taz_s_section_ss
      (command "ROTATE3D" taz_s_section_ss "" "_Y" taz_s_center "-90")
    )

    ;; MOVE Z BAZĄ W ŚRODKU
    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )

    ;; WARSTWA DOCELOWA
    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    ;; NEXT POSITION
    (setq taz_s_layout_x (+ taz_s_layout_x taz_s_layout_step))

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; =========================================================
  ;; Z
  ;; =========================================================

  (setq taz_s_tmp taz_s_z_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_z taz_s_val)

    ;; PUNKTY
    (setq taz_s_p1 (list taz_s_xmin taz_s_ymin taz_s_z))
    (setq taz_s_p2 (list taz_s_xmax taz_s_ymin taz_s_z))
    (setq taz_s_p3 (list taz_s_xmax taz_s_ymax taz_s_z))
    (setq taz_s_p4 (list taz_s_xmin taz_s_ymax taz_s_z))

    ;; ŚRODEK PROSTOKĄTA
    (setq taz_s_center (taz_s_center_point taz_s_p1 taz_s_p3))

    ;; PROSTOKĄT
    (setvar "CLAYER" "taz_s_execution_design")
    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (setq taz_s_rect_ss (ssget "_L"))

    ;; SECTION
    (setvar "CLAYER" "taz_s_sections_temp")
    (command "SECTION" taz_s_model_ss "" "_3points" taz_s_p1 taz_s_p2 taz_s_p3)
    (setq taz_s_section_ss (ssget "X" '((8 . "taz_s_sections_temp"))))

    ;; Z NIE MA ROTATE

    ;; MOVE Z BAZĄ W ŚRODKU
    (if taz_s_rect_ss
      (command "MOVE" taz_s_rect_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )
    (if taz_s_section_ss
      (command "MOVE" taz_s_section_ss "" taz_s_center (list taz_s_layout_x 0 0))
    )

    ;; WARSTWA DOCELOWA
    (if taz_s_section_ss
      (command "CHPROP" taz_s_section_ss "" "_LA" "taz_s_sections" "")
    )

    ;; NEXT POSITION
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
  ;; PRZYWRÓCENIE POPRZEDNIEGO UCS
  ;; ---------------------------------------------------------
  
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")
  
  (princ)
)
