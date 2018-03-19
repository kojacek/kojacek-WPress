; ----------------------------------------------------------------- ;
; C:USZ - krokowo zmienia rozmiar ikony UCS. by kojacek ;
; ----------------------------------------------------------------- ;
(defun C:USZ (/ l z _ValStep)
  (defun _ValStep (Val Lst / x)
     (if (setq x (cadr (member Val Lst))) x (car Lst))
   )    
   (setq z "UcsIconSize" l 
   (mapcar 'itoa (list 10 20 30 40 50 60 70 80 90 100)) 
 )
 (princ (strcat " " z "=" (setenv z (_ValStep (getenv z) l)) "%"))
 (princ) ) 
  ; ----------------------------------------------------------------- ;
  (princ)
