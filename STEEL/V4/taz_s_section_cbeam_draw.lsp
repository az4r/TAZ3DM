(defun taz_s_section_cbeam_draw ()

  ;; pobranie parametrów UPE – baza jak dla HEA, tylko UPE
  (if (= taz_s_family "UPE")
    (taz_s_section_cbeam_draw_parametres_upe) ; UWAGA: nazwa jak w bazie UPE
    (princ)
  )

  ;; pobranie parametrów UPN
  (if (= taz_s_family "UPN")
    (taz_s_section_cbeam_draw_parametres_upn) ; analogicznie jak dla UPE
    (princ)
  )

  ;; punkt bazowy
  (setq taz_s_p '(0 0 0))

  (command "_ZOOM" "_SCALE" "10000X")

  ;; obliczenia geometryczne – identyczne nazwy jak w HEA
  (setq taz_s_x1 (- (car taz_s_p) (/ taz_s_b 2.0)))     ;; lewa krawędź półki
  (setq taz_s_x2 (+ (car taz_s_p) (/ taz_s_b 2.0)))     ;; prawa krawędź półki

  (setq taz_s_y1 (- (cadr taz_s_p) (/ taz_s_h 2.0)))    ;; dół
  (setq taz_s_y2 (+ (cadr taz_s_p) (/ taz_s_h 2.0)))    ;; góra

  ;; położenie środnika UPE – web przy lewej krawędzi, bez przesunięcia o tf
  (setq taz_s_xw1 taz_s_x1)                             ;; lewa strona środnika
  (setq taz_s_xw2 (+ taz_s_xw1 taz_s_tw))               ;; prawa strona środnika

  ;; wysokości półek
  (setq taz_s_yf1 (+ taz_s_y1 taz_s_tf))
  (setq taz_s_yf2 (- taz_s_y2 taz_s_tf))
  
  (setq taz_s_x_inner (- taz_s_x2 taz_s_tw))   ;; prawa krawędź półki wewnętrznej

  ;; promień zaokrąglenia – 1, żeby nie wywalało błędu
  (command "_FILLET" "_R" taz_s_r)

  ;; rysowanie konturu – identyczna kolejność jak w HEA
  ;; 1: dół zewnętrzny  P1 → P2
  (command "_LINE"
          (list taz_s_x1 taz_s_y1)
          (list taz_s_x2 taz_s_y1)
          "")
  (setq taz_s_l1 (entlast))

  ;; 2: prawa pionowa  P2 → P3
  (command "_LINE"
          (list taz_s_x2 taz_s_y1)
          (list taz_s_x2 taz_s_y2)
          "")
  (setq taz_s_l2 (entlast))

  ;; 3: góra zewnętrzna  P3 → P4
  (command "_LINE"
          (list taz_s_x2 taz_s_y2)
          (list taz_s_x1 taz_s_y2)
          "")
  (setq taz_s_l3 (entlast))

  ;; 4: lewa pionowa zewnętrzna (góra → dół półki)  P4 → P3'
  (command "_LINE"
          (list taz_s_x1 taz_s_y2)
          (list taz_s_x1 taz_s_yf2)
          "")
  (setq taz_s_l4 (entlast))

  ;; 5: półka wewnętrzna (góra)  P3' → P4'
  (command "_LINE"
          (list taz_s_x1 taz_s_yf2)
          (list taz_s_x_inner taz_s_yf2)
          "")
  (setq taz_s_l5 (entlast))

  ;; 6: pion środnika  P4' → P5'
  (command "_LINE"
          (list taz_s_x_inner taz_s_yf2)
          (list taz_s_x_inner taz_s_yf1)
          "")
  (setq taz_s_l6 (entlast))

  ;; 7: półka wewnętrzna (dół)  P5' → P6'
  (command "_LINE"
          (list taz_s_x_inner taz_s_yf1)
          (list taz_s_x1 taz_s_yf1)
          "")
  (setq taz_s_l7 (entlast))

  ;; 8: lewa pionowa zewnętrzna (dół półki → dół)  P6' → P7
  (command "_LINE"
          (list taz_s_x1 taz_s_yf1)
          (list taz_s_x1 taz_s_y1)
          "")
  (setq taz_s_l8 (entlast))


  ;; zapisz widok 
  
  (if (tblsearch "VIEW" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
    (command "-VIEW" "_S" "taz_s_temp_view")
  )

  (command "_PLAN" "_C")

  (command "_FILLET" taz_s_l5 taz_s_l6)
  (setq taz_s_f1 (cdr (assoc -1 (entget (entlast)))))

  (command "_PLAN" "_C")

  (command "_FILLET" taz_s_l6 taz_s_l7)
  (setq taz_s_f2 (cdr (assoc -1 (entget (entlast)))))
  
  (if (= taz_s_family "UPN")
  
  (progn
  
  (command "_FILLET" "_R" 1)

  (command "_PLAN" "_C")

  (command "_FILLET" taz_s_l4 taz_s_l5)
  (setq taz_s_f3 (cdr (assoc -1 (entget (entlast)))))

  (command "_PLAN" "_C")

  (command "_FILLET" taz_s_l7 taz_s_l8)
  (setq taz_s_f4 (cdr (assoc -1 (entget (entlast)))))

  ;; kolorowanie
  (command "_CHPROP" taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4 "" "C" "6" "")

  ;; PEDIT + JOIN – identycznie jak w HEA
  (command "_PEDIT" "M")
  (command taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_f1 taz_s_f2 taz_s_f3 taz_s_f4 "")
  (command "_Y")
  (command "_J" "" "")
  
  )
  (progn
  
  ;; kolorowanie
  (command "_CHPROP" taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_f1 taz_s_f2 "" "C" "6" "")

  ;; PEDIT + JOIN – identycznie jak w HEA
  (command "_PEDIT" "M")
  (command taz_s_l1 taz_s_l2 taz_s_l3 taz_s_l4 taz_s_l5 taz_s_l6 taz_s_l7 taz_s_l8 taz_s_f1 taz_s_f2 "")
  (command "_Y")
  (command "_J" "" "")
  
  )
  )
  
  

  ;; wybór profilu
  (setq taz_s_create_beam_profile (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))

  (command "_ZOOM" "_SCALE" "0.0001X")
  (command "_ZOOM" "_SCALE" "10000X")

  ;; SWEEP – identycznie jak w HEA
  (command "_SWEEP" taz_s_create_beam_profile "" taz_s_create_beam_path "")

  ;; przywrócenie widoku
  (command "-VIEW" "_R" "taz_s_temp_view")
  (command "-VIEW" "_D" "taz_s_temp_view")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)
