(defun c:taz_s_annotation_scale ( / dcl_id selected_index selected_value)

  ;; globalna zmienna wynikowa
  (setq taz_s_annotation_scale 1)

  ;; wczytanie pliku DCL
  (setq dcl_id (load_dialog "taz_s_annotation_scale.dcl"))

  (if (not (new_dialog "taz_s_annotation_scale_dialog" dcl_id))
    (progn
      (alert "Nie mogę załadować okienka DCL.")
      (exit)
    )
  )

  ;; lista skal do popup_list
  (start_list "taz_s_annotation_scale_popup")
  (mapcar 'add_list '("1:1" "1:2" "1:5" "1:10" "1:20" "1:25" "1:50" "1:100" "1:200"))
  (end_list)

  ;; domyślnie ustaw 1:1
  (set_tile "taz_s_annotation_scale_popup" "0")

  ;; obsługa OK
  (action_tile "accept"
    "(progn
        (setq selected_index (atoi (get_tile \"taz_s_annotation_scale_popup\")))

        ;; mapowanie indeksów na wartości
        (if (= selected_index 0) (setq taz_s_annotation_scale 1))
        (if (= selected_index 1) (setq taz_s_annotation_scale 2))
        (if (= selected_index 2) (setq taz_s_annotation_scale 5))
        (if (= selected_index 3) (setq taz_s_annotation_scale 10))
        (if (= selected_index 4) (setq taz_s_annotation_scale 20))
        (if (= selected_index 5) (setq taz_s_annotation_scale 25))
        (if (= selected_index 6) (setq taz_s_annotation_scale 50))
        (if (= selected_index 7) (setq taz_s_annotation_scale 100))
        (if (= selected_index 8) (setq taz_s_annotation_scale 200))

        (done_dialog)
    )"
  )

  ;; uruchom dialog
  (start_dialog)

  ;; zwolnij DCL
  (unload_dialog dcl_id)

  ;; pokaż wynik (debug)
  (princ (strcat "\nWybrana skala opisu = " (itoa taz_s_annotation_scale)))
  (princ)
)
