; ===================================================================== ;
; QF (QuickFilter) - by kojacek 2016                                    ;
; --------------------------------------------------------------------- ;
(defun C:QF (/ f d s l p res r -dlg)
  (defun -dlg (Data Pos / fd tmp dc res)
    (if (not *cd-TempDlgPosition*)
      (setq *cd-TempDlgPosition* (list -1 -1))
    )
    (cond
      ( (not
          (and
            (setq fd
              (open
                (setq tmp (vl-FileName-MkTemp nil nil ".dcl")) "w"
              )
            )
            (foreach % 
              (list
                "qf: dialog {label=\"Nazwane filtry\";"
                ":row{"
                ":list_box {key=\"list\";label=\"Wybierz:\";"
                "fixed_width = true;fixed_height = true;"
                "width = 30;height= 8;}"
                ":column{alignment=centered;fixed_width=true;"
                "spacer_1;" "spacer_1;"
                ":button{key=\"filter\";label=\"&FILTR\";}" 
                ":button{key=\"cancel\";label=\"&Anuluj\""
                ";is_cancel = true;}"
                ":button{key=\"accept\";label=\"&OK\";"
                "is_default = true;}"
                "}}}"
              )
              (write-line % fd)
            )
            (not (close fd))
            (< 0 (setq dc (load_dialog tmp)))
            (new_dialog "qf" dc ""
              (cond
                (*cd-TempDlgPosition*)
                ( (quote (-1 -1)))
              )
            )
          )
        )
      )
      ( T (start_list "list")
        (mapcar (quote add_list) Data)
        (end_list)
        (if
          (or
            (not Pos)
            (not (< -1 Pos (length Data)))
          )
          (setq Pos 0)
        )
        (setq res (set_tile "list" (itoa Pos)))
        (action_tile "list"
          (vl-prin1-to-string
            (quote
              (progn
                (setq res $value)
                (if (= $reason 4)
                  (setq *cd-TempDlgPosition* (done_dialog 1))
                )
              )
            )
          )
        )
        (action_tile "accept"
          "(setq *cd-TempDlgPosition* (done_dialog 1))"
        )
        (action_tile "filter"
          "(setq res (itoa -1) *cd-TempDlgPosition* (done_dialog 2))"
        )
        (action_tile "cancel" "(setq res nil) (done_dialog 0)")
        (start_dialog)
      )
    )
    (if (< 0 dc) (unload_dialog dc))
    (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
    (if res (read res))
  )
  (if
    (setq f (findfile "filter.nfl"))
    (progn
      (setq d (cd:SYS_ReadFile nil f)
            d (vl-remove-if
                '(lambda (%)
                   (and
                     (not (wcmatch % ":ai_lisp*"))
                     (not (wcmatch % "(*")))
                 ) d
              )
            s (vl-string-subst "((\"" ":ai_lisp|" (car d))
            d (mapcar
                '(lambda (%)
                   (vl-string-subst ")(\"" ":ai_lisp|" %)
                )
                (cdr d)
              )
            d (mapcar
                '(lambda (%)
                   (if (not (wcmatch % "(*"))(strcat % "\"") %)
                 ) d
              )
            d (read (strcat  s "\"" (apply 'strcat d) "))"))
            l (acad_strlsort (mapcar 'car d))
            p 0
      )
      (if
        (setq res (-dlg l p))
        (if
          (minusp res)
          (command "_.FILTER")
          (setq r (nth res l))
        )
        (princ "\nNie wybrano filtra zbioru wskazań. ")
      )
    )
    (princ "\nNazwane filtry nie zostały zdefiniowane. ")
  )
  (if r
    (progn
      (princ (strcat "\nZastosowano filtr o nazwie <" r ">... "))
      (sssetfirst nil (ssget "_:L" (cdr (assoc r d))))
    )
  )
  (princ)
)
(princ)
