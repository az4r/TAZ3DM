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
  
  (command "_LINE" (list taz_s_x1 taz_s_y1) (list taz_s_x2 taz_s_y1) "")
  (setq taz_s_l1 (entlast))
  (command "_CIRCLE" (list taz_s_x1 taz_s_y1) 1)
  (setq taz_s_c1 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x2 taz_s_y1) (list taz_s_x2 taz_s_y2) "")
  (setq taz_s_l2 (entlast))
  (command "_CIRCLE" (list taz_s_x2 taz_s_y1) 1)
  (setq taz_s_c2 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x2 taz_s_y2) (list taz_s_x1 taz_s_y2) "")
  (setq taz_s_l3 (entlast))
  (command "_CIRCLE" (list taz_s_x2 taz_s_y2) 1)
  (setq taz_s_c3 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x1 taz_s_y2) (list taz_s_x1 taz_s_yf2) "")
  (setq taz_s_l4 (entlast))
  (command "_CIRCLE" (list taz_s_x1 taz_s_y2) 1)
  (setq taz_s_c4 (entlast))
  (command "REGEN")

  (command "_LINE" (list taz_s_x1 taz_s_yf2) (list taz_s_x_inner taz_s_yf2_in) "")
  (setq taz_s_l5 (entlast))
  (command "_CIRCLE" (list taz_s_x1 taz_s_yf2) 1)
  (setq taz_s_c5 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x_inner taz_s_yf2_in) (list taz_s_x_inner taz_s_yf1_in) "")
  (setq taz_s_l6 (entlast))
  (command "_CIRCLE" (list taz_s_x_inner taz_s_yf2_in) 1)
  (setq taz_s_c6 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x_inner taz_s_yf1_in) (list taz_s_x1 taz_s_yf1) "")
  (setq taz_s_l7 (entlast))
  (command "_CIRCLE" (list taz_s_x_inner taz_s_yf1_in) 1)
  (setq taz_s_c7 (entlast))
  (command "REGEN")
  
  (command "_LINE" (list taz_s_x1 taz_s_yf1) (list taz_s_x1 taz_s_y1) "")
  (setq taz_s_l8 (entlast))
  (command "_CIRCLE" (list taz_s_x1 taz_s_yf1) 1)
  (setq taz_s_c8 (entlast))
  (command "REGEN")
  
  (setq taz_s_trim_inside 0.25)
  (command "REGEN")
  
  (setq taz_s_trim_inside_p1_1 (list (- taz_s_x1 taz_s_trim_inside) (- taz_s_y1 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_1 (list (+ taz_s_x1 taz_s_trim_inside) (+ taz_s_y1 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_1 taz_s_trim_inside_p2_1 "")
  (command "REGEN")

  (setq taz_s_trim_inside_p1_2 (list (- taz_s_x2 taz_s_trim_inside) (- taz_s_y1 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_2 (list (+ taz_s_x2 taz_s_trim_inside) (+ taz_s_y1 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_2 taz_s_trim_inside_p2_2 "")
  (command "REGEN")

  (setq taz_s_trim_inside_p1_3 (list (- taz_s_x2 taz_s_trim_inside) (- taz_s_y2 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_3 (list (+ taz_s_x2 taz_s_trim_inside) (+ taz_s_y2 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_3 taz_s_trim_inside_p2_3 "")
  (command "REGEN")

  (setq taz_s_trim_inside_p1_4 (list (- taz_s_x1 taz_s_trim_inside) (- taz_s_y2 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_4 (list (+ taz_s_x1 taz_s_trim_inside) (+ taz_s_y2 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_4 taz_s_trim_inside_p2_4 "")
  (command "REGEN")
    
  (setq taz_s_trim_inside_p1_5 (list (- taz_s_x1 taz_s_trim_inside) (- taz_s_yf2 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_5 (list (+ taz_s_x1 taz_s_trim_inside) (+ taz_s_yf2 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_5 taz_s_trim_inside_p2_5 "")
  (command "REGEN")
    
  (setq taz_s_trim_inside_p1_6 (list (- taz_s_x_inner taz_s_trim_inside) (- taz_s_yf2_in taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_6 (list (+ taz_s_x_inner taz_s_trim_inside) (+ taz_s_yf2_in taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_6 taz_s_trim_inside_p2_6 "")
  (command "REGEN")

  (setq taz_s_trim_inside_p1_7 (list (- taz_s_x_inner taz_s_trim_inside) (- taz_s_yf1_in taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_7 (list (+ taz_s_x_inner taz_s_trim_inside) (+ taz_s_yf1_in taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_7 taz_s_trim_inside_p2_7 "")
  (command "REGEN")

  (setq taz_s_trim_inside_p1_8 (list (- taz_s_x1 taz_s_trim_inside) (- taz_s_yf1 taz_s_trim_inside)))
  (setq taz_s_trim_inside_p2_8 (list (+ taz_s_x1 taz_s_trim_inside) (+ taz_s_yf1 taz_s_trim_inside)))
  (command "_TRIM" "" "_C" taz_s_trim_inside_p1_8 taz_s_trim_inside_p2_8 "")
  (command "REGEN")
  
  (entdel taz_s_c1)
  (command "REGEN")
  (entdel taz_s_c2)
  (command "REGEN")
  (entdel taz_s_c3)
  (command "REGEN")
  (entdel taz_s_c4)
  (command "REGEN")
  (entdel taz_s_c5)
  (command "REGEN")
  (entdel taz_s_c6)
  (command "REGEN")
  (entdel taz_s_c7)
  (command "REGEN")
  (entdel taz_s_c8)
  (command "REGEN")
  
  ;; promień zaokrąglenia 0
  (command "_FILLET" "R" 0)
  (command)
  (command)
  
  (command "_FILLET" taz_s_l1 taz_s_l2)
  (command "REGEN")

  (command "_FILLET" taz_s_l2 taz_s_l3)
  (command "REGEN")

  (command "_FILLET" taz_s_l3 taz_s_l4)
  (command "REGEN")

  (command "_FILLET" taz_s_l4 taz_s_l5)
  (command "REGEN")

  (command "_FILLET" taz_s_l5 taz_s_l6)
  (command "REGEN")

  (command "_FILLET" taz_s_l6 taz_s_l7)
  (command "REGEN")

  (command "_FILLET" taz_s_l7 taz_s_l8)
  (command "REGEN")
  
  (command "_FILLET" taz_s_l8 taz_s_l1)
  (command "REGEN")
    
  (command "-VIEW" "_R" "taz_s_temp_view")
  
  (exit)
  
  ;; promień zaokrąglenia
  (command "_FILLET" "R" taz_s_r1)
  (command)
  (command)

  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_l5 taz_s_l6 "")
  (command "_FILLET" taz_s_l5 taz_s_l6)
  (setq taz_s_f1 (cdr (assoc -1 (entget (entlast)))))

  (command "_PLAN" "_C")
  (command "_ZOOM" "_OBJECT" taz_s_l6 taz_s_l7 "")
  (command "_FILLET" taz_s_l6 taz_s_l7)
  (setq taz_s_f2 (cdr (assoc -1 (entget (entlast)))))

  (if (= taz_s_family "UPN")
    (progn
      (command "_FILLET" "R" taz_s_r2)
      (command)
      (command)

      (command "_PLAN" "_C")
      (command "_ZOOM" "_OBJECT" taz_s_l4 taz_s_l5 "")
      (command "_FILLET" taz_s_l4 taz_s_l5)
      (setq taz_s_f3 (cdr (assoc -1 (entget (entlast)))))

      (command "_PLAN" "_C")
      (command "_ZOOM" "_OBJECT" taz_s_l7 taz_s_l8 "")
      (command "_FILLET" taz_s_l7 taz_s_l8)
      (setq taz_s_f4 (cdr (assoc -1 (entget (entlast)))))

      ;; kolorowanie
      (command "_CHPROP"
               taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4
               taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8
               taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4
               ""
               "C" "6"
               ""
      )

      ;; PEDIT + JOIN
      (command "_PEDIT" "M")
      (command taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4
               taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8
               taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4
               ""
      )
      (command "_Y")
      (command "_J" "" "")
    )
    (progn
      ;; kolorowanie
      (command "_CHPROP"
               taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4
               taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8
               taz_s_f1 taz_s_f2
               ""
               "C" "6"
               ""
      )

      ;; PEDIT + JOIN
      (command "_PEDIT" "M")
      (command taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4
               taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8
               taz_s_f1 taz_s_f2
               ""
      )
      (command "_Y")
      (command "_J" "" "")
    )
  )

  ;; wybór profilu
  (setq taz_s_create_beam_profile
        (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))

  (command "_ZOOM" "_SCALE" "0.0001X")
  (command "_ZOOM" "_SCALE" "10000X")

  ;; SWEEP
  (command "_SWEEP" taz_s_create_beam_profile "" taz_s_create_beam_path "")

  ;; przywrócenie widoku
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")
  
  (princ)
)
