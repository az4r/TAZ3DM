(defun c:taz_s_create_ibeam ( / taz_s_create_ibeam_p1 taz_s_create_ibeam_p2)
  
  (if (tblsearch "UCS" "taz_s_ucs_temp")
    (progn
      (command "_.UCS" "_W") ; przełącz na WCS, żeby dało się skasować
      (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp")
      (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
    )
    (command "_.UCS" "_NA" "_S" "taz_s_ucs_temp")
  )
  
  ;; Reset UCS do World
  (command "_.UCS" "_W")

  ;; Jeśli istnieją punkty z edycji – użyj ich
  (if (and taz_s_edit_new_path_p1 taz_s_edit_new_path_p2)
    (progn
      (setq taz_s_create_ibeam_p1 taz_s_edit_new_path_p1)
      (setq taz_s_create_ibeam_p2 taz_s_edit_new_path_p2)
    )
    ;; W przeciwnym razie – tryb tworzenia, pytamy użytkownika
    (progn
      (setq taz_s_create_ibeam_p1 (getpoint "\nPodaj pierwszy punkt linii: "))
      (setq taz_s_create_ibeam_p2 (getpoint taz_s_create_ibeam_p1 "\nPodaj drugi punkt linii: "))
    )
  )

  ;; Rysowanie linii (zawsze)
  (command "_.LINE" taz_s_create_ibeam_p1 taz_s_create_ibeam_p2 "")

  (setq taz_s_create_ibeam_path (cdr (assoc -1 (entget (entlast)))))

  ;; Ustawienie UCS do obiektu – wskazujemy właśnie narysowaną linię
  (command "_.UCS" "_OB" (entlast))

  ;; Obrót UCS wokół osi Y o 90°
  (command "_.UCS" "_Y" "90")
    
  ;; Obrót UCS wokół osi Z o 90°
  (command "_.UCS" "_Z" "90")

  (taz_s_section_ibeam)
  
  (setq taz_s_attribs_object_name (cdr (assoc 5 (entget (entlast)))))
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1")) "atrybucik1")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2")) "atrybucik2")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3")) "atrybucik3")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4")) "atrybucik4")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5")) "atrybucik5")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6")) taz_s_section_ibeam_family)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7")) taz_s_section_ibeam_type)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8")) "atrybucik8")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9")) "atrybucik9")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10")) "atrybucik10")
  
  ;; Reset UCS do World
  (command "_.UCS" "_W")

  (set (read (strcat "taz_s_create_ibeam_" taz_s_attribs_object_name "_sweep_p1"))
       taz_s_create_ibeam_p1)

  (set (read (strcat "taz_s_create_ibeam_" taz_s_attribs_object_name "_sweep_p2"))
       taz_s_create_ibeam_p2)
       
  ;; Reset UCS do poprzedniego
  (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
  (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp")

  ;; Wyczyść zmienne edycji
  (setq taz_s_edit_new_path_p1 nil)
  (setq taz_s_edit_new_path_p2 nil)
  
  (princ)
)
