; =============================================================== ;
; by kojacek
; =============================================================== ;
; Zwraca T jesli pokrywaja sie 1 i ostatni wierzcholek LWPolyline ;
; =============================================================== ;
(defun jk:LWP_EqualStartEnd-p (Ename / p)
   (setq p (cd:DXF_Massoc 10 (entget Ename)))
   (zerop (distance (car p)(last p)))
)
; =============================================================== ;
; Usuwa ostatni wierzcholek LWPoly jesli pokrywa sie z pierwszym ;
; gdy argument Closed funkcja zamyka obiekt (gdy jest otwarty) ;
; Zwraca T / nil ;
; =============================================================== ;
(defun jk:LWP_CorrectStartEndPoint (Ename Closed / d h l)
  (if
    (jk:LWP_EqualStartEnd-p Ename)
    (progn
      (setq d (entget Ename)
            l (length d)
            h (cdr (assoc 210 d))
      )
      (setq d (reverse d))
      (while
        (/= (caar d) 10)
        (setq d (cdr d))
      )
      (setq d (reverse (cdr d)))
      (entmod (append d (list (cons 210 h))))
      (if
        (and
           Closed
           (not (vlax-curve-isClosed Ename))
        )
        (cd:ENT_SetDXF Ename 70 (1+ (cdr (assoc 70 d))))
      )
      (/= (length d) l)
    )
  )
)
; =============================================================== ;
; acet-lwpline-remove-duplicate-pnts (ExpressTools: pljoinsup.lsp)
; Takes an entity list of lwpolylines and modifies the object
; removing neighboring duplicate points. If no duplicated points
; are found then the object will not be passed to (entmod ).
; Returns the new elist when done.
; =============================================================== ;
(defun acet-lwpline-remove-duplicate-pnts (e1 / a n lst e2)
  (setq n 0)
  (repeat (length e1)
    (setq a (nth n e1)) ;setq
    (cond
      ( (not (equal 10 (car a)))(setq e2 (cons a e2))) ;cond #1
      ( (not (equal (car lst) a))
        (setq lst (cons a lst) e2 (cons a e2)) ;setq
      ) ;cond #2
    ) ;cond close
    (setq n (+ n 1)) ;setq
  ) ;repeat
  (setq e2 (reverse e2))
    (if
      (and e2 (not (equal e1 e2)) lst) ;and
      (progn
        (if (equal 1 (length lst))
          (progn
            (entdel (cdr (assoc -1 e1)))
            (setq e2 nil)
          ) ;progn then single vertex polyline so delete it.
          (progn
            (setq e2 (subst (cons 90 (length lst)) (assoc 90 e2) e2)
          ) ;setq
          (entmod e2)
        ) ;progn else
      ) ;if
    ) ;progn then
  ) ;if
  e2
)
; =============================================================== ;
(princ)
