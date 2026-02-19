taz_s_edit_attributes : dialog {
  label = "Edycja atrybutów";

  : column {
    : row { : text { label = "NUMER EP:"; width = 30; fixed_width = true; }  : edit_box { key = "attr1";  edit_width = 20; } }
    : row { : text { label = "NUMER EW:"; width = 30; fixed_width = true; }  : edit_box { key = "attr2";  edit_width = 20; } }
    : row { : text { label = "PREFIKS EP:"; width = 30; fixed_width = true; }  : edit_box { key = "attr3";  edit_width = 20; } }
    : row { : text { label = "PREFIKS EW:"; width = 30; fixed_width = true; }  : edit_box { key = "attr4";  edit_width = 20; } }
    : row { : text { label = "ETAP:"; width = 30; fixed_width = true; }  : edit_box { key = "attr5";  edit_width = 20; } }
    : row { : text { label = "NAZWA PROFILU:"; width = 30; fixed_width = true; }  : edit_box { key = "attr6";  edit_width = 20; } }
    : row { : text { label = "MATERIAL:"; width = 30; fixed_width = true; }  : edit_box { key = "attr7";  edit_width = 20; } }
    : row { : text { label = "FUNKCJA:"; width = 30; fixed_width = true; }  : edit_box { key = "attr8";  edit_width = 20; } }
    : row { : text { label = "ATRYBUT DODATKOWY 1:"; width = 30; fixed_width = true; }  : edit_box { key = "attr9";  edit_width = 20; } }
    : row { : text { label = "ATRYBUT DODATKOWY 2:"; width = 30; fixed_width = true; } : edit_box { key = "attr10"; edit_width = 20; } }
  }

  ok_cancel;
}
