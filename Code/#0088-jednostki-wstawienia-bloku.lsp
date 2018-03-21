; =============================================================== ;
; C:BUN by kojacek 2017
; Dla wszystkich blokow ustawia jednoski wstawienia jako Unitless
; (bez jednostek). Wymaga CADPL-Pack-v1.lsp
; =============================================================== ;
(defun C:BUN (/ l i -GetBlockInsUnits)
  (defun -GetBlockInsUnits ()
    (mapcar
      '(lambda (%)
         (cons (vla-get-Units (vla-item (cd:ACX_Blocks) %)) %)
      )
      (cd:SYS_CollList "BLOCK" (+ 1 2 4))
    )
  )
  (if
    (setq l (-GetBlockInsUnits))
    (if
      (setq l (vl-remove-if '(lambda (%)(zerop (car %))) l))
      (progn
        (setq i (length l))
        (cd:SYS_UndoBegin)
        (foreach % (setq l (mapcar 'cdr l))
          (vla-put-Units (vla-item (cd:ACX_Blocks) %) 0)
        )
        (cd:SYS_UndoEnd)
        (princ
          (strcat "\nDla " (itoa i)
            " bloków usunięto jednostki wstawienia. "
          )
        )
      )
      (princ "\nNie ma bloków z ustaloną jednostką wstawienia. ")
    )
    (princ "\nW rysunku nie ma bloków. ")
  )
  (princ)
)
; =============================================================== ;
(princ)
