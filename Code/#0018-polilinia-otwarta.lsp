;; 4 sposoby sprawdzenia czy poly jest otwarta
; 1
(vla-get-Closed VLA-OBJECT)
; 2
(vlax-curve-isClosed ENAME / VLA-OBJECT)
; 3
(= 1 (logand 1 (cdr (assoc 70 DXF-LIST ))))
; 4
(getpropertypalue ENAME "Closed" )
