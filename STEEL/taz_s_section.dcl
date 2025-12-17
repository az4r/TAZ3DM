taz_s_section_dialog : dialog {
    label = "Wybór profilu";

    : row {
        : text { label = "Rodzina:"; }
        : popup_list { key = "rodzina"; }
    }

    : row {
        : text { label = "Typ:"; }
        : popup_list { key = "typ"; }
    }

    : row {
        : toggle { key = "draw_center"; label = "Rysuj linie centralne"; value = "1"; }
    }

    : row {
        : toggle { key = "do_hatch"; label = "Rysuj kreskowanie"; value = "1"; }
    }

    : row {
        : button { key = "ok"; label = "OK"; is_default = true; }
        : button { key = "cancel"; label = "Anuluj"; is_cancel = true; }
    }
}

