(defun c:axes_dialog_test ( / dcl_id result )

  (setq x_data '() y_data '() z_data '())

  ;; ---------------------------
  ;; format wpisu
  ;; ---------------------------
  (defun format-row (name dist)
    (strcat "[" name "]  " dist)
  )

  ;; ---------------------------
  ;; update list
  ;; ---------------------------
  (defun update_list (key data)
    (start_list key)
    (foreach item data (add_list item))
    (end_list)
  )

  ;; ---------------------------
  ;; add
  ;; ---------------------------
  (defun add_item (name dist data_key list_key)
    (if (and (/= name "") (/= dist ""))
      (progn
        (setq row (format-row name dist))

        (cond
          ((= data_key "x")
            (setq x_data (append x_data (list row)))
            (update_list list_key x_data)
          )
          ((= data_key "y")
            (setq y_data (append y_data (list row)))
            (update_list list_key y_data)
          )
          ((= data_key "z")
            (setq z_data (append z_data (list row)))
            (update_list list_key z_data)
          )
        )
      )
      (alert "Uzupełnij wszystkie pola!")
    )
  )

  ;; ---------------------------
  ;; clear
  ;; ---------------------------
  (defun clear_list (data_key list_key)
    (cond
      ((= data_key "x") (setq x_data '()) (update_list list_key x_data))
      ((= data_key "y") (setq y_data '()) (update_list list_key y_data))
      ((= data_key "z") (setq z_data '()) (update_list list_key z_data))
    )
  )

  ;; ---------------------------
  ;; DCL
  ;; ---------------------------
  (setq dcl_id (load_dialog "axes.dcl"))
  (if (<= dcl_id 0) (progn (alert "Błąd DCL") (exit)))
  (if (not (new_dialog "axes_dialog" dcl_id)) (exit))

  ;; X
  (action_tile "x_add"
    "(add_item (get_tile \"x_name\") (get_tile \"x_dist\") \"x\" \"x_list\")")
  (action_tile "x_clear"
    "(clear_list \"x\" \"x_list\")")

  ;; Y
  (action_tile "y_add"
    "(add_item (get_tile \"y_name\") (get_tile \"y_dist\") \"y\" \"y_list\")")
  (action_tile "y_clear"
    "(clear_list \"y\" \"y_list\")")

  ;; Z
  (action_tile "z_add"
    "(add_item (get_tile \"z_name\") (get_tile \"z_dist\") \"z\" \"z_list\")")
  (action_tile "z_clear"
    "(clear_list \"z\" \"z_list\")")

  ;; OK / Cancel
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (setq result (start_dialog))
  (unload_dialog dcl_id)

  ;; ---------------------------
  ;; debug
  ;; ---------------------------
  (if (= result 1)
    (progn
      (prompt "\n--- X ---")
      (foreach i x_data (prompt (strcat "\n" i)))

      (prompt "\n--- Y ---")
      (foreach i y_data (prompt (strcat "\n" i)))

      (prompt "\n--- Z ---")
      (foreach i z_data (prompt (strcat "\n" i)))
    )
  )

  (princ)
)
