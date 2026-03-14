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

  ;; punkt bazowy
  (setq taz_s_p '(0 0 0))

  (command "_ZOOM" "_SCALE" "10000X")

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


  ;; promień zaokrąglenia
  (command "_FILLET" "R" taz_s_r1)
  (command)
  (command)

  ;; rysowanie konturu
  (command "_LINE" (list taz_s_x1 taz_s_y1) (list taz_s_x2 taz_s_y1) "")
  (setq taz_s_l1 (entlast))

  (command "_LINE" (list taz_s_x2 taz_s_y1) (list taz_s_x2 taz_s_y2) "")
  (setq taz_s_l2 (entlast))

  (command "_LINE" (list taz_s_x2 taz_s_y2) (list taz_s_x1 taz_s_y2) "")
  (setq taz_s_l3 (entlast))

  (command "_LINE" (list taz_s_x1 taz_s_y2) (list taz_s_x1 taz_s_yf2) "")
  (setq taz_s_l4 (entlast))

  ;; >>> tu używamy spadku jeśli UPN <<<
  (command "_LINE" (list taz_s_x1 taz_s_yf2) (list taz_s_x_inner taz_s_yf2_in) "")
  (setq taz_s_l5 (entlast))

  (command "_LINE" (list taz_s_x_inner taz_s_yf2_in) (list taz_s_x_inner taz_s_yf1_in) "")
  (setq taz_s_l6 (entlast))

  (command "_LINE" (list taz_s_x_inner taz_s_yf1_in) (list taz_s_x1 taz_s_yf1) "")
  (setq taz_s_l7 (entlast))

  (command "_LINE" (list taz_s_x1 taz_s_yf1) (list taz_s_x1 taz_s_y1) "")
  (setq taz_s_l8 (entlast))


  ;; zapisz widok
  (if (tblsearch "VIEW" "taz_s_temp_view")
    (progn
    (command "-VIEW" "_D" "taz_s_temp_view")
    (command "-VIEW" "_S" "taz_s_temp_view")
    )
    (command "-VIEW" "_S" "taz_s_temp_view")
  )

  (command "_PLAN" "_C")
  ;;(command "_ZOOM" "_SCALE" "0.0001X")
  ;;(command "_ZOOM" "_SCALE" "10000X")
  (command "_ZOOM" "_OBJECT" taz_s_l5 taz_s_l6 "")
  (command "_FILLET" taz_s_l5 taz_s_l6)
  (setq taz_s_f1 (cdr (assoc -1 (entget (entlast)))))

  (command "_PLAN" "_C")
  ;;(command "_ZOOM" "_SCALE" "0.0001X")
  ;;(command "_ZOOM" "_SCALE" "10000X")
  (command "_ZOOM" "_OBJECT" taz_s_l6 taz_s_l7 "")
  (command "_FILLET" taz_s_l6 taz_s_l7)
  (setq taz_s_f2 (cdr (assoc -1 (entget (entlast)))))

  (if (= taz_s_family "UPN")
    (progn
      (command "_FILLET" "R" taz_s_r2)
      (command)
      (command)

      (command "_PLAN" "_C")
      ;;(command "_ZOOM" "_SCALE" "0.0001X")
      ;;(command "_ZOOM" "_SCALE" "10000X")
      (command "_ZOOM" "_OBJECT" taz_s_l4 taz_s_l5 "")
      (command "_FILLET" taz_s_l4 taz_s_l5)
      (setq taz_s_f3 (cdr (assoc -1 (entget (entlast)))))

      (command "_PLAN" "_C")
      ;;(command "_ZOOM" "_SCALE" "0.0001X")
      ;;(command "_ZOOM" "_SCALE" "10000X")
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

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)
