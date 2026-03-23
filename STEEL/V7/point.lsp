;; 1. DANE WEJSCIOWE
(setq A_1 (list X_A1 Y_A1)) 
(setq A_2 (list X_A2 Y_A2)) 
(setq B_1 (list X_B1 Y_B1)) 
(setq B_2 (list X_B2 Y_B2)) 

;; PROMIEŃ
(setq R 2)

;; PUNKT PRZECIĘCIA PROSTYCH
(setq S_X X_A2)
(setq S_Y Y_A2)
(setq S (list S_X S_Y))

;; 2. WEKTORY KIERUNKOWE PROSTYCH
;; DLA PROSTEJ 1
(setq U_X (- X_A2 X_A1))
(setq U_Y (- Y_A2 Y_A1))

;; DŁUGOŚĆ WEKTORA
(setq LEN_U (sqrt (+ (* U_X U_X) (* U_Y U_Y))))

;; WEKTOR JEDNOSTKOWY
(setq _U_X (/ U_X LEN_U))
(setq _U_Y (/ U_Y LEN_U))

;; DLA PROSTEJ 2
(setq V_X (- X_B2 X_B1))
(setq U_Y (- Y_B2 Y_B1))

;; DŁUGOŚĆ WEKTORA
(setq LEN_V (sqrt (+ (* V_X V_X) (* V_Y V_Y))))

;; WEKTOR JEDNOSTKOWY
(setq _V_X (/ V_X LEN_V))
(setq _V_Y (/ V_Y LEN_V))

;; 3. KAT MIEDZY PROSTYMI
;; ILOCZYN SKALARNY WEKTOROW JEDNOSTKOWYCH
(setq cos_phi (+ (* _U_X _V_X) (* _U_Y _V_Y )))
(setq phi acos(cos_phi)) ;; SS

;; ODLEGLOSC OD WIERZCHOLKA DO PUNKTU STYCZNOSCI
(setq TE (/ R tan(/ phi 2))) ;; SS

(setq X_T1 (+ X_S (* _U_X TE)))
(setq Y_T1 (+ Y_S (* _U_Y TE)))
(setq X_T2 (+ X_S (* _V_X TE)))
(setq Y_T2 (+ Y_S (* _V_Y TE)))

(setq TE1 (list X_T1 Y_T1))
(setq TE2 (list X_T2 Y_T2))

;; 4. ŚRODEK OKRĘGU ŁUKU
;; WEKTOR DWUSIECZNEJ
(setq W_X (+ _U_X _V_X))
(setq W_Y (+ _U_Y _V_Y))

;; DŁUGOŚC WEKTORA
(setq LEN_W (sqrt (+ (* W_X W_X) (* W_Y W_Y))))

;; WEKTOR JEDNOSTKOWY DWUSIECZNEJ
(setq _B_X (/ W_X LEN_W))
(setq _B_Y (/ W_Y LEN_W))

;; ODLEGŁOŚĆ ŚRODKA OKRĘGU OD PUNKTU S
(setq D (/ R sin(/ phi 2))) ;; SS

;; ŚRODEK OKRĘGU 
(setq X_C (+ X_S (* _B_X D)))
(setq Y_C (+ Y_S (* _B_Y D)))

(setq C (list X_C Y_C))

;; 5. PUNKT ŚRODKOWY ŁUKU
;; WEKTORY OD ŚRODKA DO PUNKTÓW STYCZNOŚCI
(setq E_1X (- X_T1 X_C))
(setq E_1Y (- Y_T1 X_C))
(setq E_2X (- X_T2 X_C))
(setq E_2Y (- Y_T2 X_C))

;; DŁUGOŚCI WEKTORÓW
(setq LEN_E1 (sqrt (+ (* E_1X E_1X) (* E_1Y E_1Y))))
(setq LEN_E2 (sqrt (+ (* E_2X E_2X) (* E_2Y E_2Y))))

;; WEKTORY JEDNOSTKOWE
(setq _E_1X (/ E_1X LEN_E1))
(setq _E_1Y (/ E_1Y LEN_E1))
(setq _E_2X (/ E_2X LEN_E2))
(setq _E_2Y (/ E_2Y LEN_E2))

;; WEKTOR ŚRODKOWY
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