; ----------------------------------------------------------------- ;
; by kojacek                                                        ;
; ----------------------------------------------------------------- ;
(defun C:VPC ()(setvar "VPCONTROL" (abs (1- (getvar "VPCONTROL")))))
; ----------------------------------------------------------------- ;
(princ)
