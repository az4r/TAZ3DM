;; ============================================================================
;; taz_s_create_drawings_execution_design_organize.lsp
;;
;; Wersja 7 porzadkowania widokow wykonanych przez:
;; taz_s_create_drawings_execution_design
;;
;; ZALOZENIA:
;; - przypadki sa utworzone kolejno: X, potem Y, potem Z,
;; - kazdy kolejny przypadek byl tworzony wyzej o 100000,
;; - dla przypadkow X/Y obiekty sa rozpoznawane po rzeczywistym zakresie Z
;;   ich geometrii, bez sprawdzania nazw warstw,
;; - po uporzadkowaniu wszystkie przypadki maja lezec na globalnej XY,
;; - pierwszy przypadek trafia do 0,0,0,
;; - kazdy kolejny trafia o 100000 w prawo po osi X.
;;
;; Skrypt celowo jest napisany prosto:
;; - setq,
;; - if,
;; - while,
;; - zmienne globalne,
;; - bez dodatkowych bibliotek.
;; ============================================================================


;; ----------------------------------------------------------------------------
;; POBRANIE LICZBY Z WIERSZA TYPU:
;; [X1]  5000.0
;; ----------------------------------------------------------------------------

(defun taz_s_organize_get_dist (taz_s_organize_row_arg)

  (setq taz_s_organize_i 1)
  (setq taz_s_organize_len (strlen taz_s_organize_row_arg))
  (setq taz_s_organize_val 0.0)

  (while
    (and
      (<= taz_s_organize_i taz_s_organize_len)
      (/= (substr taz_s_organize_row_arg taz_s_organize_i 1) "]")
    )
    (setq taz_s_organize_i (+ taz_s_organize_i 1))
  )

  (if (<= taz_s_organize_i taz_s_organize_len)
    (setq taz_s_organize_val
      (atof
        (substr
          taz_s_organize_row_arg
          (+ taz_s_organize_i 1)
        )
      )
    )
  )

  taz_s_organize_val
)


;; ----------------------------------------------------------------------------
;; ZAMIANA LISTY WIERSZY OSI NA LISTE LICZB
;; ----------------------------------------------------------------------------

