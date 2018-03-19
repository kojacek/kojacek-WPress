;;; ================================================================ ;;;
;;; by kojacek 2016
;;; ================================================================ ;;;
(defun jk:TXT_MakeBFStyle (Name Font BFont Width / o b f s)
  (if
    (and
      (not (tblobjname "STYLE" Name))
      (setq f (findfile  Font))
      (setq b (findfile  BFont))
    )
    (if
      (setq s (cd:ENT_MakeTextStyle Name))
      (progn
        (setq o (vlax-ename->vla-object s))
        (vla-put-Fontfile o f)
        (vla-put-BigFontFile o b)
        (vla-put-Width o Width)
      )
    )
  )               
  (or (tblobjname "STYLE" Name))
)
