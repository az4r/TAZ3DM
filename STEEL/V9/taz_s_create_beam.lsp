(defun taz_s_edit_section_position_parametres()
  
  (setq taz_s_r1 1)
  (setq taz_s_r2 1)
  
  (if (= taz_s_family "HEA")
    (taz_s_section_ibeam_draw_parametres_hea)
    (princ)
  )
  (if (= taz_s_family "HEB")
    (taz_s_section_ibeam_draw_parametres_heb)
    (princ)
  )
  (if (= taz_s_family "IPE")
    (taz_s_section_ibeam_draw_parametres_ipe)
    (princ)
  )
  (if (= taz_s_family "IPN")
    (taz_s_section_ibeam_draw_parametres_ipn)
    (princ)
  )
  (if (= taz_s_family "UPE")
    (taz_s_section_cbeam_draw_parametres_upe)
    (princ)
  )
  (if (= taz_s_family "UPN")
    (taz_s_section_cbeam_draw_parametres_upn)
    (princ)
  )
  (if (= taz_s_family "Katownik rownoramienny")
    (taz_s_section_lbeam_draw_parametres_katownik_rownoramienny)
    (princ)
  )
  (if (= taz_s_family "Katownik nierownoramienny")
    (taz_s_section_lbeam_draw_parametres_katownik_nierownoramienny)
    (princ)
  )
  (if (= taz_s_family "Rura kwadratowa")
    (taz_s_section_hsbeam_draw_parametres_rura_kwadratowa)
    (princ)
  )
  (if (= taz_s_family "Rura prostokatna")
    (taz_s_section_hsbeam_draw_parametres_rura_prostokatna)
    (princ)
  )
  (if (= taz_s_family "Rura okragla")
    (progn
    (taz_s_section_hsbeam_draw_parametres_rura_okragla)
    (setq taz_s_b (/ taz_s_d 2))
    (setq taz_s_h (/ taz_s_d 2))
    )
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "1")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ (- taz_s_b) 2) (/ (- taz_s_h) 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "2")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list 0 (/ (- taz_s_h) 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "3")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ taz_s_b 2) (/ (- taz_s_h) 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )

  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "4")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ (- taz_s_b) 2) 0 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "5")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list 0 0 0))
    (command "_ZOOM" "_SCALE" "1000X")  
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "6")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ taz_s_b 2) 0 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "7")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ (- taz_s_b) 2) (/ taz_s_h 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "8")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list 0 (/ taz_s_h 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )
  
  (if (= (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2) "9")
    (progn
    (setq taz_s_edit_section_position_parametres_origin (list (/ taz_s_b 2) (/ taz_s_h 2) 0))
    (command "_ZOOM" "_SCALE" "1000X")
    (command "_.UCS" "_O" taz_s_edit_section_position_parametres_origin)
    (command "_ZOOM" "_SCALE" "0.001X")
    )  
    (princ)
  )

)

