(defun taz_s_section_ibeam_draw (h b tw tf r / p x1 x2 y1 y2 xw1 xw2 yf1 yf2)

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
  (command "-VIEW" "_S" "taz_s_temp_view")

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

(defun taz_s_section_ibeam ( / h b tw tf r )

  ;; wybór rodziny – domyślnie HEA, ale jeśli taz_s_section_ibeam_family istnieje, użyj jej
  (if (not taz_s_section_ibeam_family)
    (setq taz_s_section_ibeam_family "HEA")
  )
  (setq taz_s_section_ibeam_family_null taz_s_section_ibeam_family)
  (setq taz_s_section_ibeam_family
    (getstring
      (strcat "\nRodzina profilu (HEA/HEB) <" taz_s_section_ibeam_family ">: ")
    )
  )

  (if (or (null taz_s_section_ibeam_family) (= taz_s_section_ibeam_family ""))
    (setq taz_s_section_ibeam_family taz_s_section_ibeam_family_null)
  )


  ;; wybór typu HEA – domyślnie 200, ale jeśli typ istnieje, użyj poprzedniej wartości
  (if (= taz_s_section_ibeam_family "HEA")
    (progn

      ;; jeśli typ nie istnieje, ustaw domyślne 200
      (if (not taz_s_section_ibeam_type)
        (setq taz_s_section_ibeam_type "200")
      )
    
      (setq taz_s_section_ibeam_type_null taz_s_section_ibeam_type)
      (setq taz_s_section_ibeam_type
        (getstring
          (strcat "\nTyp profilu (100/120/140/160/180/200/220/240/260/280/300/320/340/360/400/450/500/550/600/650/700/800/900/1000) <" taz_s_section_ibeam_type ">: ")
        )
      )

      ;; Enter = użyj poprzedniej wartości
      (if (or (null taz_s_section_ibeam_type) (= taz_s_section_ibeam_type ""))
        (setq taz_s_section_ibeam_type taz_s_section_ibeam_type_null)
      )
    )
  )
      

  ;; wybór typu HEB – domyślnie 200, ale jeśli typ istnieje, użyj poprzedniej wartości
  (if (= taz_s_section_ibeam_family "HEB")
    (progn

      ;; jeśli typ nie istnieje, ustaw domyślne 200
      (if (not taz_s_section_ibeam_type)
        (setq taz_s_section_ibeam_type "200")
      )
    
      (setq taz_s_section_ibeam_type_null taz_s_section_ibeam_type)
      (setq taz_s_section_ibeam_type
        (getstring
          (strcat "\nTyp profilu (100/120/140/160/180/200/220/240/260/280/300/320/340/360/400/450/500/550/600/650/700/800/900/1000) <" taz_s_section_ibeam_type ">: ")
        )
      )

      ;; Enter = użyj poprzedniej wartości
      (if (or (null taz_s_section_ibeam_type) (= taz_s_section_ibeam_type ""))
        (setq taz_s_section_ibeam_type taz_s_section_ibeam_type_null)
      )
    )
  )


  ;; HEA100
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "100"))
    (progn
      (setq h 96.0)
      (setq b 100.0)
      (setq tw 5.0)
      (setq tf 8.0)
      (setq r 12.0)
    )
  )

  ;; HEA120
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "120"))
    (progn
      (setq h 114.0)
      (setq b 120.0)
      (setq tw 5.0)
      (setq tf 8.0)
      (setq r 12.0)
    )
  )

  ;; HEA140
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "140"))
    (progn
      (setq h 133.0)
      (setq b 140.0)
      (setq tw 5.5)
      (setq tf 8.5)
      (setq r 12.0)
    )
  )

  ;; HEA160
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "160"))
    (progn
      (setq h 152.0)
      (setq b 160.0)
      (setq tw 6.0)
      (setq tf 9.0)
      (setq r 15.0)
    )
  )

  ;; HEA180
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "180"))
    (progn
      (setq h 171.0)
      (setq b 180.0)
      (setq tw 6.0)
      (setq tf 9.5)
      (setq r 15.0)
    )
  )

  ;; HEA200
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "200"))
    (progn
      (setq h 190.0)
      (setq b 200.0)
      (setq tw 6.5)
      (setq tf 10.0)
      (setq r 18.0)
    )
  )

  ;; HEA220
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "220"))
    (progn
      (setq h 210.0)
      (setq b 220.0)
      (setq tw 7.0)
      (setq tf 11.0)
      (setq r 18.0)
    )
  )

  ;; HEA240
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "240"))
    (progn
      (setq h 230.0)
      (setq b 240.0)
      (setq tw 7.5)
      (setq tf 12.0)
      (setq r 21.0)
    )
  )

  ;; HEA260
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "260"))
    (progn
      (setq h 250.0)
      (setq b 260.0)
      (setq tw 7.5)
      (setq tf 12.5)
      (setq r 24.0)
    )
  )

  ;; HEA280
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "280"))
    (progn
      (setq h 270.0)
      (setq b 280.0)
      (setq tw 8.0)
      (setq tf 13.0)
      (setq r 24.0)
    )
  )

  ;; HEA300
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "300"))
    (progn
      (setq h 290.0)
      (setq b 300.0)
      (setq tw 8.5)
      (setq tf 14.0)
      (setq r 27.0)
    )
  )

  ;; HEA320
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "320"))
    (progn
      (setq h 310.0)
      (setq b 300.0)
      (setq tw 9.0)
      (setq tf 15.5)
      (setq r 27.0)
    )
  )

  ;; HEA340
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "340"))
    (progn
      (setq h 330.0)
      (setq b 300.0)
      (setq tw 9.5)
      (setq tf 16.5)
      (setq r 27.0)
    )
  )

  ;; HEA360
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "360"))
    (progn
      (setq h 350.0)
      (setq b 300.0)
      (setq tw 10.0)
      (setq tf 17.5)
      (setq r 27.0)
    )
  )

  ;; HEA400
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "400"))
    (progn
      (setq h 390.0)
      (setq b 300.0)
      (setq tw 11.0)
      (setq tf 19.0)
      (setq r 27.0)
    )
  )

  ;; HEA450
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "450"))
    (progn
      (setq h 440.0)
      (setq b 300.0)
      (setq tw 11.5)
      (setq tf 21.0)
      (setq r 27.0)
    )
  )

  ;; HEA500
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "500"))
    (progn
      (setq h 490.0)
      (setq b 300.0)
      (setq tw 12.0)
      (setq tf 23.0)
      (setq r 27.0)
    )
  )

  ;; HEA550
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "550"))
    (progn
      (setq h 540.0)
      (setq b 300.0)
      (setq tw 12.5)
      (setq tf 24.0)
      (setq r 27.0)
    )
  )

  ;; HEA600
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "600"))
    (progn
      (setq h 590.0)
      (setq b 300.0)
      (setq tw 13.0)
      (setq tf 25.0)
      (setq r 27.0)
    )
  )

  ;; HEA650
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "650"))
    (progn
      (setq h 640.0)
      (setq b 300.0)
      (setq tw 13.5)
      (setq tf 26.0)
      (setq r 27.0)
    )
  )

  ;; HEA700
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "700"))
    (progn
      (setq h 690.0)
      (setq b 300.0)
      (setq tw 14.5)
      (setq tf 27.0)
      (setq r 27.0)
    )
  )

  ;; HEA800
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "800"))
    (progn
      (setq h 790.0)
      (setq b 300.0)
      (setq tw 15.0)
      (setq tf 28.0)
      (setq r 30.0)
    )
  )

  ;; HEA900
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "900"))
    (progn
      (setq h 890.0)
      (setq b 300.0)
      (setq tw 16.0)
      (setq tf 30.0)
      (setq r 30.0)
    )
  )

  ;; HEA1000
  (if (and (= taz_s_section_ibeam_family "HEA") (= taz_s_section_ibeam_type "1000"))
    (progn
      (setq h 990.0)
      (setq b 300.0)
      (setq tw 16.5)
      (setq tf 31.0)
      (setq r 30.0)
    )
  )
  
  ;; HEB100
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "100"))
    (progn
      (setq h 100.0)
      (setq b 100.0)
      (setq tw 6.0)
      (setq tf 10.0)
      (setq r 12.0)
    )
  )

  ;; HEB120
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "120"))
    (progn
      (setq h 120.0)
      (setq b 120.0)
      (setq tw 6.5)
      (setq tf 11.0)
      (setq r 12.0)
    )
  )

  ;; HEB140
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "140"))
    (progn
      (setq h 140.0)
      (setq b 140.0)
      (setq tw 7.0)
      (setq tf 12.0)
      (setq r 12.0)
    )
  )

  ;; HEB160
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "160"))
    (progn
      (setq h 160.0)
      (setq b 160.0)
      (setq tw 8.0)
      (setq tf 13.0)
      (setq r 15.0)
    )
  )

  ;; HEB180
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "180"))
    (progn
      (setq h 180.0)
      (setq b 180.0)
      (setq tw 8.5)
      (setq tf 14.0)
      (setq r 15.0)
    )
  )

  ;; HEB200
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "200"))
    (progn
      (setq h 200.0)
      (setq b 200.0)
      (setq tw 9.0)
      (setq tf 15.0)
      (setq r 18.0)
    )
  )

  ;; HEB220
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "220"))
    (progn
      (setq h 220.0)
      (setq b 220.0)
      (setq tw 9.5)
      (setq tf 16.0)
      (setq r 18.0)
    )
  )

  ;; HEB240
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "240"))
    (progn
      (setq h 240.0)
      (setq b 240.0)
      (setq tw 10.0)
      (setq tf 17.0)
      (setq r 21.0)
    )
  )

  ;; HEB260
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "260"))
    (progn
      (setq h 260.0)
      (setq b 260.0)
      (setq tw 10.0)
      (setq tf 17.5)
      (setq r 24.0)
    )
  )

  ;; HEB280
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "280"))
    (progn
      (setq h 280.0)
      (setq b 280.0)
      (setq tw 10.5)
      (setq tf 18.0)
      (setq r 24.0)
    )
  )

  ;; HEB300
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "300"))
    (progn
      (setq h 300.0)
      (setq b 300.0)
      (setq tw 11.0)
      (setq tf 19.0)
      (setq r 27.0)
    )
  )

  ;; HEB320
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "320"))
    (progn
      (setq h 320.0)
      (setq b 300.0)
      (setq tw 11.5)
      (setq tf 20.5)
      (setq r 27.0)
    )
  )

  ;; HEB340
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "340"))
    (progn
      (setq h 340.0)
      (setq b 300.0)
      (setq tw 12.0)
      (setq tf 21.5)
      (setq r 27.0)
    )
  )

  ;; HEB360
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "360"))
    (progn
      (setq h 360.0)
      (setq b 300.0)
      (setq tw 12.5)
      (setq tf 22.5)
      (setq r 27.0)
    )
  )

  ;; HEB400
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "400"))
    (progn
      (setq h 400.0)
      (setq b 300.0)
      (setq tw 13.5)
      (setq tf 24.0)
      (setq r 27.0)
    )
  )

  ;; HEB450
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "450"))
    (progn
      (setq h 450.0)
      (setq b 300.0)
      (setq tw 14.0)
      (setq tf 26.0)
      (setq r 27.0)
    )
  )

  ;; HEB500
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "500"))
    (progn
      (setq h 500.0)
      (setq b 300.0)
      (setq tw 14.5)
      (setq tf 28.0)
      (setq r 27.0)
    )
  )

  ;; HEB550
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "550"))
    (progn
      (setq h 550.0)
      (setq b 300.0)
      (setq tw 15.0)
      (setq tf 29.0)
      (setq r 27.0)
    )
  )

  ;; HEB600
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "600"))
    (progn
      (setq h 600.0)
      (setq b 300.0)
      (setq tw 15.5)
      (setq tf 30.0)
      (setq r 27.0)
    )
  )

  ;; HEB650
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "650"))
    (progn
      (setq h 650.0)
      (setq b 300.0)
      (setq tw 16.0)
      (setq tf 31.0)
      (setq r 27.0)
    )
  )

  ;; HEB700
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "700"))
    (progn
      (setq h 700.0)
      (setq b 300.0)
      (setq tw 17.0)
      (setq tf 32.0)
      (setq r 27.0)
    )
  )

  ;; HEB800
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "800"))
    (progn
      (setq h 800.0)
      (setq b 300.0)
      (setq tw 17.5)
      (setq tf 33.0)
      (setq r 30.0)
    )
  )

  ;; HEB900
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "900"))
    (progn
      (setq h 900.0)
      (setq b 300.0)
      (setq tw 18.5)
      (setq tf 35.0)
      (setq r 30.0)
    )
  )

  ;; HEB1000
  (if (and (= taz_s_section_ibeam_family "HEB") (= taz_s_section_ibeam_type "1000"))
    (progn
      (setq h 1000.0)
      (setq b 300.0)
      (setq tw 19.0)
      (setq tf 36.0)
      (setq r 30.0)
    )
  )

  (taz_s_section_ibeam_draw h b tw tf r)
  (princ)
)
