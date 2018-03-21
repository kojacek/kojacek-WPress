; ===================================================================== ;
; center - by kojacek 2016/17                                           ;
; --------------------------------------------------------------------- ;

; --------------------------------------------------------------------- ;
; sprawdza czy obiekt En jest znacznikiem srodka lub osia symetrii
; zwraca "CENTERMARK" lub "CENTERLINE" lub nil
(defun jk:CEN_CenterObj (En)
  (car
    (member
      (strcase (getpropertyvalue En "ClassName"))
      (list "CENTERMARK" "CENTERLINE")
    )
  )
)
; --------------------------------------------------------------------- ;
; Zwraca dane dla osi symetrii ("CENTERLINE") i znacznika srodka
; ("CENTERMARK")
(defun jk:CEN_GetData (En / c)
  (if
    (setq c (jk:CEN_CenterObj En))
    (mapcar
      '(lambda (%)
        (cons % (getpropertyvalue En %))
      )
      (cond
        ( (= c "CENTERLINE")
          (list "StartExtension" ; <- Przedłużenie poza punkt początkowy
                "EndExtension"   ; <- Przedłużenie poza punkt końcowy
          )
        )
        ( (= c "CENTERMARK")
          (list "CenterCrossGap"           ; <- Długość przerwy
                "CenterCrossSize"          ; <- Długość kresek znacznika
                "HorizontalStartOvershoot" ; <- Przedłużenie lewej linii
                "HorizontalEndOvershoot"   ; <- Przedłużenie prawej linii
                "VerticalStartOvershoot"   ; <- Przedłużenie dolnej linii
                "VerticalEndOvershoot"     ; <- Przedłużenie górnej linii
                "ExtensionLinesVisible"    ; <- Pokaż linie znacznika
          )
        )
        (T nil)
      )
    )
  )
)
; --------------------------------------------------------------------- ;
; Zmienia dane obiektu typu CENTERLINE / CENTERMARK
(defun jk:CEN_SetData (En LData / c)
  (if
    (setq c (jk:CEN_CenterObj En))
    (foreach % LData
      (if
        (zerop (ispropertyreadonly En (car %)))
        (setpropertyvalue En (car %)(cdr %))
      )
    )
  )
)
; --------------------------------------------------------------------- ;
(princ)
