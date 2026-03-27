(defun c:pointt ()
;; 1. DANE WEJSCIOWE
(setq taz_s_arc_X_A1 0)
(setq taz_s_arc_Y_A1 0)
(setq taz_s_arc_X_A2 0)
(setq taz_s_arc_Y_A2 100)

(setq taz_s_arc_X_B1 0)
(setq taz_s_arc_Y_B1 100)
(setq taz_s_arc_X_B2 100)
(setq taz_s_arc_Y_B2 100)
  
(setq taz_s_arc_A_1 (list taz_s_arc_X_A1 taz_s_arc_Y_A1)) 
(setq taz_s_arc_A_2 (list taz_s_arc_X_A2 taz_s_arc_Y_A2)) 
(setq taz_s_arc_B_1 (list taz_s_arc_X_B1 taz_s_arc_Y_B1)) 
(setq taz_s_arc_B_2 (list taz_s_arc_X_B2 taz_s_arc_Y_B2)) 

;; PROMIEŃ
(setq taz_s_arc_R 2)

;; PUNKT PRZECIĘCIA PROSTYCH
(setq taz_s_arc_S_X taz_s_arc_X_A2)
(setq taz_s_arc_S_Y taz_s_arc_Y_A2)

;; ----------------------------------------------------
;; OFFSET PROSTEJ A
;; ----------------------------------------------------

;; kierunek
(setq taz_s_arc_AX (- taz_s_arc_X_A2 taz_s_arc_X_A1))
(setq taz_s_arc_AY (- taz_s_arc_Y_A2 taz_s_arc_Y_A1))

;; normalna
(setq taz_s_arc_ANX (- taz_s_arc_AY))
(setq taz_s_arc_ANY taz_s_arc_AX)

;; długość normalnej
(setq taz_s_arc_ALEN (sqrt (+ (* taz_s_arc_ANX taz_s_arc_ANX) (* taz_s_arc_ANY taz_s_arc_ANY))))

;; współczynnik
(setq taz_s_arc_AK (/ taz_s_arc_R taz_s_arc_ALEN))

;; offset +R
(setq taz_s_arc_A1_plus (list (+ taz_s_arc_X_A1 (* taz_s_arc_ANX taz_s_arc_AK)) (+ taz_s_arc_Y_A1 (* taz_s_arc_ANY taz_s_arc_AK))))
(setq taz_s_arc_A2_plus (list (+ taz_s_arc_X_A2 (* taz_s_arc_ANX taz_s_arc_AK)) (+ taz_s_arc_Y_A2 (* taz_s_arc_ANY taz_s_arc_AK))))

;; offset -R
(setq taz_s_arc_A1_minus (list (- taz_s_arc_X_A1 (* taz_s_arc_ANX taz_s_arc_AK)) (- taz_s_arc_Y_A1 (* taz_s_arc_ANY taz_s_arc_AK))))
(setq taz_s_arc_A2_minus (list (- taz_s_arc_X_A2 (* taz_s_arc_ANX taz_s_arc_AK)) (- taz_s_arc_Y_A2 (* taz_s_arc_ANY taz_s_arc_AK))))

;; ----------------------------------------------------
;; OFFSET PROSTEJ B
;; ----------------------------------------------------

(setq taz_s_arc_BX (- taz_s_arc_X_B2 taz_s_arc_X_B1))
(setq taz_s_arc_BY (- taz_s_arc_Y_B2 taz_s_arc_Y_B1))

(setq taz_s_arc_BNX (- taz_s_arc_BY))
(setq taz_s_arc_BNY taz_s_arc_BX)

(setq taz_s_arc_BLEN (sqrt (+ (* taz_s_arc_BNX taz_s_arc_BNX) (* taz_s_arc_BNY taz_s_arc_BNY))))
(setq taz_s_arc_BK (/ taz_s_arc_R taz_s_arc_BLEN))

(setq taz_s_arc_B1_plus (list (+ taz_s_arc_X_B1 (* taz_s_arc_BNX taz_s_arc_BK)) (+ taz_s_arc_Y_B1 (* taz_s_arc_BNY taz_s_arc_BK))))
(setq taz_s_arc_B2_plus (list (+ taz_s_arc_X_B2 (* taz_s_arc_BNX taz_s_arc_BK)) (+ taz_s_arc_Y_B2 (* taz_s_arc_BNY taz_s_arc_BK))))

(setq taz_s_arc_B1_minus (list (- taz_s_arc_X_B1 (* taz_s_arc_BNX taz_s_arc_BK)) (- taz_s_arc_Y_B1 (* taz_s_arc_BNY taz_s_arc_BK))))
(setq taz_s_arc_B2_minus (list (- taz_s_arc_X_B2 (* taz_s_arc_BNX taz_s_arc_BK)) (- taz_s_arc_Y_B2 (* taz_s_arc_BNY taz_s_arc_BK))))

;; PODGLĄD
(print "Offset A +R:")
(print taz_s_arc_A1_plus)
(print taz_s_arc_A2_plus)

(print "Offset A -R:")
(print taz_s_arc_A1_minus)
(print taz_s_arc_A2_minus)

(print "Offset B +R:")
(print taz_s_arc_B1_plus)
(print taz_s_arc_B2_plus)

(print "Offset B -R:")
(print taz_s_arc_B1_minus)
(print taz_s_arc_B2_minus)

;; TESTY
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_A_1 taz_s_arc_A_2 "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_B_1 taz_s_arc_B_2 "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_A1_plus taz_s_arc_A2_plus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_A1_minus taz_s_arc_A2_minus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_B1_plus taz_s_arc_B2_plus "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_B1_minus taz_s_arc_B2_minus "")
(command "_ZOOM" "_SCALE" "0.0001X")

;; PUNKT PRZECIECIA OFFSETOW +R
(setq taz_s_arc_x1 (car taz_s_arc_A1_plus))  (setq taz_s_arc_y1 (cadr taz_s_arc_A1_plus))
(setq taz_s_arc_x2 (car taz_s_arc_A2_plus))  (setq taz_s_arc_y2 (cadr taz_s_arc_A2_plus))
(setq taz_s_arc_x3 (car taz_s_arc_B1_plus))  (setq taz_s_arc_y3 (cadr taz_s_arc_B1_plus))
(setq taz_s_arc_x4 (car taz_s_arc_B2_plus))  (setq taz_s_arc_y4 (cadr taz_s_arc_B2_plus))

(setq taz_s_arc_denom (- (* (- taz_s_arc_x1 taz_s_arc_x2) (- taz_s_arc_y3 taz_s_arc_y4)) (* (- taz_s_arc_y1 taz_s_arc_y2) (- taz_s_arc_x3 taz_s_arc_x4))))

(if (= taz_s_arc_denom 0)
  (setq taz_s_arc_P_plus nil)
  (progn
    (setq taz_s_arc_t (/ (- (* (- taz_s_arc_x1 taz_s_arc_x3) (- taz_s_arc_y3 taz_s_arc_y4)) (* (- taz_s_arc_y1 taz_s_arc_y3) (- taz_s_arc_x3 taz_s_arc_x4))) taz_s_arc_denom))
    (setq taz_s_arc_Px (+ taz_s_arc_x1 (* taz_s_arc_t (- taz_s_arc_x2 taz_s_arc_x1))))
    (setq taz_s_arc_Py (+ taz_s_arc_y1 (* taz_s_arc_t (- taz_s_arc_y2 taz_s_arc_y1))))
    (setq taz_s_arc_P_plus (list taz_s_arc_Px taz_s_arc_Py))
  )
)

(print "Przecięcie offsetów +R:")
(print taz_s_arc_P_plus)

(setq taz_s_arc_x1 (car taz_s_arc_A1_minus))  (setq taz_s_arc_y1 (cadr taz_s_arc_A1_minus))
(setq taz_s_arc_x2 (car taz_s_arc_A2_minus))  (setq taz_s_arc_y2 (cadr taz_s_arc_A2_minus))
(setq taz_s_arc_x3 (car taz_s_arc_B1_minus))  (setq taz_s_arc_y3 (cadr taz_s_arc_B1_minus))
(setq taz_s_arc_x4 (car taz_s_arc_B2_minus))  (setq taz_s_arc_y4 (cadr taz_s_arc_B2_minus))

(setq taz_s_arc_denom (- (* (- taz_s_arc_x1 taz_s_arc_x2) (- taz_s_arc_y3 taz_s_arc_y4)) (* (- taz_s_arc_y1 taz_s_arc_y2) (- taz_s_arc_x3 taz_s_arc_x4))))

(if (= taz_s_arc_denom 0)
  (setq taz_s_arc_P_minus nil)
  (progn
    (setq taz_s_arc_t (/ (- (* (- taz_s_arc_x1 taz_s_arc_x3) (- taz_s_arc_y3 taz_s_arc_y4)) (* (- taz_s_arc_y1 taz_s_arc_y3) (- taz_s_arc_x3 taz_s_arc_x4))) taz_s_arc_denom))
    (setq taz_s_arc_Px (+ taz_s_arc_x1 (* taz_s_arc_t (- taz_s_arc_x2 taz_s_arc_x1))))
    (setq taz_s_arc_Py (+ taz_s_arc_y1 (* taz_s_arc_t (- taz_s_arc_y2 taz_s_arc_y1))))
    (setq taz_s_arc_P_minus (list taz_s_arc_Px taz_s_arc_Py))
  )
)

(print "Przecięcie offsetów -R:")
(print taz_s_arc_P_minus)

;; długość łuku A_1 -> P_plus -> B_2
(if taz_s_arc_P_plus
  (setq taz_s_arc_L_plus (+ (distance taz_s_arc_A_1 taz_s_arc_P_plus) (distance taz_s_arc_P_plus taz_s_arc_B_2)))
)
(print "Dlugosc luku A_1 -> P_plus -> B_2:")
(print taz_s_arc_L_plus)

;; długość łuku A_1 -> P_minus -> B_2
(if taz_s_arc_P_minus
  (setq taz_s_arc_L_minus (+ (distance taz_s_arc_A_1 taz_s_arc_P_minus) (distance taz_s_arc_P_minus taz_s_arc_B_2)))
)
(print "Dlugosc luku A_1 -> P_minus -> B_2:")
(print taz_s_arc_L_minus)

(if (> taz_s_arc_L_plus taz_s_arc_L_minus)
  (setq taz_s_arc_P_plusminus taz_s_arc_P_minus)
  (setq taz_s_arc_P_plusminus taz_s_arc_P_plus)
)
  
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_P_plusminus (list taz_s_arc_S_X taz_s_arc_S_Y) "")
(command "_ZOOM" "_SCALE" "0.0001X")

