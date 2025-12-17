;; taz_s_section.lsp
;; HEA + HEB, dynamiczne przeładowanie listy Typ po zmianie Rodziny
;; Poprawka: get_tile dla popup_list zwraca indeks (string), więc mapujemy indeks->nazwa

;; ---------------------------
;; Bazy danych HEA i HEB (H BF TW TF R)
;; ---------------------------
(setq taz_s_HEA_data
 '(
   ("HEA100"  (H 96)   (BF 100) (TW 5)   (TF 8)   (R 12))
   ("HEA120"  (H 114)  (BF 120) (TW 5)   (TF 8)   (R 12))
   ("HEA140"  (H 133)  (BF 140) (TW 5.5) (TF 8.5) (R 12))
   ("HEA160"  (H 152)  (BF 160) (TW 6)   (TF 9)   (R 15))
   ("HEA180"  (H 171)  (BF 180) (TW 6)   (TF 9.5) (R 15))
   ("HEA200"  (H 190)  (BF 200) (TW 6.5) (TF 10)  (R 18))
   ("HEA220"  (H 210)  (BF 220) (TW 7)   (TF 11)  (R 18))
   ("HEA240"  (H 230)  (BF 240) (TW 7.5) (TF 12)  (R 21))
   ("HEA260"  (H 250)  (BF 260) (TW 7.5) (TF 12.5)(R 24))
   ("HEA280"  (H 270)  (BF 280) (TW 8)   (TF 13)  (R 24))
   ("HEA300"  (H 290)  (BF 300) (TW 8.5) (TF 14)  (R 27))
   ("HEA320"  (H 310)  (BF 300) (TW 9)   (TF 15.5)(R 27))
   ("HEA340"  (H 330)  (BF 300) (TW 9.5) (TF 16.5)(R 27))
   ("HEA360"  (H 350)  (BF 300) (TW 10)  (TF 17.5)(R 27))
   ("HEA400"  (H 390)  (BF 300) (TW 11)  (TF 19)  (R 27))
   ("HEA450"  (H 440)  (BF 300) (TW 11.5)(TF 21)  (R 27))
   ("HEA500"  (H 490)  (BF 300) (TW 12)  (TF 23)  (R 27))
   ("HEA550"  (H 540)  (BF 300) (TW 12.5)(TF 24)  (R 27))
   ("HEA600"  (H 590)  (BF 300) (TW 13)  (TF 25)  (R 27))
   ("HEA650"  (H 640)  (BF 300) (TW 13.5)(TF 26)  (R 27))
   ("HEA700"  (H 690)  (BF 300) (TW 14.5)(TF 27)  (R 27))
   ("HEA800"  (H 790)  (BF 300) (TW 15)  (TF 28)  (R 30))
   ("HEA900"  (H 890)  (BF 300) (TW 16)  (TF 30)  (R 30))
   ("HEA1000" (H 990)  (BF 300) (TW 16.5)(TF 31)  (R 30))
 ))

