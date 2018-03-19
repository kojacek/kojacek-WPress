;; -------------------------------------------------------------------- ;
;; Konwersja spline / ellipse na polilinie
;; ---------------------------------------------------------------------;
(defun C:SPLPL (/ Sel Tmp CMD Obj) 
  (if
    (setq Sel (entsel "\nWskaż splajn lub elipsę: "))
    (progn 
      (if 
        (member 
          (cdr (assoc 0 (entget (setq Obj (car Sel))))) 
          '("SPLINE" "ELLIPSE") 
        ) 
        (if
          (vlax-write-enabled-p (vlax-ename->vla-object Obj))
          (progn 
            (setq Tmp (strcat (getenv "TEMP") "\\$.dxf") 
                  CMD (getvar "CMDECHO") 
            ) 
            (setvar "CMDECHO" 0) 
            (if (findfile Tmp)(vl-file-delete Tmp))
            (command "_.undo" "_m")
            (command "_.dxfout" Tmp "_V" "R12" "_O" Obj "" "") 
            (command "_-insert" (strcat "*" Tmp)(getvar "INSBASE")"" "")
            (command "_.undo" "_e")
            (vl-file-delete Tmp) 
            (entdel Obj) 
            (setvar "CMDECHO" CMD) 
          )
          (princ "\nNie można modyfikować obiektu. ")
        ) 
        (princ "\nNależy wybrać splajn lub elipsę. ") 
      ) 
    )
  )
  (princ) 
)
(princ)
