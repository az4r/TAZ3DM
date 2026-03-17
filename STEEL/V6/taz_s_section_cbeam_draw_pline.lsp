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
  
  (command "_PLINE"
    (list taz_s_x1 taz_s_y1)          ;; dół-lewo
    (list taz_s_x2 taz_s_y1)          ;; dół-prawo
    (list taz_s_x2 taz_s_y2)          ;; góra-prawo
    (list taz_s_x1 taz_s_y2)          ;; góra-lewo
    (list taz_s_x1 taz_s_yf2)         ;; lewa półka - górny punkt
    (list taz_s_x_inner taz_s_yf2_in) ;; wewnętrzna górna półka
    (list taz_s_x_inner taz_s_yf1_in) ;; wewnętrzna dolna półka
    (list taz_s_x1 taz_s_yf1)         ;; lewa półka - dolny punkt
    "C"                               ;; zamknij polilinię
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
