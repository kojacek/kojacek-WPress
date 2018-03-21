; ===================================================================== ;
; DimHatch - kojacek (2002 / 2017)
; Polecenie DH sekwencyjnie wlacza i wylacza reaktor polecenien AutoCAD-a
; polegajacy na ukrywaniu obiektow typu HATCH po uruchomieniu i w trakcie
; trwania dowolnego polecenia wymiarowania
; ===================================================================== ;

; --------------------------------------------------------------------- ;
; przelacznik wlaczenia reaktora
(defun C:DH (/ m)
  (setq m "\nUkrywanie kreskowania podczas wymiarowania ")
  (if *jk-DH-Status*
    (progn
      (jk:DHR_InitReactor nil)(princ (strcat m "wyłączone. "))
    )
    (progn
      (jk:DHR_InitReactor T)(princ (strcat m "włączone. "))
    )
  )
  (princ)
)
; --------------------------------------------------------------------- ;
; inicjalizacja reaktorow
(defun jk:DHR_InitReactor (Mode)
  (if Mode
    (progn
      (if
        (not *jk-DH-CommReactor*)
        (setq *jk-DH-CommReactor*
          (vlr-Command-Reactor nil
            '( (:vlr-commandWillStart . jk:DHR_CommWillStart)
               (:vlr-commandEnded . jk:DHR_CommEnded)
               (:vlr-commandCancelled . jk:DHR_CommEnded)
               (:vlr-commandFailed . jk:DHR_CommEnded)
             )
          )
              *jk-DH-Status* T
        )
      )
      (if
        (not *jk-DH-DrawReactor*)
        (setq *jk-DH-DrawReactor*
          (vlr-dwg-Reactor nil
           '( (:vlr-beginClose . jk:DHR_CleanReact))
          )
        )
      )
    )
    (setq *jk-DH-CommReactor* nil
          *jk-DH-DrawReactor* nil
          *jk-DH-HatchList* nil
          *jk-DH-Status* nil
    )
  )
)
; --------------------------------------------------------------------- ;
; Reaktor polecenia - start
(defun jk:DHR_CommWillStart (r c / cmd)
  (setq cmd 
    (cond
      ( (car c))
      ( (getvar "CMDNAMES"))
      (T nil)
    )
  )
  (if
    (wcmatch cmd "*DIM*")
    (jk:DHR_HatchHide)
  )
  (princ)
)
; --------------------------------------------------------------------- ;
; Reaktor polecenia - koniec
(defun jk:DHR_CommEnded (r c)(jk:DHR_HatchUnHide))
; --------------------------------------------------------------------- ;
; zerowanie reaktorow
(defun jk:DHR_CleanReact (r c)
  (mapcar 'vlr-remove-all
    '(:vlr-Command-Reactor :vlr-dwg-Reactor)
  )
  (jk:DHR_InitReactor nil)
)
; --------------------------------------------------------------------- ;
; ssget okna
(defun jk:DHR_ScreenSelect (/ p LM:viewportextents)
;; Viewport Extents  -  Lee Mac
;; Returns two WCS points describing the lower-left and
;; upper-right corners of the active viewport.
  (defun LM:viewportextents (/ c h v)
    (setq c (trans (getvar 'viewctr) 1 0)
          h (/ (getvar 'viewsize) 2.0)
          v (list (* h (apply '/ (getvar 'screensize))) h)
    )
    (list (mapcar '- c v) (mapcar '+ c v))
  )
;; --------
  (setq p (LM:viewportextents))
  (ssget "_C" (car p)(cadr p))
)
; --------------------------------------------------------------------- ;
; ukrywa HATCH 
(defun jk:DHR_HatchHide (/ h l)
  (if *jk-DH-Status*
    (if
      (jk:DHR_ScreenSelect)
      (if
        (setq h (ssget "_P" (list (cons 0 "HATCH"))))
        (progn
          (setq l (cd:SSX_Convert h 0)
          )
          (foreach % l (redraw % 2))
          (setq *jk-DH-HatchList* l)
        )
      )
    )
  )
)
; --------------------------------------------------------------------- ;
; odkrywa HATCH
(defun jk:DHR_HatchUnHide ()
  (if *jk-DH-HatchList*
    (progn
      (foreach % *jk-DH-HatchList* (redraw % 1))
      (setq *jk-DH-HatchList* nil)
    )
  )
)
; --------------------------------------------------------------------- ;
(princ)