(setq taz_s_HEB_data
 '(
   ("HEB100"  (H 100)  (BF 100) (TW 6)   (TF 10)  (R 12))
   ("HEB120"  (H 120)  (BF 120) (TW 6.5) (TF 11)  (R 12))
   ("HEB140"  (H 140)  (BF 140) (TW 7)   (TF 12)  (R 12))
   ("HEB160"  (H 160)  (BF 160) (TW 8)   (TF 13)  (R 15))
   ("HEB180"  (H 180)  (BF 180) (TW 8.5) (TF 14)  (R 15))
   ("HEB200"  (H 200)  (BF 200) (TW 9)   (TF 15)  (R 18))
   ("HEB220"  (H 220)  (BF 220) (TW 9.5) (TF 16)  (R 18))
   ("HEB240"  (H 240)  (BF 240) (TW 10)  (TF 17)  (R 21))
   ("HEB260"  (H 260)  (BF 260) (TW 10)  (TF 17.5)(R 24))
   ("HEB280"  (H 280)  (BF 280) (TW 10.5)(TF 18)  (R 24))
   ("HEB300"  (H 300)  (BF 300) (TW 11)  (TF 19)  (R 27))
   ("HEB320"  (H 320)  (BF 300) (TW 11.5)(TF 20.5)(R 27))
   ("HEB340"  (H 340)  (BF 300) (TW 12)  (TF 21.5)(R 27))
   ("HEB360"  (H 360)  (BF 300) (TW 12.5)(TF 22.5)(R 27))
   ("HEB400"  (H 400)  (BF 300) (TW 13.5)(TF 24)  (R 27))
   ("HEB450"  (H 450)  (BF 300) (TW 14)  (TF 26)  (R 27))
   ("HEB500"  (H 500)  (BF 300) (TW 14.5)(TF 28)  (R 27))
   ("HEB550"  (H 550)  (BF 300) (TW 15)  (TF 29)  (R 27))
   ("HEB600"  (H 600)  (BF 300) (TW 15.5)(TF 30)  (R 27))
   ("HEB650"  (H 650)  (BF 300) (TW 16)  (TF 31)  (R 27))
   ("HEB700"  (H 700)  (BF 300) (TW 17)  (TF 32)  (R 27))
   ("HEB800"  (H 800)  (BF 300) (TW 17.5)(TF 33)  (R 30))
   ("HEB900"  (H 900)  (BF 300) (TW 18.5)(TF 35)  (R 30))
   ("HEB1000" (H 1000) (BF 300) (TW 19)  (TF 36)  (R 30))
 ))

;; ---------------------------
;; Pobranie parametru z wpisu
;; ---------------------------
(defun taz_s_param_from_entry (sym entry)
  (if entry (cadr (assoc sym (cdr entry))) nil)
)