(defun c:taz_s_create_beam
  ( / taz_s_create_beam_p1
       taz_s_create_beam_p2
       taz_s_ucs_exist
  )

  ;; ---------------------------------------------------------
  ;; UCS tymczasowy – zapis / nadpisanie
  ;; ---------------------------------------------------------

  (setq taz_s_ucs_exist (tblsearch "UCS" "taz_s_ucs_temp"))

  (if taz_s_ucs_exist
    (progn
      (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp2")
      (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp2")
      (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp2")
    )
    (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
  )

  ;; Reset UCS do World
  (command "_.UCS" "_W")

  ;; ---------------------------------------------------------
  ;; POBRANIE PUNKTÓW – TRYB TWORZENIA / EDYCJI
  ;; ---------------------------------------------------------

  (if (and taz_s_edit_new_path_p1 taz_s_edit_new_path_p2)
    (progn
      (setq taz_s_create_beam_p1 taz_s_edit_new_path_p1)
      (setq taz_s_create_beam_p2 taz_s_edit_new_path_p2)
    )
    (progn
      (setq taz_s_create_beam_p1
            (getpoint "\nPodaj pierwszy punkt linii: "))
      (setq taz_s_create_beam_p2
            (getpoint taz_s_create_beam_p1 "\nPodaj drugi punkt linii: "))
    )
  )

  ;; ---------------------------------------------------------
  ;; RYSOWANIE LINII ŚCIEŻKI
  ;; ---------------------------------------------------------

  (command "_.LINE" taz_s_create_beam_p1 taz_s_create_beam_p2 "")
  (setq taz_s_create_beam_path
        (cdr (assoc -1 (entget (entlast)))))

  ;; ---------------------------------------------------------
  ;; USTAWIENIE UCS DO OBIEKTU I OBROTY
  ;; ---------------------------------------------------------
  
  ;; Jezeli nie jestesmy w trybie edycji to ustaw UCS
  ;;(if (not taz_s_edit_mode)
    ;;(progn
    ;;(command "_.UCS" "_OB" (entlast))
    ;;(command "_.UCS" "_Y" "90")
    ;;(command "_.UCS" "_Z" "90")
    ;;)
    ;;(princ)
  ;;)
  
  (command "_.UCS" "_OB" (entlast))
  (command "_.UCS" "_Y" "90")
  (command "_.UCS" "_Z" "90")
  
  (if taz_s_edit_section_angle_mode
    (progn
      (print (strcat "Aktualnie profil znajduje się pod kątem: " (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle"))) 2 2)))
      (set (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle")) (getreal "\nPodaj kąt obrotu przekroju: "))
      (command "_ZOOM" "_SCALE" "1000X")
      (command "_.UCS" "_Z" (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle"))))
      (taz_s_edit_section_position_parametres)
      (command "_ZOOM" "_SCALE" "0.001X")
      (setq taz_s_section_angle_old (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle"))))
    )
      (princ)
  )
  
  (if taz_s_edit_section_position_mode
    (progn
      (print (strcat "Aktualnie profil znajduje się w pozycji: " (rtos (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))) 2 2)))
      (set (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position")) (getint "\nPodaj punkt położenia przekroju względem osi od 0 do 9: "))
      (command "_ZOOM" "_SCALE" "1000X")
      (command "_.UCS" "_Z" (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle"))))
      (taz_s_edit_section_position_parametres)
      (command "_ZOOM" "_SCALE" "0.001X")
      (setq taz_s_section_position_old (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position"))))
    )
      (princ)
  )

  ;; ---------------------------------------------------------
  ;; WYBÓR I RYSOWANIE PRZEKROJU BELKI
  ;; ---------------------------------------------------------

  ;; Jezeli nie jestesmy w trybie edycji to wybierz przekroj
  (if (not taz_s_edit_mode)
    (taz_s_select_section)
    (princ)
  )
  
  ;; Funkcja rysująca
  (if (= taz_s_category "Dwuteowniki")
    (taz_s_section_ibeam_draw)
    (princ)
  )
  (if (= taz_s_category "Ceowniki")
    (taz_s_section_cbeam_draw)
    (princ)
  )
  (if (= taz_s_category "Katowniki")
    (taz_s_section_lbeam_draw)
    (princ)
  )
  (if (= taz_s_category "Rury")
    (taz_s_section_hsbeam_draw)
    (princ)
  )

  ;; ---------------------------------------------------------
  ;; ATRYBUTY – ZAPIS DO ZMIENNYCH GLOBALNYCH
  ;; ---------------------------------------------------------

  (setq taz_s_attribs_object_name
        (cdr (assoc 5 (entget (entlast)))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6"))
       taz_s_family)

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7"))
       taz_s_type)

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8"))
       "")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9"))
       "BELKA")

  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10"))
       "")
  
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_section_angle")) 0)
    
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_section_position")) 5)

  ;; ---------------------------------------------------------
  ;; RESET UCS DO WORLD
  ;; ---------------------------------------------------------

  (command "_.UCS" "_W")

  ;; ---------------------------------------------------------
  ;; ZAPIS PUNKTÓW ŚCIEŻKI DLA EDYCJI
  ;; ---------------------------------------------------------

  (set (read
         (strcat "taz_s_create_beam_"
                 taz_s_attribs_object_name
                 "_sweep_p1"))
       taz_s_create_beam_p1)

  (set (read
         (strcat "taz_s_create_beam_"
                 taz_s_attribs_object_name
                 "_sweep_p2"))
       taz_s_create_beam_p2)

  ;; ---------------------------------------------------------
  ;; PRZYWRÓCENIE POPRZEDNIEGO UCS
  ;; ---------------------------------------------------------
  
  (if taz_s_ucs_exist
    (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
    (princ)
  )

  ;; ---------------------------------------------------------
  ;; WYCZYSZCZENIE ZMIENNYCH EDYCJI
  ;; ---------------------------------------------------------

  (setq taz_s_edit_new_path_p1 nil)
  (setq taz_s_edit_new_path_p2 nil)
  
  (setq taz_s_create_beam_profile nil)
  (setq taz_s_create_beam_path nil)
  
  (setq taz_s_p nil)
  
  (setq taz_s_r1 nil)
  (setq taz_s_r2 nil)
  (setq taz_s_r nil)

  (princ)
)
