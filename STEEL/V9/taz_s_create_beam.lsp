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

  (command "_.UCS" "_OB" (entlast))
  (command "_.UCS" "_Y" "90")
  (command "_.UCS" "_Z" "90")

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
