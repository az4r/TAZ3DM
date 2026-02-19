(defun taz_s_section_ibeam_draw (h b tw tf r / p x1 x2 y1 y2 xw1 xw2 yf1 yf2)

  (setq p '(0 0 0))

  (command "_ZOOM" "_SCALE" "10000X")

  (setq x1 (- (car p) (/ b 2.0)))
  (setq x2 (+ (car p) (/ b 2.0)))
  (setq y1 (- (cadr p) (/ h 2.0)))
  (setq y2 (+ (cadr p) (/ h 2.0)))

  (setq xw1 (- (car p) (/ tw 2.0)))
  (setq xw2 (+ (car p) (/ tw 2.0)))

  (setq yf1 (+ y1 tf))
  (setq yf2 (- y2 tf))
  
  (command "_FILLET" "_R" r)

  (command "_LINE" (list x1 y1) (list x2 y1) "")
  (setq l1 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 y1) (list x2 yf1) "")
  (setq l2 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 yf1) (list xw2 yf1) "")
  (setq l3 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw2 yf1) (list xw2 yf2) "")
  (setq l4 (cdr (assoc -1 (entget (entlast))))) 

  (command "_LINE" (list xw2 yf2) (list x2 yf2) "")
  (setq l5 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 yf2) (list x2 y2) "")
  (setq l6 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x2 y2) (list x1 y2) "")
  (setq l7 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 y2) (list x1 yf2) "")
  (setq l8 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 yf2) (list xw1 yf2) "")
  (setq l9 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw1 yf2) (list xw1 yf1) "")
  (setq l10 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list xw1 yf1) (list x1 yf1) "")
  (setq l11 (cdr (assoc -1 (entget (entlast)))))

  (command "_LINE" (list x1 yf1) (list x1 y1) "")
  (setq l12 (cdr (assoc -1 (entget (entlast)))))
  
  ;; zapisz widok 
  
  (if (tblsearch "VIEW" "taz_s_temp_view")
    (command "-VIEW" "_D" "taz_s_temp_view")
    (command "-VIEW" "_S" "taz_s_temp_view")
  )

  (command "_PLAN" "_C")
  
  (command "_FILLET" l3 l4)
  
  (setq f1 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  
  (command "_FILLET" l4 l5)
  
  (setq f2 (cdr (assoc -1 (entget (entlast)))))
    
  (command "_PLAN" "_C")
  
  (command "_FILLET" l9 l10)
  
  (setq f3 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_PLAN" "_C")
  
  (command "_FILLET" l10 l11)
  
  (setq f4 (cdr (assoc -1 (entget (entlast)))))
  
  (command "_CHPROP" l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 f1 f2 f3 f4 "" "C" "6" "")
  
  (command "_PEDIT" "M")
  
  (command l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 f1 f2 f3 f4 "")
  
  (command "_Y")
  
  (command "_J" "" "")
  
  (setq taz_s_create_ibeam_profile (ssname (ssget "_X" '((0 . "LWPOLYLINE") (62 . 6))) 0))
  
  (command "_ZOOM" "_SCALE" "0.0001X")
  (command "_ZOOM" "_SCALE" "10000X")
  
  (command "_SWEEP" taz_s_create_ibeam_profile "" taz_s_create_ibeam_path "")
  
  ;; przywróć widok
  (command "-VIEW" "_R" "taz_s_temp_view")
  
  ;; usuń widok tymczasowy
  (command "-VIEW" "_D" "taz_s_temp_view")

  (command "_ZOOM" "_SCALE" "0.0001X")
  (princ)
)

(defun taz_s_section_ibeam
  ( / taz_s_h taz_s_b taz_s_tw taz_s_tf taz_s_r
       taz_s_input
       taz_s_family_ok
       taz_s_type_ok
  )

  ;; domyślna rodzina
  (if (not taz_s_section_ibeam_family)
    (setq taz_s_section_ibeam_family "HEA")
  )

  ;; domyślny typ
  (if (not taz_s_section_ibeam_type)
    (setq taz_s_section_ibeam_type "200")
  )

  ;; pytania tylko poza trybem edycji
  (if (not taz_s_edit_mode)

    (progn

      ;; -----------------------------------------------------
      ;; WYBÓR RODZINY
      ;; -----------------------------------------------------

      (setq taz_s_family_ok nil)

      (while (not taz_s_family_ok)

        (setq taz_s_input
          (getstring
            (strcat
              "\nRodzina profilu (HEA / HEB) <"
              taz_s_section_ibeam_family
              ">: "
            )
          )
        )

        (if (= taz_s_input "")
          (setq taz_s_input taz_s_section_ibeam_family)
        )

        (if (= taz_s_input "HEA")
          (progn
            (setq taz_s_section_ibeam_family "HEA")
            (setq taz_s_family_ok T)
          )
        )

        (if (= taz_s_input "HEB")
          (progn
            (setq taz_s_section_ibeam_family "HEB")
            (setq taz_s_family_ok T)
          )
        )

        (if (not taz_s_family_ok)
          (prompt "\nNieprawidłowa rodzina. Dozwolone: HEA lub HEB.")
        )
      )

      ;; -----------------------------------------------------
      ;; WYBÓR TYPU — HEA
      ;; -----------------------------------------------------

      (if (= taz_s_section_ibeam_family "HEA")

        (progn
          (setq taz_s_type_ok nil)

          (while (not taz_s_type_ok)

            (setq taz_s_input
              (getstring
                (strcat
                  "\nTyp profilu HEA "
                  "(100 120 140 160 180 200 220 240 260 280 "
                  "300 320 340 360 400 450 500 550 600 650 "
                  "700 800 900 1000) <"
                  taz_s_section_ibeam_type
                  ">: "
                )
              )
            )

            (if (= taz_s_input "")
              (setq taz_s_input taz_s_section_ibeam_type)
            )

            ;; walidacja HEA
            (if (= taz_s_input "100")  (setq taz_s_type_ok T))
            (if (= taz_s_input "120")  (setq taz_s_type_ok T))
            (if (= taz_s_input "140")  (setq taz_s_type_ok T))
            (if (= taz_s_input "160")  (setq taz_s_type_ok T))
            (if (= taz_s_input "180")  (setq taz_s_type_ok T))
            (if (= taz_s_input "200")  (setq taz_s_type_ok T))
            (if (= taz_s_input "220")  (setq taz_s_type_ok T))
            (if (= taz_s_input "240")  (setq taz_s_type_ok T))
            (if (= taz_s_input "260")  (setq taz_s_type_ok T))
            (if (= taz_s_input "280")  (setq taz_s_type_ok T))
            (if (= taz_s_input "300")  (setq taz_s_type_ok T))
            (if (= taz_s_input "320")  (setq taz_s_type_ok T))
            (if (= taz_s_input "340")  (setq taz_s_type_ok T))
            (if (= taz_s_input "360")  (setq taz_s_type_ok T))
            (if (= taz_s_input "400")  (setq taz_s_type_ok T))
            (if (= taz_s_input "450")  (setq taz_s_type_ok T))
            (if (= taz_s_input "500")  (setq taz_s_type_ok T))
            (if (= taz_s_input "550")  (setq taz_s_type_ok T))
            (if (= taz_s_input "600")  (setq taz_s_type_ok T))
            (if (= taz_s_input "650")  (setq taz_s_type_ok T))
            (if (= taz_s_input "700")  (setq taz_s_type_ok T))
            (if (= taz_s_input "800")  (setq taz_s_type_ok T))
            (if (= taz_s_input "900")  (setq taz_s_type_ok T))
            (if (= taz_s_input "1000") (setq taz_s_type_ok T))

            (if taz_s_type_ok
              (setq taz_s_section_ibeam_type taz_s_input)
              (prompt "\nNieprawidłowy typ HEA.")
            )
          )
        )
      )

      ;; -----------------------------------------------------
      ;; WYBÓR TYPU — HEB
      ;; -----------------------------------------------------

      (if (= taz_s_section_ibeam_family "HEB")

        (progn
          (setq taz_s_type_ok nil)

          (while (not taz_s_type_ok)

            (setq taz_s_input
              (getstring
                (strcat
                  "\nTyp profilu HEB "
                  "(100 120 140 160 180 200 220 240 260 280 "
                  "300 320 340 360 400 450 500 550 600 650 "
                  "700 800 900 1000) <"
                  taz_s_section_ibeam_type
                  ">: "
                )
              )
            )

            (if (= taz_s_input "")
              (setq taz_s_input taz_s_section_ibeam_type)
            )

            ;; walidacja HEB
            (if (= taz_s_input "100")  (setq taz_s_type_ok T))
            (if (= taz_s_input "120")  (setq taz_s_type_ok T))
            (if (= taz_s_input "140")  (setq taz_s_type_ok T))
            (if (= taz_s_input "160")  (setq taz_s_type_ok T))
            (if (= taz_s_input "180")  (setq taz_s_type_ok T))
            (if (= taz_s_input "200")  (setq taz_s_type_ok T))
            (if (= taz_s_input "220")  (setq taz_s_type_ok T))
            (if (= taz_s_input "240")  (setq taz_s_type_ok T))
            (if (= taz_s_input "260")  (setq taz_s_type_ok T))
            (if (= taz_s_input "280")  (setq taz_s_type_ok T))
            (if (= taz_s_input "300")  (setq taz_s_type_ok T))
            (if (= taz_s_input "320")  (setq taz_s_type_ok T))
            (if (= taz_s_input "340")  (setq taz_s_type_ok T))
            (if (= taz_s_input "360")  (setq taz_s_type_ok T))
            (if (= taz_s_input "400")  (setq taz_s_type_ok T))
            (if (= taz_s_input "450")  (setq taz_s_type_ok T))
            (if (= taz_s_input "500")  (setq taz_s_type_ok T))
            (if (= taz_s_input "550")  (setq taz_s_type_ok T))
            (if (= taz_s_input "600")  (setq taz_s_type_ok T))
            (if (= taz_s_input "650")  (setq taz_s_type_ok T))
            (if (= taz_s_input "700")  (setq taz_s_type_ok T))
            (if (= taz_s_input "800")  (setq taz_s_type_ok T))
            (if (= taz_s_input "900")  (setq taz_s_type_ok T))
            (if (= taz_s_input "1000") (setq taz_s_type_ok T))

            (if taz_s_type_ok
              (setq taz_s_section_ibeam_type taz_s_input)
              (prompt "\nNieprawidłowy typ HEB.")
            )
          )
        )
      )
    )
  )


  ;; ============================================================
  ;;   HEA – KAŻDY TYP OSOBNY IF
  ;; ============================================================

  ;; HEA100
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "100"))
    (progn
      (setq taz_s_h 96.0)
      (setq taz_s_b 100.0)
      (setq taz_s_tw 5.0)
      (setq taz_s_tf 8.0)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEA120
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "120"))
    (progn
      (setq taz_s_h 114.0)
      (setq taz_s_b 120.0)
      (setq taz_s_tw 5.0)
      (setq taz_s_tf 8.0)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEA140
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "140"))
    (progn
      (setq taz_s_h 133.0)
      (setq taz_s_b 140.0)
      (setq taz_s_tw 5.5)
      (setq taz_s_tf 8.5)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEA160
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "160"))
    (progn
      (setq taz_s_h 152.0)
      (setq taz_s_b 160.0)
      (setq taz_s_tw 6.0)
      (setq taz_s_tf 9.0)
      (setq taz_s_r 15.0)
    )
  )

  ;; HEA180
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "180"))
    (progn
      (setq taz_s_h 171.0)
      (setq taz_s_b 180.0)
      (setq taz_s_tw 6.0)
      (setq taz_s_tf 9.5)
      (setq taz_s_r 15.0)
    )
  )

  ;; HEA200
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "200"))
    (progn
      (setq taz_s_h 190.0)
      (setq taz_s_b 200.0)
      (setq taz_s_tw 6.5)
      (setq taz_s_tf 10.0)
      (setq taz_s_r 18.0)
    )
  )

  ;; HEA220
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "220"))
    (progn
      (setq taz_s_h 210.0)
      (setq taz_s_b 220.0)
      (setq taz_s_tw 7.0)
      (setq taz_s_tf 11.0)
      (setq taz_s_r 18.0)
    )
  )

  ;; HEA240
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "240"))
    (progn
      (setq taz_s_h 230.0)
      (setq taz_s_b 240.0)
      (setq taz_s_tw 7.5)
      (setq taz_s_tf 12.0)
      (setq taz_s_r 21.0)
    )
  )

  ;; HEA260
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "260"))
    (progn
      (setq taz_s_h 250.0)
      (setq taz_s_b 260.0)
      (setq taz_s_tw 7.5)
      (setq taz_s_tf 12.5)
      (setq taz_s_r 24.0)
    )
  )

  ;; HEA280
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "280"))
    (progn
      (setq taz_s_h 270.0)
      (setq taz_s_b 280.0)
      (setq taz_s_tw 8.0)
      (setq taz_s_tf 13.0)
      (setq taz_s_r 24.0)
    )
  )

  ;; HEA300
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "300"))
    (progn
      (setq taz_s_h 290.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 8.5)
      (setq taz_s_tf 14.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA320
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "320"))
    (progn
      (setq taz_s_h 310.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 9.0)
      (setq taz_s_tf 15.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA340
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "340"))
    (progn
      (setq taz_s_h 330.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 9.5)
      (setq taz_s_tf 16.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA360
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "360"))
    (progn
      (setq taz_s_h 350.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 10.0)
      (setq taz_s_tf 17.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA400
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "400"))
    (progn
      (setq taz_s_h 390.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 11.0)
      (setq taz_s_tf 19.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA450
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "450"))
    (progn
      (setq taz_s_h 440.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 11.5)
      (setq taz_s_tf 21.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA500
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "500"))
    (progn
      (setq taz_s_h 490.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 12.0)
      (setq taz_s_tf 23.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA550
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "550"))
    (progn
      (setq taz_s_h 540.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 12.5)
      (setq taz_s_tf 24.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA600
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "600"))
    (progn
      (setq taz_s_h 590.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 13.0)
      (setq taz_s_tf 25.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA650
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "650"))
    (progn
      (setq taz_s_h 640.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 13.5)
      (setq taz_s_tf 26.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA700
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "700"))
    (progn
      (setq taz_s_h 690.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 14.5)
      (setq taz_s_tf 27.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEA800
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "800"))
    (progn
      (setq taz_s_h 790.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 15.0)
      (setq taz_s_tf 28.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; HEA900
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "900"))
    (progn
      (setq taz_s_h 890.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 16.0)
      (setq taz_s_tf 30.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; HEA1000
  (if (and (= taz_s_section_ibeam_family "HEA")
           (= taz_s_section_ibeam_type "1000"))
    (progn
      (setq taz_s_h 990.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 16.5)
      (setq taz_s_tf 31.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; ============================================================
  ;;   HEB – KAŻDY TYP OSOBNY IF
  ;; ============================================================

  ;; HEB100
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "100"))
    (progn
      (setq taz_s_h 100.0)
      (setq taz_s_b 100.0)
      (setq taz_s_tw 6.0)
      (setq taz_s_tf 10.0)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEB120
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "120"))
    (progn
      (setq taz_s_h 120.0)
      (setq taz_s_b 120.0)
      (setq taz_s_tw 6.5)
      (setq taz_s_tf 11.0)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEB140
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "140"))
    (progn
      (setq taz_s_h 140.0)
      (setq taz_s_b 140.0)
      (setq taz_s_tw 7.0)
      (setq taz_s_tf 12.0)
      (setq taz_s_r 12.0)
    )
  )

  ;; HEB160
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "160"))
    (progn
      (setq taz_s_h 160.0)
      (setq taz_s_b 160.0)
      (setq taz_s_tw 8.0)
      (setq taz_s_tf 13.0)
      (setq taz_s_r 15.0)
    )
  )

  ;; HEB180
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "180"))
    (progn
      (setq taz_s_h 180.0)
      (setq taz_s_b 180.0)
      (setq taz_s_tw 8.5)
      (setq taz_s_tf 14.0)
      (setq taz_s_r 15.0)
    )
  )

  ;; HEB200
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "200"))
    (progn
      (setq taz_s_h 200.0)
      (setq taz_s_b 200.0)
      (setq taz_s_tw 9.0)
      (setq taz_s_tf 15.0)
      (setq taz_s_r 18.0)
    )
  )

  ;; HEB220
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "220"))
    (progn
      (setq taz_s_h 220.0)
      (setq taz_s_b 220.0)
      (setq taz_s_tw 9.5)
      (setq taz_s_tf 16.0)
      (setq taz_s_r 18.0)
    )
  )

  ;; HEB240
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "240"))
    (progn
      (setq taz_s_h 240.0)
      (setq taz_s_b 240.0)
      (setq taz_s_tw 10.0)
      (setq taz_s_tf 17.0)
      (setq taz_s_r 21.0)
    )
  )

  ;; HEB260
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "260"))
    (progn
      (setq taz_s_h 260.0)
      (setq taz_s_b 260.0)
      (setq taz_s_tw 10.0)
      (setq taz_s_tf 17.5)
      (setq taz_s_r 24.0)
    )
  )

  ;; HEB280
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "280"))
    (progn
      (setq taz_s_h 280.0)
      (setq taz_s_b 280.0)
      (setq taz_s_tw 10.5)
      (setq taz_s_tf 18.0)
      (setq taz_s_r 24.0)
    )
  )

  ;; HEB300
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "300"))
    (progn
      (setq taz_s_h 300.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 11.0)
      (setq taz_s_tf 19.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB320
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "320"))
    (progn
      (setq taz_s_h 320.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 11.5)
      (setq taz_s_tf 20.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB340
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "340"))
    (progn
      (setq taz_s_h 340.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 12.0)
      (setq taz_s_tf 21.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB360
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "360"))
    (progn
      (setq taz_s_h 360.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 12.5)
      (setq taz_s_tf 22.5)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB400
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "400"))
    (progn
      (setq taz_s_h 400.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 13.5)
      (setq taz_s_tf 24.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB450
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "450"))
    (progn
      (setq taz_s_h 450.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 14.0)
      (setq taz_s_tf 26.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB500
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "500"))
    (progn
      (setq taz_s_h 500.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 14.5)
      (setq taz_s_tf 28.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB550
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "550"))
    (progn
      (setq taz_s_h 550.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 15.0)
      (setq taz_s_tf 29.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB600
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "600"))
    (progn
      (setq taz_s_h 600.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 15.5)
      (setq taz_s_tf 30.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB650
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "650"))
    (progn
      (setq taz_s_h 650.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 16.0)
      (setq taz_s_tf 31.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB700
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "700"))
    (progn
      (setq taz_s_h 700.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 17.0)
      (setq taz_s_tf 32.0)
      (setq taz_s_r 27.0)
    )
  )

  ;; HEB800
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "800"))
    (progn
      (setq taz_s_h 800.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 17.5)
      (setq taz_s_tf 33.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; HEB900
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "900"))
    (progn
      (setq taz_s_h 900.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 18.5)
      (setq taz_s_tf 35.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; HEB1000
  (if (and (= taz_s_section_ibeam_family "HEB")
           (= taz_s_section_ibeam_type "1000"))
    (progn
      (setq taz_s_h 1000.0)
      (setq taz_s_b 300.0)
      (setq taz_s_tw 19.0)
      (setq taz_s_tf 36.0)
      (setq taz_s_r 30.0)
    )
  )

  ;; rysowanie
  (taz_s_section_ibeam_draw taz_s_h taz_s_b taz_s_tw taz_s_tf taz_s_r)
  (princ)
)
