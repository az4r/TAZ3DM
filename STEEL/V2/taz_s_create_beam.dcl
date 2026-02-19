taz_s_create_beam : dialog {
    label = "Wybór profilu";

    : boxed_column {
        label = "Parametry";

        : row {
            : text { label = "Kategoria:"; }
            : popup_list { key = "taz_s_cat"; }
        }

        : row {
            : text { label = "Rodzina:"; }
            : popup_list { key = "taz_s_fam"; }
        }

        : row {
            : text { label = "Typ:"; }
            : popup_list { key = "taz_s_typ"; }
        }
    }

    : row {
        : button { key = "ok"; label = "OK"; is_default = true; }
        : button { key = "anuluj"; label = "Anuluj"; is_cancel = true; }
    }
}
