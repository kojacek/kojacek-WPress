; =============================================================== ;
; hiddenlay.lsp - kojacek - 2017 -                                ;
; =============================================================== ;
(defun C:HL (/ e d l f)
  (if
    (and
      (setq e (car (entsel "\nWybierz obiekt: ")))
      (not
        (member
          (setq l
          (cdr (assoc 8 (setq d (entget e)))))
         '("0" "DEFPOINTS")
        )
      )
    )
    (if
      (/= (getvar "CLAYER") l)
      (progn
        (setq f (if (= (substr l 1 1) "*") 0 1))
        (setpropertyvalue (tblobjname "LAYER" l) "IsHidden" f)
        (princ
          (strcat
            "\nWarstwa "
            (if (zerop f)(substr l 2 (strlen l)) l)
            " jest " (nth f '("od" "u")) "kryta. "
          )
        )
      )
      (princ "\nObiekt na warstwie aktualnej. ")
    )
  )
  (princ)
)
; =============================================================== ;
(princ)
