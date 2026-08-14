taz_s_create_drawings_execution_design_organize_dialog : dialog {
  label = "TAZ - Format arkusza";

  : column {

    : row {
      alignment = centered;

      : text {
        label = "Format arkusza:";
        width = 20;
        fixed_width = true;
      }

      : popup_list {
        key = "taz_s_organize_frame_format_popup";
        width = 20;
        fixed_width = true;
      }
    }
  }

  ok_cancel;
}
