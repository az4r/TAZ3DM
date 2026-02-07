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

  ;; wybór rodziny
  (setq family (getkword "\nRodzina profilu [HEA]: "))
  (if (null family) (setq family "HEA"))

  ;; wybór typu
  (setq type (getkword "\nTyp profilu [200]: "))
  (if (null type) (setq type "200"))

  ;; na razie HEA200 – później dodamy mapowanie
  (setq h 190.0)
  (setq b 200.0)
  (setq tw 6.5)
  (setq tf 10.0)
  (setq r 15.0)

  (taz_s_section_ibeam_draw h b tw tf r)
  (princ)
)
