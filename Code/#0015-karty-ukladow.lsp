; ----------------------------------------------------------------- ;
; by kojacek                                                        ;
; ----------------------------------------------------------------- ;
(defun C:LTAB ()(setvar "LAYOUTTAB" (abs (1- (getvar "LAYOUTTAB")))))
; ----------------------------------------------------------------- ;
(defun C:STAB ()
  (setenv "ShowTabs" (itoa (abs  (1- (atoi (getenv "ShowTabs"))))))
)
; ----------------------------------------------------------------- ;