;; ----------------------------------------------------
;; PUNKTY ODDALONE O R WZDŁUŻ NORMALNYCH (Z WYBOREM ZWROTU)
;; ----------------------------------------------------

;; normalna A
(setq taz_s_arc_nAx (/ taz_s_arc_ANX taz_s_arc_ALEN))
(setq taz_s_arc_nAy (/ taz_s_arc_ANY taz_s_arc_ALEN))

;; dwie opcje punktu dla A
(setq taz_s_arc_P1a (list (+ (car taz_s_arc_P_plusminus) (* taz_s_arc_nAx taz_s_arc_R))
                          (+ (cadr taz_s_arc_P_plusminus) (* taz_s_arc_nAy taz_s_arc_R))))

(setq taz_s_arc_P1b (list (- (car taz_s_arc_P_plusminus) (* taz_s_arc_nAx taz_s_arc_R))
                          (- (cadr taz_s_arc_P_plusminus) (* taz_s_arc_nAy taz_s_arc_R))))

(if (< (distance taz_s_arc_P1a taz_s_arc_A_2) (distance taz_s_arc_P1b taz_s_arc_A_2))
  (setq taz_s_arc_P1 taz_s_arc_P1a)
  (setq taz_s_arc_P1 taz_s_arc_P1b)
)

