; ====================================================================== ;
; 3DPoy2LwPoly.lsp | kojacek 2016
; last-mod: 10-11-2016 
; ====================================================================== ;
(if (null cd:ACX_Model)(load "CADPL-Pack-v1.lsp" -1))
; ====================================================================== ;

; ====================================================================== ;
(defun C:CONV-3DPL (/ ss ls)
  (if
    (setq ss (ssget ":L" '((0 . "POLYLINE")(-4 . "&=")(70 . 8))))
    (if
      (setq ls (cd:SSX_Convert ss 0))
      (progn
        (cd:SYS_UndoBegin)
        (foreach % ls (jk:ENT_3DPoly->LWPoly %))
        (cd:SYS_UndoEnd)
      )
    )
    (princ "\nNie wybrano obiektów. ")
  )
  (princ)
)
; ====================================================================== ;
; zmiana 3DPOLYLINE z jednakowymi wsp. Z na LWPolyline
; ====================================================================== ;
(defun jk:ENT_3DPoly->LWPoly (Ename / ov lp lz no po)
  (if
    (zerop
      (vla-get-Type
        (setq ov (vlax-ename->vla-object Ename))
      )
    )
    (progn
      (setq lp (jk:LST_ListP->XYZ
                 (vlax-safearray->list
                   (vlax-variant-value
                     (vla-get-Coordinates ov)
                   )
                 )
               )
            lz (vl-sort (mapcar '(lambda (%)(caddr %)) lp) '<)
      )
      (if
        (= (car lz)(last lz))
        (progn
          (setq po
            (cd:ACX_GetProp Ename
              '("Color" "Layer" "LineType" "LinetypeScale" "Lineweight")
            )
          )
          (setq no
            (cd:ACX_AddLWPolyline
              (cd:ACX_ASpace)
              (mapcar '(lambda (%)(list (car %)(cadr %))) lp)
              (vla-get-Closed ov)
            )
          )
          (entdel Ename)
          (vla-put-Elevation no (car lz))
          (cd:ACX_SetProp no po)
        )
      )
    )
  ) no
)
; ====================================================================== ;
; zamienia liste (x1 y1 z1 x2 y2 z2 ...) na liste punktów 3D typu:
; ((x1 y1 z1)(x2 y2 z2)...)
; ====================================================================== ;
(defun jk:LST_ListP->XYZ (in / r)
  (while in
    (setq r
      (append r
        (list
          (list (car in)(cadr in)(caddr in))
        )
      )
     in (cdddr in)
    )
  )
  r
)
; ====================================================================== ;
(princ "\n *** [3DPoy2LwPoly.lsp] Polecenie: CONV-3DPL ")
(princ)
