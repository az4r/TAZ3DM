taz_s_axes_dialog : dialog {
  label = "Osie modelu";

  : column {

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
          : edit_box { key="taz_s_x_name"; edit_width=10; }
          : edit_box { key="taz_s_x_dist"; edit_width=12; }
          : button { key="taz_s_x_add"; label="+"; width=3; }
        }

        : list_box { key="taz_s_x_list"; width=30; height=8; }

        : button { key="taz_s_x_clear"; label="Wyczyść"; }
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
          : edit_box { key="taz_s_y_name"; edit_width=10; }
          : edit_box { key="taz_s_y_dist"; edit_width=12; }
          : button { key="taz_s_y_add"; label="+"; width=3; }
        }

        : list_box { key="taz_s_y_list"; width=30; height=8; }

        : button { key="taz_s_y_clear"; label="Wyczyść"; }
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
          : edit_box { key="taz_s_z_name"; edit_width=10; }
          : edit_box { key="taz_s_z_dist"; edit_width=12; }
          : button { key="taz_s_z_add"; label="+"; width=3; }
        }

        : list_box { key="taz_s_z_list"; width=30; height=8; }

        : button { key="taz_s_z_clear"; label="Wyczyść"; }
      }

    }

    spacer;

    // ============================
    // OFFSET
    // ============================
    : boxed_row {
      label = "Ustawienia";

      : text { label="Offset osi:"; }
      : edit_box { key="taz_s_offset"; edit_width=10; value="1000"; }
    }

  }

  ok_cancel;
}
