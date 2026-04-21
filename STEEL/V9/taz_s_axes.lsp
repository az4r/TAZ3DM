(defun c:taz_s_axes ( / taz_s_dcl_id taz_s_result taz_s_offset )

  ;; dane
  (setq taz_s_x_data '())
  (setq taz_s_y_data '())
  (setq taz_s_z_data '())

  ;; ---------------------------
  ;; format wpisu
  ;; ---------------------------
  (defun taz_s_format_row (taz_s_name taz_s_dist)
    (strcat "[" taz_s_name "]  " taz_s_dist)
  )

  ;; ---------------------------
  ;; wyciąganie liczby
  ;; ---------------------------
  (defun taz_s_get_dist (taz_s_row)
    (atof (substr taz_s_row (+ (vl-string-search "]" taz_s_row) 3)))
  )

  ;; ---------------------------
  ;; wszystkie wartości
  ;; ---------------------------
  (defun taz_s_get_all_dist (taz_s_list)
    (mapcar 'taz_s_get_dist taz_s_list)
  )

  ;; ---------------------------
  ;; zakres
  ;; ---------------------------
  (defun taz_s_get_range (taz_s_vals taz_s_offset)
    (list
      (- (apply 'min taz_s_vals) taz_s_offset)
      (+ (apply 'max taz_s_vals) taz_s_offset)
    )
  )

  ;; ---------------------------
  ;; update list
  ;; ---------------------------
  (defun taz_s_update_list (taz_s_key taz_s_data)
    (start_list taz_s_key)
    (foreach taz_s_item taz_s_data (add_list taz_s_item))
    (end_list)
  )

  ;; ---------------------------
  ;; add
  ;; ---------------------------
  (defun taz_s_add_item (taz_s_name taz_s_dist taz_s_axis taz_s_list_key)
    (if (and (/= taz_s_name "") (/= taz_s_dist ""))
      (progn
        (setq taz_s_row (taz_s_format_row taz_s_name taz_s_dist))

        (cond
          ((= taz_s_axis "x")
            (setq taz_s_x_data (append taz_s_x_data (list taz_s_row)))
            (taz_s_update_list taz_s_list_key taz_s_x_data))
          ((= taz_s_axis "y")
            (setq taz_s_y_data (append taz_s_y_data (list taz_s_row)))
            (taz_s_update_list taz_s_list_key taz_s_y_data))
          ((= taz_s_axis "z")
            (setq taz_s_z_data (append taz_s_z_data (list taz_s_row)))
            (taz_s_update_list taz_s_list_key taz_s_z_data))
        )
      )
      (alert "Uzupełnij wszystkie pola!")
    )
  )

  ;; ---------------------------
  ;; clear
  ;; ---------------------------
  (defun taz_s_clear_list (taz_s_axis taz_s_list_key)
    (cond
      ((= taz_s_axis "x") (setq taz_s_x_data '()) (taz_s_update_list taz_s_list_key taz_s_x_data))
      ((= taz_s_axis "y") (setq taz_s_y_data '()) (taz_s_update_list taz_s_list_key taz_s_y_data))
      ((= taz_s_axis "z") (setq taz_s_z_data '()) (taz_s_update_list taz_s_list_key taz_s_z_data))
    )
  )

  ;; ---------------------------
  ;; rysowanie
  ;; ---------------------------
  (defun taz_s_draw_axes ()

    (setq taz_s_offset (atof (get_tile "taz_s_offset")))
    (if (= taz_s_offset 0.0) (setq taz_s_offset 1000.0))

    (setq taz_s_x_vals (taz_s_get_all_dist taz_s_x_data))
    (setq taz_s_y_vals (taz_s_get_all_dist taz_s_y_data))

    (if (or (null taz_s_x_vals) (null taz_s_y_vals))
      (progn (alert "Brak danych X lub Y!") (exit))
    )

    (setq taz_s_x_range (taz_s_get_range taz_s_y_vals taz_s_offset))
    (setq taz_s_y_range (taz_s_get_range taz_s_x_vals taz_s_offset))

    ;; widok
    (command "-VIEW" "_S" "taz_s_temp_view")

    (foreach taz_s_z taz_s_z_data

      (setq taz_s_zval (taz_s_get_dist taz_s_z))

      ;; X
      (foreach taz_s_x taz_s_x_data
        (setq taz_s_yval (taz_s_get_dist taz_s_x))
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")
        
        (command "LINE"
          (list (car taz_s_x_range) taz_s_yval taz_s_zval)
          (list (cadr taz_s_x_range) taz_s_yval taz_s_zval)
          "")
      )

      ;; Y
      (foreach taz_s_y taz_s_y_data
        (setq taz_s_xval (taz_s_get_dist taz_s_y))
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")
        
        (command "LINE"
          (list taz_s_xval (car taz_s_y_range) taz_s_zval)
          (list taz_s_xval (cadr taz_s_y_range) taz_s_zval)
          "")
      )
    )

    ;; przywrócenie widoku
    (command "-VIEW" "_R" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
  )

  ;; ---------------------------
  ;; DCL
  ;; ---------------------------
  (setq taz_s_dcl_id (load_dialog "taz_s_axes.dcl"))
  (if (<= taz_s_dcl_id 0) (progn (alert "Błąd DCL") (exit)))
  (if (not (new_dialog "taz_s_axes_dialog" taz_s_dcl_id)) (exit))

  ;; X
  (action_tile "taz_s_x_add"
    "(taz_s_add_item (get_tile \"taz_s_x_name\") (get_tile \"taz_s_x_dist\") \"x\" \"taz_s_x_list\")")
  (action_tile "taz_s_x_clear"
    "(taz_s_clear_list \"x\" \"taz_s_x_list\")")

  ;; Y
  (action_tile "taz_s_y_add"
    "(taz_s_add_item (get_tile \"taz_s_y_name\") (get_tile \"taz_s_y_dist\") \"y\" \"taz_s_y_list\")")
  (action_tile "taz_s_y_clear"
    "(taz_s_clear_list \"y\" \"taz_s_y_list\")")

  ;; Z
  (action_tile "taz_s_z_add"
    "(taz_s_add_item (get_tile \"taz_s_z_name\") (get_tile \"taz_s_z_dist\") \"z\" \"taz_s_z_list\")")
  (action_tile "taz_s_z_clear"
    "(taz_s_clear_list \"z\" \"taz_s_z_list\")")

  ;; OK
  (action_tile "accept" "(taz_s_draw_axes)(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (setq taz_s_result (start_dialog))
  (unload_dialog taz_s_dcl_id)

  (princ)
)
