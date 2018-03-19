; ----------------------------------------------------------------- ;
; Polecenie ARCC tworzy dopelnienie luku i luku eliptycznego.       ;
; Wymaga CADPL-Pack-v1.lsp                                          ;
; 2016 kojacek                                                      ;
; ----------------------------------------------------------------- ;
(defun C:ARCC (/ ss an lo _arcc)
  (defun _arcc (Mode SS / l s e o d)
    (setq l (cd:SSX_Convert ss 0))
      (foreach % l
        (setq d (entget %) o (cdr (assoc 0 d)))
        (cond
          ( (= "ARC" o)
             (setq s (cdr (assoc 50 d)) e (cdr (assoc 51 d))
                   d (cd:DXF_RemoveDXF d (list 50 51))
                   d (append d (list (cons 50 e)(cons 51 s)))
              )
             (cond
               ( (zerop Mode)(entmod d))
               ( (= 1 Mode)
                 (setq d (cd:DXF_RemoveDXF d (list -1 0 5 50 51 100))
                           d (append (list (cons 0 "CIRCLE")) d)
                 )
                 (entmakex d)(entdel %)
             )
            ( (= 2 Mode)(entmakex d))
           (t nil)
         )
       )
       ( (= "ELLIPSE")
         (setq s (cdr (assoc 41 d)) e (cdr (assoc 42 d))
                   d (cd:DXF_RemoveDXF d (list 41 42))
                   d (if
                        (= 1 Mode)
                        (append d (list (cons 41 0.0)(cons 42 (* 2 pi))))
                        (append d (list (cons 41 e)(cons 42 s)))
                     )
          )
          (cond
            ( (zerop Mode)(entmod d))
            ( (= 1 Mode)(entmakex d)(entdel %))
            ( (= 2 Mode)(entmakex d))
            (t nil)
          )
        )
        (t nil)
      )
    )
  )
  (setq lo '("Usuń" "Zintegruj" "zAchowaj"))
  (princ "\nDopełnienie łuku i łuku eliptycznego ")
  (if
    (setq ss
      (ssget "_:L"
        (list
          (cons 410 (getvar "CTAB"))
          (cons -4 "<OR")
            (cons 0 "ARC")
            (cons -4 "")
          (cons -4 "OR>")
        )
      )
    )
    (progn
      (if (not *cd-ArcC*)(setq *cd-ArcC* (last lo)))
      (setq an
        (cd:USR_GetKeyWord "\nDopełnienie łuku" lo *cd-ArcC*)
      )
      (if
        (member an lo)
        (progn
          (cd:SYS_UndoBegin)
          (_arcc (vl-position an lo) ss)
          (setq *cd-ArcC* an)
          (cd:SYS_UndoEnd)
        )
        (princ "\nPrzerwano polecenie.")
      )
    )
    (princ "\nNie wybrano łuków. ")
  )
  (princ)
)
;---------------------------------------------------------------------
(princ)
