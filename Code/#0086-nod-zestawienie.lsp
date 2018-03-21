; ===================================================================== ;
;; DictList.lsp by kojacek 2017                                         ;
; ===================================================================== ;
; Polecenie DICTLIST tworzy i uzupelnia w pliku tekstowym DictList.txt  ;
; liste unikalnych nazw obiektow w Named Object Dictionary.             ;
; Wymaga: CADPL-Pack-v1.lsp                                             ;
; --------------------------------------------------------------------- ;

(defun C:DICTLIST (/ p n f d :dialog :deldup)
  (defun :deldup (Lst)
    (foreach % Lst (setq Lst (cons % (vl-remove % Lst))))
  )
  (defun :dialog (File / d i)
    (setq d (cd:SYS_ReadFile nil File)
          i (itoa (length d))
    )
    (cd:DCL_StdListDialog d 0
      (strcat "DictList (" i " obiektów)")
      "Szczegóły: " 55 25 0 13 (list "&OK" "&Zamknij")
      nil T T nil
    )
  )
  (setq p (vl-filename-directory (findfile "DictList.lsp"))
        f (findfile (setq n (strcat p "\\" "DictList.txt")))
  )
  (if
    (not f)
    (progn
      (setq d
        (acad_strlsort (cd:DCT_GetDictList (namedobjdict) nil))
      )
      (cd:SYS_WriteFile n d nil)
      (:dialog n)
    )
    (progn
      (setq d
        (acad_strlsort
          (:deldup
            (append
              (cd:DCT_GetDictList (namedobjdict) nil)
              (cd:SYS_ReadFile nil n)
            )
          )
        )
      )
      (cd:SYS_WriteFile n d nil)
      (:dialog n)
    )
  )
  (princ)
)
; --------------------------------------------------------------------- ;
(princ)
