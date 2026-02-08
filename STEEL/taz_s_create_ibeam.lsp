(defun c:taz_s_create_ibeam ( / taz_s_create_ibeam_p1 taz_s_create_ibeam_p2)

  ;; Reset UCS do World
  (command "_.UCS" "_W")

  ;; Pobranie pierwszego punktu
  (setq taz_s_create_ibeam_p1 (getpoint "\nPodaj pierwszy punkt linii: "))

  ;; Pobranie drugiego punktu
  (setq taz_s_create_ibeam_p2 (getpoint taz_s_create_ibeam_p1 "\nPodaj drugi punkt linii: "))

  ;; Rysowanie linii
  (command "_.LINE" taz_s_create_ibeam_p1 taz_s_create_ibeam_p2 "")

  ;; Ustawienie UCS do obiektu – wskazujemy właśnie narysowaną linię
  (command "_.UCS" "_OB" (entlast))

  ;; Obrót UCS wokół osi Y o 90°
  (command "_.UCS" "_Y" "90")
    
  ;; Obrót UCS wokół osi Z o 90°
  (command "_.UCS" "_Z" "90")
  
  (command nil)

  (TAZ_S_SECTION_IBEAM)
  
  ;; Reset UCS do World
  (command "_.UCS" "_W")
  
  (princ)
)
