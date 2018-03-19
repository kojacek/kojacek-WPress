; =============================================================== ;
; C:DSB Przelacznik widocznosci paskow przewijania okna AutoCAD-a ;
; by kojacek
; --------------------------------------------------------------- ;
(defun C:DSB (/ d l)
  (setq l '(:vlax-false :vlax-true)
        d (vla-get-Display (vla-get-Preferences (vlax-get-acad-object)))
  )
  (vla-put-DisplayScrollBars d
    (nth (abs (1- (vl-position (vla-get-DisplayScrollBars d) l))) l)
  )
  (princ)
)
; --------------------------------------------------------------- ;
(princ)
