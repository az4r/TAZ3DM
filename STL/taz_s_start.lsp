(defun taz_s_start()
  
(if (tblsearch "LAYER" "taz_s_beam")
  (princ)
  (command "_layer" "_M" "taz_s_beam" "_C" "145" "" "")
)
  
(if (tblsearch "LAYER" "taz_s_plate")
  (princ)
  (command "_layer" "_M" "taz_s_plate" "_C" "30" "" "")
)
  
(if (tblsearch "LAYER" "taz_s_axes")
  (princ)
  (command "_layer" "_M" "taz_s_axes" "_C" "109" "" "")
)
  
(command "_layer" "_S" "0" "")
  
(command "_SAVE" "")
  
(setq taz_s_mkdwgdir (strcat (getvar "DWGPREFIX") (substr (getvar "DWGNAME") 1 (- (strlen (getvar "DWGNAME")) 4))))

(vl-mkdir taz_s_mkdwgdir)

)
(taz_s_start)
