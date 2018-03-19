;; ------------------------------------------------------------------- ;
;; l-izo.lsp - rysuje linie ocieplenia  
;; kojacek  - last-mod: 15-11-2016  
;; --------------------------------------------------------------------;

(defun C:L-IZO (/ l d -%g -%l OldErr)
  (defun *Error-IZO* (msg)
    (if (= 8 (logand 8 (getvar "UNDOCTL")))(cd:SYS_UndoEnd))
    (if
      (or (= msg "Function cancelled")(= msg "quit / exit abort"))
      (princ (strcat "\nBłąd: " msg))
      (princ "\nAnulowano. ")
    )
    (redraw)
    (if cls (setvar "CELTSCALE" cls))
    (if clt (setvar "CELTYPE" clt))
    (if OldErr (setq *error* OldErr))
    (princ)
  )
  (defun -%g (/ r)
    (if (not *jk-IZO*)(setq *jk-IZO* 8.0))
    (initget (+ 2 4))
    (if
      (setq r
        (getdist
          (strcat
            "Podaj szerokość izolacji w cm <"
            (cd:CON_Real2Str *jk-IZO* 2 2)
            ">: "
          )
        )
      )
      r *jk-IZO*
    )
  )
  (defun -%l (/ l f)
    (if
      (not (tblobjname "LTYPE" "Std-IZO"))
      (progn
        (setq l
          (list
            "*Std-IZO,Izolacja SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
            (strcat
              "A,.000125,-.125,[BAT,ltypeshp.shx,x=-.125,s=.125],"
              "-.25,[BAT,ltypeshp.shx,r=180,x=.125,s=.125],-.125"
            )
          )
              f (vl-filename-mktemp nil nil ".lin")
        )
        (cd:SYS_WriteFile f l nil)
        (vla-load (cd:ACX_LineTypes) "Std-IZO" f)
        (vl-file-delete f)
      )
    )
    (or (tblobjname "LTYPE" "Std-IZO"))
  )
  (setq OldErr *error* *error* *Error-IZO*)
  (setq l (-%l))
  (if
    (and l (setq *jk-IZO* (-%g)))
    (progn
      (cd:SYS_UndoBegin)
      (setq cls (getvar "CELTSCALE")
            clt (getvar "CELTYPE")
      )
      (setvar "CELTSCALE" *jk-IZO*)
      (setvar "CELTYPE" "Std-IZO")
      (command "_.line")
      (while
        (= 1 (logand (getvar "CMDACTIVE") 1))
        (command "\\")
      )
      (setvar "CELTSCALE" cls)
      (setvar "CELTYPE" clt)
      (cd:SYS_UndoEnd)
      (if OldErr (setq *error* OldErr))
    )
  )
  (princ)
)
;; ------------------------------------------------------------------- ;
(princ)
