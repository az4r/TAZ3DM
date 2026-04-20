(defun c:axes_dialog_test ( / dcl_id result )

  ;; listy danych
  (setq x_data '())
  (setq y_data '())
  (setq z_data '())

  ;; ---------------------------
  ;; Funkcja odświeżania listy
  ;; ---------------------------
  (defun update_list (key data)
    (start_list key)
    (foreach item data
      (add_list item)
    )
    (end_list)
  )

  ;; ---------------------------
  ;; Funkcja dodawania wpisu
  ;; ---------------------------
  (defun add_item (name1 dist name2 data_key list_key)
    (if (and (/= name1 "") (/= dist "") (/= name2 ""))
      (progn
        (setq new_item (strcat name1 " | " dist " | " name2))

        (cond
          ((= data_key "x") (setq x_data (append x_data (list new_item))) (update_list list_key x_data))
          ((= data_key "y") (setq y_data (append y_data (list new_item))) (update_list list_key y_data))
          ((= data_key "z") (setq z_data (append z_data (list new_item))) (update_list list_key z_data))
        )
      )
      (alert "Uzupełnij wszystkie pola!")
    )
  )

  ;; ---------------------------
  ;; Czyszczenie listy
  ;; ---------------------------
  (defun clear_list (data_key list_key)
    (cond
      ((= data_key "x") (setq x_data '()) (update_list list_key x_data))
      ((= data_key "y") (setq y_data '()) (update_list list_key y_data))
      ((= data_key "z") (setq z_data '()) (update_list list_key z_data))
    )
  )

  ;; ---------------------------
  ;; Ładowanie DCL
  ;; ---------------------------
  (setq dcl_id (load_dialog "axes.dcl"))

  (if (<= dcl_id 0)
    (progn (alert "Błąd DCL!") (exit))
  )

  (if (not (new_dialog "axes_dialog" dcl_id))
    (progn (alert "Nie można otworzyć!") (exit))
  )

  ;; ---------------------------
  ;; X
  ;; ---------------------------
  (action_tile "x_add"
    "(add_item (get_tile \"x_name1\") (get_tile \"x_dist\") (get_tile \"x_name2\") \"x\" \"x_list\")"
  )

  (action_tile "x_clear"
    "(clear_list \"x\" \"x_list\")"
  )

  ;; ---------------------------
  ;; Y
  ;; ---------------------------
  (action_tile "y_add"
    "(add_item (get_tile \"y_name1\") (get_tile \"y_dist\") (get_tile \"y_name2\") \"y\" \"y_list\")"
  )

  (action_tile "y_clear"
    "(clear_list \"y\" \"y_list\")"
  )

  ;; ---------------------------
  ;; Z
  ;; ---------------------------
  (action_tile "z_add"
    "(add_item (get_tile \"z_name1\") (get_tile \"z_dist\") (get_tile \"z_name2\") \"z\" \"z_list\")"
  )

  (action_tile "z_clear"
    "(clear_list \"z\" \"z_list\")"
  )

  ;; ---------------------------
  ;; OK / Cancel
  ;; ---------------------------
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  ;; ---------------------------
  ;; Start
  ;; ---------------------------
  (setq result (start_dialog))
  (unload_dialog dcl_id)

  ;; ---------------------------
  ;; Po OK
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
