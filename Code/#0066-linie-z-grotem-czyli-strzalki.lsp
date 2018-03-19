;;; ================================================================== ;
;;; by kojacek 2016
(defun C:L-LINE (/ ps pe st flag)
  (if
    (setq ps (getpoint  "\nPunkt początkowy: "))
    (while
      (not flag)
      (progn
        (setq pe (getpoint ps "\nOkreśl następny punkt: "))
        (if pe
          (progn
            (setq st (getvar "DIMSTYLE"))
            (entmakex
              (list
                (cons 0 "LEADER")
                (cons 100  "AcDbEntity")
                (cons 100  "AcDbLeader")
                (cons 3 st)
                (cons 67 0)
                (cons 71 1)
                (cons 72 0)
                (cons 73 3)
                (cons 74 0)
                (cons 75 0)
                (cons 40 0.0)
                (cons 41 0.0)
                (cons 76 2)
                (cons 10 pe)
                (cons 10 ps)
                (list 211 1.0 0.0 0.0)
                (list 210 0.0 0.0 1.0)
                (list 212 0.0 0.0 0.0)
              )
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
;------------------------------------------------------------
(princ)
