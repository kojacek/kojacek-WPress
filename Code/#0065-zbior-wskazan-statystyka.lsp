; ===================================================================== ;
; SSSTAT - by kojacek 2016                                              ;
; --------------------------------------------------------------------- ;
(defun C:SSSTAT (/ ss so ssstat-sn ssstat-cl)
  (defun ssstat-sn ()
    (if
      (not (null (setq ss (ssget))))
      (ssstat-cl ss)
      (princ "\nNic nie wybrano. ")
    )
  )
  (defun ssstat-cl (ss / si sl sn sx)
    (setq si (sslength ss)
          sl (cd:SSX_Convert ss 0)
          sl (mapcar '(lambda (%)(cdr (assoc 0 (entget %)))) sl)
          sn (Acet-List-Remove-Duplicates sl nil)
          sx (mapcar
               '(lambda (%)
                  (strcat " - "
                    (cd:STR_FillChar (strcat % " ") "." 25 t) " "
                       (itoa (length (cd:LST_ItemPosition % sl))))
                ) sn
             )
    )
    (textpage)
    (princ (strcat "\nW zbiorze wskazań znaleziono " (itoa si)
      " obiektów w tym: \n"))
    (mapcar '(lambda (%)(princ (strcat % "\n"))) sx)
    (princ "\n ")
  )
  (if
    (null (setq ss (ssget "_P")))
    (ssstat-sn)
    (if
      (setq so
        (cd:USR_GetKeyWord "\nZbiór wskazań"
          '("Nowy" "Poprzedni" "Wyjdź") "Poprzedni")
      )
      (cond
        ((= so "Nowy")(ssstat-sn))
        ((= so "Poprzedni")(ssstat-cl ss))
        (T (princ "\nAnulowano. "))
      )
      (princ "\nAnulowano. ")
    )
  )
  (princ)
)
; --------------------------------------------------------------------- ;
(princ)
