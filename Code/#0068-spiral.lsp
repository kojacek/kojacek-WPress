;*************************** SPIRAL.LSP ***************************;
; Autor programu:  Kelvin R. Throop, Autodesk  stycze¤ 1985
; Wersja polska: G. Burda, APLIKOM  27-4-89 ;
; Program rysuje spiral?.
; Wczytanie i wywo?anie programu przez wpisanie  "spiral" lub:;
;       (cspiral <# obrot˘w>  <# punkt˘w na obr˘t>).;
;****************************************************************
(defun cspiral 
  (ntimes bpoint cfac lppass / ang dist tp ainc dinc circle bs cs)
  (setq cs (getvar "cmdecho"))    ; zapami?tanie warto?ci zmiennych
  (setq bs (getvar "blipmode"))   ; "cmdecho" i "blipmode"
  (setvar "blipmode" 0)           ; wy??czenie "blipmode"
  (setvar "cmdecho" 0)            ; wy??czenie "cmdecho"
  (setq circle (* 3.141596235 2))
  (setq ainc (/ circle lppass))
  (setq dinc (/ cfac lppass))
  (setq ang 0.0)
  (setq dist 0.0)
     ;*(command "plinia" bpoint)        ; pocz?tek spirali od ?rodka i...
  (command "_.pline" bpoint)
  (repeat ntimes
    (repeat lppass
      (setq tp (polar bpoint (setq ang (+ ang ainc))
                 (setq dist (+ dist dinc))))
           (command tp)              ; kontynuacja do nast?pnego punktu...
    )
  )
  (command)                       ; a§ do zako¤czenia spirali.
  (setvar "blipmode" bs)          ; odtworzenie zapami?tanej "blipmode"
  (setvar "cmdecho" cs)           ; odtworzenie zapami?tanej "cmdecho"
  nil
)
;
;       Interaktywne generowanie spirali
;
(defun C:SPIRAL ( / nt bp cf lp)
  (initget 1)                  ; bp nie mo§e by? zerowe
  (setq bp (getpoint "\nrodek spirali: "))
  (initget 7)                  ; nt nie mo§e by? zerowe, ujemne lub puste
  (setq nt (getint "\nLiczba obrot˘w: "))
  (initget 3)                  ; cf nie mo§e by? zerowe, ujemne lub puste
  (setq cf (getdist "\nPrzyrost na obr˘t: "))
  (initget 6)                  ; lp nie mo§e by? zerowe lub ujemne
  (setq lp (getint "\nIlo?? punkt˘w na obr˘t : "))
  (cond ((null lp) (setq lp 30)))
  (cspiral nt bp cf lp)
)
(princ)
