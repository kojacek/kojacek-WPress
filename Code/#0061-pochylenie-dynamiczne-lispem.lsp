; ----------------------------------------------------------------- ;
; Polecenie NACHYL tworzy opis pochylenia wskazanej linii           ;
; Wymaga CADPL-Pack-v1.lsp                                          ;
; 2016 kojacek                                                      ;
; ----------------------------------------------------------------- ;

(defun C:NACHYL (/ o l p f v i x GetObjectID)
  (defun GetObjectID (obj doc) ;; Lee Mac
    (if (eq "64" (strcase (getenv "PROCESSOR_ARCHITECTURE")))
      (vlax-invoke-method (vla-get-Utility doc)
        'GetObjectIdString obj :vlax-false)
      (itoa (vla-get-Objectid obj))
    )
  )
  (if
    (setq o
      (cd:USR_GetKeyWord "\nOpis nachylenia linii"
        '("Procent" "pRomil" "Kąt") "Procent")
    )
    (if
      (setq l
        (cd:USR_EntSelObj
          (list
            "\nWybierz linię nachylenia: " "Należy wskazać linię. "
            "Nic nie wybrano. " "To nie jest linia. "
          )
          (list "LINE") nil nil t
        )
      )
      (if
        (setq p (getpoint "\nPunkt wstawienia tekstu: "))
        (progn
          (setq v (GetObjectID (vlax-ename->vla-object (car l))
                    (cd:ACX_ADoc))
                i (if
                    (>= (atof (getvar "ACADVER")) 17.1)
                    "%<\\AcObjProp.16.2 Object(%<\\_ObjId "
                    "%<\\AcObjProp Object(%<\\_ObjId "
                  )
                j ">%).Angle \\f \"%au0%zs8\">%"
                x "%<\\AcExpr (round(abs(tang("
                z (if
                    (= o "Procent")
                    "))*100))>%"
                    "))*1000))>%"
                  )
          )
          (setq f
            (if
              (= o "Kąt")
              (strcat i v j "%%d")
              (strcat
                (strcat x i v j z)
                (if (= o "Procent") "%" "\\U+2030")
              )
            )
          )
          (cd:SYS_UndoBegin)
          (cd:ACX_AddText (cd:ACX_ASpace) f p
            (getvar "TEXTSIZE") 0.0)
          (cd:SYS_UndoEnd)
        )
        (princ "\nAnulowano. ")
      )
      (princ "\nAnulowano. ")
    )
  )
  (princ)
)
;---------------------------------------------------------
(princ)
