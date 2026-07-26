taz_s_annotation_scale_dialog : dialog {
  label = "TAZ - Skala opisu";

  : column {

    : row {
      : text {
        label = "Skala opisu:";
        width = 20;
        fixed_width = true;
      }
    }

    : row {
      : popup_list {
        key = "taz_s_annotation_scale_popup";
        width = 20;
        fixed_width = true;
      }
    }

  }

  ok_cancel;
}
