; =============================================================== ;
; C:RETA - Tworzy wypełniony prostokat (TRACE / SOLD) metodami    ;
;          ActiveX - kojacek - 2017 -                             ;
; =============================================================== ;
(defun C:RETA (/ p c r o e)
  (if (not *jk-ReTrace*)(setq *jk-ReTrace* "Trasa"))
  (if
    (setq r
      (cd:USR_GetKeyWord
        "\nRysuj wypełniony prostokąt"
        '("Obszar" "Trasa") *jk-ReTrace*
      )
    )
    (if
      (setq p (getpoint "\nOkreśl pierwszy narożnik: "))
      (if
        (setq c
          (cd:USR_GetCorner p "\nOkreśl drugi narożnik: " T)
        )
        (progn
          (setq e (getvar "ELEVATION")
                c (list (car c)(cadddr c)(cadr c)(caddr c))
                c (mapcar '(lambda (%)(append % (list e))) c)
                c
                   (if
                    (= r "Trasa")
                    (apply 'append c)
                    (mapcar 'vlax-3d-point c)
                  )
                *jk-ReTrace* r
          )
          (cd:SYS_UndoBegin)
          (if
            (= *jk-ReTrace* "Trasa")
            (vla-AddTrace (cd:ACX_ASpace)
              (vlax-make-variant
                (vlax-safearray-fill
                  (vlax-make-safearray vlax-vbdouble
                    (cons 0 (1- (length c)))
                  )
                  c
                )
              )
            )
            (vla-AddSolid (cd:ACX_ASpace)
              (car c)(cadr c)(caddr c)(cadddr c)
            )
          )
          (cd:SYS_UndoEnd)
        )
        (princ "\nBłąd. Nie wskazano prawidłowego punktu. ")
      )
      (princ "\nBłąd. Nie wskazano prawidłowego punktu. ")
    )
    (princ "\nBłąd. Nie wybrano opcji. ")
  )
  (princ)
)
; =============================================================== ;
; C:RETE - Tworzy wypełniony prostokat (TRACE / SOLD) funkcja     ;
;          entmakex - kojacek - 2017 -                            ;
; =============================================================== ;
(defun C:RETE (/ p c r o e)
  (if (not *jk-ReTrace*)(setq *jk-ReTrace* "Trasa"))
  (if
    (setq r
      (cd:USR_GetKeyWord
        "\nRysuj wypełniony prostokąt"
        '("Obszar" "Trasa") *jk-ReTrace*
      )
    )
    (if
      (setq p (getpoint "\nOkreśl pierwszy narożnik: "))
      (if
        (setq c
          (cd:USR_GetCorner p "\nOkreśl drugi narożnik: " T)
        )
        (progn
          (setq e (getvar "ELEVATION")
                c (list (car c)(cadddr c)(cadr c)(caddr c))
                c (mapcar '(lambda (%)(append % (list e))) c)
                c (list
                    (cons 10 (car c))
                    (cons 11 (cadr c))
                    (cons 12 (caddr c))
                    (cons 13 (cadddr c))
                  )
                *jk-ReTrace* r
          )
          (cd:SYS_UndoBegin)
          (entmakex
            (append
              (list
                (cons 0
                  (if (= *jk-ReTrace* "Trasa") "TRACE" "SOLID")
                )
                (cons 100 "AcDbTrace")
              ) c
            )
          )
          (cd:SYS_UndoEnd)
        )
        (princ "\nBłąd. Nie wskazano prawidłowego punktu. ")
      )
      (princ "\nBłąd. Nie wskazano prawidłowego punktu. ")
    )
    (princ "\nBłąd. Nie wybrano opcji. ")
  )
  (princ)
)
; ----------------------------- 
(princ)
