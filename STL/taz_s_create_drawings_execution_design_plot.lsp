;; =============================================================
;; taz_s_create_drawings_execution_design_plot.lsp
;;
;; Drugi etap tworzenia rysunow wykonawczych.
;; Uruchamiamy PO taz_s_create_drawings_execution_design_v6.lsp
;;
;; Dla kazdego przypadku zapisanego w taz_s_ed_section_sets:
;;   1. Tworzy nowy arkusz (layout) o nazwie SECTION_<nazwa_osi>
;;   2. Wchodzi do rzutni domyslnej na nowym arkuszu
;;   3. Przywraca saved view dla tego przypadku
;;   4. Wykonuje SOLPROF na obiektach z danego selection setu
;; =============================================================

(defun c:taz_s_create_drawings_execution_design_plot ()

  (taz_s_current_settings_save)

  ;; ---------------------------------
  ;; SPRAWDZENIE CZY LISTA SETOW ISTNIEJE
  ;; ---------------------------------

  (if (or (not (boundp 'taz_s_ed_section_sets))
          (null taz_s_ed_section_sets)
      )
    (progn
      (alert "Brak danych z poprzedniego etapu!\nUruchom najpierw taz_s_create_drawings_execution_design.")
      (taz_s_current_settings_restore)
      (princ)
    )

    ;; ---------------------------------
    ;; GLOWNA PETLA PO PRZYPADKACH
    ;; ---------------------------------

    (progn

      (setq taz_s_plot_list taz_s_ed_section_sets)

      (while taz_s_plot_list

        (setq taz_s_plot_pair      (car taz_s_plot_list))
        (setq taz_s_plot_axis_name (car taz_s_plot_pair))
        (setq taz_s_plot_ss        (cdr taz_s_plot_pair))

        (setq taz_s_plot_layout_name
          (strcat "SECTION_" taz_s_plot_axis_name)
        )
        (setq taz_s_plot_view_name
          (strcat "taz_s_execution_design_view_" taz_s_plot_axis_name)
        )

        (princ (strcat "\n[PLOT] Przetwarzam: " taz_s_plot_axis_name))

        ;; -----------------------------------------------
        ;; KROK 1: UTWORZ NOWY ARKUSZ (LAYOUT)
        ;; W GstarCAD uzywamy zwyklego (command ...) bez
        ;; vl-catch-all-apply ktory tam nie dziala z 'command
        ;; -----------------------------------------------

        (command "_layout" "_N" taz_s_plot_layout_name)

        ;; Upewniamy sie ze jestesmy na wlasciwym layoucie
        ;; przez CTAB - w GstarCAD _layout _N automatycznie
        ;; przelacza do nowego layoutu, ale dla pewnosci:
        (setvar "CTAB" taz_s_plot_layout_name)

        (princ (strcat "\n[PLOT] Utworzono arkusz: " taz_s_plot_layout_name))

        ;; -----------------------------------------------
        ;; KROK 2: WEJDZ DO RZUTNI (MSPACE)
        ;;
        ;; Na nowym layoucie jest jedna domyslna rzutnia.
        ;; Musimy do niej wejsc zeby SOLPROF i VIEW dzialaly
        ;; w kontekscie tej rzutni.
        ;; W GstarCAD komenda to MSPACE (bez podkreslnika).
        ;; -----------------------------------------------

        (command "MSPACE")

        ;; -----------------------------------------------
        ;; KROK 3: PRZYWROC ZAPISANY VIEW
        ;; -----------------------------------------------

        (if (tblsearch "VIEW" taz_s_plot_view_name)
          (progn
            (command "-VIEW" "_R" taz_s_plot_view_name)
            (princ (strcat "\n[PLOT] Przywrocono view: " taz_s_plot_view_name))
          )
          (progn
            (princ (strcat "\n[PLOT] UWAGA: Nie znaleziono view: " taz_s_plot_view_name))
            (command "_ZOOM" "_E")
          )
        )

        ;; -----------------------------------------------
        ;; KROK 4: SOLPROF
        ;;
        ;; WAZNE: (command ...) nie przyjmuje selection setu
        ;; jako argumentu bezposrednio. Musimy obiekt po obiekcie
        ;; wyslac enames do komendy, a potem zakonczyc pustym "".
        ;;
        ;; Schemat:
        ;;   (command "SOLPROF")         <- uruchom komende
        ;;   (command ename1)            <- wskazuj obiekty
        ;;   (command ename2)
        ;;   ...
        ;;   (command "")                <- Enter - koniec wyboru
        ;;   (command "_Y" "_Y" "_Y")    <- odpowiedzi na pytania
        ;; -----------------------------------------------

        (if (and taz_s_plot_ss (> (sslength taz_s_plot_ss) 0))
          (progn
            (princ (strcat "\n[PLOT] Wykonuje SOLPROF dla: " taz_s_plot_axis_name
                           " (" (itoa (sslength taz_s_plot_ss)) " obiektow)"))

            ;; Uruchom SOLPROF
            (command "SOLPROF")

            ;; Przekaz obiekty ze selection setu jeden po jeden
            (setq taz_s_si 0)
            (while (< taz_s_si (sslength taz_s_plot_ss))
              (command (ssname taz_s_plot_ss taz_s_si))
              (setq taz_s_si (+ taz_s_si 1))
            )

            ;; Enter - koniec wyboru obiektow
            (command "")

            ;; Odpowiedzi na pytania SOLPROF:
            ;;   Display hidden profile lines on separate layer? -> Y
            ;;   Project profile lines onto a plane?             -> Y
            ;;   Delete tangential edges?                        -> Y
            (command "_Y")
            (command "_Y")
            (command "_Y")

            (princ (strcat "\n[PLOT] SOLPROF zakonczony dla: " taz_s_plot_axis_name))
          )
          (progn
            (princ (strcat "\n[PLOT] UWAGA: Pusty selection set dla: "
                           taz_s_plot_axis_name " - pomijam SOLPROF."))
          )
        )

        ;; Wyjdz z mspace z powrotem do przestrzeni papieru
        (command "PSPACE")

        (setq taz_s_plot_list (cdr taz_s_plot_list))
      )

      (princ "\n[PLOT] Wszystkie przypadki przetworzone.")
      (taz_s_current_settings_restore)
      (princ)
    )
  )
)
