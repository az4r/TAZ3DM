(defun c:taz_s_create_drawings_execution_design ()

  ;; ---------------------------------
  ;; UCS WORLD
  ;; ---------------------------------

  (command "_UCS" "_W")

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
  ;; WARSTWA
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_execution_design"))
    (command "_LAYER" "_M" "taz_s_execution_design" "_C" "30" "" "")
  )

  (setvar "CLAYER" "taz_s_execution_design")

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTWY
  ;; ---------------------------------

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_execution_design")))
  )

  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  ;; ---------------------------------
  ;; PROSTOKĄTY X
  ;; ---------------------------------

  (setq taz_s_tmp taz_s_x_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))

    (taz_s_get_dist)

    ;; pozycja Y osi
    (setq y taz_s_val)

    ;; punkty prostokąta
    (setq p1 (list taz_s_xmin y taz_s_zmin))
    (setq p2 (list taz_s_xmax y taz_s_zmin))
    (setq p3 (list taz_s_xmax y taz_s_zmax))
    (setq p4 (list taz_s_xmin y taz_s_zmax))

    ;; polilinia 3D
    (command
      "3DPOLY"
      p1
      p2
      p3
      p4
      p1
      ""
    )

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; PROSTOKĄTY Y
  ;; ---------------------------------

  (setq taz_s_tmp taz_s_y_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))

    (taz_s_get_dist)

    ;; pozycja X osi
    (setq x taz_s_val)

    ;; punkty prostokąta
    (setq p1 (list x taz_s_ymin taz_s_zmin))
    (setq p2 (list x taz_s_ymax taz_s_zmin))
    (setq p3 (list x taz_s_ymax taz_s_zmax))
    (setq p4 (list x taz_s_ymin taz_s_zmax))

    ;; polilinia 3D
    (command
      "3DPOLY"
      p1
      p2
      p3
      p4
      p1
      ""
    )

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  (princ)
)
