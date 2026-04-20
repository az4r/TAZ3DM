(defun c:taz_s_start()
  
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

)