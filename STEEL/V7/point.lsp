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
(setq phi acos(cos_phi)) ;; TU PEWNIE BEDZIE BLAD

;; ODLEGLOSC OD WIERZCHOLKA DO PUNKTU STYCZNOSCI
(setq TE (/ R tan(/ phi 2))) ;; TU SPRAWDZIC

(setq X_T1 (+ X_S (* _U_X TE)))
(setq Y_T1 (+ Y_S (* _U_Y TE)))
(setq X_T2 (+ X_S (* _V_X TE)))
(setq Y_T2 (+ Y_S (* _V_Y TE)))

(setq TE1 (list X_T1 Y_T1))
(setq TE2 (list X_T2 Y_T2))

;; 4. ŚRODEK OKRĘGU ŁUKU
;; WEKTOR DWUSIECZNEJ
