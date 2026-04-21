(defun c:taz_s_axes ()

  ;; ---------------------------
  ;; WCZYTANIE DANYCH
  ;; ---------------------------
  (if (and (boundp 'taz_s_axis_data_x) taz_s_axis_data_x)
    (setq taz_s_x_data taz_s_axis_data_x)
    (setq taz_s_x_data '())
  )

  (if (and (boundp 'taz_s_axis_data_y) taz_s_axis_data_y)
    (setq taz_s_y_data taz_s_axis_data_y)
    (setq taz_s_y_data '())
  )

  (if (and (boundp 'taz_s_axis_data_z) taz_s_axis_data_z)
    (setq taz_s_z_data taz_s_axis_data_z)
    (setq taz_s_z_data '())
  )

  ;; ---------------------------
  ;; FORMAT
  ;; ---------------------------
  (defun taz_s_format_row ()
    (setq taz_s_row (strcat "[" taz_s_n "]  " taz_s_d))
  )

  ;; ---------------------------
  ;; NAZWA
  ;; ---------------------------
  (defun taz_s_get_name ()
    (setq taz_s_i 2)
    (setq taz_s_res "")
    (while (/= (substr taz_s_row taz_s_i 1) "]")
      (setq taz_s_res (strcat taz_s_res (substr taz_s_row taz_s_i 1)))
      (setq taz_s_i (+ taz_s_i 1))
    )
  )

  ;; ---------------------------
  ;; ODLEGŁOŚĆ
  ;; ---------------------------
  (defun taz_s_get_dist ()
    (setq taz_s_i 1)
    (setq taz_s_len (strlen taz_s_row))

    (while (and (<= taz_s_i taz_s_len) (/= (substr taz_s_row taz_s_i 1) "]"))
      (setq taz_s_i (+ taz_s_i 1))
    )

    (setq taz_s_i (+ taz_s_i 3))
    (setq taz_s_val (atof (substr taz_s_row taz_s_i)))
  )

  ;; ---------------------------
  ;; UPDATE LIST
  ;; ---------------------------
  (defun taz_s_update_list ()
    (start_list taz_s_key)
    (setq taz_s_tmp taz_s_data)
    (while taz_s_tmp
      (add_list (car taz_s_tmp))
      (setq taz_s_tmp (cdr taz_s_tmp))
    )
    (end_list)
  )

  ;; ---------------------------
  ;; ADD
  ;; ---------------------------
  (defun taz_s_add_item ()
    (if (and (/= taz_s_n "") (/= taz_s_d ""))
      (progn
        (taz_s_format_row)

        (if (= taz_s_axis "x") (setq taz_s_x_data (append taz_s_x_data (list taz_s_row))))
        (if (= taz_s_axis "y") (setq taz_s_y_data (append taz_s_y_data (list taz_s_row))))
        (if (= taz_s_axis "z") (setq taz_s_z_data (append taz_s_z_data (list taz_s_row))))

        (setq taz_s_data
          (if (= taz_s_axis "x") taz_s_x_data
            (if (= taz_s_axis "y") taz_s_y_data taz_s_z_data)
          )
        )

        (taz_s_update_list)
      )
      (alert "Uzupełnij pola!")
    )
  )

  ;; ---------------------------
  ;; CLEAR LIST
  ;; ---------------------------
  (defun taz_s_clear_list ()
    (if (= taz_s_axis "x") (setq taz_s_x_data '()))
    (if (= taz_s_axis "y") (setq taz_s_y_data '()))
    (if (= taz_s_axis "z") (setq taz_s_z_data '()))

    (setq taz_s_data '())
    (taz_s_update_list)
  )

  ;; ---------------------------
  ;; MIN / MAX
  ;; ---------------------------
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

  ;; ---------------------------
  ;; WARSTWA + CZYSZCZENIE
  ;; ---------------------------
  (defun taz_s_prepare_layer ()

    ;; utwórz jeśli nie istnieje
    (if (not (tblsearch "LAYER" "taz_s_axes"))
      (command "_layer" "_M" "taz_s_axes" "_C" "109" "" "")
    )

    ;; ustaw warstwę
    (setvar "CLAYER" "taz_s_axes")

    ;; usuń tylko elementy z tej warstwy
    (setq taz_s_ss (ssget "X" '((8 . "taz_s_axes"))))
    (if taz_s_ss (command "ERASE" taz_s_ss ""))
  )

  ;; ---------------------------
  ;; RYSOWANIE
  ;; ---------------------------
  (defun taz_s_draw_axes ()
    
    ;; widok
    (command "-VIEW" "_S" "taz_s_temp_view")

    (taz_s_prepare_layer)

    (setq taz_s_offset (atof (get_tile "taz_s_offset")))
    (if (= taz_s_offset 0.0) (setq taz_s_offset 1000.0))

    (setq taz_s_draw_labels (get_tile "taz_s_draw_labels"))

    ;; X vals
    (setq taz_s_xvals '())
    (setq taz_s_tmp taz_s_x_data)
    (while taz_s_tmp
      (setq taz_s_row (car taz_s_tmp))
      (taz_s_get_dist)
      (setq taz_s_xvals (append taz_s_xvals (list taz_s_val)))
      (setq taz_s_tmp (cdr taz_s_tmp))
    )

    ;; Y vals
    (setq taz_s_yvals '())
    (setq taz_s_tmp taz_s_y_data)
    (while taz_s_tmp
      (setq taz_s_row (car taz_s_tmp))
      (taz_s_get_dist)
      (setq taz_s_yvals (append taz_s_yvals (list taz_s_val)))
      (setq taz_s_tmp (cdr taz_s_tmp))
    )

    ;; zakres
    (setq taz_s_list taz_s_yvals)(taz_s_min)
    (setq taz_s_xmin (- taz_s_m taz_s_offset))

    (setq taz_s_list taz_s_yvals)(taz_s_max)
    (setq taz_s_xmax (+ taz_s_m taz_s_offset))

    (setq taz_s_list taz_s_xvals)(taz_s_min)
    (setq taz_s_ymin (- taz_s_m taz_s_offset))

    (setq taz_s_list taz_s_xvals)(taz_s_max)
    (setq taz_s_ymax (+ taz_s_m taz_s_offset))

    ;; Z
    (setq taz_s_zlist taz_s_z_data)
    (while taz_s_zlist

      (setq taz_s_row (car taz_s_zlist))
      (taz_s_get_dist)
      (setq taz_s_zval taz_s_val)

      ;; X
      (setq taz_s_tmp taz_s_x_data)
      (while taz_s_tmp

        (setq taz_s_row (car taz_s_tmp))
        (taz_s_get_dist)
        (setq taz_s_yval taz_s_val)

        (taz_s_get_name)
        (setq taz_s_name taz_s_res)
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")

        (command "LINE"
          (list taz_s_xmin taz_s_yval taz_s_zval)
          (list taz_s_xmax taz_s_yval taz_s_zval)
          ""
        )

        (if (= taz_s_draw_labels "1")
          (progn
            (command "TEXT"
              (list taz_s_xmin taz_s_yval taz_s_zval)
              250
              0
              taz_s_name
            )
            (command "TEXT"
              (list taz_s_xmax taz_s_yval taz_s_zval)
              250
              0
              taz_s_name
            )
          )
        )

        (setq taz_s_tmp (cdr taz_s_tmp))
      )

      ;; Y
      (setq taz_s_tmp taz_s_y_data)
      (while taz_s_tmp

        (setq taz_s_row (car taz_s_tmp))
        (taz_s_get_dist)
        (setq taz_s_xval taz_s_val)

        (taz_s_get_name)
        (setq taz_s_name taz_s_res)
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")

        (command "LINE"
          (list taz_s_xval taz_s_ymin taz_s_zval)
          (list taz_s_xval taz_s_ymax taz_s_zval)
          ""
        )

        (if (= taz_s_draw_labels "1")
          (progn
            (command "TEXT"
              (list taz_s_xval taz_s_ymin taz_s_zval)
              250
              90
              taz_s_name
            )
            (command "TEXT"
              (list taz_s_xval taz_s_ymax taz_s_zval)
              250
              90
              taz_s_name
            )
          )
        )

        (setq taz_s_tmp (cdr taz_s_tmp))
      )

      (setq taz_s_zlist (cdr taz_s_zlist))
    )

    ;; zapis
    (setq taz_s_axis_data_x taz_s_x_data)
    (setq taz_s_axis_data_y taz_s_y_data)
    (setq taz_s_axis_data_z taz_s_z_data)
    
    ;; przywrócenie widoku
    (command "-VIEW" "_R" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
  )

  ;; ---------------------------
  ;; DCL
  ;; ---------------------------
  (setq taz_s_dcl_id (load_dialog "taz_s_axes.dcl"))
  (new_dialog "taz_s_axes_dialog" taz_s_dcl_id)

  ;; load list
  (setq taz_s_key "taz_s_x_list")(setq taz_s_data taz_s_x_data)(taz_s_update_list)
  (setq taz_s_key "taz_s_y_list")(setq taz_s_data taz_s_y_data)(taz_s_update_list)
  (setq taz_s_key "taz_s_z_list")(setq taz_s_data taz_s_z_data)(taz_s_update_list)

  ;; akcje
  (action_tile "taz_s_x_add"
    "(setq taz_s_n (get_tile \"taz_s_x_name\"))(setq taz_s_d (get_tile \"taz_s_x_dist\"))(setq taz_s_axis \"x\")(setq taz_s_key \"taz_s_x_list\")(taz_s_add_item)")

  (action_tile "taz_s_x_clear"
    "(setq taz_s_axis \"x\")(setq taz_s_key \"taz_s_x_list\")(taz_s_clear_list)")

  (action_tile "taz_s_y_add"
    "(setq taz_s_n (get_tile \"taz_s_y_name\"))(setq taz_s_d (get_tile \"taz_s_y_dist\"))(setq taz_s_axis \"y\")(setq taz_s_key \"taz_s_y_list\")(taz_s_add_item)")

  (action_tile "taz_s_y_clear"
    "(setq taz_s_axis \"y\")(setq taz_s_key \"taz_s_y_list\")(taz_s_clear_list)")

  (action_tile "taz_s_z_add"
    "(setq taz_s_n (get_tile \"taz_s_z_name\"))(setq taz_s_d (get_tile \"taz_s_z_dist\"))(setq taz_s_axis \"z\")(setq taz_s_key \"taz_s_z_list\")(taz_s_add_item)")

  (action_tile "taz_s_z_clear"
    "(setq taz_s_axis \"z\")(setq taz_s_key \"taz_s_z_list\")(taz_s_clear_list)")

  (action_tile "accept" "(taz_s_draw_axes)(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (start_dialog)
  (unload_dialog taz_s_dcl_id)

  (princ)
)
