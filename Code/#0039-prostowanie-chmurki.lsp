;-------------------------------------------------------
; by kojacek
;-------------------------------------------------------
(defun C:PLWP (/ Sel Data NData) 
  (if 
    (setq Sel (entsel "\nWybierz LWPoly: ")) 
    (if 
      (= 
        (cdr 
          (assoc 0 
            (setq Data 
              (entget (car Sel)) 
            ) 
          ) 
        ) "LWPOLYLINE") 
        (progn 
          (setq NData 
            (vl-remove-if 
              (function 
                (lambda (%)(= (car %) 42)) 
              ) 
              Data 
            ) 
         ) 
         (entmod NData) 
         T 
       )
       Nil 
    ) 
    Nil 
  ) 
)
;-------------------------------------------------------
(princ)
