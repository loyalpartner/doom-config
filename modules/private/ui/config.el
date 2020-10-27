;;; private/ui/config.el -*- lexical-binding: t; -*-

(use-package! awesome-tab
  :init
  (setq awesome-tab-height 150
        awesome-tab-terminal-dark-select-background-color "red")
  :config
  (awesome-tab-mode)
  (map! "M-h" #'awesome-tab-backward-tab
        "M-j" #'awesome-tab-forward-group
        "M-k" #'awesome-tab-backward-group
        "M-l" #'awesome-tab-forward-tab))


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


