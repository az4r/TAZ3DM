(defun c:taz_s_move_copy ()

  ;; ---------------------------------------------------------
  ;; ZMIENNE GLOBALNE
  ;; ---------------------------------------------------------

  (setq taz_s_move_copy_selection nil)
  (setq taz_s_move_copy_ok T)
  (setq taz_s_move_copy_i 0)
  (setq taz_s_move_copy_ent nil)
  (setq taz_s_move_copy_type nil)

  (setq taz_s_move_copy_mode "1")
  (setq taz_s_move_copy_x "0")
  (setq taz_s_move_copy_y "0")
  (setq taz_s_move_copy_z "0")

  (setq taz_s_move_copy_dialog_result 0)

  ;; ---------------------------------------------------------
  ;; WYBÓR OBIEKTÓW
  ;; ---------------------------------------------------------

  (setq taz_s_move_copy_selection (ssget))

  (if (null taz_s_move_copy_selection)
    (progn
      (alert "Nie wybrano żadnych obiektów.")
      (setq taz_s_move_copy_ok nil)
    )
    (princ)
  )

  ;; ---------------------------------------------------------
  ;; SPRAWDZENIE CZY WSZYSTKIE OBIEKTY TO 3DSOLID
  ;; ---------------------------------------------------------

  (if taz_s_move_copy_ok
    (progn
      (setq taz_s_move_copy_i 0)
      (while (< taz_s_move_copy_i (sslength taz_s_move_copy_selection))

        (setq taz_s_move_copy_ent (ssname taz_s_move_copy_selection taz_s_move_copy_i))
        (setq taz_s_move_copy_type (cdr (assoc 0 (entget taz_s_move_copy_ent))))

        (if (/= taz_s_move_copy_type "3DSOLID")
          (setq taz_s_move_copy_ok nil)
          (princ)
        )

        (setq taz_s_move_copy_i (+ taz_s_move_copy_i 1))
      )
    )
    (princ)
  )

  (if (not taz_s_move_copy_ok)
    (progn
      (if taz_s_move_copy_selection
        (alert "Wszystkie zaznaczone obiekty muszą być bryłami 3D (3DSOLID).")
        (princ)
      )
    )
    (princ)
  )

  ;; ---------------------------------------------------------
  ;; OKNO DIALOGOWE
  ;; ---------------------------------------------------------

  (if taz_s_move_copy_ok
    (progn

      (setq taz_s_move_copy_dcl_id (load_dialog "taz_s_move_copy.dcl"))
      (new_dialog "taz_s_move_copy_dialog" taz_s_move_copy_dcl_id)

      (set_tile "taz_s_mode_move" "1")
      (set_tile "taz_s_mode_copy" "0")

      (set_tile "taz_s_x" taz_s_move_copy_x)
      (set_tile "taz_s_y" taz_s_move_copy_y)
      (set_tile "taz_s_z" taz_s_move_copy_z)

      (action_tile "taz_s_mode_move" "(setq taz_s_move_copy_mode \"1\")")
      (action_tile "taz_s_mode_copy" "(setq taz_s_move_copy_mode \"0\")")

      (action_tile "accept" "(taz_s_move_copy_read_values)(done_dialog 1)")
      (action_tile "cancel" "(done_dialog 0)")

      (setq taz_s_move_copy_dialog_result (start_dialog))

      (unload_dialog taz_s_move_copy_dcl_id)

    )
    (princ)
  )

  ;; ---------------------------------------------------------
  ;; WYKONANIE MOVE / COPY
  ;; ---------------------------------------------------------

  (if (and taz_s_move_copy_ok (= taz_s_move_copy_dialog_result 1))
    (progn

      (setq taz_s_move_copy_xval (atof taz_s_move_copy_x))
      (setq taz_s_move_copy_yval (atof taz_s_move_copy_y))
      (setq taz_s_move_copy_zval (atof taz_s_move_copy_z))

      (setq taz_s_move_copy_p1 (list 0 0 0))
      (setq taz_s_move_copy_p2 (list taz_s_move_copy_xval taz_s_move_copy_yval taz_s_move_copy_zval))

      (if (= taz_s_move_copy_mode "1")
        (command "_MOVE" taz_s_move_copy_selection "" taz_s_move_copy_p1 taz_s_move_copy_p2)
        (command "_COPY" taz_s_move_copy_selection "" taz_s_move_copy_p1 taz_s_move_copy_p2)
      )

    )
    (princ)
  )

  (princ)

)

;; ---------------------------------------------------------
;; ODCZYT WARTOŚCI Z OKNA DIALOGOWEGO
;; ---------------------------------------------------------

(defun taz_s_move_copy_read_values ()

  (setq taz_s_move_copy_x (get_tile "taz_s_x"))
  (setq taz_s_move_copy_y (get_tile "taz_s_y"))
  (setq taz_s_move_copy_z (get_tile "taz_s_z"))

  (if (= taz_s_move_copy_x "") (setq taz_s_move_copy_x "0") (princ))
  (if (= taz_s_move_copy_y "") (setq taz_s_move_copy_y "0") (princ))
  (if (= taz_s_move_copy_z "") (setq taz_s_move_copy_z "0") (princ))

  (princ)

)
