; ----------------------------------------------------------------- ;
; C:CS - krokowo zmienia rozmiar krzyza nitkowego. by kojacek ;
; ----------------------------------------------------------------- ;
(defun C:CS (/ l z _ValStep)
  (defun _ValStep (Val Lst / x)
     (if (setq x (cadr (member Val Lst))) x (car Lst))
   )    
  (setq z "CURSORSIZE" l (list 10 20 30 40 50 60 70 80 90 100))
  (princ (strcat " " z "=" (itoa (setvar z (_ValStep (getvar z) l))) "%"))
  (princ)
  )
; ----------------------------------------------------------------- ;
(princ)
