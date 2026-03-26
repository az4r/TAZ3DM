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

)
