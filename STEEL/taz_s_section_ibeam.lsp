(defun taz_s_section_ibeam_draw (h b tw tf r / p x1 x2 y1 y2 xw1 xw2 yf1 yf2)

  ;; pobranie punktu bazowego (środek przekroju)
  (setq p (getpoint "\nWskaż punkt środka przekroju: "))
  
  ;; przybliżenie
  (command "_ZOOM" "_SCALE" "10000X")

  ;; obliczenia podstawowych granic
  (setq x1 (- (car p) (/ b 2.0)))
  (setq x2 (+ (car p) (/ b 2.0)))
  (setq y1 (- (cadr p) (/ h 2.0)))
  (setq y2 (+ (cadr p) (/ h 2.0)))

  ;; granice środnika
  (setq xw1 (- (car p) (/ tw 2.0)))
  (setq xw2 (+ (car p) (/ tw 2.0)))

  ;; granice półek
  (setq yf1 (+ y1 tf))
  (setq yf2 (- y2 tf))

  ;; rysowanie obrysu polilinią (bez zaokrągleń r)
  (command "_.PLINE"
           (list x1 y1)
           (list x2 y1)
           (list x2 yf1)
           (list xw2 yf1)
           (list xw2 yf2)
           (list x2 yf2)
           (list x2 y2)
           (list x1 y2)
           (list x1 yf2)
           (list xw1 yf2)
           (list xw1 yf1)
           (list x1 yf1)
           "C"
  )
  
  ;; oddalenie
  (command "_ZOOM" "_SCALE" "0.0001X")
  
  (princ)
)


(defun c:taz_s_section_ibeam ( / h b tw tf r )

  ;; HEA200 – wartości na sztywno
  (setq h 190.0)
  (setq b 200.0)
  (setq tw 6.5)
  (setq tf 10.0)
  (setq r 15.0)

  ;; wywołanie funkcji rysującej
  (taz_s_section_ibeam_draw h b tw tf r)

  (princ)
)
