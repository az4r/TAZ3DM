(defun taz_s_merge_solprof_layers ()

  (setq taz_s_layer_rec (tblnext "LAYER" T))

  (while taz_s_layer_rec

    (setq taz_s_layer_name
          (cdr (assoc 2 taz_s_layer_rec))
    )

    ;; PH* -> taz_s_hidden
    (if (= "PH"
           (strcase
             (substr
               taz_s_layer_name
               1
               (min 2 (strlen taz_s_layer_name))
             )
           )
        )
      (progn

        ;; Rozbij bloki
        (setq taz_s_blkss
              (ssget "X"
                     (list
                       (cons 8 taz_s_layer_name)
                       (cons 0 "INSERT")
                     )
              )
        )

        (if taz_s_blkss
          (command "_.explode" taz_s_blkss)
        )

        ;; Pobierz wszystkie obiekty po rozbiciu
        (setq taz_s_ss
              (ssget "X"
                     (list (cons 8 taz_s_layer_name))
              )
        )

        (if taz_s_ss
          (progn

            (setq taz_s_idx (sslength taz_s_ss))

            (repeat taz_s_idx

              (setq taz_s_idx (1- taz_s_idx))

              (setq taz_s_ent
                    (ssname taz_s_ss taz_s_idx)
              )

              (setq taz_s_edata
                    (entget taz_s_ent)
              )

              (entmod
                (subst
                  (cons 8 "taz_s_hidden")
                  (assoc 8 taz_s_edata)
                  taz_s_edata
                )
              )

            )
          )
        )
      )
    )

    ;; PV* -> taz_s_visible
    (if (= "PV"
           (strcase
             (substr
               taz_s_layer_name
               1
               (min 2 (strlen taz_s_layer_name))
             )
           )
        )
      (progn

        ;; Rozbij bloki
        (setq taz_s_blkss
              (ssget "X"
                     (list
                       (cons 8 taz_s_layer_name)
                       (cons 0 "INSERT")
                     )
              )
        )

        (if taz_s_blkss
          (command "_.explode" taz_s_blkss)
        )

        ;; Pobierz wszystkie obiekty po rozbiciu
        (setq taz_s_ss
              (ssget "X"
                     (list (cons 8 taz_s_layer_name))
              )
        )

        (if taz_s_ss
          (progn

            (setq taz_s_idx (sslength taz_s_ss))

            (repeat taz_s_idx

              (setq taz_s_idx (1- taz_s_idx))

              (setq taz_s_ent
                    (ssname taz_s_ss taz_s_idx)
              )

              (setq taz_s_edata
                    (entget taz_s_ent)
              )

              (entmod
                (subst
                  (cons 8 "taz_s_visible")
                  (assoc 8 taz_s_edata)
                  taz_s_edata
                )
              )

            )
          )
        )
      )
    )

    (setq taz_s_layer_rec (tblnext "LAYER"))
  )
  
  ;; Purge bloków *u...
  (setq taz_s_block_rec (tblnext "BLOCK" T))

  (while taz_s_block_rec

    (setq taz_s_block_name
          (cdr (assoc 2 taz_s_block_rec))
    )

    (if (= "*U"
          (strcase
            (substr
              taz_s_block_name
              1
              (min 2 (strlen taz_s_block_name))
            )
          )
        )
      (command "_.-purge" "_B" taz_s_block_name "_N")
    )

    (setq taz_s_block_rec (tblnext "BLOCK"))
  )

  ;; Usuń puste warstwy PH* i PV*
  (setq taz_s_layer_rec (tblnext "LAYER" T))

  (while taz_s_layer_rec

    (setq taz_s_layer_name
          (cdr (assoc 2 taz_s_layer_rec))
    )

    (if (or
          (= "PH"
            (strcase
              (substr
                taz_s_layer_name
                1
                (min 2 (strlen taz_s_layer_name))
              )
            )
          )
          (= "PV"
            (strcase
              (substr
                taz_s_layer_name
                1
                (min 2 (strlen taz_s_layer_name))
              )
            )
          )
        )
      (command "_.-layer" "_delete" taz_s_layer_name "")
    )

    (setq taz_s_layer_rec (tblnext "LAYER"))
  )
  
  (command "_.REGEN")

  (princ "\nPrzeniesiono obiekty z warstw PH* i PV*.")
  (princ)
)

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
  ;; GRANICE BEZ MARGINESU
  ;; ---------------------------------
  
  (setq taz_s_xmin_nomargin taz_s_xmin)
  (setq taz_s_xmax_nomargin taz_s_xmax)
  (setq taz_s_ymin_nomargin taz_s_ymin)
  (setq taz_s_ymax_nomargin taz_s_ymax)
  (setq taz_s_zmin_nomargin taz_s_zmin)
  (setq taz_s_zmax_nomargin taz_s_zmax)

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
        (cons 67 0)                                          ; tylko model space
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
  ;; POMOCNICZA: PRZENIES ATRYBUTY Z ORYGINALU NA KOPIE
  ;; Zaraz po COPY oryginal i kopia istnieja obok siebie. Nowe
  ;; kopie powstaja w tej samej kolejnosci co taz_s_orig_enames,
  ;; wiec parujemy je pozycyjnie. Dla kazdej pary tworzymy nowa
  ;; zmienna globalna pod handle KOPII, z wartoscia skopiowana
  ;; z odpowiedniego oryginalu - jesli oryginal w ogole ja mial.
  ;; ---------------------------------

  (defun taz_s_copy_attrs_to_copies (taz_s_last_before)
    (setq taz_s_new_ent (entnext taz_s_last_before))
    (setq taz_s_map_index 0)
    (while taz_s_new_ent
      (setq taz_s_orig_h
        (cdr (assoc 5 (entget (nth taz_s_map_index taz_s_orig_enames))))
      )
      (setq taz_s_new_h (cdr (assoc 5 (entget taz_s_new_ent))))

      (setq taz_s_orig_attr6_sym (read (strcat "taz_s_" taz_s_orig_h "_attr6")))
      (if (boundp taz_s_orig_attr6_sym)
        (set (read (strcat "taz_s_" taz_s_new_h "_attr6")) (eval taz_s_orig_attr6_sym))
      )

      (setq taz_s_orig_attr7_sym (read (strcat "taz_s_" taz_s_orig_h "_attr7")))
      (if (boundp taz_s_orig_attr7_sym)
        (set (read (strcat "taz_s_" taz_s_new_h "_attr7")) (eval taz_s_orig_attr7_sym))
      )
      
      (setq taz_s_orig_sweep_p1_sym (read (strcat "taz_s_" taz_s_orig_h "_sweep_p1")))
      (if (boundp taz_s_orig_sweep_p1_sym)
        (set (read (strcat "taz_s_" taz_s_new_h "_sweep_p1")) (eval taz_s_orig_sweep_p1_sym))
      )

      (setq taz_s_orig_sweep_p2_sym (read (strcat "taz_s_" taz_s_orig_h "_sweep_p2")))
      (if (boundp taz_s_orig_sweep_p2_sym)
        (set (read (strcat "taz_s_" taz_s_new_h "_sweep_p2")) (eval taz_s_orig_sweep_p2_sym))
      )

      (setq taz_s_map_index (+ taz_s_map_index 1))
      (setq taz_s_new_ent (entnext taz_s_new_ent))
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
  ;; POMOCNICZA: SRODEK SCIEZKI SWEEP ORYGINALNEGO PROFILU
  ;; ---------------------------------

  (defun taz_s_get_center (taz_s_ent)
    (setq taz_s_annotation_h (cdr (assoc 5 (entget taz_s_ent))))
    (setq taz_s_annotation_p1
      (eval (read (strcat "taz_s_" taz_s_annotation_h "_sweep_p1")))
    )
    (setq taz_s_annotation_p2
      (eval (read (strcat "taz_s_" taz_s_annotation_h "_sweep_p2")))
    )
    (if (and taz_s_annotation_p1 taz_s_annotation_p2)
      (list
        (/ (+ (car taz_s_annotation_p1) (car taz_s_annotation_p2)) 2.0)
        (/ (+ (cadr taz_s_annotation_p1) (cadr taz_s_annotation_p2)) 2.0)
        (+ (/ (+ (caddr taz_s_annotation_p1) (caddr taz_s_annotation_p2)) 2.0) taz_s_zoffset)
      )
      (progn
        ;;(princ (strcat "\nUWAGA: brak danych linii sterujacej " taz_s_annotation_h ", uzywam (0,0,0)"))
        (list 0.0 0.0 taz_s_zoffset)
      )
    )
  )
  
  ;; ---------------------------------
  ;; POMOCNICZA: PRZECIECIE ODCINKA Z PLASZCZYZNA (X=const lub Y=const)
  ;; taz_s_annotation_coord_index: 0 = wspolrzedna X, 1 = wspolrzedna Y
  ;; Zwraca punkt przeciecia jesli odcinek p1-p2 rzeczywiscie
  ;; przecina te plaszczyzne (t w zakresie 0..1), w przeciwnym
  ;; razie nil (linia rownolegla do plaszczyzny lub przeciecie
  ;; poza odcinkiem).
  ;; ---------------------------------

  (defun taz_s_line_plane_intersect (taz_s_annotation_p1 taz_s_annotation_p2 taz_s_annotation_coord_index taz_s_annotation_target_val)
    (setq taz_s_annotation_v1 (nth taz_s_annotation_coord_index taz_s_annotation_p1))
    (setq taz_s_annotation_v2 (nth taz_s_annotation_coord_index taz_s_annotation_p2))
    (setq taz_s_annotation_denom (- taz_s_annotation_v2 taz_s_annotation_v1))
    (if (equal taz_s_annotation_denom 0.0 1e-8)
      nil
      (progn
        (setq taz_s_annotation_t (/ (- taz_s_annotation_target_val taz_s_annotation_v1) taz_s_annotation_denom))
        (if (and (>= taz_s_annotation_t 0.0) (<= taz_s_annotation_t 1.0))
          (list
            (+ (car   taz_s_annotation_p1) (* taz_s_annotation_t (- (car   taz_s_annotation_p2) (car   taz_s_annotation_p1))))
            (+ (cadr  taz_s_annotation_p1) (* taz_s_annotation_t (- (cadr  taz_s_annotation_p2) (cadr  taz_s_annotation_p1))))
            (+ (caddr taz_s_annotation_p1) (* taz_s_annotation_t (- (caddr taz_s_annotation_p2) (caddr taz_s_annotation_p1))))
          )
          nil
        )
      )
    )
  )

  ;; ---------------------------------
  ;; POMOCNICZA: PUNKT PRZECIECIA SCIEZKI SWEEP Z PLASZCZYZNA CIECIA
  ;; Zwraca punkt lub nil jesli sciezka nie przecina danej plaszczyzny
  ;; ---------------------------------

  (defun taz_s_get_sweep_plane_point (taz_s_annotation_ent taz_s_annotation_coord_index taz_s_annotation_target_val)
    (setq taz_s_annotation_sp_h (cdr (assoc 5 (entget taz_s_annotation_ent))))
    (setq taz_s_annotation_sp1 (eval (read (strcat "taz_s_" taz_s_annotation_sp_h "_sweep_p1"))))
    (setq taz_s_annotation_sp2 (eval (read (strcat "taz_s_" taz_s_annotation_sp_h "_sweep_p2"))))
    (if (and taz_s_annotation_sp1 taz_s_annotation_sp2)
      (taz_s_line_plane_intersect taz_s_annotation_sp1 taz_s_annotation_sp2 taz_s_annotation_coord_index taz_s_annotation_target_val)
      nil
    )
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
  ;;
  ;; Dodatkowo: przed kazdym intersectem sprawdzamy przez -INTERFERE
  ;; (na warstwie "0") czy przeciecie danej pary w ogole wystepuje.
  ;; Jesli tak - entlast sie zmienia (powstaje bryla interferencji) -
  ;; wtedy sprzatamy wszystko co powstalo na warstwie "0". Jesli nie -
  ;; entlast sie nie zmienia - nic nie sprzatamy, bo nic nie powstalo.
  ;; Po samym -INTERFERE lecimy pusta komenda kilka razy, zeby
  ;; wyzerowac linie polecen niezaleznie od tego czy padlo pytanie
  ;; o utworzenie bryly wynikowej czy nie.
  ;; ---------------------------------
  (defun taz_s_intersect_pairs (taz_s_cut_ename taz_s_elems_list taz_s_case)
    (setq taz_s_ei 0)
    (setq taz_s_total_elems (length taz_s_elems_list))
    (while (< taz_s_ei taz_s_total_elems)
      (setq taz_s_target_ent (nth taz_s_ei taz_s_elems_list))
      (setq taz_s_orig_ent (nth taz_s_ei taz_s_orig_enames))
      ;; --- SPRAWDZENIE CZY WYSTEPUJE PRZECIECIE (-INTERFERE) ---
      ;; Kopiujemy bryle tnaca na miejsce oryginalu (bez zoffset),
      ;; sprawdzamy przeciecie wzgledem ORYGINALU, potem kasujemy kopie.
      (setvar "CLAYER" "taz_s_editing_layer")
      (setq taz_s_cut_tmp_ss (ssadd))
      (ssadd taz_s_cut_ename taz_s_cut_tmp_ss)
      (command "COPY" taz_s_cut_tmp_ss "" "0,0,0" (list 0 0 (- taz_s_zoffset)))
      (setq taz_s_cut_tmp_ent (entlast))
      (setq taz_s_layer0_ss_before (ssget "X" (list (cons 8 "taz_s_editing_layer"))))
      (setq taz_s_layer0_count_before (if taz_s_layer0_ss_before (sslength taz_s_layer0_ss_before) 0))
      (setq taz_s_if_set1 (ssadd))
      (ssadd taz_s_cut_tmp_ent taz_s_if_set1)
      (setq taz_s_if_set2 (ssadd))
      (ssadd taz_s_orig_ent taz_s_if_set2)
      (command "-INTERFERE" taz_s_if_set1 "" taz_s_if_set2 "" "Y")
      (command)
      (command)
      (command)
      (setq taz_s_layer0_ss (ssget "X" (list (cons 8 "taz_s_editing_layer"))))
      (setq taz_s_layer0_count_after (if taz_s_layer0_ss (sslength taz_s_layer0_ss) 0))
      (if (> taz_s_layer0_count_after taz_s_layer0_count_before)
        (progn
          (if taz_s_layer0_ss
            (command "ERASE" taz_s_layer0_ss "")
          )
          (setq taz_s_annotation_text
          (strcat
            (eval (read (strcat "taz_s_" (cdr (assoc 5 (entget taz_s_orig_ent))) "_attr6")))
            " "
            (eval (read (strcat "taz_s_" (cdr (assoc 5 (entget taz_s_orig_ent))) "_attr7")))
          )
          )
          ;; Punkt wstawienia - skorygowany wzgledem plaszczyzny ciecia
          (setq taz_s_annotation_ins_pt (taz_s_get_center taz_s_orig_ent))
          (cond
            ((= taz_s_case "X")
             (setq taz_s_annotation_plane_pt
               (taz_s_get_sweep_plane_point taz_s_orig_ent 1 taz_s_y)
             )
             (if taz_s_annotation_plane_pt
               (setq taz_s_annotation_ins_pt
                 (list
                   (car   taz_s_annotation_plane_pt)
                   taz_s_y
                   (+ (caddr taz_s_annotation_plane_pt) taz_s_zoffset)
                 )
               )
               (setq taz_s_annotation_ins_pt
                 (list
                   (car   taz_s_annotation_ins_pt)
                   taz_s_y
                   (caddr taz_s_annotation_ins_pt)
                 )
               )
             )
            )
            ((= taz_s_case "Y")
             (setq taz_s_annotation_plane_pt
               (taz_s_get_sweep_plane_point taz_s_orig_ent 0 taz_s_x)
             )
             (if taz_s_annotation_plane_pt
               (setq taz_s_annotation_ins_pt
                 (list
                   taz_s_x
                   (cadr  taz_s_annotation_plane_pt)
                   (+ (caddr taz_s_annotation_plane_pt) taz_s_zoffset)
                 )
               )
               (setq taz_s_annotation_ins_pt
                 (list
                   taz_s_x
                   (cadr  taz_s_annotation_ins_pt)
                   (caddr taz_s_annotation_ins_pt)
                 )
               )
             )
            )
            ((= taz_s_case "Z")
             (setq taz_s_annotation_plane_pt
               (taz_s_get_sweep_plane_point taz_s_orig_ent 2 taz_s_z)
             )
             (if taz_s_annotation_plane_pt
               (setq taz_s_annotation_ins_pt
                 (list
                   (car  taz_s_annotation_plane_pt)
                   (cadr taz_s_annotation_plane_pt)
                   (+ taz_s_z taz_s_zoffset)
                 )
               )
               (setq taz_s_annotation_ins_pt
                 (list
                   (car  taz_s_annotation_ins_pt)
                   (cadr taz_s_annotation_ins_pt)
                   (+ taz_s_z taz_s_zoffset)
                 )
               )
             )
            )
          )
          (entmake
            (list
              (cons 0 "MTEXT")
              (cons 10 taz_s_annotation_ins_pt)
              (cons 1 taz_s_annotation_text)
              (cons 7 "Standard")
              (cons 8 "taz_s_labels")   ; <- warstwa od razu przy tworzeniu
              (cons 40 150) ; wysokość tekstu
              (cons 71 5)   ; wyrównanie: 1 = górne lewe
              (cons 90 16)
            )
          )
          ;; Obrot etykiety do plaszczyzny ciecia (analogicznie do opisow osi)
          (cond
            ((= taz_s_case "X")
             (command "_.ROTATE3D" (entlast) "" "X" taz_s_annotation_ins_pt "90")
            )
            ((= taz_s_case "Y")
             (command "_.ROTATE3D" (entlast) "" "Y" taz_s_annotation_ins_pt "90")
             (command "_.ROTATE3D" (entlast) "" "X" taz_s_annotation_ins_pt "90")
            )
          )
        )
      )
      ;; usun tymczasowa kopie bryly tnacej - nie jest juz potrzebna
      (entdel taz_s_cut_tmp_ent)
      ;; --- KONIEC SPRAWDZENIA ---
      ;; Zawsze kopiuj bryle tnaca - oryginał zostaje nienaruszony
      (setq taz_s_cut_ss1 (ssadd))
      (ssadd taz_s_cut_ename taz_s_cut_ss1)
      (command "COPY" taz_s_cut_ss1 "" "0,0,0" "0,0,0")
      (setq taz_s_cut_work_ent (entlast))
      (setvar "CLAYER" "taz_s_editing_layer")
      (setq taz_s_int_ss (ssadd))
      (ssadd taz_s_cut_work_ent taz_s_int_ss)      
      (ssadd taz_s_target_ent   taz_s_int_ss)
      (command "INTERSECT" taz_s_int_ss "")
      (setq taz_s_ei (+ taz_s_ei 1))
    )
    ;; Oryginal bryly tnacej nigdy nie byl uzyty w INTERSECT
    ;; wiec na pewno nadal istnieje - kasujemy go tutaj
    (entdel taz_s_cut_ename)
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
          (cons 67 0)
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

          ;; FILTR: tylko 3DSOLID
          (setq taz_s_ed (entget taz_s_cand_ent))
          (setq taz_s_type (cdr (assoc 0 taz_s_ed)))

          (if (and
                (equal taz_s_type "3DSOLID")
                (not (taz_s_is_original taz_s_cand_ent))
              )
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
  ;; POMOCNICZA: POBIERZ NAZWE OSI Z WIERSZA
  ;; Format wiersza: "[X1]  5000.0"
  ;; Zwraca np. "X1"
  ;; ---------------------------------

  (defun taz_s_get_axis_name (taz_s_row_arg)
    (setq taz_s_ni 2)
    (setq taz_s_nres "")
    (while (/= (substr taz_s_row_arg taz_s_ni 1) "]")
      (setq taz_s_nres (strcat taz_s_nres (substr taz_s_row_arg taz_s_ni 1)))
      (setq taz_s_ni (+ taz_s_ni 1))
    )
    taz_s_nres
  )

  ;; =================================================================
  ;; GLOWNA PETLA - jeden przypadek na raz:
  ;;   1. Narysuj bryle tnaca w strefie Z tego przypadku
  ;;   2. Skopiuj oryginalny model do tej samej strefy Z
  ;;   3. Zbierz enames kopii (bez oryginalu, bez pomocniczych warstw)
  ;;   4. Intersect parami (wyniki na taz_s_editing_layer)
  ;; =================================================================

  (setq taz_s_copy_nr 1)
  
  (defun taz_s_get_number (taz_s_txt / taz_s_i taz_s_len taz_s_pos)
    (setq taz_s_i 1
          taz_s_len (strlen taz_s_txt)
          taz_s_pos 0)

    ;; szukamy pierwszej spacji
    (while (and (<= taz_s_i taz_s_len) (= taz_s_pos 0))
      (if (= (substr taz_s_txt taz_s_i 1) " ")
        (setq taz_s_pos taz_s_i)
      )
      (setq taz_s_i (1+ taz_s_i))
    )

    ;; pobieramy wszystko po spacji
    (if taz_s_pos
      (atof (substr taz_s_txt (1+ taz_s_pos)))
      0.0
    )
  )

  ;; -------------------------------------------------------
  ;; PRZYPADKI X
  ;; Plaszczyzna prostopadla do osi Y
  ;; -------------------------------------------------------

  (setq taz_s_tmp taz_s_x_data)
  
  (setq taz_s_initial_solprof 1)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))
    (taz_s_get_dist)
    (setq taz_s_y taz_s_val)
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca i osie
    (setvar "CLAYER" "taz_s_execution_design")
    
    (foreach taz_s_axis taz_s_axis_data_y

      (setq taz_s_x (taz_s_get_number taz_s_axis))
      (setq taz_s_axis_name (taz_s_get_axis_name taz_s_axis))

      ;; linia osi (góra / dół)
      (setq taz_s_p1_axis (list taz_s_x taz_s_y (+ taz_s_zmin taz_s_zoffset)))
      (setq taz_s_p2_axis (list taz_s_x taz_s_y (+ taz_s_zmax taz_s_zoffset)))

      (command "3DPOLY" taz_s_p1_axis taz_s_p2_axis "")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.CIRCLE" (list taz_s_x taz_s_y (- (+ taz_s_zmin taz_s_zoffset) 250.0)) 250.0)
      (setq taz_s_circle_center (list taz_s_x taz_s_y (- (+ taz_s_zmin taz_s_zoffset) 250.0)))
      (command "_.ROTATE3D" (entlast) "" "X" taz_s_circle_center "90")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 0 taz_s_axis_name)
      (command "_.ROTATE3D" (entlast) "" "X" taz_s_circle_center "90")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
    )

    
    (setq taz_s_p1_nomargin (list taz_s_xmin_nomargin taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2_nomargin (list taz_s_xmax_nomargin taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3_nomargin (list taz_s_xmax_nomargin taz_s_y (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4_nomargin (list taz_s_xmin_nomargin taz_s_y (+ taz_s_zmax taz_s_zoffset)))

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
    (command "-VIEW" "_S" "taz_s_view_cutting_view")

    ;; WIDOK: zoom na bryle tnaca zgodnie z kierunkiem extrude (os Y) i zapis widoku
    (setq taz_s_view_axis_name (taz_s_get_axis_name taz_s_row))
    (setq taz_s_view_name (strcat "taz_s_view_" taz_s_view_axis_name))
    (command "_VPOINT" "0,-1,0")
    (command "_ZOOM" "_OBJECT" taz_s_cutting_ename "")
    (command "-VIEW" "_S" taz_s_view_name)
    (command "-VIEW" "_R" "taz_s_view_cutting_view")

    ;; KROK 2: skopiuj oryginalny model
    (setq taz_s_last_before_copy (entlast))
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )
    (taz_s_copy_attrs_to_copies taz_s_last_before_copy)

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames "X")
      (princ (strcat "\nPrzypadek X nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
    
    (command "_layout" "_N" taz_s_view_name)
    (command "_layout" "_S" taz_s_view_name)
    (command "_mspace")
    ;;(command "-VIEW" "_R" taz_s_view_name)
    
    (command "_UCS" "_W")
    (if (= taz_s_initial_solprof 1)
      (command "_PLAN" "_W")
    )
    
    (setq taz_s_initial_solprof 0)
    
    (command "_UCS" "_O" (list (/ (+ taz_s_xmin taz_s_xmax) 2.0) taz_s_y taz_s_zoffset))
    (command "_UCS" "_X" 90)
    (command "_PLAN" "_C")
    ;;(command "_REGEN")
    
    (setq taz_s_solprof_ss (ssget "_X" (list (cons 8 "taz_s_execution_design"))))    
    (command "_.SOLPROF")
    (command taz_s_solprof_ss)
    (command "" "_Y" "_Y" "_Y")
    (command "_.ERASE" (ssget "_X" (list (cons 8 "taz_s_execution_design"))) "")
    (command "_pspace")
    (command "_layout" "_S" "Model")
    
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
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca i osie
    (setvar "CLAYER" "taz_s_execution_design")
    
    (foreach taz_s_axis taz_s_axis_data_x

      ;; Y z tekstu osi
      (setq taz_s_y (taz_s_get_number taz_s_axis))
      (setq taz_s_axis_name (taz_s_get_axis_name taz_s_axis))

      ;; punkty osi
      (setq taz_s_p1_axis (list taz_s_x taz_s_y (+ taz_s_zmin taz_s_zoffset)))
      (setq taz_s_p2_axis (list taz_s_x taz_s_y (+ taz_s_zmax taz_s_zoffset)))

      (command "3DPOLY" taz_s_p1_axis taz_s_p2_axis "")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.CIRCLE" (list taz_s_x taz_s_y (- (+ taz_s_zmin taz_s_zoffset) 250.0)) 250.0)
      (setq taz_s_circle_center (list taz_s_x taz_s_y (- (+ taz_s_zmin taz_s_zoffset) 250.0)))
      (command "_.ROTATE3D" (entlast) "" "Y" taz_s_circle_center "90")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 90 taz_s_axis_name)
      (command "_.ROTATE3D" (entlast) "" "Y" taz_s_circle_center "90")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
    )
    
    (setq taz_s_p1_nomargin (list taz_s_x taz_s_ymin_nomargin (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2_nomargin (list taz_s_x taz_s_ymax_nomargin (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3_nomargin (list taz_s_x taz_s_ymax_nomargin (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4_nomargin (list taz_s_x taz_s_ymin_nomargin (+ taz_s_zmax taz_s_zoffset)))

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
    (command "-VIEW" "_S" "taz_s_view_cutting_view")

    ;; WIDOK: zoom na bryle tnaca zgodnie z kierunkiem extrude (os X) i zapis widoku
    (setq taz_s_view_axis_name (taz_s_get_axis_name taz_s_row))
    (setq taz_s_view_name (strcat "taz_s_view_" taz_s_view_axis_name))
    (command "_VPOINT" "-1,0,0")
    (command "_ZOOM" "_OBJECT" taz_s_cutting_ename "")
    (command "-VIEW" "_S" taz_s_view_name)
    (command "-VIEW" "_R" "taz_s_view_cutting_view")

    ;; KROK 2: skopiuj oryginalny model
    (setq taz_s_last_before_copy (entlast))
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )
    (taz_s_copy_attrs_to_copies taz_s_last_before_copy)

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames "Y")
      (princ (strcat "\nPrzypadek Y nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
    
    (command "_layout" "_N" taz_s_view_name)
    (command "_layout" "_S" taz_s_view_name)
    (command "_mspace")
    ;;(command "-VIEW" "_R" taz_s_view_name)
    
    (command "_UCS" "_W")
    ;;(command "_PLAN" "_W")
    (command "_UCS" "_O" (list taz_s_x (/ (+ taz_s_ymin taz_s_ymax) 2.0) taz_s_zoffset))
    (command "_UCS" "_X" 90)
    (command "_UCS" "_Y" 90)
    (command "_PLAN" "_C")
    ;;(command "_REGEN")
    
    (setq taz_s_solprof_ss (ssget "_X" (list (cons 8 "taz_s_execution_design"))))    
    (command "_.SOLPROF")
    (command taz_s_solprof_ss)
    (command "" "_Y" "_Y" "_Y")
    (command "_.ERASE" (ssget "_X" (list (cons 8 "taz_s_execution_design"))) "")
    (command "_pspace")
    (command "_layout" "_S" "Model")
    
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
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; KROK 1: narysuj bryle tnaca i osie
    (setvar "CLAYER" "taz_s_execution_design")
    
    ;; ----------------------------------------
    ;; Osie X (linie równoległe do osi Y)
    ;; ----------------------------------------

    (foreach taz_s_axis taz_s_axis_data_y

      (setq taz_s_x (taz_s_get_number taz_s_axis))
      (setq taz_s_axis_name (taz_s_get_axis_name taz_s_axis))

      (setq taz_s_p1_axis
            (list taz_s_x
                  taz_s_ymin
                  (+ taz_s_z taz_s_zoffset)))

      (setq taz_s_p2_axis
            (list taz_s_x
                  taz_s_ymax
                  (+ taz_s_z taz_s_zoffset)))

      (command "3DPOLY" taz_s_p1_axis taz_s_p2_axis "")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")

      ;; dolne kółko
      (setq taz_s_circle_center
            (list taz_s_x
                  (- taz_s_ymin 250.0)
                  (+ taz_s_z taz_s_zoffset)))

      (command "_.CIRCLE" taz_s_circle_center 250.0)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 0 taz_s_axis_name)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")

      ;; górne kółko
      (setq taz_s_circle_center
            (list taz_s_x
                  (+ taz_s_ymax 250.0)
                  (+ taz_s_z taz_s_zoffset)))

      (command "_.CIRCLE" taz_s_circle_center 250.0)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 0 taz_s_axis_name)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
    )

    ;; ----------------------------------------
    ;; Osie Y (linie równoległe do osi X)
    ;; ----------------------------------------

    (foreach taz_s_axis taz_s_axis_data_x

      (setq taz_s_y (taz_s_get_number taz_s_axis))
      (setq taz_s_axis_name (taz_s_get_axis_name taz_s_axis))

      (setq taz_s_p1_axis
            (list taz_s_xmin
                  taz_s_y
                  (+ taz_s_z taz_s_zoffset)))

      (setq taz_s_p2_axis
            (list taz_s_xmax
                  taz_s_y
                  (+ taz_s_z taz_s_zoffset)))

      (command "3DPOLY" taz_s_p1_axis taz_s_p2_axis "")
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")

      ;; lewe kółko
      (setq taz_s_circle_center
            (list (- taz_s_xmin 250.0)
                  taz_s_y
                  (+ taz_s_z taz_s_zoffset)))

      (command "_.CIRCLE" taz_s_circle_center 250.0)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 0 taz_s_axis_name)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")

      ;; prawe kółko
      (setq taz_s_circle_center
            (list (+ taz_s_xmax 250.0)
                  taz_s_y
                  (+ taz_s_z taz_s_zoffset)))

      (command "_.CIRCLE" taz_s_circle_center 250.0)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
      (command "_.TEXT" "_J" "_MC" taz_s_circle_center 150.0 0 taz_s_axis_name)
      (command "_.CHPROP" (entlast) "" "LA" "taz_s_axes" "")
    )
    
    (setq taz_s_p1_nomargin (list taz_s_xmin taz_s_ymin_nomargin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p2_nomargin (list taz_s_xmin_nomargin taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p3_nomargin (list taz_s_xmax_nomargin taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p4_nomargin (list taz_s_xmax taz_s_ymin_nomargin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p5_nomargin (list taz_s_xmax taz_s_ymax_nomargin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p6_nomargin (list taz_s_xmax_nomargin taz_s_ymax (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p7_nomargin (list taz_s_xmin_nomargin taz_s_ymax (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p8_nomargin (list taz_s_xmin taz_s_ymax_nomargin (+ taz_s_z taz_s_zoffset)))

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
    (command "-VIEW" "_S" "taz_s_view_cutting_view")
    
    ;; WIDOK: zoom na bryle tnaca zgodnie z kierunkiem extrude (os Y) i zapis widoku
    (setq taz_s_view_axis_name (taz_s_get_axis_name taz_s_row))
    (setq taz_s_view_name (strcat "taz_s_view_" taz_s_view_axis_name))
    (command "_VPOINT" "0,0,-1")
    (command "_ZOOM" "_OBJECT" taz_s_cutting_ename "")
    (command "-VIEW" "_S" taz_s_view_name)
    (command "-VIEW" "_R" "taz_s_view_cutting_view")

    ;; KROK 2: skopiuj oryginalny model
    (setq taz_s_last_before_copy (entlast))
    (if taz_s_orig_ss
      (command "COPY" taz_s_orig_ss "" "0,0,0" (list 0 0 taz_s_zoffset))
    )
    (taz_s_copy_attrs_to_copies taz_s_last_before_copy)

    ;; KROK 3: zbierz enames kopii biezacego przypadku
    (setq taz_s_copy_enames (taz_s_collect_copy_enames))

    ;; KROK 4: intersect parami
    (if (> (length taz_s_copy_enames) 0)
      (taz_s_intersect_pairs taz_s_cutting_ename taz_s_copy_enames "Z")
      (princ (strcat "\nPrzypadek Z nr " (itoa taz_s_copy_nr) ": brak elementow kopii - pomijam."))
    )

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
    
    (command "_layout" "_N" taz_s_view_name)
    (command "_layout" "_S" taz_s_view_name)
    (command "_mspace")
    ;;(command "-VIEW" "_R" taz_s_view_name)
    
    (command "_UCS" "_W")
    (command "_UCS" "_O" (list 0 0 taz_s_zoffset))
    (command "_PLAN" "_C")
    ;;(command "_REGEN")
    
    (setq taz_s_solprof_ss (ssget "_X" (list (cons 8 "taz_s_execution_design"))))    
    (command "_.SOLPROF")
    (command taz_s_solprof_ss)
    (command "" "_Y" "_Y" "_Y")
    (command "_.ERASE" (ssget "_X" (list (cons 8 "taz_s_execution_design"))) "")
    (command "_pspace")
    (command "_layout" "_S" "Model")
    
  )

  (command "-LAYDEL" "N" "taz_s_execution_design" "" "_Y")
  (taz_s_merge_solprof_layers)
  (taz_s_lock_all_layers)
  (taz_s_current_settings_restore)
  (princ)
)
