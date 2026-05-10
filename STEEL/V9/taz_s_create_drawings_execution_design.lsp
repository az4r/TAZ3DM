(defun c:taz_s_create_drawings_execution_design ()

  ;; ---------------------------------
  ;; UCS WORLD
  ;; ---------------------------------

  (command "_UCS" "_W")

  ;; ---------------------------------
  ;; OFFSET START
  ;; ---------------------------------

  (setq taz_s_layout_start 100000.0)

  ;; ---------------------------------
  ;; OFFSET KOLEJNYCH
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
  ;; POBRANIE ODLEGŁOŚCI
  ;; ---------------------------------

  (defun taz_s_get_dist ()

    (setq taz_s_i 1)
    (setq taz_s_len (strlen taz_s_row))

    (while
      (and
        (<= taz_s_i taz_s_len)
        (/= (substr taz_s_row taz_s_i 1) "]")
      )

      (setq taz_s_i (+ taz_s_i 1))
    )

    (setq taz_s_i (+ taz_s_i 3))

    (setq taz_s_val
      (atof (substr taz_s_row taz_s_i))
    )
  )

  ;; ---------------------------------
  ;; MIN
  ;; ---------------------------------

  (defun taz_s_min ()

    (setq taz_s_m (car taz_s_list))

    (setq taz_s_list (cdr taz_s_list))

    (while taz_s_list

      (if (< (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list))
      )

      (setq taz_s_list (cdr taz_s_list))
    )
  )

  ;; ---------------------------------
  ;; MAX
  ;; ---------------------------------

  (defun taz_s_max ()

    (setq taz_s_m (car taz_s_list))

    (setq taz_s_list (cdr taz_s_list))

    (while taz_s_list

      (if (> (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list))
      )

      (setq taz_s_list (cdr taz_s_list))
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

    (setq taz_s_xvals
      (append taz_s_xvals (list taz_s_val))
    )

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

    (setq taz_s_yvals
      (append taz_s_yvals (list taz_s_val))
    )

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

    (setq taz_s_zvals
      (append taz_s_zvals (list taz_s_val))
    )

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; X MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals)
  (taz_s_min)

  (setq taz_s_xmin taz_s_m)

  ;; ---------------------------------
  ;; X MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals)
  (taz_s_max)

  (setq taz_s_xmax taz_s_m)

  ;; ---------------------------------
  ;; Y MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_xvals)
  (taz_s_min)

  (setq taz_s_ymin taz_s_m)

  ;; ---------------------------------
  ;; Y MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_xvals)
  (taz_s_max)

  (setq taz_s_ymax taz_s_m)

  ;; ---------------------------------
  ;; Z MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_zvals)
  (taz_s_min)

  (setq taz_s_zmin taz_s_m)

  ;; ---------------------------------
  ;; Z MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_zvals)
  (taz_s_max)

  (setq taz_s_zmax taz_s_m)

  ;; ---------------------------------
  ;; WARSTWA PROSTOKĄTÓW
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_execution_design"))
    (command "_LAYER" "_M" "taz_s_execution_design" "_C" "30" "" "")
  )

  ;; ---------------------------------
  ;; WARSTWA SECTION
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_sections"))
    (command "_LAYER" "_M" "taz_s_sections" "_C" "1" "" "")
  )

  ;; ---------------------------------
  ;; WARSTWA SECTION TEMP
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_sections_temp"))
    (command "_LAYER" "_M" "taz_s_sections_temp" "_C" "3" "" "")
  )

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTW
  ;; ---------------------------------

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_execution_design")))
  )

  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_sections")))
  )

  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_sections_temp")))
  )

  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
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

    ;; ---------------------------------
    ;; PUNKTY
    ;; ---------------------------------

    (setq taz_s_p1 (list taz_s_xmin taz_s_y taz_s_zmin))
    (setq taz_s_p2 (list taz_s_xmax taz_s_y taz_s_zmin))
    (setq taz_s_p3 (list taz_s_xmax taz_s_y taz_s_zmax))
    (setq taz_s_p4 (list taz_s_xmin taz_s_y taz_s_zmax))

    ;; ---------------------------------
    ;; PROSTOKĄT
    ;; ---------------------------------

    (setvar "CLAYER" "taz_s_execution_design")

    (command
      "3DPOLY"
      taz_s_p1
      taz_s_p2
      taz_s_p3
      taz_s_p4
      taz_s_p1
      ""
    )

    ;; ---------------------------------
    ;; ŁAPANIE PROSTOKĄTA
    ;; ---------------------------------

    (setq taz_s_rect_ss
      (ssget "_L")
    )

    ;; ---------------------------------
    ;; SECTION TEMP
    ;; ---------------------------------

    (setvar "CLAYER" "taz_s_sections_temp")

    (command
      "SECTION"
      taz_s_model_ss
      ""
      "_3points"
      taz_s_p1
      taz_s_p2
      taz_s_p3
    )

    ;; ---------------------------------
    ;; ŁAPANIE SECTION
    ;; ---------------------------------

    (setq taz_s_section_ss
      (ssget "X" '((8 . "taz_s_sections_temp")))
    )

    ;; ---------------------------------
    ;; ROTATE 3D
    ;; ---------------------------------

    (if taz_s_rect_ss
      (command
        "ROTATE3D"
        taz_s_rect_ss
        ""
        "_X"
        '(0 0 0)
        "90"
      )
    )

    (if taz_s_section_ss
      (command
        "ROTATE3D"
        taz_s_section_ss
        ""
        "_X"
        '(0 0 0)
        "90"
      )
    )

    ;; ---------------------------------
    ;; MOVE
    ;; ---------------------------------

    (if taz_s_rect_ss
      (command
        "MOVE"
        taz_s_rect_ss
        ""
        '(0 0 0)
        (list taz_s_layout_x 0 0)
      )
    )

    (if taz_s_section_ss
      (command
        "MOVE"
        taz_s_section_ss
        ""
        '(0 0 0)
        (list taz_s_layout_x 0 0)
      )
    )

    ;; ---------------------------------
    ;; WARSTWA DOCELOWA
    ;; ---------------------------------

    (if taz_s_section_ss
      (command
        "CHPROP"
        taz_s_section_ss
        ""
        "_LA"
        "taz_s_sections"
        ""
      )
    )

    ;; ---------------------------------
    ;; KOLEJNA POZYCJA
    ;; ---------------------------------

    (setq taz_s_layout_x
      (+ taz_s_layout_x taz_s_layout_step)
    )

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  (princ)
)
