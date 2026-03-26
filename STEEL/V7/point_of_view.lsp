(defun c:pointt ()
;; 1. DANE WEJSCIOWE
(setq X_A1 0)
(setq Y_A1 0)
(setq X_A2 0)
(setq Y_A2 100)

(setq X_B1 0)
(setq Y_B1 100)
(setq X_B2 100)
(setq Y_B2 100)
  
(setq A_1 (list X_A1 Y_A1)) 
(setq A_2 (list X_A2 Y_A2)) 
(setq B_1 (list X_B1 Y_B1)) 
(setq B_2 (list X_B2 Y_B2)) 

;; PROMIEŃ
(setq R 2)

;; PUNKT PRZECIĘCIA PROSTYCH
(setq S_X X_A2)
(setq S_Y Y_A2)

;; ----------------------------------------------------
;; OFFSET PROSTEJ A
;; ----------------------------------------------------

;; kierunek
(setq AX (- X_A2 X_A1))
(setq AY (- Y_A2 Y_A1))

;; normalna
(setq ANX (- AY))
(setq ANY AX)

;; długość normalnej
(setq ALEN (sqrt (+ (* ANX ANX) (* ANY ANY))))

;; współczynnik
(setq AK (/ R ALEN))

;; offset +R
(setq A1_plus (list (+ X_A1 (* ANX AK)) (+ Y_A1 (* ANY AK))))
(setq A2_plus (list (+ X_A2 (* ANX AK)) (+ Y_A2 (* ANY AK))))

;; offset -R
(setq A1_minus (list (- X_A1 (* ANX AK)) (- Y_A1 (* ANY AK))))
(setq A2_minus (list (- X_A2 (* ANX AK)) (- Y_A2 (* ANY AK))))

;; ----------------------------------------------------
;; OFFSET PROSTEJ B
;; ----------------------------------------------------

(setq BX (- X_B2 X_B1))
(setq BY (- Y_B2 Y_B1))

(setq BNX (- BY))
(setq BNY BX)

(setq BLEN (sqrt (+ (* BNX BNX) (* BNY BNY))))
(setq BK (/ R BLEN))

(setq B1_plus (list (+ X_B1 (* BNX BK)) (+ Y_B1 (* BNY BK))))
(setq B2_plus (list (+ X_B2 (* BNX BK)) (+ Y_B2 (* BNY BK))))

(setq B1_minus (list (- X_B1 (* BNX BK)) (- Y_B1 (* BNY BK))))
(setq B2_minus (list (- X_B2 (* BNX BK)) (- Y_B2 (* BNY BK))))

;; PODGLĄD
(print "Offset A +R:")
(print A1_plus)
(print A2_plus)

(print "Offset A -R:")
(print A1_minus)
(print A2_minus)

(print "Offset B +R:")
(print B1_plus)
(print B2_plus)

(print "Offset B -R:")
(print B1_minus)
(print B2_minus)

;; TESTY
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" A_1 A_2 "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" B_1 B_2 "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" A1_plus A2_plus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" A1_minus A2_minus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" B1_plus B2_plus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" B1_minus B2_minus "")
(command "_ZOOM" "_SCALE" "0.0001X")

;; PUNKT PRZECIECIA OFFSETOW +R
(setq x1 (car A1_plus))  (setq y1 (cadr A1_plus))
(setq x2 (car A2_plus))  (setq y2 (cadr A2_plus))
(setq x3 (car B1_plus))  (setq y3 (cadr B1_plus))
(setq x4 (car B2_plus))  (setq y4 (cadr B2_plus))

(setq denom (- (* (- x1 x2) (- y3 y4)) (* (- y1 y2) (- x3 x4))))

(if (= denom 0)
  (setq P_plus nil)  ;; równoległe
  (progn
    (setq t (/ (- (* (- x1 x3) (- y3 y4)) (* (- y1 y3) (- x3 x4))) denom))
    (setq Px (+ x1 (* t (- x2 x1))))
    (setq Py (+ y1 (* t (- y2 y1))))
    (setq P_plus (list Px Py))
  )
)

(print "Przecięcie offsetów +R:")
(print P_plus)

(setq x1 (car A1_minus))  (setq y1 (cadr A1_minus))
(setq x2 (car A2_minus))  (setq y2 (cadr A2_minus))
(setq x3 (car B1_minus))  (setq y3 (cadr B1_minus))
(setq x4 (car B2_minus))  (setq y4 (cadr B2_minus))

(setq denom (- (* (- x1 x2) (- y3 y4)) (* (- y1 y2) (- x3 x4))))

(if (= denom 0)
  (setq P_minus nil)
  (progn
    (setq t (/ (- (* (- x1 x3) (- y3 y4)) (* (- y1 y3) (- x3 x4))) denom))
    (setq Px (+ x1 (* t (- x2 x1))))
    (setq Py (+ y1 (* t (- y2 y1))))
    (setq P_minus (list Px Py))
  )
)

(print "Przecięcie offsetów -R:")
(print P_minus)

;;(command "_ZOOM" "_SCALE" "10000X")
;;(command "_PLINE" P_plus P_minus "")
;;(command "_ZOOM" "_SCALE" "0.0001X")

;; długość łuku A_1 -> P_plus -> B_2
(if P_plus
  (setq L_plus (+ (distance A_1 P_plus) (distance P_plus B_2)))
)
(print "Dlugosc luku A_1 -> P_plus -> B_2:")
(print L_plus)

;; długość łuku A_1 -> P_minus -> B_2
(if P_minus
  (setq L_minus (+ (distance A_1 P_minus) (distance P_minus B_2)))
)
(print "Dlugosc luku A_1 -> P_minus -> B_2:")
(print L_minus)

(if (> L_plus L_minus)
  (setq P_plusminus P_minus)
  (setq P_plusminus P_plus)
)
  
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" P_plusminus (list S_X S_Y) "")
(command "_ZOOM" "_SCALE" "0.0001X")

)
