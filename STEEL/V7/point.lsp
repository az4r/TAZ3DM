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

;; 2. WEKTORY KIERUNKOWE PROSTYCH
;; DLA PROSTEJ 1
(setq U_X (- X_A1 S_X))
(setq U_Y (- Y_A1 S_Y))

(setq LEN_U (sqrt (+ (* U_X U_X) (* U_Y U_Y))))

(setq _U_X (/ U_X LEN_U))
(setq _U_Y (/ U_Y LEN_U))

;; DLA PROSTEJ 2 (ZABEZPIECZENIE + KOREKTA KIERUNKU)
;; WYBÓR PUNKTU (ABY UNIKNĄĆ WEKTORA ZEROWEGO)
(if (and (= X_B1 S_X) (= Y_B1 S_Y))
  (progn
    (setq V_X (- X_B2 S_X))
    (setq V_Y (- Y_B2 S_Y))
  )
  (progn
    (setq V_X (- X_B1 S_X))
    (setq V_Y (- Y_B1 S_Y))
  )
)

;; NORMALIZACJA
(setq LEN_V (sqrt (+ (* V_X V_X) (* V_Y V_Y))))
(setq _V_X (/ V_X LEN_V))
(setq _V_Y (/ V_Y LEN_V))

;; KOREKTA KIERUNKU
(setq cross_raw (- (* _U_X _V_Y) (* _U_Y _V_X)))

(if (< cross_raw 0)
  (progn
    (setq _V_X (- _V_X))
    (setq _V_Y (- _V_Y))
  )
)

;; 3. KAT MIEDZY PROSTYMI
(setq dot (+ (* _U_X _V_X) (* _U_Y _V_Y)))

(setq cross (abs (- (* _U_X _V_Y) (* _U_Y _V_X))))

(if (= dot 0)
  (setq phi (/ pi 2))
  (setq phi (atan (/ cross (abs dot))))
)

(setq TE (/ R (tan (/ phi 2))))

(setq X_T1 (+ S_X (* _U_X TE)))
(setq Y_T1 (+ S_Y (* _U_Y TE)))
(setq X_T2 (+ S_X (* _V_X TE)))
(setq Y_T2 (+ S_Y (* _V_Y TE)))

(setq TE1 (list X_T1 Y_T1))
(setq TE2 (list X_T2 Y_T2))

;; 4. ŚRODEK OKRĘGU ŁUKU
(setq W_X (+ _U_X _V_X))
(setq W_Y (+ _U_Y _V_Y))

(setq LEN_W (sqrt (+ (* W_X W_X) (* W_Y W_Y))))

(setq _B_X (/ W_X LEN_W))
(setq _B_Y (/ W_Y LEN_W))

(setq D (/ R (sin (/ phi 2))))

(setq X_C (+ S_X (* _B_X D)))
(setq Y_C (+ S_Y (* _B_Y D)))

(setq C (list X_C Y_C))

;; 5. PUNKT ŚRODKOWY ŁUKU
(setq E_1X (- X_T1 X_C))
(setq E_1Y (- Y_T1 Y_C))
(setq E_2X (- X_T2 X_C))
(setq E_2Y (- Y_T2 Y_C))

(setq LEN_E1 (sqrt (+ (* E_1X E_1X) (* E_1Y E_1Y))))
(setq LEN_E2 (sqrt (+ (* E_2X E_2X) (* E_2Y E_2Y))))

(setq _E_1X (/ E_1X LEN_E1))
(setq _E_1Y (/ E_1Y LEN_E1))
(setq _E_2X (/ E_2X LEN_E2))
(setq _E_2Y (/ E_2Y LEN_E2))

(setq M_X (+ _E_1X _E_2X))
(setq M_Y (+ _E_1Y _E_2Y))

(setq LEN_M (sqrt (+ (* M_X M_X) (* M_Y M_Y))))

(setq _M_X (/ M_X LEN_M))
(setq _M_Y (/ M_Y LEN_M))

(setq X_M (+ X_C (* R _M_X)))
(setq Y_M (+ Y_C (* R _M_Y)))

(setq M (list X_M Y_M))

(print "POCZĄTEK ŁUKU:")
(print TE1)
(print "ŚRODEK ŁUKU:")
(print M)
(print "KONIEC ŁUKU:")
(print TE2)
(command "_ZOOM" "_SCALE" "10000X")
(command "_PLINE" A_1 TE1 M TE2 B_2 "")
(command "_ZOOM" "_SCALE" "0.0001X")
)
