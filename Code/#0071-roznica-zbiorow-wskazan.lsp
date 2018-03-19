;; ! *********************************************************************
;; ! SS_SSsub
;; ! *********************************************************************
;; ! Function : Subtracts one selection set from another and returns their
;; !            difference
;; ! Arguments:
;; !            'ss1'    - First Selection set (to subtract from)
;; !            'ss2'    - Second Seclection set (to be subtracted)
;; ! Return   : The difference selection set
;; ! Updated  : April 24, 1998
;; ! Copyright: (C) 2000, Four Dimension Technologies, Singapore
;; ! Contact  : rakesh.rao@4d-technologies.com for help/support/info

(defun SS_SSsub (ss1 ss2 / ss)
  (cond
    ( (and ss1 ss2)
      (command "._Select" ss1 "_Remove" ss2 "")
      (setq ss (ssget "_P"))
    )
    ( (and ss1 (not ss2))
      (setq ss ss1)
    )
    (T
      (setq ss nil)
    )
  )
  ss
)

;*************************************************************************
; difference selection set
;*************************************************************************
(defun SS-Different (ss1 ss2)
  (cond
    ( (eq ss2 ss1)(ssadd))
    ( (null ss1)(ssadd))
    ( (null ss2) ss1)
    ( (null (ssname ss2 0)) ss1)
    ( (ssmemb (ssname ss2 0) ss1)
      (SS-Different
	(ssdel (ssname ss2 0) ss1)
        (ssdel (ssname ss2 0) ss2)
      )
    )
    (T
      (SS-Different ss1 (ssdel (ssname ss2 0) ss2))
    )
  )
)
; ------ ;
(princ)
