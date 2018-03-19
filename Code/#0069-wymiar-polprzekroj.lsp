; -------------------------------------------------------------------- ;
; Polecenie PWYM zamienia wymiar liniowy wymiar srednicy w polwidoku
; by kojacek 2016 
; -------------------------------------------------------------------- ;
(defun C:PWYM (/ e d r)
  (if
    (and
      (setq e (entsel "\nWybierz stronę wymiaru do ukrycia/odkrycia: "))
      (setq d (entget (car e)))
      (= (cdr (assoc 0 d)) "DIMENSION")
    )
    (progn
      (setq r (jk:Dim_HalfDim-p (car e)))
      (cd:SYS_UndoBegin)
      (vla-put-TextPrefix
        (vlax-ename->vla-object (car e))(if (zerop r) "%%c" "")
      )
      (if
        (zerop r)
        (jk:DIM_PutHalfDim (car e)(jk:DIM_GetExtLine e)  T)
        (foreach % '(1 2)(jk:DIM_PutHalfDim (car e) % nil))
      )
      (cd:SYS_UndoEnd)
    )
  )
  (princ)
)
; ------------------------------------------------------------------- ;
; dla danych EntData (zgodnych z entsel) zwraca ktora strona wymiaru
; zostala wskazana 1 / 2
(defun jk:DIM_GetExtLine (EntData / p d)
  (setq d (entget (car EntData))
        p (trans (cadr EntData) 1 0)
  )
  (if
    (<
      (distance p (cdr (assoc 13 d)))
      (distance p (cdr (assoc 14 d)))
    )
    1 2
  )
)
; -------------------------------------------------------------------- ;
; dla wymiaru Ent ukrywa / odkrywa 1 lub 2 linie pomocnicza i wymiarowa
(defun jk:DIM_PutHalfDim (Ent Dir Val / v)
  (setq v (vlax-ename->vla-object Ent))
  (foreach % '("Dim" "Ext")
    (vlax-put v
      (strcat  % "Line" (itoa Dir) "Suppress")
      (if Val -1 0)
    )
  )
)
; -------------------------------------------------------------------- ;
; zwraca 0 dla wymiaru bez ukrytych l. pom. i wym. oraz bez prefixu
(defun jk:Dim_HalfDim-p (Ent / o l i)
  (setq o (vlax-ename->vla-object Ent)
        l '("DimLine1" "ExtLine1" "DimLine2" "ExtLine2")
        i "Suppress"
  )
  (+
    (strlen (vla-get-TextPrefix o))
    (apply '+ (mapcar '(lambda (%)(abs (vlax-get o (strcat % i)))) l))
  )
)
; -------------------------------------------------------------------- ;
(princ)
