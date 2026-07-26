(defun taz_s_annotation_scale ( / dcl_id selected_index default_index taz_s_annotation_scale_dialog_result)

  ;; jeśli zmienna istnieje – użyjemy jej jako propozycji
  ;; jeśli nie – ustawimy domyślnie 1
  (if (not taz_s_annotation_scale)
    (setq taz_s_annotation_scale 1)
  )

  ;; ustal indeks listy rozwijalnej na podstawie wartości zmiennej
  (setq default_index 0) ;; domyślnie 1:1

  (if (= taz_s_annotation_scale 1)   (setq default_index 0))
  (if (= taz_s_annotation_scale 2)   (setq default_index 1))
  (if (= taz_s_annotation_scale 5)   (setq default_index 2))
  (if (= taz_s_annotation_scale 10)  (setq default_index 3))
  (if (= taz_s_annotation_scale 20)  (setq default_index 4))
  (if (= taz_s_annotation_scale 25)  (setq default_index 5))
  (if (= taz_s_annotation_scale 50)  (setq default_index 6))
  (if (= taz_s_annotation_scale 100) (setq default_index 7))
  (if (= taz_s_annotation_scale 200) (setq default_index 8))

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

  ;; ustawienie proponowanej wartości
  (set_tile "taz_s_annotation_scale_popup" (itoa default_index))

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

        (done_dialog 1)
    )"
  )

  ;; obsługa ANULUJ
  (action_tile "cancel"
    "(progn
        (done_dialog 0)
    )"
  )

  ;; uruchom dialog
  (setq taz_s_annotation_scale_dialog_result (start_dialog))

  ;; zwolnij DCL
  (unload_dialog dcl_id)

  ;; jeśli anulowano → przerwij skrypt
  (if (= taz_s_annotation_scale_dialog_result 0)
    (progn
      (setq taz_s_old_error *error*)
      (setq *error* (lambda (msg) (princ "")))
      (exit)
      (setq *error* taz_s_old_error)
    )
  )


  ;; debug
  (princ (strcat "\nWybrana skala opisu = " (itoa taz_s_annotation_scale)))
  ;; ustawienie wysokości tekstu na podstawie skali
  ;; toporne if-y, jeden pod drugim

  (if (= taz_s_annotation_scale 1)
    (setq taz_s_annotation_scale_label 2.5)
  )

  (if (= taz_s_annotation_scale 2)
    (setq taz_s_annotation_scale_label 5)
  )

  (if (= taz_s_annotation_scale 5)
    (setq taz_s_annotation_scale_label 12.5)
  )

  (if (= taz_s_annotation_scale 10)
    (setq taz_s_annotation_scale_label 25)
  )

  (if (= taz_s_annotation_scale 20)
    (setq taz_s_annotation_scale_label 50)
  )

  (if (= taz_s_annotation_scale 25)
    (setq taz_s_annotation_scale_label 62.5)
  )

  (if (= taz_s_annotation_scale 50)
    (setq taz_s_annotation_scale_label 125)
  )

  (if (= taz_s_annotation_scale 100)
    (setq taz_s_annotation_scale_label 250)
  )

  (if (= taz_s_annotation_scale 200)
    (setq taz_s_annotation_scale_label 500)
  )

  (princ)
)
