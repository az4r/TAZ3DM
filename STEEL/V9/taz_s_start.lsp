(defun c:taz_s_start()
  
(if (tblsearch "LAYER" "taz_s_beam")
  (princ)
  (command "_layer" "_M" "taz_s_beam" "_C" "145" "" "")
)
  
(if (tblsearch "LAYER" "taz_s_grid")
  (princ)
  (command "_layer" "_M" "taz_s_grid" "_C" "109" "" "")
)
  
(command "_layer" "_S" "0" "")

)