;; normalna B
(setq taz_s_arc_nBx (/ taz_s_arc_BNX taz_s_arc_BLEN))
(setq taz_s_arc_nBy (/ taz_s_arc_BNY taz_s_arc_BLEN))

(setq taz_s_arc_P2a (list (+ (car taz_s_arc_P_plusminus) (* taz_s_arc_nBx taz_s_arc_R))
                          (+ (cadr taz_s_arc_P_plusminus) (* taz_s_arc_nBy taz_s_arc_R))))

(setq taz_s_arc_P2b (list (- (car taz_s_arc_P_plusminus) (* taz_s_arc_nBx taz_s_arc_R))
                          (- (cadr taz_s_arc_P_plusminus) (* taz_s_arc_nBy taz_s_arc_R))))

(if (< (distance taz_s_arc_P2a taz_s_arc_B_1) (distance taz_s_arc_P2b taz_s_arc_B_1))
  (setq taz_s_arc_P2 taz_s_arc_P2a)
  (setq taz_s_arc_P2 taz_s_arc_P2b)
)

(print "Punkt od A:")
(print taz_s_arc_P1)

(print "Punkt od B:")
(print taz_s_arc_P2)

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_P_plusminus taz_s_arc_P1 "")
(command "_ZOOM" "_SCALE" "0.0001X")

(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_P_plusminus taz_s_arc_P2 "")
(command "_ZOOM" "_SCALE" "0.0001X")
  
;; ----------------------------------------------------
;; PUNKT W KIERUNKU S NA ODLEGŁOŚĆ R
;; ----------------------------------------------------

;; wektor od P_plusminus do S
(setq taz_s_arc_vx (- taz_s_arc_S_X (car taz_s_arc_P_plusminus)))
(setq taz_s_arc_vy (- taz_s_arc_S_Y (cadr taz_s_arc_P_plusminus)))

;; długość wektora
(setq taz_s_arc_vlen (sqrt (+ (* taz_s_arc_vx taz_s_arc_vx)
                              (* taz_s_arc_vy taz_s_arc_vy))))

;; współczynnik skalujący
(setq taz_s_arc_k (/ taz_s_arc_R taz_s_arc_vlen))

;; nowy punkt
(setq taz_s_arc_P3
  (list (+ (car taz_s_arc_P_plusminus) (* taz_s_arc_vx taz_s_arc_k))
        (+ (cadr taz_s_arc_P_plusminus) (* taz_s_arc_vy taz_s_arc_k)))
)

(print "Punkt w kierunku S o długości R:")
(print taz_s_arc_P3)

;; rysowanie
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" taz_s_arc_P_plusminus taz_s_arc_P3 "")
(command "_ZOOM" "_SCALE" "0.0001X")

 

)
