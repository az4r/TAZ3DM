(defun c:taz_s_create_drawings_execution_design ()
  
  (taz_s_current_settings_save)
  (taz_s_unlock_all_layers)

  ;; ---------------------------------
  ;; UCS WORLD
  ;; ---------------------------------

  (command "_UCS" "_W")

  ;; ---------------------------------
  ;; WCZYTANIE DANYCH
  ;; ---------------------------------

  (setq taz_s_x_data taz_s_axis_data_x)
  (setq taz_s_y_data taz_s_axis_data_y)
  (setq taz_s_z_data taz_s_axis_data_z)

  ;; ---------------------------------
  ;; POBRANIE ODLEGLOSCI
  ;; ---------------------------------

  (defun taz_s_get_dist ()
    (setq taz_s_i 1)
    (setq taz_s_len (strlen taz_s_row))
    (while
      (and
        (<= taz_s_i taz_s_len)
        (/= (substr taz_s_row taz_s_i 1) "]")
      )
      (setq taz_s_i (+ taz_s_i 1))
    )
    (setq taz_s_i (+ taz_s_i 3))
    (setq taz_s_val
      (atof (substr taz_s_row taz_s_i))
    )
  )

  ;; ---------------------------------
  ;; POBRANIE NAZWY OSI Z WIERSZA
  ;; Format wiersza: "[nazwa]  odleglosc"
  ;; ---------------------------------

  (defun taz_s_get_name ()
    (setq taz_s_i 2)
    (setq taz_s_res "")
    (while (/= (substr taz_s_row taz_s_i 1) "]")
      (setq taz_s_res (strcat taz_s_res (substr taz_s_row taz_s_i 1)))
      (setq taz_s_i (+ taz_s_i 1))
    )
  )

  ;; ---------------------------------
  ;; MIN
  ;; ---------------------------------

  (defun taz_s_min ()
    (setq taz_s_m (car taz_s_list))
    (setq taz_s_list (cdr taz_s_list))
    (while taz_s_list
      (if (< (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list))
      )
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  ;; ---------------------------------
  ;; MAX
  ;; ---------------------------------

  (defun taz_s_max ()
    (setq taz_s_m (car taz_s_list))
    (setq taz_s_list (cdr taz_s_list))
    (while taz_s_list
      (if (> (car taz_s_list) taz_s_m)
        (setq taz_s_m (car taz_s_list))
      )
      (setq taz_s_list (cdr taz_s_list))
    )
  )

  ;; ---------------------------------
  ;; X VALUES
  ;; ---------------------------------

  (setq taz_s_xvals '())
  (setq taz_s_tmp taz_s_x_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_xvals (append taz_s_xvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; Y VALUES
  ;; ---------------------------------

  (setq taz_s_yvals '())
  (setq taz_s_tmp taz_s_y_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_yvals (append taz_s_yvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; Z VALUES
  ;; ---------------------------------

  (setq taz_s_zvals '())
  (setq taz_s_tmp taz_s_z_data)
  (while taz_s_tmp
    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_zvals (append taz_s_zvals (list taz_s_val)))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; GRANICE MODELU
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals) (taz_s_min) (setq taz_s_xmin taz_s_m)
  (setq taz_s_list taz_s_yvals) (taz_s_max) (setq taz_s_xmax taz_s_m)
  (setq taz_s_list taz_s_xvals) (taz_s_min) (setq taz_s_ymin taz_s_m)
  (setq taz_s_list taz_s_xvals) (taz_s_max) (setq taz_s_ymax taz_s_m)
  (setq taz_s_list taz_s_zvals) (taz_s_min) (setq taz_s_zmin taz_s_m)
  (setq taz_s_list taz_s_zvals) (taz_s_max) (setq taz_s_zmax taz_s_m)

  ;; ---------------------------------
  ;; MARGINES PROSTOKATOW
  ;; ---------------------------------

  (setq taz_s_xmin (- taz_s_xmin 1000))
  (setq taz_s_xmax (+ taz_s_xmax 1000))
  (setq taz_s_ymin (- taz_s_ymin 1000))
  (setq taz_s_ymax (+ taz_s_ymax 1000))
  (setq taz_s_zmin (- taz_s_zmin 1000))
  (setq taz_s_zmax (+ taz_s_zmax 1000))

  ;; ---------------------------------
  ;; WARSTWA execution_design
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_execution_design"))
    (command "_LAYER" "_M" "taz_s_execution_design" "_C" "30" "" "")
  )

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTWY execution_design
  ;; ---------------------------------

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_execution_design")))
  )
  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTWY editing_layer
  ;; (wyniki poprzednich intersectow jesli skrypt byl juz uruchamiany)
  ;; ---------------------------------

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_editing_layer")))
  )
  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  ;; ---------------------------------
  ;; SELEKCJA ORYGINALU - raz, przed wszystkimi petlami
  ;;
  ;; Zbieramy enames oryginalu teraz gdy w rysunku sa tylko:
  ;;   - oryginalny model
  ;;   - osie (taz_s_axes)
  ;; Wykluczone: osie, execution_design, editing_layer
  ;; ---------------------------------

  (setq taz_s_orig_ss
    (ssget "X"
      (list
        (cons -4 "<AND")
        (cons -4 "<NOT") (cons 8 "taz_s_axes")             (cons -4 "NOT>")
        (cons -4 "<NOT") (cons 8 "taz_s_execution_design") (cons -4 "NOT>")
        (cons -4 "<NOT") (cons 8 "taz_s_editing_layer")    (cons -4 "NOT>")
        (cons -4 "AND>")
      )
    )
  )

  ;; Zamien selection set na liste enames - bedziemy ja uzywac
  ;; do wykluczania oryginalu przy ssget w kazdym przypadku
  (setq taz_s_orig_enames '())
  (if taz_s_orig_ss
    (progn
      (setq taz_s_oi 0)
      (while (< taz_s_oi (sslength taz_s_orig_ss))
        (setq taz_s_orig_enames
          (append taz_s_orig_enames
            (list (ssname taz_s_orig_ss taz_s_oi))
          )
        )
        (setq taz_s_oi (+ taz_s_oi 1))
      )
    )
  )

  ;; ---------------------------------
  ;; POMOCNICZA: sprawdz czy ename jest na liscie oryginalu
  ;; ---------------------------------

  (defun taz_s_is_original (taz_s_ent)
    (setq taz_s_found nil)
    (setq taz_s_oi 0)
    (while (< taz_s_oi (length taz_s_orig_enames))
      (if (equal taz_s_ent (nth taz_s_oi taz_s_orig_enames))
        (setq taz_s_found T)
      )
      (setq taz_s_oi (+ taz_s_oi 1))
    )
    taz_s_found
  )

  ;; ---------------------------------
  ;; POMOCNICZA: INTERSECT PARAMI
  ;;
  ;; Argumenty:
  ;;   taz_s_cut_ename  - ename bryly tnacej (wzorzec)
  ;;   taz_s_elems_list - lista ename elementow kopii do obrobki
  ;;
  ;; Przed kazdym intersectem ustawia warstwe na taz_s_editing_layer
  ;; dzieki czemu wyniki intersect trafiaja na te warstwe.
  ;; Dla wszystkich elementow oprocz ostatniego: kopiuje bryle tnaca
  ;; w to samo miejsce i uzywa duplikatu. Ostatni element: uzywa
  ;; oryginalnej bryly tnacej bezposrednio (oszczednosc jednego COPY).
  ;; ---------------------------------

  (defun taz_s_intersect_pairs (taz_s_cut_ename taz_s_elems_list)

    (setq taz_s_ei 0)
    (setq taz_s_total_elems (length taz_s_elems_list))

    (while (< taz_s_ei taz_s_total_elems)

      (setq taz_s_target_ent (nth taz_s_ei taz_s_elems_list))

      (if (< taz_s_ei (- taz_s_total_elems 1))

        ;; Nie ostatni: kopiuj bryle tnaca w to samo miejsce
        (progn
          (setq taz_s_cut_ss1 (ssadd))
          (ssadd taz_s_cut_ename taz_s_cut_ss1)
          (command "COPY" taz_s_cut_ss1 "" "0,0,0" "0,0,0")
          (setq taz_s_cut_work_ent (entlast))
        )

        ;; Ostatni: uzyj oryginalnej bryly tnacej
        (setq taz_s_cut_work_ent taz_s_cut_ename)
      )

      ;; Ustaw warstwe na editing_layer - wynik intersect trafi tam
      (setvar "CLAYER" "taz_s_editing_layer")

      ;; Wykonaj INTERSECT
      (setq taz_s_int_ss (ssadd))
      (ssadd taz_s_cut_work_ent taz_s_int_ss)
      (ssadd taz_s_target_ent   taz_s_int_ss)
      (command "INTERSECT" taz_s_int_ss "")

      (setq taz_s_ei (+ taz_s_ei 1))
    )
  )

  ;; ---------------------------------
  ;; POMOCNICZA: ZBIERZ ENAMES KOPII BIEZACEGO PRZYPADKU
  ;;
  ;; Pobiera wszystko oprocz:
  ;;   - warstwy osi (taz_s_axes)
  ;;   - warstwy bryly tnacej (taz_s_execution_design)
  ;;   - warstwy wynikow intersect (taz_s_editing_layer)
  ;; ...a nastepnie wyklucza oryginalne enames modelu.
  ;; To co zostaje to wylacznie elementy skopiowane dla biezacego przypadku.
  ;; ---------------------------------

  (defun taz_s_collect_copy_enames ()

    (setq taz_s_copy_enames '())

    (setq taz_s_all_candidate
      (ssget "X"
        (list
          (cons -4 "<AND")
          (cons -4 "<NOT") (cons 8 "taz_s_axes")             (cons -4 "NOT>")
          (cons -4 "<NOT") (cons 8 "taz_s_execution_design") (cons -4 "NOT>")
          (cons -4 "<NOT") (cons 8 "taz_s_editing_layer")    (cons -4 "NOT>")
          (cons -4 "AND>")
        )
      )
    )

    (if taz_s_all_candidate
      (progn
        (setq taz_s_ci 0)
        (while (< taz_s_ci (sslength taz_s_all_candidate))
          (setq taz_s_cand_ent (ssname taz_s_all_candidate taz_s_ci))
          (if (not (taz_s_is_original taz_s_cand_ent))
            (setq taz_s_copy_enames
              (append taz_s_copy_enames (list taz_s_cand_ent))
            )
          )
          (setq taz_s_ci (+ taz_s_ci 1))
        )
      )
    )

    taz_s_copy_enames
  )

  ;; ---------------------------------
  ;; POMOCNICZA: ZAPISZ SELECTION SET I VIEW DLA PRZYPADKU
  ;;
  ;; Argumenty:
  ;;   taz_s_case_name  - nazwa osi np. "x1"
  ;;   taz_s_cut_ename  - ename aktualnej bryly tnacej
  ;;                      (uzywana do ustawienia viewpoint)
  ;;
  ;; Funkcja:
  ;;   1. Zapisuje ss wszystkich obiektow z warstwy
  ;;      taz_s_execution_design do globalnej listy
  ;;      taz_s_ed_section_sets pod kluczem (nazwa_osi . ss)
  ;;   2. Ustawia viewpoint prostopadle do plaszczyzny bryly
  ;;      tnacej i zapisuje nazwany widok
  ;;      "taz_s_execution_design_view_<nazwa_osi>"
  ;; ---------------------------------

  (defun taz_s_save_section_set_and_view (taz_s_case_name taz_s_cut_ename taz_s_case_axis)

    ;; --- 1. SELECTION SET obiektow z warstwy execution_design ---
    ;; Zbieramy wszystko co aktualnie jest na tej warstwie
    ;; (jest tam tylko bryła tnąca biezacego przypadku, bo poprzednie
    ;; już zniknęły w INTERSECT - bryła tnąca jest wchłaniana)

    (setq taz_s_ed_ss_current
      (ssget "X" '((8 . "taz_s_execution_design")))
    )

    ;; Jesli jest cos na warstwie - zapiszmy do globalnej listy
    ;; taz_s_ed_section_sets to lista par: '(("x1" . ss) ("y1" . ss) ...)
    (if taz_s_ed_ss_current
      (progn
        ;; Inicjalizacja listy jesli jeszcze nie istnieje
        (if (not (boundp 'taz_s_ed_section_sets))
          (setq taz_s_ed_section_sets '())
        )
        (setq taz_s_ed_section_sets
          (append taz_s_ed_section_sets
            (list (cons taz_s_case_name taz_s_ed_ss_current))
          )
        )
      )
    )

    ;; --- 2. NAMED VIEW rownolegly do plaszczyzny tnacej ---
    ;; Ustawiamy viewpoint zgodnie z kierunkiem normalnym plaszczyzny:
    ;;   przypadki X (przekroj wzdluz Y) -> viewpoint z osi Y -> (0 -1 0)
    ;;   przypadki Y (przekroj wzdluz X) -> viewpoint z osi X -> (-1 0 0)
    ;;   przypadki Z (przekroj poziomy)  -> viewpoint z gory  -> (0 0 -1)
    ;;
    ;; Uzywamy -VIEW _O aby zoom objal bryle tnaca,
    ;; potem -VIEW _S aby zapisac widok pod nazwa.

    (setq taz_s_view_name
      (strcat "taz_s_execution_design_view_" taz_s_case_name)
    )

    ;; Zoom na bryle tnaca - zeby widok byl dobrze wycentrowany
    (command "_ZOOM" "_OBJECT" (ssname (ssget "X" '((8 . "taz_s_execution_design"))) 0) "")
    (command "_ZOOM" "_SCALE" "1.2X")

    ;; Ustaw viewpoint prostopadle do plaszczyzny tnacej
    (cond
      ((= taz_s_case_axis "x")
       ;; Plaszczyzna prostopadla do Y -> patrzymy wzdluz +Y
       (command "_VPOINT" "0,-1,0")
      )
      ((= taz_s_case_axis "y")
       ;; Plaszczyzna prostopadla do X -> patrzymy wzdluz +X
       (command "_VPOINT" "-1,0,0")
      )
      ((= taz_s_case_axis "z")
       ;; Plaszczyzna pozioma -> patrzymy z gory
       (command "_VPOINT" "0,0,-1")
      )
    )

    ;; Zoom ponownie po zmianie viewpoint - obiekt moze sie nie miescic
    (setq taz_s_ed_ss_for_zoom
      (ssget "X" '((8 . "taz_s_execution_design")))
    )
    (if taz_s_ed_ss_for_zoom
      (progn
        (command "_ZOOM" "_OBJECT" (ssname taz_s_ed_ss_for_zoom 0) "")
        (command "_ZOOM" "_SCALE" "1.2X")
      )
    )

    ;; Zapisz nazwany widok
    (command "-VIEW" "_S" taz_s_view_name)

    (princ (strcat "\n[PLOT] Zapisano view: " taz_s_view_name))
  )

  ;; ---------------------------------
  ;; INICJALIZACJA GLOBALNEJ LISTY SETOW
  ;; Czyscimy liste przed kazda pelna sesja skryptu
  ;; ---------------------------------

  (setq taz_s_ed_section_sets '())

  ;; =================================================================
  ;; GLOWNA PETLA - jeden przypadek na raz:
  ;;   1. Narysuj bryle tnaca w strefie Z tego przypadku
  ;;   2. Skopiuj oryginalny model do tej samej strefy Z
  ;;   3. Zbierz enames kopii (bez oryginalu, bez pomocniczych warstw)
  ;;   4. Intersect parami (wyniki na taz_s_editing_layer)
  ;;   5. [NOWE] Zapisz ss warstwy execution_design i named view
  ;; =================================================================

  (setq taz_s_copy_nr 1)

  ;; -------------------------------------------------------
  ;; PRZYPADKI X
  ;; Plaszczyzna prostopadla do osi Y
  ;; -------------------------------------------------------

  (setq taz_s_tmp taz_s_x_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_y taz_s_val)
    ;; Pobierz nazwe osi - potrzebna do nazwania setu i view
    (taz_s_get_name)
    (setq taz_s_case_axis_name taz_s_res)

    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca
    (setvar "CLAYER" "taz_s_execution_design")

    (setq taz_s_p1 (list taz_s_xmin taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_xmax taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_xmax taz_s_y (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_xmin taz_s_y (+ taz_s_zmax taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (command "EXTRUDE" (entlast) "" "1000" "0")
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")
    (command "MOVE" (entlast) "" "0,0,0" "0,-500,0")
    (setq taz_s_cutting_ename (entlast))

    ;; KROK 2: skopiuj oryginalny model
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames)
      (princ (strcat "\nPrzypadek X nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    ;; KROK 5: [NOWE] Zapisz selection set i named view
    ;; UWAGA: wykonujemy to gdy bryla tnaca WCIAZ ISTNIEJE na warstwie
    ;; execution_design (taz_s_intersect_pairs zuzywa bryle jako argument
    ;; INTERSECT, ktory moze ja zniszczyc - sprawdzamy czy nadal jest)
    ;; Jesli bryly nie ma (zostala zniszczona przez INTERSECT),
    ;; tworzymy chwilowy prostopadly marker do zapamiecia widoku
    (taz_s_save_section_set_and_view taz_s_case_axis_name taz_s_cutting_ename "x")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; -------------------------------------------------------
  ;; PRZYPADKI Y
  ;; Plaszczyzna prostopadla do osi X
  ;; -------------------------------------------------------

  (setq taz_s_tmp taz_s_y_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_x taz_s_val)
    ;; Pobierz nazwe osi
    (taz_s_get_name)
    (setq taz_s_case_axis_name taz_s_res)

    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca
    (setvar "CLAYER" "taz_s_execution_design")

    (setq taz_s_p1 (list taz_s_x taz_s_ymin (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_x taz_s_ymax (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_x taz_s_ymax (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_x taz_s_ymin (+ taz_s_zmax taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (command "EXTRUDE" (entlast) "" "1000" "0")
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")
    (command "MOVE" (entlast) "" "0,0,0" "-500,0,0")
    (setq taz_s_cutting_ename (entlast))

    ;; KROK 2: skopiuj oryginalny model
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames)
      (princ (strcat "\nPrzypadek Y nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    ;; KROK 5: [NOWE] Zapisz selection set i named view
    (taz_s_save_section_set_and_view taz_s_case_axis_name taz_s_cutting_ename "y")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; -------------------------------------------------------
  ;; PRZYPADKI Z
  ;; Plaszczyzna pozioma
  ;; -------------------------------------------------------

  (setq taz_s_tmp taz_s_z_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_z taz_s_val)
    ;; Pobierz nazwe osi
    (taz_s_get_name)
    (setq taz_s_case_axis_name taz_s_res)

    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca
    (setvar "CLAYER" "taz_s_execution_design")

    (setq taz_s_p1 (list taz_s_xmin taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_xmax taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_xmax taz_s_ymax (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_xmin taz_s_ymax (+ taz_s_z taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")
    (command "EXTRUDE" (entlast) "" "1000" "0")
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")
    (command "MOVE" (entlast) "" "0,0,0" "0,0,-500")
    (setq taz_s_cutting_ename (entlast))

    ;; KROK 2: skopiuj oryginalny model
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames)
      (princ (strcat "\nPrzypadek Z nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    ;; KROK 5: [NOWE] Zapisz selection set i named view
    (taz_s_save_section_set_and_view taz_s_case_axis_name taz_s_cutting_ename "z")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  (taz_s_lock_all_layers)
  (taz_s_current_settings_restore)

  (princ (strcat "\n[PLOT] Gotowe. Liczba zapisanych przypadkow: " (itoa (length taz_s_ed_section_sets))))
  (princ)
)
