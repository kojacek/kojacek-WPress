; =============================================================== ;
; secpoly.lsp - kojacek - 2017 -                                  ;
; =============================================================== ;
; Polecenie SECPOLY dzieli zamknieta polilinie na dwie odrebne    ;
; zamkniete polilinie, wzdluz linii wyznaczonej przez 2 wskazane  ;
; punkty. Linia wyznaczajaca ciecie musi przebiegac tylko przez   ;
; dwa segmenty polilinii.                                         ;
; --------------------------------------------------------------- ;
(defun C:SECPOLY
  (/ *error* :z :i s d e o p1 p2 l p q a n1 n2 u x s1 s2 v)
  (defun *error* (msg) 
    (or
      (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
      (progn
        (cd:SYS_UndoEnd)
        (if l (vla-delete l))
        (foreach % (list s1 s2)(if % (entdel %)))
        (princ (strcat "\n*** Błąd: " msg " ***"))
      )
    )
    (princ)
  )
  (defun :z (e / a b)
    (if e
      (progn
        (vla-GetBoundingBox (vlax-ename->vla-object e) 'a 'b)
        (vla-ZoomWindow (vlax-get-acad-object) a b)
      )
      (vla-ZoomPrevious (vlax-get-acad-object))
    )
  )
  (defun :i (v1 v2 Tp / x r %)
    (if
      (vl-catch-all-error-p
        (setq x
          (vl-catch-all-apply
            'vlax-safearray->list
            (list
              (vl-catch-all-apply
                'vlax-variant-value
                (list (vla-intersectwith v1 v2 Tp))
              )
            )
          )
        )
      )
      (setq r nil)
      (repeat
        (/ (length x) 3)
        (setq % (list (car x)(cadr x)(caddr x)))
        (setq r (cons % r))
        (setq x (cdddr x))
      )
    ) r
  )
  (if
    (setq s (entsel "\nWybierz polilinię do podziału: "))
    (if
      (and
        (= (cdr (assoc 0 (setq d (entget (setq e (car s))))))
           "LWPOLYLINE"
        )
        (not (zerop (getpropertyvalue e "Area")))
        (= 1 (logand 1 (cdr (assoc 70 d))))
      )
      (if
        (and
          (setq p1 (getpoint "\nWskaż pierwszy punkt cięcia: "))
          (setq p2 (getpoint p1 "\nWskaż drugi punkt cięcia: "))
        )
        (progn
          (cd:SYS_UndoBegin)
          (setq l (cd:ACX_AddLine (cd:ACX_ASpace) p1 p2 T)
                o (vlax-ename->vla-object e)
                v (cd:ACX_GetProp o
                    '("Color" "Layer" "LineType" "LineTypeScale")
                  )
          )
          (if
            (and
              (setq p (:i o l AcExtendNone))
              (setq q (:i o l acExtendOtherEntity))
              (= (length p)(length q) 2)
            )
            (progn
              (setq n1 (car p)
                    n2 (cadr p)
                    i (distance n1 n2)
                    a (angle n1 n2)
                    x (polar n1 a (* 0.5 i))
                    u (* i 0.01)
              )
              (:z e)
              (bpoly (polar x (+ a (* 0.5 pi)) u))
              (setq s1 (entlast))
              (bpoly (polar x (+ a (* 1.5 pi)) u))
              (setq s2 (entlast))
              (:z nil)
              (if
                (equal
                  (getpropertyvalue e "Area")
                  (+
                    (getpropertyvalue s1 "Area")
                    (getpropertyvalue s2 "Area")
                  )
                  0.001
                )
                (progn
                  (cd:ACX_SetProp s1 v)
                  (cd:ACX_SetProp s2 v)
                  (vla-delete l)(entdel e)
                )
                (progn
                  (foreach % (list s1 s2)
                    (if % (entdel %))
                  )
                  (if l (vla-delete l))
                  (princ "\nNie można utworzyć podziału polilinii. ")
                )
              )
            )
            (progn
              (vla-delete l)
              (princ "\nNie można utworzyć podziału polilinii. ")
            )
          )
          (cd:SYS_UndoEnd)
        )
        (princ "\nNie wskazano punktu. ")
      )
      (princ "\nNiepoprawny wybór. ")
    )
    (princ "\nNic nie wybrano. ")
  )
  (princ)
)
; =============================================================== ;
(princ)
