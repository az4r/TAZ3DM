(setq taz_s_edit_cmd_reactor nil)
(setq taz_s_edit_internal_update nil)
(setq taz_s_attribs_line nil)
(setq taz_s_attribs_object_old nil)
(setq taz_s_edit_mode nil)

(defun taz_s_edit_check_line_change ( )

  ;; tryb edycji – wyłącz prompty w taz_s_section_ibeam
  (setq taz_s_edit_mode T)

  ;; Ustaw rodzinę i typ profilu na podstawie atrybutów starej bryły
  (setq taz_s_section_ibeam_family
        (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6"))))

  (setq taz_s_section_ibeam_type
        (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7"))))

  ;; Zapisz nowe punkty do zmiennych używanych przez create_ibeam
  (setq taz_s_edit_new_path_p1 (cdr (assoc 10 (entget taz_s_attribs_line))))
  (setq taz_s_edit_new_path_p2 (cdr (assoc 11 (entget taz_s_attribs_line))))

  ;; Uruchom ponownie generator bryły
  (c:taz_s_create_ibeam)

  ;; Nadaj transparency 75 nowej bryle
  (setq taz_s_attribs_object_new (entlast))
  (command "_CHPROP" taz_s_attribs_object_new "" "_P" "_TR" "75" "")

  ;; Przenieś atrybuty ze starej bryły na nową
  (setq taz_s_attribs_object_name_new (cdr (assoc 5 (entget taz_s_attribs_object_new))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr1"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr2"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr3"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr4"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr5"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr6"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr7"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr8"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr9"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9"))))

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr10"))
       (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10"))))

  ;; Usuń starą bryłę (bezpiecznie)
  (if (and taz_s_attribs_object_old (entget taz_s_attribs_object_old))
    (progn
      (entdel taz_s_attribs_object_old)
    )
  )

  ;; Ustaw nową bryłę jako aktualną
  (setq taz_s_attribs_object      taz_s_attribs_object_new)
  (setq taz_s_attribs_object_name taz_s_attribs_object_name_new)

  ;; ustaw nową bryłę jako "starą" dla kolejnej przebudowy
  (setq taz_s_attribs_object_old taz_s_attribs_object_new)

  ;; wyłącz tryb edycji – przywróć normalne działanie promptów
  (setq taz_s_edit_mode nil)

  (princ "\n[TAZ] Reaktor: narysowano nową bryłę i usunięto starą.")
  (princ)
)

(defun taz_s_edit_command_callback ( reactor taz_s_edit_cmdinfo / taz_s_edit_cmd )

  (setq taz_s_edit_cmd (strcase (car taz_s_edit_cmdinfo)))

  ;; Reagujemy tylko na zakończenie wybranych komend
  (if (and (not taz_s_edit_internal_update)
           (member taz_s_edit_cmd
                   '("STRETCH" "MOVE" "GRIP_STRETCH" "GRIP_MOVE" "GRIP_ROTATE" "GRIP_SCALE")))
    (taz_s_edit_check_line_change)
  )

  (princ)
)

(defun c:taz_s_edit_ibeam ( /
        taz_s_attribs_selection 
        taz_s_attribs_object
        taz_s_attribs_object_name
        taz_s_edit_p1
        taz_s_edit_p2
        )

  ;; 1. Pobierz aktualną selekcję
  (setq taz_s_attribs_selection (ssget "_I"))

  ;; 2. Jeśli zaznaczono więcej niż jeden obiekt → odznacz wszystko i wymuś wybór
  (if (and taz_s_attribs_selection
           (> (sslength taz_s_attribs_selection) 1))
    (progn
      (sssetfirst nil nil)
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

  ;; Zapamiętaj starą bryłę (tylko raz)
  (if (not taz_s_attribs_object_old)
    (setq taz_s_attribs_object_old taz_s_attribs_object)
  )

  ;; 6. Sprawdź typ
  (if (/= (cdr (assoc 0 (entget taz_s_attribs_object))) "3DSOLID")
    (progn
      (print "Wybrany obiekt nie jest bryłą 3D.")
      (exit)
    )
  )

  ;; 7. Pobierz nazwę obiektu (handle)
  (setq taz_s_attribs_object_name (cdr (assoc 5 (entget taz_s_attribs_object))))

  ;; 8. Pobierz zapisane punkty ścieżki
  (setq taz_s_edit_p1 
        (eval (read (strcat "taz_s_create_ibeam_" taz_s_attribs_object_name "_sweep_p1"))))

  (setq taz_s_edit_p2 
        (eval (read (strcat "taz_s_create_ibeam_" taz_s_attribs_object_name "_sweep_p2"))))

  ;; 9. Narysuj linię sterującą
  (command "_ZOOM" "_SCALE" "10000X")
  (command "_LINE" taz_s_edit_p1 taz_s_edit_p2 "")
  (command "_ZOOM" "_SCALE" "0.0001X")
  (setq taz_s_attribs_line (entlast))

  ;; 10. Ustaw kolor czerwony
  (command "_CHPROP" taz_s_attribs_line "" "_P" "_C" "1" "")

  ;; 11. Ustaw transparency 75 na bryle
  (command "_CHPROP" taz_s_attribs_object "" "_P" "_TR" "75" "")

  ;; 12. Włącz reaktor jeśli jeszcze nie istnieje
  (if (not taz_s_edit_cmd_reactor)
    (setq taz_s_edit_cmd_reactor
      (vlr-command-reactor
        "taz_s_edit_cmd_reactor"
        '((:vlr-commandEnded . taz_s_edit_command_callback))
      )
    )
  )

  (princ "\n[TAZ] Edycja otwarta – linia sterująca gotowa, bryła przygaszona.")
  (princ)
)

(defun c:taz_s_edit_ibeam_close ( / )

  ;; Przywróć normalną przezroczystość bryły
  (if (and taz_s_attribs_object (entget taz_s_attribs_object))
    (command "_CHPROP" taz_s_attribs_object "" "_P" "_TR" "0" "")
  )

  ;; Usuń czerwoną linię sterującą
  (if (and taz_s_attribs_line (entget taz_s_attribs_line))
    (entdel taz_s_attribs_line)
  )

  ;; Wyczyść zmienne
  (setq taz_s_attribs_line nil)
  (setq taz_s_attribs_object_old nil)
  (setq taz_s_edit_mode nil)

  ;; Wyłącz reaktor
  (if taz_s_edit_cmd_reactor
    (progn
      (vlr-remove taz_s_edit_cmd_reactor)
      (setq taz_s_edit_cmd_reactor nil)
    )
  )

  (princ "\n[TAZ] Edycja zamknięta – linia usunięta, bryła przywrócona.")
  (princ)
)
