axes_dialog : dialog {
  label = "Osie modelu";

  : boxed_radio_column {
    label = "Zakładki";
    key = "tabs";
    : radio_button { label = "X"; key = "tabX"; }
    : radio_button { label = "Y"; key = "tabY"; }
    : radio_button { label = "Z"; key = "tabZ"; }
  }

  spacer_1;

  // ============================
  //   PANEL X
  // ============================
  : column {
    key = "panelX";
    : row { : label { key="x1a"; } : label { key="x1b"; } : label { key="x1c"; } }
    : row { : label { key="x2a"; } : label { key="x2b"; } : label { key="x2c"; } }
    : row { : label { key="x3a"; } : label { key="x3b"; } : label { key="x3c"; } }
    : row { : label { key="x4a"; } : label { key="x4b"; } : label { key="x4c"; } }
    : row { : label { key="x5a"; } : label { key="x5b"; } : label { key="x5c"; } }
  }

  // ============================
  //   PANEL Y
  // ============================
  : column {
    key = "panelY";
    : row { : label { key="y1a"; } : label { key="y1b"; } : label { key="y1c"; } }
    : row { : label { key="y2a"; } : label { key="y2b"; } : label { key="y2c"; } }
    : row { : label { key="y3a"; } : label { key="y3b"; } : label { key="y3c"; } }
    : row { : label { key="y4a"; } : label { key="y4b"; } : label { key="y4c"; } }
    : row { : label { key="y5a"; } : label { key="y5b"; } : label { key="y5c"; } }
  }

  // ============================
  //   PANEL Z
  // ============================
  : column {
    key = "panelZ";
    : row { : label { key="z1a"; } : label { key="z1b"; } : label { key="z1c"; } }
    : row { : label { key="z2a"; } : label { key="z2b"; } : label { key="z2c"; } }
    : row { : label { key="z3a"; } : label { key="z3b"; } : label { key="z3c"; } }
    : row { : label { key="z4a"; } : label { key="z4b"; } : label { key="z4c"; } }
    : row { : label { key="z5a"; } : label { key="z5b"; } : label { key="z5c"; } }
  }

  ok_cancel;

}
