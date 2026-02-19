(setq taz_s_edit_cmd_reactor nil)
(setq taz_s_edit_internal_update nil)
(setq taz_s_attribs_line nil)
(setq taz_s_attribs_object_old nil)
(setq taz_s_edit_mode nil)

(defun taz_s_edit_check_line_change ( / 
        taz_s_attr1_old
        taz_s_attr2_old
        taz_s_attr3_old
        taz_s_attr4_old
        taz_s_attr5_old
        taz_s_attr6_old
        taz_s_attr7_old
        taz_s_attr8_old
        taz_s_attr9_old
        taz_s_attr10_old
      )

  ;; ---------------------------------------------------------
  ;; TRYB EDYCJI – wyłącz prompty w taz_s_section_ibeam
  ;; ---------------------------------------------------------

  (setq taz_s_edit_mode T)

  ;; ---------------------------------------------------------
  ;; POBIERZ ATRYBUTY STAREJ BRYŁY (PRZED create_ibeam!)
  ;; ---------------------------------------------------------

  (setq taz_s_attr1_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr1"))))
  (setq taz_s_attr2_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr2"))))
  (setq taz_s_attr3_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr3"))))
  (setq taz_s_attr4_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr4"))))
  (setq taz_s_attr5_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr5"))))
  (setq taz_s_attr6_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr6"))))
  (setq taz_s_attr7_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr7"))))
  (setq taz_s_attr8_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr8"))))
  (setq taz_s_attr9_old  (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr9"))))
  (setq taz_s_attr10_old (eval (read (strcat "taz_s_" taz_s_attribs_object_name "_attr10"))))

  ;; ---------------------------------------------------------
  ;; Ustaw rodzinę i typ profilu na podstawie starych atrybutów
  ;; ---------------------------------------------------------

  (setq taz_s_section_ibeam_family taz_s_attr6_old)
  (setq taz_s_section_ibeam_type   taz_s_attr7_old)

  ;; ---------------------------------------------------------
  ;; Zapisz nowe punkty ścieżki
  ;; ---------------------------------------------------------

  (setq taz_s_edit_new_path_p1 (cdr (assoc 10 (entget taz_s_attribs_line))))
  (setq taz_s_edit_new_path_p2 (cdr (assoc 11 (entget taz_s_attribs_line))))

  ;; ---------------------------------------------------------
  ;; GENERUJ NOWĄ BRYŁĘ
  ;; ---------------------------------------------------------

  (c:taz_s_create_ibeam)

  ;; ---------------------------------------------------------
  ;; NOWA BRYŁA – pobierz jej handle
  ;; ---------------------------------------------------------

  (setq taz_s_attribs_object_new (entlast))
  (setq taz_s_attribs_object_name_new
        (cdr (assoc 5 (entget taz_s_attribs_object_new))))

  ;; nadaj transparency 75
  (command "_CHPROP" taz_s_attribs_object_new "" "_P" "_TR" "75" "")

  ;; ---------------------------------------------------------
  ;; PRZENIEŚ ATRYBUTY ZE STAREJ BRYŁY NA NOWĄ
  ;; ---------------------------------------------------------

  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr1"))  taz_s_attr1_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr2"))  taz_s_attr2_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr3"))  taz_s_attr3_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr4"))  taz_s_attr4_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr5"))  taz_s_attr5_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr6"))  taz_s_attr6_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr7"))  taz_s_attr7_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr8"))  taz_s_attr8_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr9"))  taz_s_attr9_old)
  (set (read (strcat "taz_s_" taz_s_attribs_object_name_new "_attr10")) taz_s_attr10_old)

  ;; ---------------------------------------------------------
  ;; Usuń starą bryłę
  ;; ---------------------------------------------------------

  (if (and taz_s_attribs_object_old (entget taz_s_attribs_object_old))
    (entdel taz_s_attribs_object_old)
  )

  ;; ---------------------------------------------------------
  ;; Ustaw nową bryłę jako aktualną
  ;; ---------------------------------------------------------

  (setq taz_s_attribs_object      taz_s_attribs_object_new)
  (setq taz_s_attribs_object_name taz_s_attribs_object_name_new)
  (setq taz_s_attribs_object_old  taz_s_attribs_object_new)

  ;; ---------------------------------------------------------
  ;; Wyłącz tryb edycji
  ;; ---------------------------------------------------------

  (setq taz_s_edit_mode nil)

  (princ "\n[TAZ] Reaktor: narysowano nową bryłę i przeniesiono atrybuty.")
  (princ)
)

(defun taz_s_edit_command_callback
  ( taz_s_reactor taz_s_edit_cmdinfo / taz_s_edit_cmd )

  (setq taz_s_edit_cmd (strcase (car taz_s_edit_cmdinfo)))

  (if (and (not taz_s_edit_internal_update)
           (member taz_s_edit_cmd
                   '("STRETCH" "MOVE" "GRIP_STRETCH"
                     "GRIP_MOVE" "GRIP_ROTATE" "GRIP_SCALE")))
    (taz_s_edit_check_line_change)
  )

  (princ)
)

(defun c:taz_s_edit_ibeam
  ( / taz_s_attribs_selection
       taz_s_attribs_object
       taz_s_attribs_object_name
       taz_s_edit_p1
       taz_s_edit_p2
  )

  ;; pobierz aktualną selekcję
  (setq taz_s_attribs_selection (ssget "_I"))

  ;; jeśli zaznaczono więcej niż jeden obiekt → wymuś wybór jednego
  (if (and taz_s_attribs_selection
           (> (sslength taz_s_attribs_selection) 1))
    (progn
      (sssetfirst nil nil)
      (setq taz_s_attribs_selection (ssget "_+.:E:S"))
    )
  )

  ;; jeśli brak selekcji → poproś o wskazanie
  (if (null taz_s_attribs_selection)
    (setq taz_s_attribs_selection (ssget "_+.:E:S"))
  )

  ;; jeśli nadal brak selekcji → zakończ
  (if (null taz_s_attribs_selection)
    (progn
      (print "Nie wybrano obiektu.")
      (exit)
    )
  )

  ;; pobierz obiekt
  (setq taz_s_attribs_object (ssname taz_s_attribs_selection 0))

  ;; zapamiętaj starą bryłę (tylko raz)
  (if (not taz_s_attribs_object_old)
    (setq taz_s_attribs_object_old taz_s_attribs_object)
  )

  ;; sprawdź typ
  (if (/= (cdr (assoc 0 (entget taz_s_attribs_object))) "3DSOLID")
    (progn
      (print "Wybrany obiekt nie jest bryłą 3D.")
      (exit)
    )
  )

  ;; pobierz nazwę obiektu (handle)
  (setq taz_s_attribs_object_name
        (cdr (assoc 5 (entget taz_s_attribs_object))))

  ;; pobierz zapisane punkty ścieżki
  (setq taz_s_edit_p1
        (eval (read
               (strcat "taz_s_create_ibeam_"
                       taz_s_attribs_object_name
                       "_sweep_p1"))))

  (setq taz_s_edit_p2
        (eval (read
               (strcat "taz_s_create_ibeam_"
                       taz_s_attribs_object_name
                       "_sweep_p2"))))

  ;; narysuj linię sterującą
  (command "_ZOOM" "_SCALE" "10000X")
  (command "_LINE" taz_s_edit_p1 taz_s_edit_p2 "")
  (command "_ZOOM" "_SCALE" "0.0001X")
  (setq taz_s_attribs_line (entlast))

  ;; ustaw kolor czerwony
  (command "_CHPROP" taz_s_attribs_line "" "_P" "_C" "1" "")

  ;; ustaw transparency 75 na bryle
  (command "_CHPROP" taz_s_attribs_object "" "_P" "_TR" "75" "")

  ;; włącz reaktor jeśli jeszcze nie istnieje
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

  ;; przywróć normalną przezroczystość bryły
  (if (and taz_s_attribs_object (entget taz_s_attribs_object))
    (command "_CHPROP" taz_s_attribs_object "" "_P" "_TR" "0" "")
  )

  ;; usuń czerwoną linię sterującą
  (if (and taz_s_attribs_line (entget taz_s_attribs_line))
    (entdel taz_s_attribs_line)
  )

  ;; wyczyść zmienne
  (setq taz_s_attribs_line nil)
  (setq taz_s_attribs_object_old nil)
  (setq taz_s_edit_mode nil)

  ;; wyłącz reaktor
  (if taz_s_edit_cmd_reactor
    (progn
      (vlr-remove taz_s_edit_cmd_reactor)
      (setq taz_s_edit_cmd_reactor nil)
    )
  )

  (princ "\n[TAZ] Edycja zamknięta – linia usunięta, bryła przywrócona.")
  (princ)
)
