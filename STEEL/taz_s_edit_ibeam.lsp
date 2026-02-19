(defun c:taz_s_edit_ibeam ( / taz_s_attribs_selection taz_s_attribs_object)

  ;; 1. Pobierz aktualną selekcję
  (setq taz_s_attribs_selection (ssget "_I"))

  ;; 2. Jeśli zaznaczono więcej niż jeden obiekt → odznacz wszystko i wymuś wybór
  (if (and taz_s_attribs_selection
           (> (sslength taz_s_attribs_selection) 1))
    (progn
      (sssetfirst nil nil) ;; odznacz wszystko
      (setq taz_s_attribs_selection (ssget "_+.:E:S"))
    )
  )

  ;; 3. Jeśli brak selekcji → poproś o wskazanie jednego obiektu
  (if (null taz_s_attribs_selection)
    (setq taz_s_attribs_selection (ssget "_+.:E:S"))
  )

  ;; 4. Jeśli nadal brak selekcji → zakończ
  (if (null taz_s_attribs_selection)
    (progn
      (print "Nie wybrano obiektu.")
      (exit)
    )
  )

  ;; 5. Pobierz obiekt
  (setq taz_s_attribs_object (ssname taz_s_attribs_selection 0))

  ;; 6. Sprawdź typ
  (if (/= (cdr (assoc 0 (entget taz_s_attribs_object))) "3DSOLID")
    (progn
      (print "Wybrany obiekt nie jest bryłą 3D.")
      (exit)
    )
  )

  ;; 7. Zwróć obiekt
  taz_s_attribs_object
)
