; ----------------------------------------------------------------- ;
; by kojacek                                                        ;
; ----------------------------------------------------------------- ;
(defun C:TT ()(setvar "TOOLTIPS" (abs (1- (getvar "TOOLTIPS")))))
; ----------------------------------------------------------------- ;
(princ)