;; ---------------------------
;; Zastosuj wpis do zmiennych globalnych (zapamiętanie w sesji)
;; ---------------------------
(defun taz_s_apply_entry (entry)
  (if entry
    (progn
      (setq taz_s_selected_entry entry)
      (setq taz_s_H  (taz_s_param_from_entry 'H  entry))
      (setq taz_s_BF (taz_s_param_from_entry 'BF entry))
      (setq taz_s_TW (taz_s_param_from_entry 'TW entry))
      (setq taz_s_TF (taz_s_param_from_entry 'TF entry))
      (setq taz_s_R  (taz_s_param_from_entry 'R  entry))
      T)
    nil)
)

;; ---------------------------
;; Wypełnij listę "typ" na podstawie nazwy rodziny ("HEA" lub "HEB")
;; ---------------------------
(defun taz_s_populate_types (family / list)
  (cond
    ((and family (equal family "HEB")) (setq list taz_s_HEB_data))
    (T                                   (setq list taz_s_HEA_data))
  )
  (if list
    (progn
      (start_list "typ")
      (foreach e list (add_list (car e)))
      (end_list)
      (set_tile "typ" "0")
    )
  )
)

;; ---------------------------
;; Główny szkic rysujący (Twoja sekwencja, zmienne zamiast stałych)
;; ---------------------------
(defun c:taz_s_section (/ p s s0 temperr taz_s_echo taz_s_osmode taz_s_clayer
                         halfBF x_web_left x_web_right x_a x_b x_c x_d
                         y_tf y_tfR y_hTR y_h)
  (setq p (getpoint "\nSpecify a point: "))
  (setq temperr *error*)
  (setq taz_s_echo (getvar "cmdecho")) (setvar "cmdecho" 0)
  (command "_.undo" "_group")
  (setq taz_s_osmode (getvar "osmode")) (setvar "osmode" 0)
  (setq taz_s_clayer (getvar "clayer"))
  (setq *error* taz_s_error)
  (setq s (ssadd))

  (if (not (and (boundp 'taz_s_H) (boundp 'taz_s_BF) (boundp 'taz_s_TW) (boundp 'taz_s_TF) (boundp 'taz_s_R)))
    (progn (prompt "\nBłąd: profil nie ustawiony. Użyj dialogu wyboru.") (princ) (return))
  )

  (setq halfBF (/ taz_s_BF 2.0))
  (setq x_web_left  (- halfBF (/ taz_s_TW 2.0)))
  (setq x_web_right (+ halfBF (/ taz_s_TW 2.0)))
  (setq x_a (- x_web_left taz_s_R)) (setq x_b x_web_left) (setq x_c x_web_right) (setq x_d (+ x_web_right taz_s_R))
  (if (< x_a 0) (setq x_a 0)) (if (> x_d taz_s_BF) (setq x_d taz_s_BF))

  (setq y_tf taz_s_TF) (setq y_tfR (+ taz_s_TF taz_s_R)) (setq y_hTR (- taz_s_H taz_s_TF taz_s_R)) (setq y_h (- taz_s_H taz_s_TF))

  (command "_-layer" "_m" "steel_contour" "")
  (command "_pline"
           (list 0 y_tf)
           (list x_a y_tf)
           "_a" "_r" taz_s_R (list x_b y_tfR)
           "_l" (list x_b y_hTR)
           "_a" "_r" taz_s_R (list x_a y_h)
           "_l" (list 0 y_h)
           (list 0 taz_s_H)
           (list taz_s_BF taz_s_H)
           (list taz_s_BF y_h)
           (list x_d y_h)
           "_a" "_r" taz_s_R (list x_c y_hTR)
           "_l" (list x_c y_tfR)
           "_a" "_r" taz_s_R (list x_d y_tf)
           "_l" (list taz_s_BF y_tf)
           (list taz_s_BF 0)
           (list 0 0)
           (list 0 y_tf)
           ""
  )
  (ssadd (entlast) s)

  ;; Hatch (warunkowo)
  (if (and (boundp 'taz_s_do_hatch) taz_s_do_hatch)
    (progn
      (command "_-layer" "_m" "steel_hatch" "")
      (command "_-hatch" "_s" s "" "_p" "ANSI31" "0.8" "0" "")
      (ssadd (entlast) s)
    )
  )

  ;; Centerlines (warunkowo)
  (if (and (boundp 'taz_s_draw_center) taz_s_draw_center)
    (progn
      (command "_-layer" "_m" "centerline" "")
      (command "_line" (list (/ taz_s_BF 2.0) (- y_tf 9.6)) (list (/ taz_s_BF 2.0) (+ taz_s_H 9.6)) "")
      (ssadd (entlast) s)
      (command "_line" (list -10 (/ taz_s_H 2.0)) (list (+ taz_s_BF 10) (/ taz_s_H 2.0)) "")
      (ssadd (entlast) s)
    )
  )

  (command "_move" s "" (list 0 0) p)
  (setvar "clayer" taz_s_clayer) (setvar "osmode" taz_s_osmode)
  (command "_.undo" "_end") (setvar "cmdecho" taz_s_echo)
  (princ)
)

;; ---------------------------
;; Dialog: bezpieczne ładowanie DCL i dynamiczne przeładowanie typów
;; ---------------------------
(defun c:taz_s_section_dialog (/ dclpath dcl_id wynik rodz typ_index entry typ idx default_typ_str
                                 draw_center_val do_hatch_val current_family_index current_family)
  ;; znajdź i załaduj DCL
  (setq dclpath (findfile "taz_s_section.dcl"))
  (if (not dclpath) (progn (prompt "\nBłąd: nie znaleziono taz_s_section.dcl") (princ) (exit)))
  (setq dcl_id (load_dialog dclpath))
  (if (not dcl_id) (progn (prompt "\nBłąd: load_dialog nie powiódł się") (princ) (exit)))
  (if (not (new_dialog "taz_s_section_dialog" dcl_id)) (progn (prompt "\nBłąd: new_dialog nie może otworzyć dialogu") (unload_dialog dcl_id) (princ) (exit)))

  ;; Rodzina: wypełnij listę rodzin (indeksy)
  (start_list "rodzina") (add_list "HEA") (add_list "HEB") (end_list)

  ;; Przywróć poprzednią rodzinę jeśli istnieje (ustawiamy indeks)
  (if (and (boundp 'taz_s_selected_entry) taz_s_selected_entry)
    (progn
      (setq current_family (substr (car taz_s_selected_entry) 1 3))
      (if (equal current_family "HEB") (setq current_family_index "1") (setq current_family_index "0"))
    )
    (setq current_family_index "0")
  )
  (set_tile "rodzina" current_family_index)

  ;; Wypełnij typy zgodnie z aktualną rodziną (mapujemy indeks->nazwa)
  (setq current_family (if (= (atoi (get_tile "rodzina")) 1) "HEB" "HEA"))
  (taz_s_populate_types current_family)

  ;; Przywróć checkboxy (flagi "1"/"0"), domyślnie "1"
  (setq draw_center_val (if (boundp 'taz_s_draw_center_flag) taz_s_draw_center_flag "1"))
  (setq do_hatch_val    (if (boundp 'taz_s_do_hatch_flag)    taz_s_do_hatch_flag    "1"))
  (set_tile "draw_center" draw_center_val)
  (set_tile "do_hatch" do_hatch_val)

  ;; action_tile dla zmiany rodziny: get_tile zwraca indeks -> mapujemy na nazwę i przeładujemy typy
  (action_tile "rodzina"
    "(progn
       (setq idx (atoi (get_tile \"rodzina\")))
       (setq fam (if (= idx 1) \"HEB\" \"HEA\"))
       (taz_s_populate_types fam)
       (set_tile \"typ\" \"0\")
     )"
  )

  ;; action_tile OK: wybierz wpis z odpowiedniej bazy i zapisz flagi
  (action_tile "ok"
    "(progn
       (setq rodz_idx (atoi (get_tile \"rodzina\")))
       (setq rodz (if (= rodz_idx 1) \"HEB\" \"HEA\"))
       (setq typ_index (atoi (get_tile \"typ\")))
       (setq taz_s_selected_entry (nth typ_index (if (equal rodz \"HEB\") taz_s_HEB_data taz_s_HEA_data)))
       ;; zapisz flagi jako stringi '1'/'0' i ustaw zmienne logiczne
       (setq taz_s_draw_center_flag (if (= (atoi (get_tile \"draw_center\")) 1) \"1\" \"0\"))
       (setq taz_s_do_hatch_flag    (if (= (atoi (get_tile \"do_hatch\")) 1)    \"1\" \"0\"))
       (setq taz_s_draw_center (if (= taz_s_draw_center_flag \"1\") T nil))
       (setq taz_s_do_hatch    (if (= taz_s_do_hatch_flag    \"1\") T nil))
     )
     (done_dialog 1)"
  )

  (action_tile "cancel" "(done_dialog 0)")

  ;; uruchom dialog
  (setq wynik (start_dialog))
  (unload_dialog dcl_id)

  ;; jeśli OK: zastosuj wpis i wywołaj rysowanie
  (if (= wynik 1)
    (progn
      (if (and (boundp 'taz_s_selected_entry) taz_s_selected_entry)
        (progn
          (if (taz_s_apply_entry taz_s_selected_entry)
            (c:taz_s_section)
            (prompt "\nBłąd: nie udało się zastosować wpisu.")
          )
        )
        (prompt "\nBłąd: nie znaleziono parametrów dla wybranego typu.")
      )
    )
    (prompt "\nPrzerwano.")
  )
  (princ)
)

;; ---------------------------
;; Obsługa błędu
;; ---------------------------
(defun taz_s_error (errmsg)
  (setq *error* temperr)
  (if (boundp 'taz_s_clayer) (setvar "clayer" taz_s_clayer))
  (if (boundp 'taz_s_osmode) (setvar "osmode" taz_s_osmode))
  (if (boundp 'taz_s_echo) (setvar "cmdecho" taz_s_echo))
  (princ)
)

