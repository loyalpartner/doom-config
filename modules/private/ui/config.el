
;;; private/ui/config.el -*- lexical-binding: t; -*-

(defun awesome-tab-buffer-groups ()
  (list
   (cond
    ((derived-mode-p 'emacs-lisp-mode) "Elisp")
    ((derived-mode-p 'eaf-mode) "Eaf")
    ((or (string-equal "*" (substring (buffer-name) 0 1))
         (memq major-mode '(magit-process-mode
                            magit-status-mode magit-diff-mode magit-log-mode
                            magit-file-mode magit-blob-mode magit-blame-mode
                            )))
     "Emacs")
    ((derived-mode-p 'eshell-mode) "EShell")
    ((derived-mode-p 'dired-mode) "Dired")
    ;; ((locate-dominating-file "vue.config.js") "VueJs")
    ((memq major-mode '(org-mode org-agenda-mode diary-mode)) "OrgMode")
    (t (awesome-tab-get-group-name (current-buffer))))))


(use-package! awesome-tab
  :init
  (setq awesome-tab-height 150
        awesome-tab-terminal-dark-select-background-color "red")
  :config
  (awesome-tab-mode))

(defhydra awesome-switch (global-map "M-h")
  "
 ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc
-^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
   ^_k_^   prev group    | _C-a_^^     select first | _b_ search buffer | _C-k_   kill buffer
 _h_   _l_  switch tab   | _C-e_^^     select last  | _g_ search group  | _C-S-k_ kill others in group
   ^_j_^   next group    | _C-j_^^     ace jump     | ^^                | ^^
 ^^0 ~ 9^^ select window | _C-h_/_C-l_ move current | ^^                | ^^
-^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
"
  ("h" awesome-tab-backward-tab)
  ("j" awesome-tab-forward-group)
  ("k" awesome-tab-backward-group)
  ("l" awesome-tab-forward-tab)
  ("C-a" awesome-tab-select-beg-tab)
  ("C-e" awesome-tab-select-end-tab)
  ("C-j" awesome-tab-ace-jump)
  ("C-h" awesome-tab-move-current-tab-to-left)
  ("C-l" awesome-tab-move-current-tab-to-right)
  ("b" ivy-switch-buffer)
  ("g" awesome-tab-counsel-switch-group)
  ("C-k" kill-current-buffer)
  ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
  ("q" nil "quit"))
