; ----------------------------------------------------------------- ;
; by kojacek (2002)                                                 ;
; ----------------------------------------------------------------- ;
(vl-load-com)
; ----------------------------------------------------------------- ;
(defun C:BKG (/ disp data)
  (setq Disp
    (vla-get-display
      (vla-get-preferences
        (vlax-get-acad-object)
      )
    )
  )
  (setq Data
    (list
      (vla-get-ModelCrossHairColor Disp)
      (vla-get-GraphicsWinModelBackgrndcolor Disp)
    )
  )
  (vla-put-ModelCrossHairColor Disp (cadr Data))
  (vla-put-graphicswinmodelbackgrndcolor Disp (car Data))
  (princ)
)
; ----------------------------------------------------------------- ;
