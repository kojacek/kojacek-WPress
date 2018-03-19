; ==================================================================== ;
; by kojacek 2016
(defun daprop (Ename / d f r s a i)
  (if
    (and Ename (setq d (entget Ename)))
    (if
      (= (getvar "LOGFILEMODE") 1)
      (progn
        (setvar "LOGFILEMODE" 0)
        (setq f (getvar "LOGFILENAME"))
        (cd:SYS_WriteFile f (list "=====") nil)
        (setvar "LOGFILEMODE" 1)
        (dumpallproperties Ename)
        (setvar "LOGFILEMODE" 0)
        (setq r (cd:SYS_ReadFile nil f))
        (if
          (wcmatch (car r) "=====*")
          (setq r (cddr r))
        )
        (setq s (car (vl-sort (mapcar 'strlen r) '>))
              i (itoa (- (length r) 2))
        )
        (if (> s 180)(setq s (- s 30)))
        (cd:DCL_StdListDialog r 0
          (strcat "Dumpallproperties ("
                  i " linii danych dla "
                  (cdr (assoc 0 d)) ")"
          )
          "Szczegóły: " s 25 0 13 (list "&OK" "&Zamknij")
          nil T T '(setq a (nth (atoi res) r))
        )
        (setvar "LOGFILEMODE" 1)
      )
    )
  ) a
)
