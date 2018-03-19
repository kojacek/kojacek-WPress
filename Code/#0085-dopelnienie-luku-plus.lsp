; =================================================================== ;
; Polecenie ARCC tworzy dopelnienie luku i luku eliptycznego.         ;
; Wymaga CADPL-Pack-v1.lsp                                            ;
; 2016, 2017 kojacek                                                  ;
; ------------------------------------------------------------------- ;
(defun C:ARCC (/ ss an lo _arcc)
  (defun _arcc (Mode SS / l s e o d r v c a b)
    (setq l (cd:SSX_Convert ss 0))
    (foreach % l
      (setq d (entget %) o (cdr (assoc 0 d))
            c (cdr (assoc 10 d))
            v (list (cons 0 "LINE"))
      )
      (cond
        ( (= "ARC" o)
          (setq s (cdr (assoc 50 d)) e (cdr (assoc 51 d))
                r (cdr (assoc 40 d))
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
            ( (= 3 Mode)
              (setq d
                (cd:DXF_RemoveDXF d (list -1 0 5 40 50 51 100 330))
              )
              (foreach % (list s e)
                (entmakex
                  (append v (list (cons 11 (polar c % r))) d)
                )
              )
            )
            ( (= 4 Mode)
              (setq d
                (cd:DXF_RemoveDXF d (list -1 0 5 10 40 50 51 100 330))
              )
              (entmakex
                (append v
                  (list
                    (cons 10 (polar c e r))
                    (cons 11 (polar c s r))
                  ) d
                )
              )
            )
            (t nil)
          )
        )
        ( (= "ELLIPSE")
          (setq s (cdr (assoc 41 d)) e (cdr (assoc 42 d))
                d (cd:DXF_RemoveDXF d (list 41 42))
                a (getpropertyvalue % "StartPoint")
                b (getpropertyvalue % "EndPoint")
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
            ( (= 3 Mode)
              (setq d
                (cd:DXF_RemoveDXF d
                  (list -1 0 5 11 40 41 42 100 330)
                )
              )
              (foreach % (list a b)
                (entmakex
                  (append v (list (cons 11 %)) d)
                )
              )
            )
            ( (= 4 Mode)
              (setq d
                (cd:DXF_RemoveDXF d
                  (list -1 0 5 10 11 40 41 42 100 330)
                )
              )
              (entmakex
                (append v
                  (list
                    (cons 10 a)
                    (cons 11 b)
                  ) d
                )
              )
            )
            (t nil)
          )
        )
        (t nil)
      )
    )
  )
  (setq lo '("Usuń" "Zintegruj" "zAchowaj" "pRomień" "Cięciwa"))
  (princ "\nDopełnienie łuku i łuku eliptycznego ")
  (if
    (setq ss
      (ssget "_:L"
        (list
          (cons 410 (getvar "CTAB"))
          (cons -4 "<OR")
            (cons 0 "ARC")
            (cons -4 "<AND")
              (cons 0 "ELLIPSE")
              (cons -4 "/=")
              (cons 41 0.0)
            (cons -4 "AND>")
          (cons -4 "OR>")
        )
      )
    )
    (progn
      (if (not *cd-ArcC*)(setq *cd-ArcC* (nth 2 lo)))
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
    (princ "\Nie wybrano łuków. ")
  )
  (princ)
)
(princ)
