(defun taz_s_section_ibeam_draw (h b tw tf r / p
      x1 x2 y1 y2 xw1 xw2 yf1 yf2
      lprev lcurr)

  (setq p (getpoint "\nWskaż punkt środka przekroju: "))

  (command "_ZOOM" "_SCALE" "10000X")

  (setq x1 (- (car p) (/ b 2.0)))
  (setq x2 (+ (car p) (/ b 2.0)))
  (setq y1 (- (cadr p) (/ h 2.0)))
  (setq y2 (+ (cadr p) (/ h 2.0)))

  (setq xw1 (- (car p) (/ tw 2.0)))
  (setq xw2 (+ (car p) (/ tw 2.0)))

  (setq yf1 (+ y1 tf))
  (setq yf2 (- y2 tf))

  (command "_LINE" (list x1 y1) (list x2 y1) "")
  (setq lprev (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 y1) (list x2 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list x2 yf1) (list xw2 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list xw2 yf1) (list xw2 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  (setq lprev lcurr)

  (command "_LINE" (list xw2 yf2) (list x2 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  (setq lprev lcurr)

  (command "_LINE" (list x2 yf2) (list x2 y2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list x2 y2) (list x1 y2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list x1 y2) (list x1 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list x1 yf2) (list xw1 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  (setq lprev lcurr)

  (command "_LINE" (list xw1 yf2) (list xw1 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  (setq lprev lcurr)

  (command "_LINE" (list xw1 yf1) (list x1 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  (setq lprev lcurr)

  (command "_LINE" (list x1 yf1) (list x1 y1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (command "_PEDIT" "M" "ALL" "" "_Y" "_J" "" "")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)

(defun c:taz_s_section_ibeam ( / h b tw tf r family type )

  ;; wybór rodziny (na razie tylko HEA)
  (initget "HEA")
  (setq family (getkword "\nRodzina profilu [HEA]: "))
  (if (null family) (setq family "HEA"))

  ;; wybór typu HEA
  (if (= family "HEA")
    (progn
      (initget "100 120 140 160 180 200 220 240 260 280 300 320 340 360 400 450 500 550 600 650 700 800 900 1000")
      (setq type (getkword "\nTyp profilu [100/120/140/160/180/200/220/240/260/280/300/320/340/360/400/450/500/550/600/650/700/800/900/1000]: "))
      (if (null type) (setq type "200"))
	)
  )

  ;; HEA100
  (if (and (= family "HEA") (= type "100"))
    (progn
      (setq h 96.0)
      (setq b 100.0)
      (setq tw 5.0)
      (setq tf 8.0)
      (setq r 12.0)
    )
  )

  ;; HEA120
  (if (and (= family "HEA") (= type "120"))
    (progn
      (setq h 114.0)
      (setq b 120.0)
      (setq tw 5.0)
      (setq tf 8.0)
      (setq r 12.0)
    )
  )

  ;; HEA140
  (if (and (= family "HEA") (= type "140"))
    (progn
      (setq h 133.0)
      (setq b 140.0)
      (setq tw 5.5)
      (setq tf 8.5)
      (setq r 12.0)
    )
  )

  ;; HEA160
  (if (and (= family "HEA") (= type "160"))
    (progn
      (setq h 152.0)
      (setq b 160.0)
      (setq tw 6.0)
      (setq tf 9.0)
      (setq r 15.0)
    )
  )

  ;; HEA180
  (if (and (= family "HEA") (= type "180"))
    (progn
      (setq h 171.0)
      (setq b 180.0)
      (setq tw 6.0)
      (setq tf 9.5)
      (setq r 15.0)
    )
  )

  ;; HEA200
  (if (and (= family "HEA") (= type "200"))
    (progn
      (setq h 190.0)
      (setq b 200.0)
      (setq tw 6.5)
      (setq tf 10.0)
      (setq r 18.0)
    )
  )

  ;; HEA220
  (if (and (= family "HEA") (= type "220"))
    (progn
      (setq h 210.0)
      (setq b 220.0)
      (setq tw 7.0)
      (setq tf 11.0)
      (setq r 18.0)
    )
  )

  ;; HEA240
  (if (and (= family "HEA") (= type "240"))
    (progn
      (setq h 230.0)
      (setq b 240.0)
      (setq tw 7.5)
      (setq tf 12.0)
      (setq r 21.0)
    )
  )

  ;; HEA260
  (if (and (= family "HEA") (= type "260"))
    (progn
      (setq h 250.0)
      (setq b 260.0)
      (setq tw 7.5)
      (setq tf 12.5)
      (setq r 24.0)
    )
  )

  ;; HEA280
  (if (and (= family "HEA") (= type "280"))
    (progn
      (setq h 270.0)
      (setq b 280.0)
      (setq tw 8.0)
      (setq tf 13.0)
      (setq r 24.0)
    )
  )

  ;; HEA300
  (if (and (= family "HEA") (= type "300"))
    (progn
      (setq h 290.0)
      (setq b 300.0)
      (setq tw 8.5)
      (setq tf 14.0)
      (setq r 27.0)
    )
  )

  ;; HEA320
  (if (and (= family "HEA") (= type "320"))
    (progn
      (setq h 310.0)
      (setq b 300.0)
      (setq tw 9.0)
      (setq tf 15.5)
      (setq r 27.0)
    )
  )

  ;; HEA340
  (if (and (= family "HEA") (= type "340"))
    (progn
      (setq h 330.0)
      (setq b 300.0)
      (setq tw 9.5)
      (setq tf 16.5)
      (setq r 27.0)
    )
  )

  ;; HEA360
  (if (and (= family "HEA") (= type "360"))
    (progn
      (setq h 350.0)
      (setq b 300.0)
      (setq tw 10.0)
      (setq tf 17.5)
      (setq r 27.0)
    )
  )

  ;; HEA400
  (if (and (= family "HEA") (= type "400"))
    (progn
      (setq h 390.0)
      (setq b 300.0)
      (setq tw 11.0)
      (setq tf 19.0)
      (setq r 27.0)
    )
  )

  ;; HEA450
  (if (and (= family "HEA") (= type "450"))
    (progn
      (setq h 440.0)
      (setq b 300.0)
      (setq tw 11.5)
      (setq tf 21.0)
      (setq r 27.0)
    )
  )

  ;; HEA500
  (if (and (= family "HEA") (= type "500"))
    (progn
      (setq h 490.0)
      (setq b 300.0)
      (setq tw 12.0)
      (setq tf 23.0)
      (setq r 27.0)
    )
  )

  ;; HEA550
  (if (and (= family "HEA") (= type "550"))
    (progn
      (setq h 540.0)
      (setq b 300.0)
      (setq tw 12.5)
      (setq tf 24.0)
      (setq r 27.0)
    )
  )

  ;; HEA600
  (if (and (= family "HEA") (= type "600"))
    (progn
      (setq h 590.0)
      (setq b 300.0)
      (setq tw 13.0)
      (setq tf 25.0)
      (setq r 27.0)
    )
  )

  ;; HEA650
  (if (and (= family "HEA") (= type "650"))
    (progn
      (setq h 640.0)
      (setq b 300.0)
      (setq tw 13.5)
      (setq tf 26.0)
      (setq r 27.0)
    )
  )

  ;; HEA700
  (if (and (= family "HEA") (= type "700"))
    (progn
      (setq h 690.0)
      (setq b 300.0)
      (setq tw 14.5)
      (setq tf 27.0)
      (setq r 27.0)
    )
  )

  ;; HEA800
  (if (and (= family "HEA") (= type "800"))
    (progn
      (setq h 790.0)
      (setq b 300.0)
      (setq tw 15.0)
      (setq tf 28.0)
      (setq r 30.0)
    )
  )

  ;; HEA900
  (if (and (= family "HEA") (= type "900"))
    (progn
      (setq h 890.0)
      (setq b 300.0)
      (setq tw 16.0)
      (setq tf 30.0)
      (setq r 30.0)
    )
  )

  ;; HEA1000
  (if (and (= family "HEA") (= type "1000"))
    (progn
      (setq h 990.0)
      (setq b 300.0)
      (setq tw 16.5)
      (setq tf 31.0)
      (setq r 30.0)
    )
  )

  (taz_s_section_ibeam_draw h b tw tf r)
  (princ)
)
