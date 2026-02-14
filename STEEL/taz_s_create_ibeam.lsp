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

  ;; Pobranie pierwszego punktu
  (setq taz_s_create_ibeam_p1 (getpoint "\nPodaj pierwszy punkt linii: "))

  ;; Pobranie drugiego punktu
  (setq taz_s_create_ibeam_p2 (getpoint taz_s_create_ibeam_p1 "\nPodaj drugi punkt linii: "))

  ;; Rysowanie linii
  (command "_.LINE" taz_s_create_ibeam_p1 taz_s_create_ibeam_p2 "")
  
  (setq taz_s_create_ibeam_path (cdr (assoc -1 (entget (entlast)))))

  ;; Ustawienie UCS do obiektu – wskazujemy właśnie narysowaną linię
  (command "_.UCS" "_OB" (entlast))

  ;; Obrót UCS wokół osi Y o 90°
  (command "_.UCS" "_Y" "90")
    
  ;; Obrót UCS wokół osi Z o 90°
  (command "_.UCS" "_Z" "90")

  (taz_s_section_ibeam)
  
  ;; Reset UCS do poprzedniego
  (command "_.UCS" "_NA" "_R" "taz_s_ucs_temp")
  (command "_.UCS" "_NA" "_D" "taz_s_ucs_temp")
  
  (setq taz_s_attribs_object_name (cdr (assoc 5 (entget (entlast)))))
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9")) "")
  (set (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10")) "")
  
  ;;(print taz_s_attribs_object_name)
  ;;(print (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1")))
  ;;(print (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1"))))
  
  (princ)
)
