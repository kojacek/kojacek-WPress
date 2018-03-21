; =============================================================== ;
; funkcja wyboru obiektow przez LWPolyline                        ;
;  msg  - zgloszenie                                              ;
;  Vlst - lista dla ssget                                         ;
; =============================================================== ;
(defun  jk:SSX_SelbyPoly (Msg VLst / s e d i l x :z)
  (defun :z (e / a b)
    (if e
      (progn
        (vla-GetBoundingBox (vlax-ename->vla-object e) 'a 'b)
        (vla-ZoomWindow (vlax-get-acad-object) a b)
      )
      (vla-ZoomPrevious (vlax-get-acad-object))
    )
  )
  (if
    (and
      (setq s (entsel Msg))
      (= (cdr (assoc 0 (setq d (entget (setq e (car s))))))
         "LWPOLYLINE"
      )
    )
    (progn
      (setq i (jk:ENT_GetLWPolySeg e (cadr s))
            l (cd:DXF_Massoc 10 d)
            l (if (= 1 (logand 1 (cdr (assoc 70 d))))
                (append l (list (car l))) l)
            l (if (< i (/ (cdr (assoc 90 d)) 2)) l (reverse l))
      )
      (:z e)
      (if
        (setq x
          (if VLst
            (ssget "_F" l VLst)
            (ssget "_F" l)
          )
        )
        (progn
          (:z nil)
          (setq x (if (ssmemb e x)(ssdel e x) x))
          (if (zerop (sslength x)) nil x)
        )
        (:z nil)
      )
    )
  )
)
; =============================================================== ;
; zwraca numer segmentu obiektu LWPOLYLINE                        ;
;   en - ename lub vla-object LWPOLYLINE                          ;
;   pt - punkt wskazania                                          ;
; =============================================================== ;
(defun jk:ENT_GetLWPolySeg (en pt)
  (fix
    (vlax-curve-getParamAtPoint
      en
      (vlax-curve-getClosestPointTo en pt)
    )
  )
)
; =============================================================== ;
