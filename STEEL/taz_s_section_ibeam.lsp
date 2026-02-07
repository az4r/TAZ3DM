(defun taz_s_section_ibeam_draw (h b tw tf r / p
      x1 x2 y1 y2 xw1 xw2 yf1 yf2
      lprev lcurr)

  (setq p (getpoint "\nWskaż punkt środka przekroju: "))

  (command "_ZOOM" "_SCALE" "10000X")

  ;; obliczenia
  (setq x1 (- (car p) (/ b 2.0)))
  (setq x2 (+ (car p) (/ b 2.0)))
  (setq y1 (- (cadr p) (/ h 2.0)))
  (setq y2 (+ (cadr p) (/ h 2.0)))

  (setq xw1 (- (car p) (/ tw 2.0)))
  (setq xw2 (+ (car p) (/ tw 2.0)))

  (setq yf1 (+ y1 tf))
  (setq yf2 (- y2 tf))

  ;; 1: dół – lewo → prawo
  (command "_LINE" (list x1 y1) (list x2 y1) "")
  (setq lprev (cdr (assoc -1 (entget (entlast)))))

  ;; 2: dół – pion do półki
  (command "_LINE" (list x2 y1) (list x2 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
 
  (setq lprev lcurr)
  
  ;; 3: półka dolna – poziom do środnika
  (command "_LINE" (list x2 yf1) (list xw2 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  (setq lprev lcurr)
  
  ;; 4: pion środnika
  (command "_LINE" (list xw2 yf1) (list xw2 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  ;; FILLET
  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  
  (setq lprev lcurr)
  
  ;; 5: półka górna – poziom do prawej
  (command "_LINE" (list xw2 yf2) (list x2 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  ;; FILLET
  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  
  (setq lprev lcurr)
  
  ;; 6: pion do góry
  (command "_LINE" (list x2 yf2) (list x2 y2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  (setq lprev lcurr)

  ;; 7: góra – prawo → lewo
  (command "_LINE" (list x2 y2) (list x1 y2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  (setq lprev lcurr)

  ;; 8: pion do półki górnej
  (command "_LINE" (list x1 y2) (list x1 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (setq lprev lcurr)

  ;; 9: półka górna – poziom do środnika
  (command "_LINE" (list x1 yf2) (list xw1 yf2) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))

  (setq lprev lcurr)
  
  ;; 10: pion środnika
  (command "_LINE" (list xw1 yf2) (list xw1 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  ;; FILLET
  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  
  (setq lprev lcurr)
  
  ;; 11: półka dolna – poziom do lewej
  (command "_LINE" (list xw1 yf1) (list x1 yf1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  ;; FILLET
  (command "_FILLET" "_R" r)
  (command "_FILLET" lprev lcurr)
  
  (setq lprev lcurr)
  
  ;; 12: pion do dołu
  (command "_LINE" (list x1 yf1) (list x1 y1) "")
  (setq lcurr (cdr (assoc -1 (entget (entlast)))))
  
  ;; łączenie w polilinię
  (command "_PEDIT" "M" "ALL" "" "_Y" "_J" "" "")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)


(defun c:taz_s_section_ibeam ( / h b tw tf r )
  (setq h 190.0)
  (setq b 200.0)
  (setq tw 6.5)
  (setq tf 10.0)
  (setq r 15.0)
  (taz_s_section_ibeam_draw h b tw tf r)
  (princ)
)
