axes_dialog : dialog {
  label = "Osie modelu";

  : row {

    // ============================
    // KOLUMNA X
    // ============================
    : boxed_column {
      label = "X";

      : row {
        : edit_box { key="x_name1"; edit_width=8; }
        : edit_box { key="x_dist"; edit_width=8; }
        : edit_box { key="x_name2"; edit_width=8; }
        : button { key="x_add"; label="+"; width=3; }
      }

      : list_box {
        key = "x_list";
        width = 30;
        height = 8;
      }

      : button {
        key = "x_clear";
        label = "Wyczyść";
      }
    }

    // ============================
    // KOLUMNA Y
    // ============================
    : boxed_column {
      label = "Y";

      : row {
        : edit_box { key="y_name1"; edit_width=8; }
        : edit_box { key="y_dist"; edit_width=8; }
        : edit_box { key="y_name2"; edit_width=8; }
        : button { key="y_add"; label="+"; width=3; }
      }

      : list_box {
        key = "y_list";
        width = 30;
        height = 8;
      }

      : button {
        key = "y_clear";
        label = "Wyczyść";
      }
    }

    // ============================
    // KOLUMNA Z
    // ============================
    : boxed_column {
      label = "Z";

      : row {
        : edit_box { key="z_name1"; edit_width=8; }
        : edit_box { key="z_dist"; edit_width=8; }
        : edit_box { key="z_name2"; edit_width=8; }
        : button { key="z_add"; label="+"; width=3; }
      }

      : list_box {
        key = "z_list";
        width = 30;
        height = 8;
      }

      : button {
        key = "z_clear";
        label = "Wyczyść";
      }
    }

  }

  ok_cancel;
}
