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

    (setq taz_s_xvals
      (append taz_s_xvals (list taz_s_val))
    )

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

    (setq taz_s_yvals
      (append taz_s_yvals (list taz_s_val))
    )

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

    (setq taz_s_zvals
      (append taz_s_zvals (list taz_s_val))
    )

    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; X MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals)
  (taz_s_min)

  (setq taz_s_xmin taz_s_m)

  ;; ---------------------------------
  ;; X MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_yvals)
  (taz_s_max)

  (setq taz_s_xmax taz_s_m)

  ;; ---------------------------------
  ;; Y MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_xvals)
  (taz_s_min)

  (setq taz_s_ymin taz_s_m)

  ;; ---------------------------------
  ;; Y MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_xvals)
  (taz_s_max)

  (setq taz_s_ymax taz_s_m)

  ;; ---------------------------------
  ;; Z MIN
  ;; ---------------------------------

  (setq taz_s_list taz_s_zvals)
  (taz_s_min)

  (setq taz_s_zmin taz_s_m)

  ;; ---------------------------------
  ;; Z MAX
  ;; ---------------------------------

  (setq taz_s_list taz_s_zvals)
  (taz_s_max)

  (setq taz_s_zmax taz_s_m)

  ;; ---------------------------------
  ;; MARGINES PROSTOKATOW
  ;; Powiekszamy granice o 1000 jednostek
  ;; aby bryly mialy zapas i nic nie umknelo
  ;; na pozniejszych widokach
  ;; ---------------------------------

  (setq taz_s_xmin (- taz_s_xmin 1000))
  (setq taz_s_xmax (+ taz_s_xmax 1000))
  (setq taz_s_ymin (- taz_s_ymin 1000))
  (setq taz_s_ymax (+ taz_s_ymax 1000))
  (setq taz_s_zmin (- taz_s_zmin 1000))
  (setq taz_s_zmax (+ taz_s_zmax 1000))

  ;; ---------------------------------
  ;; WARSTWA
  ;; ---------------------------------

  (if
    (not (tblsearch "LAYER" "taz_s_execution_design"))
    (command "_LAYER" "_M" "taz_s_execution_design" "_C" "30" "" "")
  )

  (setvar "CLAYER" "taz_s_execution_design")

  ;; ---------------------------------
  ;; CZYSZCZENIE WARSTWY
  ;; ---------------------------------

  (setq taz_s_ss
    (ssget "X" '((8 . "taz_s_execution_design")))
  )

  (if taz_s_ss
    (command "ERASE" taz_s_ss "")
  )

  ;; ---------------------------------
  ;; LICZNIK KOPII
  ;; Kazda plaszczyzna to kolejna kopia modelu.
  ;; Prostokat rysujemy od razu na wysokosci
  ;; wlasciwej dla danej kopii:
  ;; Z_oryginalne + (nr_kopii * 100000)
  ;; ---------------------------------

  (setq taz_s_copy_nr 1)

  ;; ---------------------------------
  ;; PROSTOKATY X
  ;; Plaszczyzna prostopadla do osi Y
  ;; (stala wspolrzedna Y, rozciaga sie w XZ)
  ;; ---------------------------------

  (setq taz_s_tmp taz_s_x_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))

    (taz_s_get_dist)

    ;; pozycja Y osi - nie zmienia sie
    (setq taz_s_y taz_s_val)

    ;; przesuniecie Z dla tej kopii
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; punkty prostokata przesuniete w gore o offset
    (setq taz_s_p1 (list taz_s_xmin taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_xmax taz_s_y (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_xmax taz_s_y (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_xmin taz_s_y (+ taz_s_zmax taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")

    ;; wyciagnij prostokat wzdluz osi Y o 1000
    (command "EXTRUDE" (entlast) "" "1000" "0")
    
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")

    ;; cofnij o 500 w przeciwnym kierunku niz wyciagniecie
    (command "MOVE" (entlast) "" "0,0,0" "0,-500,0")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; PROSTOKATY Y
  ;; Plaszczyzna prostopadla do osi X
  ;; (stala wspolrzedna X, rozciaga sie w YZ)
  ;; ---------------------------------

  (setq taz_s_tmp taz_s_y_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))

    (taz_s_get_dist)

    ;; pozycja X osi - nie zmienia sie
    (setq taz_s_x taz_s_val)

    ;; przesuniecie Z dla tej kopii
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; punkty prostokata przesuniete w gore o offset
    (setq taz_s_p1 (list taz_s_x taz_s_ymin (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_x taz_s_ymax (+ taz_s_zmin taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_x taz_s_ymax (+ taz_s_zmax taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_x taz_s_ymin (+ taz_s_zmax taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")

    ;; wyciagnij prostokat wzdluz osi X o 1000
    (command "EXTRUDE" (entlast) "" "1000" "0")
    
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")

    ;; przesuń bryłę o -500 wzdluz X
    ;; aby plaszczyzna byla w srodku bryly
    (command "MOVE" (entlast) "" "0,0,0" "-500,0,0")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; PROSTOKATY Z
  ;; Plaszczyzna pozioma
  ;; (stala wspolrzedna Z, rozciaga sie w XY)
  ;; ---------------------------------

  (setq taz_s_tmp taz_s_z_data)

  (while taz_s_tmp

    (setq taz_s_row (car taz_s_tmp))

    (taz_s_get_dist)

    ;; wysokosc Z osi - przesunieta o offset kopii
    (setq taz_s_z taz_s_val)

    ;; przesuniecie Z dla tej kopii
    (setq taz_s_zoffset (* taz_s_copy_nr 100000))

    ;; punkty prostokata - Z oryginalne + offset kopii
    (setq taz_s_p1 (list taz_s_xmin taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p2 (list taz_s_xmax taz_s_ymin (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p3 (list taz_s_xmax taz_s_ymax (+ taz_s_z taz_s_zoffset)))
    (setq taz_s_p4 (list taz_s_xmin taz_s_ymax (+ taz_s_z taz_s_zoffset)))

    (command "3DPOLY" taz_s_p1 taz_s_p2 taz_s_p3 taz_s_p4 taz_s_p1 "")

    ;; wyciagnij prostokat wzdluz osi Z o 1000
    (command "EXTRUDE" (entlast) "" "1000" "0")
    
    (command "_ZOOM" "_OBJECT" (entlast) "")
    (command "_ZOOM" "_SCALE" "1000X")
    (command "REGEN")

    ;; przesuń bryłę o -500 wzdluz Z
    ;; aby plaszczyzna byla w srodku bryly
    (command "MOVE" (entlast) "" "0,0,0" "0,0,-500")

    (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
    (setq taz_s_tmp (cdr taz_s_tmp))
  )

  ;; ---------------------------------
  ;; KOPIOWANIE MODELU (BEZ OSI, BEZ PROSTOKATOW)
  ;; DLA KAZDEJ PLASZCZYZNY
  ;;
  ;; Selekcje robimy RAZ przed petla - zeby
  ;; przy kazdym COPY zrodlem byl zawsze tylko
  ;; oryginalny model, a nie narastajace kopie.
  ;; ---------------------------------

  (setq taz_s_total_copies (- taz_s_copy_nr 1))

  ;; zaznacz raz - tylko oryginalny model
  ;; (bez osi i bez prostokatow)
  (setq taz_s_copy_ss
    (ssget "X"
      (list
        (cons -4 "<AND")
        (cons -4 "<NOT")
        (cons 8 "taz_s_axes")
        (cons -4 "NOT>")
        (cons -4 "<NOT")
        (cons 8 "taz_s_execution_design")
        (cons -4 "NOT>")
        (cons -4 "AND>")
      )
    )
  )

  ;; kopiuj tyle razy ile plaszczyzn
  ;; za kazdym razem ze stalej selekcji oryginalu
  (if taz_s_copy_ss

    (progn

      (setq taz_s_copy_nr 1)

      (while (<= taz_s_copy_nr taz_s_total_copies)

        (setq taz_s_zoffset (* taz_s_copy_nr 100000))

        (command
          "COPY"
          taz_s_copy_ss
          ""
          "0,0,0"
          (list 0 0 taz_s_zoffset)
        )

        (setq taz_s_copy_nr (+ taz_s_copy_nr 1))
      )
    )
  )

  (taz_s_lock_all_layers)
  (taz_s_current_settings_restore)
  (princ)
)
