;;; ==============================================================
;;; TextIO.lsp 2016 kojacek
;;; Export + import wartosci obiektow TEXT do/z pliku TXT
;;; ==============================================================
(setq *jk-TextIO-Sep* "\t")         ; separator
(setq *jk-TextIO-SelectField* 0)    ; 0 = bez FILED-ow
;;; ==============================================================
(defun C:TEXTOUT (/ ss l f)
  (if
    (setq ss
      (ssget "_:L"
        (if
          (zerop *jk-TextIO-SelectField*)
          '((0 . "TEXT")(-4 . "<NOT")(1 . "*<\\Ac*")(-4 . "NOT>"))
          '((0 . "TEXT"))
        )
      )
    )
    (progn
      (setq l (cd:SSX_Convert ss 0)
            n (vl-string-subst ".txt" ".dwg" (getvar "DWGNAME"))
            l (mapcar
                '(lambda (% / %1)
                   (setq %1 (entget %))
                   (strcat "'" (cdr (assoc 5 %1))
                           *jk-TextIO-Sep* (cdr (assoc 1 %1)))
                ) l)
      )
      (if
        (setq f (getfiled "Zapisz plik TXT" n "txt" 1))
        (cd:SYS_WriteFile f
          (append (list
            (strcat "HANDLE" *jk-TextIO-Sep* "TEXT")) l) nil)
        (princ "\nNie wskazano pliku. ")
      )
    )
    (princ "\nNie wybrano tekstów. ")
  )
  (princ)
)
;;; ==============================================================
(defun C:TEXTIN (/ f n l h v e i d)
  (if
    (setq f (getfiled "Otwórz plik TXT" "" "txt" 8))
    (if
      (and
        (setq n (cd:SYS_ReadFile 0 f))
        (eq n (strcat "HANDLE" *jk-TextIO-Sep* "TEXT"))
      )
      (if
        (setq l (cd:SYS_ReadFile nil f))
        (progn
          (setq i 0
                l (cdr l)
                l (mapcar
                    '(lambda (%)
                       (cd:STR_Parse % *jk-TextIO-Sep* nil)
                    ) l
                  )
          )
          (cd:SYS_UndoBegin)
          (foreach % l
            (setq h (vl-string-left-trim "'" (car %))
                  v (cadr %)
            )
            (if
              (and
                (setq e (handent h))
                (= "TEXT" (cdr (assoc 0 (setq d (entget e)))))
              )
              (if
                (/= v (cdr (assoc 1 d)))
                (progn
                  (setq i (1+ i))
                  (cd:ENT_SetDXF e 1 v)
                )
              )
            )
          )
          (if
            (not (zerop i))
            (princ (strcat "\nZmieniono " (itoa i) " obiektów."))
          )
          (cd:SYS_UndoEnd)
        )
        (princ "\nBłędne dane w pliku tekstowym.")
      )
      (princ "\nBłędny plik tekstowy.")
    )
    (princ "\nNie wskazano pliku. ")
  )
  (princ)
)
;;; ==============================================================
(princ "\n [TextIO.lsp]: (TEXTOUT TEXTIN) ")
(princ)
