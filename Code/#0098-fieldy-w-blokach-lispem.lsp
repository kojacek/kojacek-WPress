; =============================================================== ;
; atat.lsp - kojacek 2017
; =============================================================== ;
(defun C:ATAT (/ s a d b l la lb r i u o)
  (defun GetObjectID (obj doc) ;; by Lee Mac
    (if
      (eq "X64" (strcase (getenv "PROCESSOR_ARCHITECTURE")))
      (vlax-invoke-method
        (vla-get-Utility doc) 'GetObjectIdString obj :vlax-false
      )
      (itoa (vla-get-Objectid obj))
    )
  )
  (if
    (not dos_checklist)
    (princ "\nNie załadowano biblioteki DOSLib. ")
    (if
      (setq s (nentselp "\nWybierz atrybut bloku: "))
      (if
        (and 
          (setq d (entget (car s)))
          (= "ATTRIB" (cdr (assoc 0 d)))
        )
        (if
          (zerop (getpropertyvalue (car s) "HasFields"))
          (progn
            (setq b (cdr (assoc 330 d))
                  l (cd:BLK_GetAttEntity b)
            )
            (if
              (= 1 (length l))
              (princ "\nBlok ma tylko jeden atrybut. ")
              (progn
                (setq l (vl-remove (car s) l)
                      la (mapcar
                           '(lambda (% / %1)
                              (setq %1 (entget %))
                              (cons (cdr (assoc 2 %1)) %)
                            ) l
                         )
                      lb (mapcar 'car la)
                      lb (mapcar '(lambda (%)(cons % 0)) lb)
                )
                (if
                  (setq r
                    (dos_checklist
                      (strcat "Skojarz wartość atrybutu "
                        "\"" (cdr (assoc 2 d)) "\"" " jako FILED"
                      )
                      "Wybierz atrybuty:" lb
                    )
                  )
                  (progn
                    (setq i
                      (strcat
                        "%<\\AcObjProp Object(%<\\_ObjId "
                        (GetObjectID
                          (vlax-ename->vla-object (car s))
                          (cd:ACX_ADoc)
                        )
                        ">%).TextString>%"
                      )
                    )
                    (cd:SYS_UndoBegin)
                    (foreach % lb
                      (setq u (car %)
                            o (vlax-ename->vla-object
                                (cdr (assoc u la))
                              )
                      )
                      (if
                        (not (zerop (cdr (assoc u r))))
                        (progn
                          (vla-put-TextString o i)
                          (vla-update o)
                          (vla-regen
                            (cd:ACX_ADoc) acActiveViewport)
                        )
                      )
                    )
                    (cd:SYS_UndoEnd)
                  )
                  (princ "\nNie wybrano skojarzeń atrybutów. ")
                )
              )
            )
          )
          (princ "\nWskazany atrybut jest już field-em. ")
        )
        (princ "\nNie wskazano atrybutu. ")
      )
      (princ "\nNie wskazano obiektu. ")
    )
  )
  (princ)
)
; =============================================================== ;
(princ)
