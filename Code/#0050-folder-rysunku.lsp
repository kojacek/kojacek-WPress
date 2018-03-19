; ----------------------------------------------------------------- ;
; Otwiera katalog (lokalizacje) aktywnego rysunku. by kojacek       ;
; ----------------------------------------------------------------- ;
(defun C:FF ()
  (if
    (zerop (getvar "DWGTITLED"))
    (princ "\nRysunek nie jest jeszcze nazwany") 
    (startapp (strcat "explorer" " " (getvar "DWGPREFIX"))) 
  )
  (princ)
)
; ----------------------------------------------------------------- ;
(princ)
