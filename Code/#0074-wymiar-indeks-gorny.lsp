; ===================================================================== ;
;; DimUtils.lsp by kojacek
; ===================================================================== ;
; Polecenie DIM5 zmienia tekst wymiaru majacego koncowke .5 na tekst z  ;
; indeksem gornym 5
; --------------------------------------------------------------------- ;
(defun C:DIM5 (/ ss dl)
  (if
    (setq ss (ssget "_:L" '((0 . "DIMENSION"))))
    (progn
      (setq dl (cd:SSX_Convert ss 0))
      (if
        (setq dl
          (vl-remove-if-not
            '(lambda (%)
               (and
                 (jk:DIM_TextTest % 1)
                 (member
                   "AcDbAlignedDimension"
                   (cd:DXF_Massoc 100 (entget %))
                 )
               )
            ) dl
          )
        )
        (progn
          (cd:SYS_UndoBegin)
          (jk:DIM_Index5 dl)
          (cd:SYS_UndoEnd)
        )
        (princ "\nNie wybrano odpowiednich wymiarów. ")
      )
    )
    (princ "\nNic nie wybrano. ")
  )
  (princ)
)
; --------------------------------------------------------------------- ;
; zmienia wymiarom z listy wartosc tekstu na dlugosc + 5 w indeksie
; --------------------------------------------------------------------- ;
(defun jk:DIM_Index5 (ObjList / d)
  (foreach % ObjList
    (setq d (itoa (fix (cdr (assoc 42 (entget %))))))
    (cd:ENT_SetDXF % 1
      (strcat "\\A1;" d "{\\H0.7x;\\S5^")
    )
  )
)
; --------------------------------------------------------------------- ;
; Sprawdza tekst wymiaru czy:
; Code = 0 => wymiar niezmieniony
;      = 1 => ma koncowke ,5
;      = 2 => text zmieniony
; zwraca T po spelnieniu warunku
; --------------------------------------------------------------------- ;
(defun jk:DIM_TextTest (En Code / % %%)
  (setq %% (vla-get-TextOverride (vlax-ename->vla-object En))
         % (cdr
             (assoc 1
               (entget
                 (car
                   (cd:BLK_GetEntity
                     (cdr (assoc 2 (entget En)))
                     "MTEXT"
                   )
                 )
               )
             )
           )
  )
  (cond
    ( (zerop Code)(= "" %%))
    ( (= 1 Code)(or (wcmatch % "*`,5")(wcmatch % "*`.5")))
    ( (= 2 Code)(/= "" %%))
    (t nil)
  )
)
; --------------------------------------------------------------------- ;
(princ)
