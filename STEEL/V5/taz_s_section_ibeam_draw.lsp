(defun taz_s_section_ibeam_draw ()
  
  (if (= taz_s_family "HEA")
    (taz_s_section_ibeam_draw_parametres_hea)
    (princ)
  )
  (if (= taz_s_family "HEB")
    (taz_s_section_ibeam_draw_parametres_heb)
    (princ)
  )
  (if (= taz_s_family "IPE")
    (taz_s_section_ibeam_draw_parametres_ipe)
    (princ)
  )
  (if (= taz_s_family "IPN")
    (taz_s_section_ibeam_draw_parametres_ipn)
    (princ)
  )

  (setq taz_s_p '(0 0 0))

  (command "_ZOOM" "_SCALE" "10000X")

  (setq taz_s_x1 (- (car taz_s_p) (/ taz_s_b 2.0)))
  (setq taz_s_x2 (+ (car taz_s_p) (/ taz_s_b 2.0)))
  (setq taz_s_y1 (- (cadr taz_s_p) (/ taz_s_h 2.0)))
  (setq taz_s_y2 (+ (cadr taz_s_p) (/ taz_s_h 2.0)))

  (setq taz_s_xw1 (- (car taz_s_p) (/ taz_s_tw 2.0)))
  (setq taz_s_xw2 (+ (car taz_s_p) (/ taz_s_tw 2.0)))

  (setq taz_s_yf1 (+ taz_s_y1 taz_s_tf))
  (setq taz_s_yf2 (- taz_s_y2 taz_s_tf))
  
  (command "_FILLET" "R" taz_s_r)
  (command)
  (command)

  (command "_LINE" (list taz_s_x1 taz_s_y1) (list taz_s_x2 taz_s_y1) "")
  (setq taz_s_l1 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x2 taz_s_y1) (list taz_s_x2 taz_s_yf1) "")
  (setq taz_s_l2 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x2 taz_s_yf1) (list taz_s_xw2 taz_s_yf1) "")
  (setq taz_s_l3 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_xw2 taz_s_yf1) (list taz_s_xw2 taz_s_yf2) "")
  (setq taz_s_l4 (cdr (assoc -1 (entget (entlast))))) 

  (command "_LINE" (list taz_s_xw2 taz_s_yf2) (list taz_s_x2 taz_s_yf2) "")
  (setq taz_s_l5 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x2 taz_s_yf2) (list taz_s_x2 taz_s_y2) "")
  (setq taz_s_l6 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x2 taz_s_y2) (list taz_s_x1 taz_s_y2) "")
  (setq taz_s_l7 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x1 taz_s_y2) (list taz_s_x1 taz_s_yf2) "")
  (setq taz_s_l8 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x1 taz_s_yf2) (list taz_s_xw1 taz_s_yf2) "")
  (setq taz_s_l9 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_xw1 taz_s_yf2) (list taz_s_xw1 taz_s_yf1) "")
  (setq taz_s_l10 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_xw1 taz_s_yf1) (list taz_s_x1 taz_s_yf1) "")
  (setq taz_s_l11 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list taz_s_x1 taz_s_yf1) (list taz_s_x1 taz_s_y1) "")
  (setq taz_s_l12 (cdr (assoc -1 (entget (entlast)))))
  
  ;; zapisz widok
  (if (tblsearch "VIEW" "taz_s_temp_view")
    (progn
    (command "-VIEW" "_D" "taz_s_temp_view")
    (command "-VIEW" "_S" "taz_s_temp_view")
    )
    (command "-VIEW" "_S" "taz_s_temp_view")
  )

  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_l3 taz_s_l4 "")
  (command "_FILLET" taz_s_l3 taz_s_l4)
  
  (setq taz_s_f1 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_l4 taz_s_l5 "")
  (command "_FILLET" taz_s_l4 taz_s_l5)
  
  (setq taz_s_f2 (cdr (assoc -1 (entget (entlast)))))
    
  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_l9 taz_s_l10 "")
  (command "_FILLET" taz_s_l9 taz_s_l10)
  
  (setq taz_s_f3 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_10 taz_s_11 "")
  (command "_FILLET" taz_s_l10 taz_s_l11)
  
  (setq taz_s_f4 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_CHPROP" taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_l9 taz_s_l10 taz_s_l11 taz_s_l12 taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4 "" "C" "6" "")
  
  (command "_PEDIT" "M")
  
  (command taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_l9 taz_s_l10 taz_s_l11 taz_s_l12 taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4 "")
  
  (command "_Y")
  
  (command "_J" "" "")
  
  (setq taz_s_create_beam_profile (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))
  
  (command "_ZOOM" "_SCALE" "0.0001X")
  (command "_ZOOM" "_SCALE" "10000X")
  
  (command "_SWEEP" taz_s_create_beam_profile "" taz_s_create_beam_path "")
  
  ;; przywrócenie widoku
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)