(defun taz_s_organize_make_values (taz_s_organize_source_list)

  (setq taz_s_organize_values '())
  (setq taz_s_organize_tmp_values taz_s_organize_source_list)

  (while taz_s_organize_tmp_values

    (setq taz_s_organize_row_values (car taz_s_organize_tmp_values))
    (setq taz_s_organize_value_values
      (taz_s_organize_get_dist taz_s_organize_row_values)
    )

    (setq taz_s_organize_values
      (append
        taz_s_organize_values
        (list taz_s_organize_value_values)
      )
    )

    (setq taz_s_organize_tmp_values (cdr taz_s_organize_tmp_values))
  )

  taz_s_organize_values
)


;; ----------------------------------------------------------------------------
;; MINIMUM Z LISTY
;; ----------------------------------------------------------------------------

(defun taz_s_organize_min (taz_s_organize_min_list)

  (setq taz_s_organize_min_value (car taz_s_organize_min_list))
  (setq taz_s_organize_min_tmp (cdr taz_s_organize_min_list))

  (while taz_s_organize_min_tmp

    (if (< (car taz_s_organize_min_tmp) taz_s_organize_min_value)
      (setq taz_s_organize_min_value (car taz_s_organize_min_tmp))
    )

    (setq taz_s_organize_min_tmp (cdr taz_s_organize_min_tmp))
  )

  taz_s_organize_min_value
)


;; ----------------------------------------------------------------------------
;; MAKSIMUM Z LISTY
;; ----------------------------------------------------------------------------

(defun taz_s_organize_max (taz_s_organize_max_list)

  (setq taz_s_organize_max_value (car taz_s_organize_max_list))
  (setq taz_s_organize_max_tmp (cdr taz_s_organize_max_list))

  (while taz_s_organize_max_tmp

    (if (> (car taz_s_organize_max_tmp) taz_s_organize_max_value)
      (setq taz_s_organize_max_value (car taz_s_organize_max_tmp))
    )

    (setq taz_s_organize_max_tmp (cdr taz_s_organize_max_tmp))
  )

  taz_s_organize_max_value
)


;; ----------------------------------------------------------------------------
;; POBRANIE PRZYBLIZONEGO Z OBIEKTU
;;
;; Ta starsza funkcja zostaje tylko dla przypadkow Z,
;; bo przypadki Z dzialaja poprawnie i celowo ich nie zmieniamy.
;;
;; Dla przypadkow X/Y uzywana jest nizej nowa funkcja,
;; ktora wyznacza Zmin i Zmax calej geometrii obiektu.
;; ----------------------------------------------------------------------------

(defun taz_s_organize_get_entity_z (taz_s_organize_entity_arg)

  (setq taz_s_organize_entity_z nil)
  (setq taz_s_organize_entity_point nil)
  (setq taz_s_organize_entity_point_wcs nil)
  (setq taz_s_organize_entity_data (entget taz_s_organize_entity_arg))
  (setq taz_s_organize_entity_type
    (cdr (assoc 0 taz_s_organize_entity_data))
  )

  ;; ----------------------------------------------------------
  ;; STARA POLYLINE
  ;; Bierzemy pierwszy VERTEX.
  ;; ----------------------------------------------------------

  (if (= taz_s_organize_entity_type "POLYLINE")
    (progn

      (setq taz_s_organize_poly_next (entnext taz_s_organize_entity_arg))
      (setq taz_s_organize_poly_done nil)

      (while
        (and
          taz_s_organize_poly_next
          (= taz_s_organize_poly_done nil)
        )

        (setq taz_s_organize_poly_data (entget taz_s_organize_poly_next))
        (setq taz_s_organize_poly_type
          (cdr (assoc 0 taz_s_organize_poly_data))
        )

        (if (= taz_s_organize_poly_type "VERTEX")
          (progn

            (setq taz_s_organize_entity_point
              (cdr (assoc 10 taz_s_organize_poly_data))
            )

            (if taz_s_organize_entity_point
              (progn

                (if (= (caddr taz_s_organize_entity_point) nil)
                  (setq taz_s_organize_entity_point
                    (list
                      (car taz_s_organize_entity_point)
                      (cadr taz_s_organize_entity_point)
                      0.0
                    )
                  )
                )

                ;; 3DPOLY przechowuje swoje wierzcholki juz w WCS.
                ;; Nie robimy tutaj TRANS, bo mogloby to zmienic poprawny punkt.
                (setq taz_s_organize_entity_point_wcs
                  taz_s_organize_entity_point
                )

                (setq taz_s_organize_entity_z
                  (caddr taz_s_organize_entity_point_wcs)
                )

                (setq taz_s_organize_poly_done T)
              )
            )
          )
        )

        (if (= taz_s_organize_poly_type "SEQEND")
          (setq taz_s_organize_poly_done T)
        )

        (if (= taz_s_organize_poly_done nil)
          (setq taz_s_organize_poly_next
            (entnext taz_s_organize_poly_next)
          )
        )
      )
    )
  )

  ;; ----------------------------------------------------------
  ;; LWPOLYLINE
  ;; Punkt 10 ma X/Y, a wysokosc moze siedziec w kodzie 38.
  ;; ----------------------------------------------------------

  (if
    (and
      (= taz_s_organize_entity_z nil)
      (= taz_s_organize_entity_type "LWPOLYLINE")
    )
    (progn

      (setq taz_s_organize_entity_point
        (cdr (assoc 10 taz_s_organize_entity_data))
      )

      (setq taz_s_organize_entity_elevation 0.0)

      (if (assoc 38 taz_s_organize_entity_data)
        (setq taz_s_organize_entity_elevation
          (cdr (assoc 38 taz_s_organize_entity_data))
        )
      )

      (if taz_s_organize_entity_point
        (progn

          (setq taz_s_organize_entity_point
            (list
              (car taz_s_organize_entity_point)
              (cadr taz_s_organize_entity_point)
              taz_s_organize_entity_elevation
            )
          )

          (setq taz_s_organize_entity_point_wcs
            (trans
              taz_s_organize_entity_point
              taz_s_organize_entity_arg
              0
            )
          )

          (if taz_s_organize_entity_point_wcs
            (setq taz_s_organize_entity_z
              (caddr taz_s_organize_entity_point_wcs)
            )
          )
        )
      )
    )
  )

  ;; ----------------------------------------------------------
  ;; TEXT
  ;; Dla tekstu wyrownanego (np. MC) wazny jest punkt 11.
  ;; ----------------------------------------------------------

  (if
    (and
      (= taz_s_organize_entity_z nil)
      (= taz_s_organize_entity_type "TEXT")
    )
    (progn

      (setq taz_s_organize_text_h 0)
      (setq taz_s_organize_text_v 0)

      (if (assoc 72 taz_s_organize_entity_data)
        (setq taz_s_organize_text_h
          (cdr (assoc 72 taz_s_organize_entity_data))
        )
      )

      (if (assoc 73 taz_s_organize_entity_data)
        (setq taz_s_organize_text_v
          (cdr (assoc 73 taz_s_organize_entity_data))
        )
      )

      (if
        (and
          (or
            (/= taz_s_organize_text_h 0)
            (/= taz_s_organize_text_v 0)
          )
          (assoc 11 taz_s_organize_entity_data)
        )
        (setq taz_s_organize_entity_point
          (cdr (assoc 11 taz_s_organize_entity_data))
        )
        (setq taz_s_organize_entity_point
          (cdr (assoc 10 taz_s_organize_entity_data))
        )
      )
    )
  )

  ;; ----------------------------------------------------------
  ;; POZOSTALE OBIEKTY
  ;; ----------------------------------------------------------

  (if
    (and
      (= taz_s_organize_entity_z nil)
      (= taz_s_organize_entity_point nil)
    )
    (setq taz_s_organize_entity_point
      (cdr (assoc 10 taz_s_organize_entity_data))
    )
  )

  ;; ----------------------------------------------------------
  ;; Punkt obiektu moze byc zapisany w OCS.
  ;; Przeliczamy go do globalnego WCS.
  ;; ----------------------------------------------------------

  (if
    (and
      (= taz_s_organize_entity_z nil)
      taz_s_organize_entity_point
    )
    (progn

      (if (= (caddr taz_s_organize_entity_point) nil)
        (setq taz_s_organize_entity_point
          (list
            (car taz_s_organize_entity_point)
            (cadr taz_s_organize_entity_point)
            0.0
          )
        )
      )

      (setq taz_s_organize_entity_point_wcs
        (trans
          taz_s_organize_entity_point
          taz_s_organize_entity_arg
          0
        )
      )

      (if taz_s_organize_entity_point_wcs
        (setq taz_s_organize_entity_z
          (caddr taz_s_organize_entity_point_wcs)
        )
      )
    )
  )

  taz_s_organize_entity_z
)


;; ----------------------------------------------------------------------------
;; DODANIE JEDNEJ WARTOSCI Z DO ZAKRESU OBIEKTU
;; ----------------------------------------------------------------------------

(defun taz_s_organize_update_entity_z_value (taz_s_organize_z_value_arg)

  (if taz_s_organize_z_value_arg
    (progn

      (if (= taz_s_organize_entity_z_min nil)
        (setq taz_s_organize_entity_z_min taz_s_organize_z_value_arg)
        (if (< taz_s_organize_z_value_arg taz_s_organize_entity_z_min)
          (setq taz_s_organize_entity_z_min taz_s_organize_z_value_arg)
        )
      )

      (if (= taz_s_organize_entity_z_max nil)
        (setq taz_s_organize_entity_z_max taz_s_organize_z_value_arg)
        (if (> taz_s_organize_z_value_arg taz_s_organize_entity_z_max)
          (setq taz_s_organize_entity_z_max taz_s_organize_z_value_arg)
        )
      )
    )
  )
)


;; ----------------------------------------------------------------------------
;; DODANIE PUNKTU DO ZAKRESU Z OBIEKTU
;;
;; taz_s_organize_point_is_wcs_arg:
;; T   - punkt jest juz w globalnym WCS
;; nil - punkt jest w OCS obiektu i trzeba uzyc TRANS
;; ----------------------------------------------------------------------------

(defun taz_s_organize_update_entity_z_from_point
  (
    taz_s_organize_point_arg
    taz_s_organize_point_entity_arg
    taz_s_organize_point_is_wcs_arg
  )

  (if taz_s_organize_point_arg
    (progn

      (setq taz_s_organize_range_point taz_s_organize_point_arg)

      (if (= (caddr taz_s_organize_range_point) nil)
        (setq taz_s_organize_range_point
          (list
            (car taz_s_organize_range_point)
            (cadr taz_s_organize_range_point)
            0.0
          )
        )
      )

      (if taz_s_organize_point_is_wcs_arg
        (setq taz_s_organize_range_point_wcs
          taz_s_organize_range_point
        )
        (setq taz_s_organize_range_point_wcs
          (trans
            taz_s_organize_range_point
            taz_s_organize_point_entity_arg
            0
          )
        )
      )

      (if taz_s_organize_range_point_wcs
        (taz_s_organize_update_entity_z_value
          (caddr taz_s_organize_range_point_wcs)
        )
      )
    )
  )
)


;; ----------------------------------------------------------------------------
;; RZECZYWISTY ZAKRES Z OBIEKTU
;;
;; Zamiast pytac tylko o jeden punkt obiektu, probujemy ustalic:
;; - najnizszy Z obiektu,
;; - najwyzszy Z obiektu.
;;
;; Nie ma tutaj zadnego sprawdzania nazw warstw.
;; Rozrozniane sa tylko typy obiektow, bo rozne typy przechowuja
;; geometrie w inny sposob.
;;
;; Najwazniejsze przypadki:
;; - LINE       -> poczatek i koniec,
;; - 3DPOLY     -> wszystkie VERTEX,
;; - LWPOLYLINE -> wszystkie wierzcholki,
;; - TEXT       -> punkty 10 i 11,
;; - MTEXT      -> punkt wstawienia,
;; - CIRCLE/ARC -> srodek i promien.
;; ----------------------------------------------------------------------------

(defun taz_s_organize_get_entity_z_range (taz_s_organize_range_entity_arg)

  (setq taz_s_organize_entity_z_min nil)
  (setq taz_s_organize_entity_z_max nil)

  (setq taz_s_organize_range_data
    (entget taz_s_organize_range_entity_arg)
  )

  (setq taz_s_organize_range_type
    (cdr (assoc 0 taz_s_organize_range_data))
  )

  ;; --------------------------------------------------------------------------
  ;; POLYLINE
  ;;
  ;; Dla 3DPOLY / 3D MESH wierzcholki sa juz w WCS.
  ;; Dla starej polilinii 2D punkt przechodzi przez OCS -> WCS.
  ;; Sprawdzamy WSZYSTKIE wierzcholki.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "POLYLINE")
    (progn

      (setq taz_s_organize_range_poly_flags 0)

      (if (assoc 70 taz_s_organize_range_data)
        (setq taz_s_organize_range_poly_flags
          (cdr (assoc 70 taz_s_organize_range_data))
        )
      )

      (setq taz_s_organize_range_poly_wcs nil)

      (if (/= (logand taz_s_organize_range_poly_flags 8) 0)
        (setq taz_s_organize_range_poly_wcs T)
      )

      (if (/= (logand taz_s_organize_range_poly_flags 16) 0)
        (setq taz_s_organize_range_poly_wcs T)
      )

      (if (/= (logand taz_s_organize_range_poly_flags 64) 0)
        (setq taz_s_organize_range_poly_wcs T)
      )

      (setq taz_s_organize_range_poly_next
        (entnext taz_s_organize_range_entity_arg)
      )

      (setq taz_s_organize_range_poly_done nil)

      (while
        (and
          taz_s_organize_range_poly_next
          (= taz_s_organize_range_poly_done nil)
        )

        (setq taz_s_organize_range_poly_vertex_data
          (entget taz_s_organize_range_poly_next)
        )

        (setq taz_s_organize_range_poly_vertex_type
          (cdr
            (assoc 0 taz_s_organize_range_poly_vertex_data)
          )
        )

        (if (= taz_s_organize_range_poly_vertex_type "VERTEX")
          (progn

            (setq taz_s_organize_range_poly_vertex_point
              (cdr
                (assoc 10 taz_s_organize_range_poly_vertex_data)
              )
            )

            (taz_s_organize_update_entity_z_from_point
              taz_s_organize_range_poly_vertex_point
              taz_s_organize_range_entity_arg
              taz_s_organize_range_poly_wcs
            )
          )
        )

        (if (= taz_s_organize_range_poly_vertex_type "SEQEND")
          (setq taz_s_organize_range_poly_done T)
        )

        (if (= taz_s_organize_range_poly_done nil)
          (setq taz_s_organize_range_poly_next
            (entnext taz_s_organize_range_poly_next)
          )
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; LWPOLYLINE
  ;;
  ;; Kod 10 moze wystapic wiele razy.
  ;; Wysokosc polilinii siedzi w kodzie 38.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "LWPOLYLINE")
    (progn

      (setq taz_s_organize_range_lw_elevation 0.0)

      (if (assoc 38 taz_s_organize_range_data)
        (setq taz_s_organize_range_lw_elevation
          (cdr (assoc 38 taz_s_organize_range_data))
        )
      )

      (setq taz_s_organize_range_lw_tmp
        taz_s_organize_range_data
      )

      (while taz_s_organize_range_lw_tmp

        (setq taz_s_organize_range_lw_item
          (car taz_s_organize_range_lw_tmp)
        )

        (if (= (car taz_s_organize_range_lw_item) 10)
          (progn

            (setq taz_s_organize_range_lw_point
              (cdr taz_s_organize_range_lw_item)
            )

            (setq taz_s_organize_range_lw_point
              (list
                (car taz_s_organize_range_lw_point)
                (cadr taz_s_organize_range_lw_point)
                taz_s_organize_range_lw_elevation
              )
            )

            (taz_s_organize_update_entity_z_from_point
              taz_s_organize_range_lw_point
              taz_s_organize_range_entity_arg
              nil
            )
          )
        )

        (setq taz_s_organize_range_lw_tmp
          (cdr taz_s_organize_range_lw_tmp)
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; LINE
  ;; Punkty linii sa juz w WCS.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "LINE")
    (progn

      (taz_s_organize_update_entity_z_from_point
        (cdr (assoc 10 taz_s_organize_range_data))
        taz_s_organize_range_entity_arg
        T
      )

      (taz_s_organize_update_entity_z_from_point
        (cdr (assoc 11 taz_s_organize_range_data))
        taz_s_organize_range_entity_arg
        T
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; 3DFACE
  ;; Wszystkie punkty sa juz w WCS.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "3DFACE")
    (progn

      (setq taz_s_organize_range_face_code 10)

      (while (<= taz_s_organize_range_face_code 13)

        (if (assoc taz_s_organize_range_face_code taz_s_organize_range_data)
          (taz_s_organize_update_entity_z_from_point
            (cdr
              (assoc
                taz_s_organize_range_face_code
                taz_s_organize_range_data
              )
            )
            taz_s_organize_range_entity_arg
            T
          )
        )

        (setq taz_s_organize_range_face_code
          (+ taz_s_organize_range_face_code 1)
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; POINT
  ;; Punkt jest juz w WCS.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "POINT")
    (taz_s_organize_update_entity_z_from_point
      (cdr (assoc 10 taz_s_organize_range_data))
      taz_s_organize_range_entity_arg
      T
    )
  )

  ;; --------------------------------------------------------------------------
  ;; DIMENSION
  ;; Punkty wymiaru sa w WCS.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "DIMENSION")
    (progn

      (setq taz_s_organize_range_dim_code 10)

      (while (<= taz_s_organize_range_dim_code 16)

        (if (assoc taz_s_organize_range_dim_code taz_s_organize_range_data)
          (taz_s_organize_update_entity_z_from_point
            (cdr
              (assoc
                taz_s_organize_range_dim_code
                taz_s_organize_range_data
              )
            )
            taz_s_organize_range_entity_arg
            T
          )
        )

        (setq taz_s_organize_range_dim_code
          (+ taz_s_organize_range_dim_code 1)
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; TEXT
  ;;
  ;; Bierzemy oba punkty 10 i 11.
  ;; Dla tekstu MC punkt 11 jest szczegolnie wazny.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "TEXT")
    (progn

      (if (assoc 10 taz_s_organize_range_data)
        (taz_s_organize_update_entity_z_from_point
          (cdr (assoc 10 taz_s_organize_range_data))
          taz_s_organize_range_entity_arg
          nil
        )
      )

      (if (assoc 11 taz_s_organize_range_data)
        (taz_s_organize_update_entity_z_from_point
          (cdr (assoc 11 taz_s_organize_range_data))
          taz_s_organize_range_entity_arg
          nil
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; MTEXT
  ;;
  ;; W GstarCAD po ROTATE3D punkt 10 zachowuje rzeczywiste polozenie
  ;; potrzebne do naszego grupowania. Czytamy go bez dodatkowego TRANS.
  ;; To rozwiazuje przypadek etykiet umieszczonych centralnie w widoku.
  ;; --------------------------------------------------------------------------

  (if (= taz_s_organize_range_type "MTEXT")
    (taz_s_organize_update_entity_z_from_point
      (cdr (assoc 10 taz_s_organize_range_data))
      taz_s_organize_range_entity_arg
      T
    )
  )

  ;; --------------------------------------------------------------------------
  ;; CIRCLE ORAZ ARC
  ;;
  ;; Bierzemy srodek po OCS -> WCS.
  ;; Do zakresu dodajemy tez promien z obu stron.
  ;; Jest to celowo bezpieczne przy okregu / luku obroconym w 3D.
  ;; --------------------------------------------------------------------------

  (if
    (or
      (= taz_s_organize_range_type "CIRCLE")
      (= taz_s_organize_range_type "ARC")
    )
    (progn

      (setq taz_s_organize_range_point_wcs nil)

      (taz_s_organize_update_entity_z_from_point
        (cdr (assoc 10 taz_s_organize_range_data))
        taz_s_organize_range_entity_arg
        nil
      )

      (setq taz_s_organize_range_radius 0.0)

      (if (assoc 40 taz_s_organize_range_data)
        (setq taz_s_organize_range_radius
          (cdr (assoc 40 taz_s_organize_range_data))
        )
      )

      (if taz_s_organize_range_point_wcs
        (progn

          (setq taz_s_organize_range_center_z
            (caddr taz_s_organize_range_point_wcs)
          )

          (taz_s_organize_update_entity_z_value
            (- taz_s_organize_range_center_z taz_s_organize_range_radius)
          )

          (taz_s_organize_update_entity_z_value
            (+ taz_s_organize_range_center_z taz_s_organize_range_radius)
          )
        )
      )
    )
  )

  ;; --------------------------------------------------------------------------
  ;; POZOSTALE OBIEKTY
  ;;
  ;; Jesli powyzej nie udalo sie znalezc zadnego Z, probujemy punktu 10.
  ;; Jest to zachowanie awaryjne dla pozostalych typow.
  ;; --------------------------------------------------------------------------

  (if
    (and
      (= taz_s_organize_entity_z_min nil)
      (assoc 10 taz_s_organize_range_data)
    )
    (taz_s_organize_update_entity_z_from_point
      (cdr (assoc 10 taz_s_organize_range_data))
      taz_s_organize_range_entity_arg
      nil
    )
  )

  (if
    (and
      taz_s_organize_entity_z_min
      taz_s_organize_entity_z_max
    )
    (list
      taz_s_organize_entity_z_min
      taz_s_organize_entity_z_max
    )
    nil
  )
)


;; ----------------------------------------------------------------------------
;; ZBIERANIE OBIEKTOW JEDNEGO PRZYPADKU Z
;;
;; Ta starsza selekcja zostaje tylko dla przypadkow Z,
;; poniewaz przypadki Z dzialaja poprawnie.
;; Kazdy przypadek byl tworzony co 100000 w osi Z.
;; Przyjmujemy pas +/- 49000 wokol danego poziomu.
;; ----------------------------------------------------------------------------

(defun taz_s_organize_collect_case (taz_s_organize_case_z_arg)

  (setq taz_s_organize_case_ss (ssadd))

  (setq taz_s_organize_all_ss
    (ssget
      "_X"
      (list
        (cons 67 0)
      )
    )
  )

  (if taz_s_organize_all_ss
    (progn

      (setq taz_s_organize_all_i 0)

      (while (< taz_s_organize_all_i (sslength taz_s_organize_all_ss))

        (setq taz_s_organize_all_ent
          (ssname taz_s_organize_all_ss taz_s_organize_all_i)
        )

        (setq taz_s_organize_all_z
          (taz_s_organize_get_entity_z taz_s_organize_all_ent)
        )

        (if taz_s_organize_all_z
          (progn
            (if
              (and
                (>=
                  taz_s_organize_all_z
                  (- taz_s_organize_case_z_arg taz_s_organize_case_half_range)
                )
                (<=
                  taz_s_organize_all_z
                  (+ taz_s_organize_case_z_arg taz_s_organize_case_half_range)
                )
              )
              (ssadd taz_s_organize_all_ent taz_s_organize_case_ss)
            )
          )
        )

        (setq taz_s_organize_all_i (+ taz_s_organize_all_i 1))
      )
    )
  )

  taz_s_organize_case_ss
)


;; ----------------------------------------------------------------------------
;; ZBIERANIE OBIEKTOW Z CALEGO ZAKRESU Z
;;
;; Ta funkcja jest uzywana tylko dla przypadkow X oraz Y.
;;
;; Najpierw kazdy obiekt dostaje swoj rzeczywisty zakres:
;;   Zmin obiektu ... Zmax obiektu
;;
;; Potem sprawdzamy, czy ten zakres przecina zakres danego przypadku.
;; Nie ma zadnego filtrowania po nazwach warstw.
;; ----------------------------------------------------------------------------

(defun taz_s_organize_collect_case_z_range
  (taz_s_organize_range_min_arg taz_s_organize_range_max_arg)

  (setq taz_s_organize_case_ss (ssadd))

  (setq taz_s_organize_all_ss
    (ssget
      "_X"
      (list
        (cons 67 0)
      )
    )
  )

  (if taz_s_organize_all_ss
    (progn

      (setq taz_s_organize_all_i 0)

      (while (< taz_s_organize_all_i (sslength taz_s_organize_all_ss))

        (setq taz_s_organize_all_ent
          (ssname taz_s_organize_all_ss taz_s_organize_all_i)
        )

        (setq taz_s_organize_all_z_range
          (taz_s_organize_get_entity_z_range
            taz_s_organize_all_ent
          )
        )

        (if taz_s_organize_all_z_range
          (progn

            (setq taz_s_organize_all_z_min
              (car taz_s_organize_all_z_range)
            )

            (setq taz_s_organize_all_z_max
              (cadr taz_s_organize_all_z_range)
            )

            ;; --------------------------------------------------------------
            ;; Zakres obiektu przecina zakres przypadku, jezeli:
            ;;
            ;; Zmin obiektu <= Zmax przypadku
            ;; ORAZ
            ;; Zmax obiektu >= Zmin przypadku
            ;;
            ;; Dzieki temu dluga os zostanie wybrana nawet wtedy,
            ;; gdy jej poczatek i koniec leza poza naszym zakresem,
            ;; ale sama os przechodzi przez ten zakres.
            ;; --------------------------------------------------------------

            (if
              (and
                (<=
                  taz_s_organize_all_z_min
                  taz_s_organize_range_max_arg
                )
                (>=
                  taz_s_organize_all_z_max
                  taz_s_organize_range_min_arg
                )
              )
              (ssadd
                taz_s_organize_all_ent
                taz_s_organize_case_ss
              )
            )
          )
        )

        (setq taz_s_organize_all_i (+ taz_s_organize_all_i 1))
      )
    )
  )

  taz_s_organize_case_ss
)


;; ----------------------------------------------------------------------------
;; ZAPAMIETANIE WARSTW, KTORE BYLY ZABLOKOWANE
;; I ODBLOKOWANIE WARSTW NA CZAS PRACY
;; ----------------------------------------------------------------------------

(defun taz_s_organize_unlock_layers ()

  (setq taz_s_organize_locked_layers '())
  (setq taz_s_organize_layer_rec (tblnext "LAYER" T))

  (while taz_s_organize_layer_rec

    (setq taz_s_organize_layer_name
      (cdr (assoc 2 taz_s_organize_layer_rec))
    )

    (setq taz_s_organize_layer_flags
      (cdr (assoc 70 taz_s_organize_layer_rec))
    )

    (if (= (logand taz_s_organize_layer_flags 4) 4)
      (setq taz_s_organize_locked_layers
        (append
          taz_s_organize_locked_layers
          (list taz_s_organize_layer_name)
        )
      )
    )

    (setq taz_s_organize_layer_rec (tblnext "LAYER"))
  )

  (command "_.-LAYER" "_UNLOCK" "*" "")
)


;; ----------------------------------------------------------------------------
;; PONOWNE ZABLOKOWANIE TYLKO TYCH WARSTW,
;; KTORE BYLY ZABLOKOWANE PRZED STARTEM SKRYPTU
;; ----------------------------------------------------------------------------

(defun taz_s_organize_restore_locked_layers ()

  (setq taz_s_organize_locked_tmp taz_s_organize_locked_layers)

  (while taz_s_organize_locked_tmp

    (setq taz_s_organize_locked_name
      (car taz_s_organize_locked_tmp)
    )

    (command "_.-LAYER" "_LOCK" taz_s_organize_locked_name "")

    (setq taz_s_organize_locked_tmp (cdr taz_s_organize_locked_tmp))
  )
)


;; ----------------------------------------------------------------------------
;; PRZYGOTOWANIE DANYCH OSI
;;
;; Najpierw probujemy wykorzystac dane, ktore zostaly w pamieci po skrypcie
;; tworzacym rysunki. Jesli ich nie ma, probujemy zaladowac taz_s_data_file.
;; ----------------------------------------------------------------------------

(defun taz_s_organize_prepare_data ()

  (setq taz_s_organize_can_run T)

  (if
    (or
      (not (boundp 'taz_s_axis_data_x))
      (not (boundp 'taz_s_axis_data_y))
      (not (boundp 'taz_s_axis_data_z))
    )
    (progn
      (if (boundp 'taz_s_data_file)
        (progn
          (if (findfile taz_s_data_file)
            (load taz_s_data_file)
          )
        )
      )
    )
  )

  (if
    (and
      (boundp 'taz_s_axis_data_x)
      (boundp 'taz_s_axis_data_y)
      (boundp 'taz_s_axis_data_z)
    )
    (progn
      (setq taz_s_organize_x_data taz_s_axis_data_x)
      (setq taz_s_organize_y_data taz_s_axis_data_y)
      (setq taz_s_organize_z_data taz_s_axis_data_z)
    )
    (progn
      (setq taz_s_organize_can_run nil)
      (princ "\nBrak danych osi taz_s_axis_data_x / y / z - porzadkowanie przerwane.")
    )
  )
)


;; ============================================================================
;; GLOWNA KOMENDA
;; ============================================================================

(defun c:taz_s_create_drawings_execution_design_organize ()

  (setq taz_s_organize_old_cmdecho (getvar "CMDECHO"))
  (setq taz_s_organize_old_clayer (getvar "CLAYER"))

  (setvar "CMDECHO" 0)

  ;; Na sztywno zgodnie z pierwszym zalozeniem
  (setq taz_s_organize_spacing 100000.0)
  (setq taz_s_organize_case_half_range 49000.0)
  (setq taz_s_organize_z_range_margin 5000.0)
  (setq taz_s_organize_align_size 1000.0)

  (taz_s_organize_prepare_data)

  (if taz_s_organize_can_run
    (progn

      (command "_.UCS" "_W")

      (taz_s_organize_unlock_layers)

      ;; ----------------------------------------------------------------------
      ;; WARTOSCI LICZBOWE OSI
      ;; ----------------------------------------------------------------------

      (setq taz_s_organize_x_values
        (taz_s_organize_make_values taz_s_organize_x_data)
      )

      (setq taz_s_organize_y_values
        (taz_s_organize_make_values taz_s_organize_y_data)
      )

      (setq taz_s_organize_z_values
        (taz_s_organize_make_values taz_s_organize_z_data)
      )

      ;; ----------------------------------------------------------------------
      ;; ZAKRES Z DLA PRZYPADKOW X ORAZ Y
      ;;
      ;; Bierzemy najnizsza i najwyzsza os Z.
      ;; Zakres zawsze obejmuje tez wzgledne Z = 0, bo na tym poziomie
      ;; jest kotwiczona tabela.
      ;; Na koncu dodajemy margines 5000 z obu stron.
      ;; ----------------------------------------------------------------------

      (setq taz_s_organize_z_relative_min 0.0)
      (setq taz_s_organize_z_relative_max 0.0)

      (if taz_s_organize_z_values
        (progn

          (setq taz_s_organize_z_relative_min
            (taz_s_organize_min taz_s_organize_z_values)
          )

          (setq taz_s_organize_z_relative_max
            (taz_s_organize_max taz_s_organize_z_values)
          )

          (if (> taz_s_organize_z_relative_min 0.0)
            (setq taz_s_organize_z_relative_min 0.0)
          )

          (if (< taz_s_organize_z_relative_max 0.0)
            (setq taz_s_organize_z_relative_max 0.0)
          )
        )
      )

      (setq taz_s_organize_z_relative_min
        (- taz_s_organize_z_relative_min taz_s_organize_z_range_margin)
      )

      (setq taz_s_organize_z_relative_max
        (+ taz_s_organize_z_relative_max taz_s_organize_z_range_margin)
      )

      ;; ----------------------------------------------------------------------
      ;; SRODEK KONSTRUKCJI W X I Y
      ;;
      ;; Tak samo jak w skrypcie tworzacym widoki:
      ;; - taz_s_axis_data_y daje polozenia w globalnym X,
      ;; - taz_s_axis_data_x daje polozenia w globalnym Y.
      ;; ----------------------------------------------------------------------

      (setq taz_s_organize_x_center 0.0)
      (setq taz_s_organize_y_center 0.0)

      (if taz_s_organize_y_values
        (progn
          (setq taz_s_organize_x_min
            (taz_s_organize_min taz_s_organize_y_values)
          )
          (setq taz_s_organize_x_max
            (taz_s_organize_max taz_s_organize_y_values)
          )
          (setq taz_s_organize_x_center
            (/ (+ taz_s_organize_x_min taz_s_organize_x_max) 2.0)
          )
        )
      )

      (if taz_s_organize_x_values
        (progn
          (setq taz_s_organize_y_min
            (taz_s_organize_min taz_s_organize_x_values)
          )
          (setq taz_s_organize_y_max
            (taz_s_organize_max taz_s_organize_x_values)
          )
          (setq taz_s_organize_y_center
            (/ (+ taz_s_organize_y_min taz_s_organize_y_max) 2.0)
          )
        )
      )

      ;; ----------------------------------------------------------------------
      ;; NUMER PRZYPADKU
      ;; Odpowiada taz_s_copy_nr ze skryptu tworzacego widoki.
      ;; ----------------------------------------------------------------------

      (setq taz_s_organize_case_nr 1)
      (setq taz_s_organize_total_moved 0)

      ;; ======================================================================
      ;; PRZYPADKI X
      ;;
      ;; Oryginalna plaszczyzna: X-Z, Y = wartosc osi.
      ;; Po ALIGN:
      ;; - globalny X zostaje poziomo,
      ;; - globalny Z idzie do gory po nowym Y.
      ;; ======================================================================

      (setq taz_s_organize_tmp taz_s_organize_x_data)

      (while taz_s_organize_tmp

        (setq taz_s_organize_row (car taz_s_organize_tmp))
        (setq taz_s_organize_section_value
          (taz_s_organize_get_dist taz_s_organize_row)
        )

        (setq taz_s_organize_case_z
          (* taz_s_organize_case_nr taz_s_organize_spacing)
        )

        (setq taz_s_organize_destination_x
          (* (- taz_s_organize_case_nr 1) taz_s_organize_spacing)
        )

        (setq taz_s_organize_case_range_min
          (+ taz_s_organize_case_z taz_s_organize_z_relative_min)
        )

        (setq taz_s_organize_case_range_max
          (+ taz_s_organize_case_z taz_s_organize_z_relative_max)
        )

        (setq taz_s_organize_case_ss
          (taz_s_organize_collect_case_z_range
            taz_s_organize_case_range_min
            taz_s_organize_case_range_max
          )
        )

        (if (> (sslength taz_s_organize_case_ss) 0)
          (progn

            ;; Punkt bazowy przypadku
            (setq taz_s_organize_source_1
              (list
                taz_s_organize_x_center
                taz_s_organize_section_value
                taz_s_organize_case_z
              )
            )

            ;; Kierunek poziomy po uporzadkowaniu = globalny X
            (setq taz_s_organize_source_2
              (list
                (+ taz_s_organize_x_center taz_s_organize_align_size)
                taz_s_organize_section_value
                taz_s_organize_case_z
              )
            )

            ;; Kierunek pionowy po uporzadkowaniu = globalny Z
            (setq taz_s_organize_source_3
              (list
                taz_s_organize_x_center
                taz_s_organize_section_value
                (+ taz_s_organize_case_z taz_s_organize_align_size)
              )
            )

            (setq taz_s_organize_destination_1
              (list taz_s_organize_destination_x 0.0 0.0)
            )

            (setq taz_s_organize_destination_2
              (list
                (+ taz_s_organize_destination_x taz_s_organize_align_size)
                0.0
                0.0
              )
            )

            (setq taz_s_organize_destination_3
              (list
                taz_s_organize_destination_x
                taz_s_organize_align_size
                0.0
              )
            )

            (command
              "_.ALIGN"
              taz_s_organize_case_ss
              ""
              taz_s_organize_source_1
              taz_s_organize_destination_1
              taz_s_organize_source_2
              taz_s_organize_destination_2
              taz_s_organize_source_3
              taz_s_organize_destination_3
            )

            (setq taz_s_organize_total_moved
              (+ taz_s_organize_total_moved (sslength taz_s_organize_case_ss))
            )

            (princ
              (strcat
                "\nX - przypadek "
                (itoa taz_s_organize_case_nr)
                " - przeniesiono obiektow: "
                (itoa (sslength taz_s_organize_case_ss))
              )
            )
          )
          (princ
            (strcat
              "\nX - przypadek "
              (itoa taz_s_organize_case_nr)
              " - nie znaleziono obiektow."
            )
          )
        )

        (setq taz_s_organize_case_nr (+ taz_s_organize_case_nr 1))
        (setq taz_s_organize_tmp (cdr taz_s_organize_tmp))
      )

      ;; ======================================================================
      ;; PRZYPADKI Y
      ;;
      ;; Oryginalna plaszczyzna: Y-Z, X = wartosc osi.
      ;; Po ALIGN:
      ;; - globalny Y idzie w prawo po nowym X,
      ;; - globalny Z idzie do gory po nowym Y.
      ;; ======================================================================

      (setq taz_s_organize_tmp taz_s_organize_y_data)

      (while taz_s_organize_tmp

        (setq taz_s_organize_row (car taz_s_organize_tmp))
        (setq taz_s_organize_section_value
          (taz_s_organize_get_dist taz_s_organize_row)
        )

        (setq taz_s_organize_case_z
          (* taz_s_organize_case_nr taz_s_organize_spacing)
        )

        (setq taz_s_organize_destination_x
          (* (- taz_s_organize_case_nr 1) taz_s_organize_spacing)
        )

        (setq taz_s_organize_case_range_min
          (+ taz_s_organize_case_z taz_s_organize_z_relative_min)
        )

        (setq taz_s_organize_case_range_max
          (+ taz_s_organize_case_z taz_s_organize_z_relative_max)
        )

        (setq taz_s_organize_case_ss
          (taz_s_organize_collect_case_z_range
            taz_s_organize_case_range_min
            taz_s_organize_case_range_max
          )
        )

        (if (> (sslength taz_s_organize_case_ss) 0)
          (progn

            ;; Punkt bazowy przypadku
            (setq taz_s_organize_source_1
              (list
                taz_s_organize_section_value
                taz_s_organize_y_center
                taz_s_organize_case_z
              )
            )

            ;; Kierunek poziomy po uporzadkowaniu = globalny Y
            (setq taz_s_organize_source_2
              (list
                taz_s_organize_section_value
                (+ taz_s_organize_y_center taz_s_organize_align_size)
                taz_s_organize_case_z
              )
            )

            ;; Kierunek pionowy po uporzadkowaniu = globalny Z
            (setq taz_s_organize_source_3
              (list
                taz_s_organize_section_value
                taz_s_organize_y_center
                (+ taz_s_organize_case_z taz_s_organize_align_size)
              )
            )

            (setq taz_s_organize_destination_1
              (list taz_s_organize_destination_x 0.0 0.0)
            )

            (setq taz_s_organize_destination_2
              (list
                (+ taz_s_organize_destination_x taz_s_organize_align_size)
                0.0
                0.0
              )
            )

            (setq taz_s_organize_destination_3
              (list
                taz_s_organize_destination_x
                taz_s_organize_align_size
                0.0
              )
            )

            (command
              "_.ALIGN"
              taz_s_organize_case_ss
              ""
              taz_s_organize_source_1
              taz_s_organize_destination_1
              taz_s_organize_source_2
              taz_s_organize_destination_2
              taz_s_organize_source_3
              taz_s_organize_destination_3
            )

            (setq taz_s_organize_total_moved
              (+ taz_s_organize_total_moved (sslength taz_s_organize_case_ss))
            )

            (princ
              (strcat
                "\nY - przypadek "
                (itoa taz_s_organize_case_nr)
                " - przeniesiono obiektow: "
                (itoa (sslength taz_s_organize_case_ss))
              )
            )
          )
          (princ
            (strcat
              "\nY - przypadek "
              (itoa taz_s_organize_case_nr)
              " - nie znaleziono obiektow."
            )
          )
        )

        (setq taz_s_organize_case_nr (+ taz_s_organize_case_nr 1))
        (setq taz_s_organize_tmp (cdr taz_s_organize_tmp))
      )

      ;; ======================================================================
      ;; PRZYPADKI Z
      ;;
      ;; Oryginalna plaszczyzna jest juz rownolegla do globalnej XY.
      ;; Po ALIGN:
      ;; - globalny X zostaje poziomo,
      ;; - globalny Y zostaje pionowo.
      ;; ======================================================================

      (setq taz_s_organize_tmp taz_s_organize_z_data)

      (while taz_s_organize_tmp

        (setq taz_s_organize_row (car taz_s_organize_tmp))
        (setq taz_s_organize_section_value
          (taz_s_organize_get_dist taz_s_organize_row)
        )

        (setq taz_s_organize_case_z
          (* taz_s_organize_case_nr taz_s_organize_spacing)
        )

        (setq taz_s_organize_destination_x
          (* (- taz_s_organize_case_nr 1) taz_s_organize_spacing)
        )

        (setq taz_s_organize_case_ss
          (taz_s_organize_collect_case taz_s_organize_case_z)
        )

        (if (> (sslength taz_s_organize_case_ss) 0)
          (progn

            ;; Punkt bazowy przypadku lezy na rzeczywistej plaszczyznie Z
            (setq taz_s_organize_source_1
              (list
                taz_s_organize_x_center
                taz_s_organize_y_center
                (+ taz_s_organize_case_z taz_s_organize_section_value)
              )
            )

            ;; Globalny X
            (setq taz_s_organize_source_2
              (list
                (+ taz_s_organize_x_center taz_s_organize_align_size)
                taz_s_organize_y_center
                (+ taz_s_organize_case_z taz_s_organize_section_value)
              )
            )

            ;; Globalny Y
            (setq taz_s_organize_source_3
              (list
                taz_s_organize_x_center
                (+ taz_s_organize_y_center taz_s_organize_align_size)
                (+ taz_s_organize_case_z taz_s_organize_section_value)
              )
            )

            (setq taz_s_organize_destination_1
              (list taz_s_organize_destination_x 0.0 0.0)
            )

            (setq taz_s_organize_destination_2
              (list
                (+ taz_s_organize_destination_x taz_s_organize_align_size)
                0.0
                0.0
              )
            )

            (setq taz_s_organize_destination_3
              (list
                taz_s_organize_destination_x
                taz_s_organize_align_size
                0.0
              )
            )

            (command
              "_.ALIGN"
              taz_s_organize_case_ss
              ""
              taz_s_organize_source_1
              taz_s_organize_destination_1
              taz_s_organize_source_2
              taz_s_organize_destination_2
              taz_s_organize_source_3
              taz_s_organize_destination_3
            )

            (setq taz_s_organize_total_moved
              (+ taz_s_organize_total_moved (sslength taz_s_organize_case_ss))
            )

            (princ
              (strcat
                "\nZ - przypadek "
                (itoa taz_s_organize_case_nr)
                " - przeniesiono obiektow: "
                (itoa (sslength taz_s_organize_case_ss))
              )
            )
          )
          (princ
            (strcat
              "\nZ - przypadek "
              (itoa taz_s_organize_case_nr)
              " - nie znaleziono obiektow."
            )
          )
        )

        (setq taz_s_organize_case_nr (+ taz_s_organize_case_nr 1))
        (setq taz_s_organize_tmp (cdr taz_s_organize_tmp))
      )

      ;; ----------------------------------------------------------------------
      ;; KONIEC
      ;; ----------------------------------------------------------------------

      (command "_.UCS" "_W")
      (command "_.REGEN")
      (command "_.ZOOM" "_E")

      (if (tblsearch "LAYER" taz_s_organize_old_clayer)
        (setvar "CLAYER" taz_s_organize_old_clayer)
      )

      (taz_s_organize_restore_locked_layers)

      (princ
        (strcat
          "\nGotowe. Lacznie przeniesiono obiektow: "
          (itoa taz_s_organize_total_moved)
        )
      )
    )
  )

  (setvar "CMDECHO" taz_s_organize_old_cmdecho)

  (princ)
)

