(defun taz_s_section_ibeam_draw (h b tw tf r / p x1 x2 y1 y2 xw1 xw2 yf1 yf2)
  
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

  (setq p '(0 0 0))

  (command "_ZOOM" "_SCALE" "10000X")

  (setq x1 (- (car p) (/ b 2.0)))
  (setq x2 (+ (car p) (/ b 2.0)))
  (setq y1 (- (cadr p) (/ h 2.0)))
  (setq y2 (+ (cadr p) (/ h 2.0)))

  (setq xw1 (- (car p) (/ tw 2.0)))
  (setq xw2 (+ (car p) (/ tw 2.0)))

  (setq yf1 (+ y1 tf))
  (setq yf2 (- y2 tf))
  
  (command "_FILLET" "_R" r)

  (command "_LINE" (list x1 y1) (list x2 y1) "")
  (setq l1 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 y1) (list x2 yf1) "")
  (setq l2 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 yf1) (list xw2 yf1) "")
  (setq l3 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw2 yf1) (list xw2 yf2) "")
  (setq l4 (cdr (assoc -1 (entget (entlast))))) 

  (command "_LINE" (list xw2 yf2) (list x2 yf2) "")
  (setq l5 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 yf2) (list x2 y2) "")
  (setq l6 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 y2) (list x1 y2) "")
  (setq l7 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 y2) (list x1 yf2) "")
  (setq l8 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 yf2) (list xw1 yf2) "")
  (setq l9 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw1 yf2) (list xw1 yf1) "")
  (setq l10 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw1 yf1) (list x1 yf1) "")
  (setq l11 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 yf1) (list x1 y1) "")
  (setq l12 (cdr (assoc -1 (entget (entlast)))))
  
  ;; zapisz widok 
  
  (if (tblsearch "VIEW" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
    (command "-VIEW" "_S" "taz_s_temp_view")
  )

  (command "_PLAN" "_C")
  
  (command "_FILLET" l3 l4)
  
  (setq f1 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  
  (command "_FILLET" l4 l5)
  
  (setq f2 (cdr (assoc -1 (entget (entlast)))))
    
  (command "_PLAN" "_C")
  
  (command "_FILLET" l9 l10)
  
  (setq f3 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  
  (command "_FILLET" l10 l11)
  
  (setq f4 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_CHPROP" l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 f1 f2 f3 f4 "" "C" "6" "")
  
  (command "_PEDIT" "M")
  
  (command l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 f1 f2 f3 f4 "")
  
  (command "_Y")
  
  (command "_J" "" "")
  
  (setq taz_s_create_ibeam_profile (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))
  
  (command "_ZOOM" "_SCALE" "0.0001X")
  (command "_ZOOM" "_SCALE" "10000X")
  
  (command "_SWEEP" taz_s_create_ibeam_profile "" taz_s_create_ibeam_path "")
  
  ;; przywróć widok
  (command "-VIEW" "_R" "taz_s_temp_view")
  
  ;; usuń widok tymczasowy
  (command "-VIEW" "_D" "taz_s_temp_view")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)