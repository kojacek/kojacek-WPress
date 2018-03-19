; =========================================================================================== ;
; MenuGroup.lsp by kojacek 2010, 2016
; last-mod: 28-08-2016
; =========================================================================================== ;
(if (null cd:ACX_Model)(load "CADPL-Pack-v1.lsp" -1))
;* (if (null jk:VEC_GripDraw)(load "jkutils.lsp" -1))
; =========================================================================================== ;

; =========================================================================================== ;
; jk:MNU_GetMenuGruops + jk:MNU_GetMenuGroup + jk:MNU_GetToolbars -> jkutils.lsp
; =========================================================================================== ;
(defun jk:MNU_GetMenuGruops (Mode / r)
  (vlax-for %
    (vla-get-MenuGroups (vlax-get-acad-object))
    (setq r
      (cons (cons (vla-get-name %) %) r)
    )
  )
  (cond
    ( (not Mode) r)
    ( (zerop Mode)(mapcar 'car r))
    ( (= 1 Mode)(mapcar 'cdr r))
    (T nil)
  )
)
; =========================================================================================== ;
(defun jk:MNU_GetMenuGroup (Name)
  (cdr (assoc Name (jk:MNU_GetMenuGruops nil)))
)
; =========================================================================================== ;
(defun jk:MNU_GetToolbars (GroupName Mode / s b r)
  (if
    (setq s (jk:MNU_GetMenuGroup GroupName))
    (if
      (setq b (vla-get-Toolbars s))
      (vlax-for % b
        (setq r
          (cons (cons (vla-get-name %) %) r)
        )
      )
    )
  )
  (cond
    ( (not Mode) r)
    ( (zerop Mode)(mapcar 'car r))
    ( (= 1 Mode)(mapcar 'cdr r))
    ( (= 2 Mode)
      (mapcar
        '(lambda (%) 
           (list
             (car %)
             (vla-get-HelpString (cdr %))
             (vla-get-Visible (cdr %))
             (cdr %)
           )
         ) r
       )
    )
    (T nil)
  )
)
; =========================================================================================== ;
; MenuGroup 
; =========================================================================================== ;
(defun C:BTN (/ lm pm lt pt po fl db vb ub lv)
  (setq pm 0
        pt 0
        po 0
        lm (acad_strlsort (jk:MNU_GetMenuGruops 0))
        lt (jk:MNU_GetToolbars (nth pm lm) 0)
        lt (if lt (acad_strlsort lt))
        fl (if lt T nil)
        db (if fl (jk:MNU_GetToolbars (nth pm lm) 2))
        ub (if db (assoc (nth pt lt) db))
        lv (list :vlax-false :vlax-true)
  )
  (jk:MenuGroupDlg)
  (princ)
)
; =========================================================================================== ;
(defun jk:MenuGroupDlg ( / a d _$m _$t _$v u f r)
  (defun _$t (v)
    (setq pt (read v))
    (if (not fl)
      (progn
        (set_tile "h"
          (strcat "Grupa: "
            (nth pm lm) " nie ma pasków narzêdzi")
        )
        (foreach % '("v" "t")(mode_tile % 1))
      )
      (progn
        (setq ub (assoc (nth pt lt) db)
              vb (vla-get-visible (nth 3 ub))
        )
        (foreach % '("v" "t")(mode_tile % 0))
        (set_tile "h" (strcat "Opis: " (nth 1 ub)))
        (set_tile "v" (itoa (vl-position vb lv)))
        
      )
    )
  )
  (defun _$m (v)
    (setq pm (read v)
          pt 0
          lt (jk:MNU_GetToolbars (nth pm lm) 0)
          lt (if lt (acad_strlsort lt))
          fl (if lt T nil)
          db (if fl (jk:MNU_GetToolbars (nth pm lm) 2))
          ub (if db (assoc (nth pt lt) db))
    )
    (cd:DCL_SetList "t" lt (itoa pt))
    (_$t (itoa pt))
  )
  (defun _$v (v)
    (vla-put-visible (nth 3 ub)(nth (read v) lv))
  )
  ;--------
  (cond
    ( (not
        (and
          (setq f
            (open
              (setq u (vl-FileName-MkTemp nil nil ".dcl")) "w"
            )
          )
          (foreach %
            (list
              "mbtn:dialog{label=\"Menu Toolbars\";"
              "  :column{"
              "    :row{"
              "      :list_box{label=\"Grupy menu:\";key=\"m\";"
              "         width=22;height=15;}"
              "      :list_box{label=\"Paski narzêdzi:\";key=\"t\";"
              "         width=40;height=15;}"
              "    }"
              "    :boxed_row{label=\"W³aœciwoœci paska narzêdzi:\";"
              "    :text{label=\"\";key=\"h\";width=45;}"
              "    :toggle{key=\"v\";label=\"Widoczny\";}"
              "    }"
              "    ok_only;"
              "  }"
              "}"
            )
            (write-line % f)
          )
          (not (close f))
          (< 0 (setq d (load_dialog u)))
          (new_dialog "mbtn" d)
        )
      )
    )
    (T
      (cd:DCL_SetList "m" lm (itoa pm))
      (cd:DCL_SetList "t" lt (itoa pt))
      (_$t (itoa pt))
      (foreach % '("m" "t" "v")
        (action_tile % (strcat "(_$" % " $value)"))
      )
      (setq r (start_dialog))
    )
  )
  (if (< 0 d) (unload_dialog d))
  (if (setq u (findfile u))(vl-File-Delete u))
)
; =========================================================================================== ;
(princ "\n *** [menugroup.lsp] Polecenie: BTN ")
(princ)
