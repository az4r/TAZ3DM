(defun c:axes_dialog_test ( / dcl_id result )

  (setq dcl_id (load_dialog "axes.dcl"))
  (if (not (new_dialog "axes_dialog" dcl_id))
    (progn (alert "Błąd ładowania DCL!") (exit))
  )

  ;; ---------------------------
  ;; Funkcja przełączania paneli
  ;; ---------------------------
  (defun show-panel (panel)
    (mode_tile "panelX" 1)
    (mode_tile "panelY" 1)
    (mode_tile "panelZ" 1)
    (mode_tile panel 0)
  )

  ;; Domyślnie zakładka X
  (set_tile "tabX" "1")
  (show-panel "panelX")

  ;; Obsługa kliknięć zakładek
  (action_tile "tabX" "(show-panel \"panelX\")")
  (action_tile "tabY" "(show-panel \"panelY\")")
  (action_tile "tabZ" "(show-panel \"panelZ\")")

  ;; Obsługa przycisków
  (action_tile "ok_btn" "(done_dialog 1)")
  (action_tile "cancel_btn" "(done_dialog 0)")

  ;; Start dialogu
  (setq result (start_dialog))
  (unload_dialog dcl_id)

  (cond
    ((= result 1)
      (princ "Wybrano OK")
    )
    (T
      (princ "Anulowano")
    )
  )

  (princ)
)
