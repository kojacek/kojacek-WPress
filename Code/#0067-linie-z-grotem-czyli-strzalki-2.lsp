;;; ================================================================== ;
;;; by kojacek 2016
(defun C:B-LINE (/ ps pe sc an en ds flag)
  (setq sc (getvar "DIMASZ"))
  (if
    (setq ps (getpoint  "\nPunkt początkowy: "))
    (while
      (not flag)
      (progn
        (setq pe (getpoint ps "\nOkreśl następny punkt: "))
        (if pe
          (progn
            (setq ds (distance ps pe)
                  an (angle ps pe)
            )
            (cd:BLK_SetDynamicProps
              (cd:BLK_InsertBlock ps "GrotA1" (list sc sc sc) an nil)
              "L" ds
            )
            (setq flag nil ps pe pe nil)
          )
          (setq flag T)
        )
      )
    )
    (princ "\nNic nie wskazano. ")
  )
  (princ)
)
; ---------------------------------------------------------------------
(princ)
