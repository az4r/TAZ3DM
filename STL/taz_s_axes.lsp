(defun c:taz_s_axes ()

  (setq taz_s_text_offset 250.0)
  (setq taz_s_circle_radius 250.0)


  ;; ---------------------------
  ;; XDATA: ZAPIS LISTY DO STRINGA
  ;; Wejście:  taz_s_conv_list  (lista stringów do zakodowania)
  ;; Wyjście:  taz_s_conv_str   (jeden string połączony separatorem ";;")
  ;; ---------------------------
  (defun taz_s_list_to_str ()
    (setq taz_s_conv_str "")
    (setq taz_s_conv_tmp taz_s_conv_list)
    (while taz_s_conv_tmp
      (if (= taz_s_conv_str "")
        (setq taz_s_conv_str (car taz_s_conv_tmp))
        (setq taz_s_conv_str (strcat taz_s_conv_str ";;" (car taz_s_conv_tmp)))
      )
      (setq taz_s_conv_tmp (cdr taz_s_conv_tmp))
    )
  )


  ;; ---------------------------
  ;; XDATA: ODCZYT STRINGA DO LISTY
  ;; Wejście:  taz_s_conv_str   (string z separatorami ";;")
  ;; Wyjście:  taz_s_conv_list  (lista stringów)
  ;; ---------------------------
  (defun taz_s_str_to_list ()
    (setq taz_s_conv_list '())
    (setq taz_s_conv_remain taz_s_conv_str)
    (while (/= taz_s_conv_remain "")
      (setq taz_s_conv_pos (vl-string-search ";;" taz_s_conv_remain))
      (if taz_s_conv_pos
        (progn
          (setq taz_s_conv_list
            (append taz_s_conv_list
              (list (substr taz_s_conv_remain 1 taz_s_conv_pos))
            )
          )
          (setq taz_s_conv_remain (substr taz_s_conv_remain (+ taz_s_conv_pos 3)))
        )
        (progn
          (setq taz_s_conv_list (append taz_s_conv_list (list taz_s_conv_remain)))
          (setq taz_s_conv_remain "")
        )
      )
    )
  )


  ;; ---------------------------
  ;; XDATA: ZAPIS DO RYSUNKU
  ;; Punkt pomocniczy (0,0,0) leży na warstwie taz_s_data
  ;; (warstwa tworzona przez taz_s_start.lsp)
  ;; ---------------------------
  (defun taz_s_save_xdata ()

    (if (not (tblsearch "APPID" "TAZ_S_AXES_DATA"))
      (regapp "TAZ_S_AXES_DATA")
    )

    ;; warstwa taz_s_data powinna już istnieć (taz_s_start.lsp)
    ;; ale dla pewności tworzymy ją jeśli jej nie ma
    (if (not (tblsearch "LAYER" "taz_s_data"))
      (command "_layer" "_M" "taz_s_data" "_C" "145" "" "")
    )

    ;; szukamy punktu pomocniczego na warstwie taz_s_data
    (setq taz_s_xd_ent nil)
    (setq taz_s_xd_ss (ssget "X" '((8 . "taz_s_data") (0 . "POINT"))))
    (if taz_s_xd_ss
      (setq taz_s_xd_ent (ssname taz_s_xd_ss 0))
    )

    ;; jeśli punkt nie istnieje – tworzymy go na warstwie taz_s_data
    (if (not taz_s_xd_ent)
      (progn
        (setq taz_s_prev_layer (getvar "CLAYER"))
        (setvar "CLAYER" "taz_s_data")
        (entmake (list '(0 . "POINT") '(10 0.0 0.0 0.0) '(8 . "taz_s_data")))
        (setq taz_s_xd_ent (entlast))
        (setvar "CLAYER" taz_s_prev_layer)
      )
    )

    ;; zakoduj X do stringa
    (setq taz_s_conv_list taz_s_x_data)
    (taz_s_list_to_str)
    (setq taz_s_xd_str_x taz_s_conv_str)

    ;; zakoduj Y do stringa
    (setq taz_s_conv_list taz_s_y_data)
    (taz_s_list_to_str)
    (setq taz_s_xd_str_y (strcat "##Y##" taz_s_conv_str))

    ;; zakoduj Z do stringa
    (setq taz_s_conv_list taz_s_z_data)
    (taz_s_list_to_str)
    (setq taz_s_xd_str_z (strcat "##Z##" taz_s_conv_str))

    (entmod
      (append
        (entget taz_s_xd_ent)
        (list
          (list -3
            (list "TAZ_S_AXES_DATA"
              (cons 1000 taz_s_xd_str_x)
              (cons 1000 taz_s_xd_str_y)
              (cons 1000 taz_s_xd_str_z)
            )
          )
        )
      )
    )
  )


  ;; ---------------------------
  ;; XDATA: ODCZYT Z RYSUNKU
  ;; Szuka punktu pomocniczego na warstwie taz_s_data
  ;; ---------------------------
  (defun taz_s_load_xdata ()
    (setq taz_s_x_data '())
    (setq taz_s_y_data '())
    (setq taz_s_z_data '())

    ;; szukamy punktu na warstwie taz_s_data
    (setq taz_s_xd_ss (ssget "X" '((8 . "taz_s_data") (0 . "POINT"))))
    (if taz_s_xd_ss
      (progn
        (setq taz_s_xd_ent (ssname taz_s_xd_ss 0))
        (setq taz_s_xd (cdadr (assoc -3 (entget taz_s_xd_ent '("TAZ_S_AXES_DATA")))))

        (if taz_s_xd
          (progn
            (setq taz_s_raw_x (cdr (nth 0 taz_s_xd)))
            (setq taz_s_raw_y (cdr (nth 1 taz_s_xd)))
            (setq taz_s_raw_z (cdr (nth 2 taz_s_xd)))

            (if (and taz_s_raw_x (/= taz_s_raw_x ""))
              (progn
                (setq taz_s_conv_str taz_s_raw_x)
                (taz_s_str_to_list)
                (setq taz_s_x_data taz_s_conv_list)
              )
            )

            (if (and taz_s_raw_y (> (strlen taz_s_raw_y) 5))
              (progn
                (setq taz_s_conv_str (substr taz_s_raw_y 6))
                (taz_s_str_to_list)
                (setq taz_s_y_data taz_s_conv_list)
              )
            )

            (if (and taz_s_raw_z (> (strlen taz_s_raw_z) 5))
              (progn
                (setq taz_s_conv_str (substr taz_s_raw_z 6))
                (taz_s_str_to_list)
                (setq taz_s_z_data taz_s_conv_list)
              )
            )
          )
        )
      )
    )
  )


  ;; ---------------------------
  ;; WCZYTANIE DANYCH
  ;; ---------------------------
  (taz_s_load_xdata)

  (if (and (not taz_s_x_data) (boundp 'taz_s_axis_data_x) taz_s_axis_data_x)
    (setq taz_s_x_data taz_s_axis_data_x)
  )
  (if (and (not taz_s_y_data) (boundp 'taz_s_axis_data_y) taz_s_axis_data_y)
    (setq taz_s_y_data taz_s_axis_data_y)
  )
  (if (and (not taz_s_z_data) (boundp 'taz_s_axis_data_z) taz_s_axis_data_z)
    (setq taz_s_z_data taz_s_axis_data_z)
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
      (if (< (car taz_s_list) taz_s_m) (setq taz_s_m (car taz_s_list)))
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  (defun taz_s_max ()
    (setq taz_s_m (car taz_s_list))
    (setq taz_s_list (cdr taz_s_list))
    (while taz_s_list
      (if (> (car taz_s_list) taz_s_m) (setq taz_s_m (car taz_s_list)))
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  ;; ---------------------------
  ;; WARSTWA + CZYSZCZENIE
  ;; (dotyczy wyłącznie warstwy rysunkowej taz_s_axes)
  ;; ---------------------------
  (defun taz_s_prepare_layer ()
    (if (not (tblsearch "LAYER" "taz_s_axes"))
      (command "_layer" "_M" "taz_s_axes" "_C" "109" "" "")
    )
    (setvar "CLAYER" "taz_s_axes")
    (setq taz_s_ss (ssget "X"
      '((8 . "taz_s_axes") (-4 . "<OR")
        (0 . "LINE") (0 . "CIRCLE") (0 . "TEXT")
        (-4 . "OR>")
      )
    ))
    (if taz_s_ss (command "ERASE" taz_s_ss ""))
  )

  ;; ---------------------------
  ;; RYSOWANIE
  ;; ---------------------------
  (defun taz_s_draw_axes ()

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
    (setq taz_s_list taz_s_yvals)(taz_s_min)(setq taz_s_xmin (- taz_s_m taz_s_offset))
    (setq taz_s_list taz_s_yvals)(taz_s_max)(setq taz_s_xmax (+ taz_s_m taz_s_offset))
    (setq taz_s_list taz_s_xvals)(taz_s_min)(setq taz_s_ymin (- taz_s_m taz_s_offset))
    (setq taz_s_list taz_s_xvals)(taz_s_max)(setq taz_s_ymax (+ taz_s_m taz_s_offset))

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
            (setq taz_s_pt1 (list (- taz_s_xmin taz_s_text_offset) taz_s_yval taz_s_zval))
            (command "CIRCLE" taz_s_pt1 taz_s_circle_radius)
            (command "TEXT" "_J" "MC" taz_s_pt1 250 0 taz_s_name)
            (setq taz_s_pt2 (list (+ taz_s_xmax taz_s_text_offset) taz_s_yval taz_s_zval))
            (command "CIRCLE" taz_s_pt2 taz_s_circle_radius)
            (command "TEXT" "_J" "MC" taz_s_pt2 250 0 taz_s_name)
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
            (setq taz_s_pt1 (list taz_s_xval (- taz_s_ymin taz_s_text_offset) taz_s_zval))
            (command "CIRCLE" taz_s_pt1 taz_s_circle_radius)
            (command "TEXT" "_J" "MC" taz_s_pt1 250 90 taz_s_name)
            (setq taz_s_pt2 (list taz_s_xval (+ taz_s_ymax taz_s_text_offset) taz_s_zval))
            (command "CIRCLE" taz_s_pt2 taz_s_circle_radius)
            (command "TEXT" "_J" "MC" taz_s_pt2 250 90 taz_s_name)
          )
        )
        (setq taz_s_tmp (cdr taz_s_tmp))
      )

      (setq taz_s_zlist (cdr taz_s_zlist))
    )

    (setq taz_s_axis_data_x taz_s_x_data)
    (setq taz_s_axis_data_y taz_s_y_data)
    (setq taz_s_axis_data_z taz_s_z_data)

    (taz_s_save_xdata)

    (command "-VIEW" "_R" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
  )
  ;; ---------------------------
  ;; DCL
  ;; ---------------------------
  (setq taz_s_dcl_id (load_dialog "taz_s_axes.dcl"))
  (new_dialog "taz_s_axes_dialog" taz_s_dcl_id)

  (setq taz_s_key "taz_s_x_list")(setq taz_s_data taz_s_x_data)(taz_s_update_list)
  (setq taz_s_key "taz_s_y_list")(setq taz_s_data taz_s_y_data)(taz_s_update_list)
  (setq taz_s_key "taz_s_z_list")(setq taz_s_data taz_s_z_data)(taz_s_update_list)

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
