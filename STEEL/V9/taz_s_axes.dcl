axes_dialog : dialog {
  label = "Osie modelu";

  : row {

    // ============================
    // X
    // ============================
    : boxed_column {
      label = "X";

      : row {
        : text { label="Nazwa"; width=10; }
        : text { label="Odległość"; width=12; }
      }

      : row {
        : edit_box { key="x_name"; edit_width=10; }
        : edit_box { key="x_dist"; edit_width=12; }
        : button { key="x_add"; label="+"; width=3; }
      }

      : list_box {
        key = "x_list";
        width = 30;
        height = 8;
      }

      : button { key="x_clear"; label="Wyczyść"; }
    }

    // ============================
    // Y
    // ============================
    : boxed_column {
      label = "Y";

      : row {
        : text { label="Nazwa"; width=10; }
        : text { label="Odległość"; width=12; }
      }

      : row {
        : edit_box { key="y_name"; edit_width=10; }
        : edit_box { key="y_dist"; edit_width=12; }
        : button { key="y_add"; label="+"; width=3; }
      }

      : list_box {
        key = "y_list";
        width = 30;
        height = 8;
      }

      : button { key="y_clear"; label="Wyczyść"; }
    }

    // ============================
    // Z
    // ============================
    : boxed_column {
      label = "Z";

      : row {
        : text { label="Nazwa"; width=10; }
        : text { label="Odległość"; width=12; }
      }

      : row {
        : edit_box { key="z_name"; edit_width=10; }
        : edit_box { key="z_dist"; edit_width=12; }
        : button { key="z_add"; label="+"; width=3; }
      }

      : list_box {
        key = "z_list";
        width = 30;
        height = 8;
      }

      : button { key="z_clear"; label="Wyczyść"; }
    }

  }

  ok_cancel;
}
