(defun taz_s_section_cbeam_draw ()

  ;; pobranie parametrów UPE – baza jak dla HEA, tylko UPE
  (if (= taz_s_family "UPE")
    (taz_s_section_cbeam_draw_parametres_upe)
    (princ)
  )

  ;; pobranie parametrów UPN
  (if (= taz_s_family "UPN")
    (taz_s_section_cbeam_draw_parametres_upn)
    (princ)
  )
  
  ;; zapisz widok
  (command "-VIEW" "_S" "taz_s_temp_view")

  (command "_ZOOM" "_SCALE" "10000X")
  
  ;; punkt bazowy
  (setq taz_s_p '(0 0 0))

  ;; obliczenia geometryczne
  (setq taz_s_x1 (- (car taz_s_p) (/ taz_s_b 2.0)))
  (setq taz_s_x2 (+ (car taz_s_p) (/ taz_s_b 2.0)))

  (setq taz_s_y1 (- (cadr taz_s_p) (/ taz_s_h 2.0)))
  (setq taz_s_y2 (+ (cadr taz_s_p) (/ taz_s_h 2.0)))

  ;; środnik
  (setq taz_s_xw1 taz_s_x1)
  (setq taz_s_xw2 (+ taz_s_xw1 taz_s_tw))

  ;; wysokości półek przy zewnętrznej krawędzi
  (setq taz_s_yf1 (+ taz_s_y1 taz_s_tf))
  (setq taz_s_yf2 (- taz_s_y2 taz_s_tf))

  ;; prawa krawędź półki wewnętrznej
  (setq taz_s_x_inner (- taz_s_x2 taz_s_tw))

  ;; >>> UPN SLOPE LOGIC <<<
  ;; jeśli UPN → obliczamy spadek półek
  (if (= taz_s_family "UPN")
    (progn
      (setq taz_s_dx (- taz_s_x_inner taz_s_x1))          ;; długość półki
      (setq taz_s_alpha (atan (/ taz_s_sf 100.0)))        ;; kąt ze spadku %
      (setq taz_s_dy (* taz_s_dx (tan taz_s_alpha)))      ;; różnica wysokości

      ;; górna półka wyżej przy środniku
      (setq taz_s_yf2_in (- taz_s_yf2 taz_s_dy))

      ;; dolna półka niżej przy środniku
      (setq taz_s_yf1_in (+ taz_s_yf1 taz_s_dy))
    )
    (progn
      ;; inne profile – półki poziome
      (setq taz_s_yf2_in taz_s_yf2)
      (setq taz_s_yf1_in taz_s_yf1)
    )
  )
  ;; >>> END UPN SLOPE <<<

  ;; rysowanie konturu
  ;; ustawienie kamery
  (command "_LINE" '(-50 -50 0) '(50 50 0) "")
  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" (entlast) "")
  (entdel (entlast))
  (command "_ZOOM" "_SCALE" "1000X")
  (command "REGEN")
  
  ;; przypisanie punktów
  (setq taz_s_plp1 (list taz_s_x1 taz_s_y1))          ;; dół-lewo
  (setq taz_s_plp2 (list taz_s_x2 taz_s_y1))          ;; dół-prawo
  (setq taz_s_plp3 (list taz_s_x2 taz_s_y2))          ;; góra-prawo
  (setq taz_s_plp4 (list taz_s_x1 taz_s_y2))          ;; góra-lewo
  (setq taz_s_plp5 (list taz_s_x1 taz_s_yf2))         ;; lewa półka - górny punkt
  (setq taz_s_plp6 (list taz_s_x_inner taz_s_yf2_in)) ;; wewnętrzna górna półka
  (setq taz_s_plp7 (list taz_s_x_inner taz_s_yf1_in)) ;; wewnętrzna dolna półka
  (setq taz_s_plp8 (list taz_s_x1 taz_s_yf1))         ;; lewa półka - dolny punkt
  
  ;; ===== dodatkowe punkty dla wyokrąglenia przy plp6 =====

  ;; wektor od plp6 do plp5
  (setq taz_s_dx1 (- (car taz_s_plp5) (car taz_s_plp6)))
  (setq taz_s_dy1 (- (cadr taz_s_plp5) (cadr taz_s_plp6)))

  (setq taz_s_len1 (sqrt (+ (* taz_s_dx1 taz_s_dx1) (* taz_s_dy1 taz_s_dy1))))

  (setq taz_s_plp6_before
    (list
      (+ (car taz_s_plp6) (* (/ taz_s_dx1 taz_s_len1) taz_s_r1))
      (+ (cadr taz_s_plp6) (* (/ taz_s_dy1 taz_s_len1) taz_s_r1))
    )
  )

  ;; wektor od plp6 do plp7
  (setq taz_s_dx2 (- (car taz_s_plp7) (car taz_s_plp6)))
  (setq taz_s_dy2 (- (cadr taz_s_plp7) (cadr taz_s_plp6)))

  (setq taz_s_len2 (sqrt (+ (* taz_s_dx2 taz_s_dx2) (* taz_s_dy2 taz_s_dy2))))

  (setq taz_s_plp6_after
    (list
      (+ (car taz_s_plp6) (* (/ taz_s_dx2 taz_s_len2) taz_s_r1))
      (+ (cadr taz_s_plp6) (* (/ taz_s_dy2 taz_s_len2) taz_s_r1))
    )
  )
  
  ;; ===== dodatkowe punkty dla wyokrąglenia przy plp7 =====

  ;; wektor od plp7 do plp6
  (setq taz_s_dx3 (- (car taz_s_plp6) (car taz_s_plp7)))
  (setq taz_s_dy3 (- (cadr taz_s_plp6) (cadr taz_s_plp7)))

  (setq taz_s_len3 (sqrt (+ (* taz_s_dx3 taz_s_dx3) (* taz_s_dy3 taz_s_dy3))))

  (setq taz_s_plp7_before
    (list
      (+ (car taz_s_plp7) (* (/ taz_s_dx3 taz_s_len3) taz_s_r1))
      (+ (cadr taz_s_plp7) (* (/ taz_s_dy3 taz_s_len3) taz_s_r1))
    )
  )

  ;; wektor od plp7 do plp8
  (setq taz_s_dx4 (- (car taz_s_plp8) (car taz_s_plp7)))
  (setq taz_s_dy4 (- (cadr taz_s_plp8) (cadr taz_s_plp7)))

  (setq taz_s_len4 (sqrt (+ (* taz_s_dx4 taz_s_dx4) (* taz_s_dy4 taz_s_dy4))))

  (setq taz_s_plp7_after
    (list
      (+ (car taz_s_plp7) (* (/ taz_s_dx4 taz_s_len4) taz_s_r1))
      (+ (cadr taz_s_plp7) (* (/ taz_s_dy4 taz_s_len4) taz_s_r1))
    )
  )

  ;; ===== dodatkowe punkty dla wyokrąglenia przy plp5 (tylko UPN) =====

  (if (= taz_s_family "UPN")
    (progn

      ;; wektor od plp5 do plp4
      (setq taz_s_dx5 (- (car taz_s_plp4) (car taz_s_plp5)))
      (setq taz_s_dy5 (- (cadr taz_s_plp4) (cadr taz_s_plp5)))

      (setq taz_s_len5 (sqrt (+ (* taz_s_dx5 taz_s_dx5) (* taz_s_dy5 taz_s_dy5))))

      (setq taz_s_plp5_before
        (list
          (+ (car taz_s_plp5) (* (/ taz_s_dx5 taz_s_len5) taz_s_r2))
          (+ (cadr taz_s_plp5) (* (/ taz_s_dy5 taz_s_len5) taz_s_r2))
        )
      )

      ;; wektor od plp5 do plp6
      (setq taz_s_dx6 (- (car taz_s_plp6) (car taz_s_plp5)))
      (setq taz_s_dy6 (- (cadr taz_s_plp6) (cadr taz_s_plp5)))

      (setq taz_s_len6 (sqrt (+ (* taz_s_dx6 taz_s_dx6) (* taz_s_dy6 taz_s_dy6))))

      (setq taz_s_plp5_after
        (list
          (+ (car taz_s_plp5) (* (/ taz_s_dx6 taz_s_len6) taz_s_r2))
          (+ (cadr taz_s_plp5) (* (/ taz_s_dy6 taz_s_len6) taz_s_r2))
        )
      )

    )
  )


  
  ;; rysowanie
  (command "_PLINE"
    taz_s_plp1
    taz_s_plp2
    taz_s_plp3
    taz_s_plp4
    
    (if (= taz_s_family "UPN")
      taz_s_plp5_before
      taz_s_plp5
    )

    (if (= taz_s_family "UPN")
      "A"
    )

    (if (= taz_s_family "UPN")
      taz_s_plp5_after
    )

    (if (= taz_s_family "UPN")
      "L"
    )      

    taz_s_plp6_before
    "A"
    taz_s_plp6_after
    "L"

    ;; NOWE
    taz_s_plp7_before
    "A"
    taz_s_plp7_after
    "L"

    taz_s_plp8
    "C"
  )



  (command "_CHPROP" (entlast) "" "C" "6" "")

  ;; wybór profilu
  (setq taz_s_create_beam_profile
        (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))

  (command "REGEN")

  ;; SWEEP
  (command "_SWEEP" taz_s_create_beam_profile "" taz_s_create_beam_path "")

  ;; przywrócenie widoku
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")
  
  (princ)
)
