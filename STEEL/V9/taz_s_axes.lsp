(defun c:taz_s_axes ( / taz_s_dcl_id taz_s_result taz_s_len )

  ;; długość osi (możesz zmienić)
  (setq taz_s_len 10000.0)

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
  ;; WYCIĄGANIE LICZBY
  ;; ---------------------------
  (defun taz_s_get_dist (taz_s_row)
    (atof (substr taz_s_row (+ (vl-string-search "]" taz_s_row) 3)))
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
            (taz_s_update_list taz_s_list_key taz_s_x_data)
          )
          ((= taz_s_axis "y")
            (setq taz_s_y_data (append taz_s_y_data (list taz_s_row)))
            (taz_s_update_list taz_s_list_key taz_s_y_data)
          )
          ((= taz_s_axis "z")
            (setq taz_s_z_data (append taz_s_z_data (list taz_s_row)))
            (taz_s_update_list taz_s_list_key taz_s_z_data)
          )
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
  ;; RYSOWANIE
  ;; ---------------------------
  (defun taz_s_draw_axes ()
    
    ;; zapisz widok
    (command "-VIEW" "_S" "taz_s_temp_view")

    (foreach taz_s_z taz_s_z_data

      (setq taz_s_zval (taz_s_get_dist taz_s_z))

      ;; X (linie poziome)
      (foreach taz_s_x taz_s_x_data
        (setq taz_s_yval (taz_s_get_dist taz_s_x))
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")

        (command "LINE"
          (list (- taz_s_len) taz_s_yval taz_s_zval)
          (list taz_s_len taz_s_yval taz_s_zval)
          ""
        )
      )

      ;; Y (linie pionowe)
      (foreach taz_s_y taz_s_y_data
        (setq taz_s_xval (taz_s_get_dist taz_s_y))
        
        (command "_LINE" '(-50 -50 0) '(50 50 0) "")
        (command "_PLAN" "_C")
        (command "_ZOOM" "_OBJECT" (entlast) "")
        (entdel (entlast))
        (command "_ZOOM" "_SCALE" "1000X")
        (command "REGEN")

        (command "LINE"
          (list taz_s_xval (- taz_s_len) taz_s_zval)
          (list taz_s_xval taz_s_len taz_s_zval)
          ""
        )
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

  ;; OK / Cancel
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  ;; start
  (setq taz_s_result (start_dialog))
  (unload_dialog taz_s_dcl_id)

  ;; ---------------------------
  ;; PO OK → RYSUJ
  ;; ---------------------------
  (if (= taz_s_result 1)
    (progn
      (taz_s_draw_axes)
      (prompt "\nOsie narysowane.")
    )
  )

  (princ)
)
