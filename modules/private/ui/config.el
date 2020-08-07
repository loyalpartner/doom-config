;;; private/ui/config.el -*- lexical-binding: t; -*-

(use-package awesome-tab
  :init
  (setq awesome-tab-height 150
        awesome-tab-show-tab-index nil)
  :config
  (awesome-tab-mode)
  (map! "s-," #'awesome-tab-backward-group
        "s-." #'awesome-tab-forward-group

        :n "C-." #'awesome-tab-forward-tab
        :n "C-," #'awesome-tab-backward-tab

        (:when t :map eaf-mode-map
              "C-." #'awesome-tab-forward-tab
              "C-," #'awesome-tab-backward-tab)))

(defun awesome-tab-buffer-groups ()
  "`awesome-tab-buffer-groups' control buffers' group rules.

Group awesome-tab with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
All buffer name start with * will group to \"Emacs\".
Other buffer group by `awesome-tab-get-group-name' with project name."
  (list
   (cond
    ((derived-mode-p 'emacs-lisp-mode) "Elisp")
    ((derived-mode-p 'eaf-mode) "Eaf")
    ((or (string-equal "*" (substring (buffer-name) 0 1))
         (memq major-mode '(magit-process-mode
                            magit-status-mode
                            magit-diff-mode
                            magit-log-mode
                            magit-file-mode
                            magit-blob-mode
                            magit-blame-mode
                            )))
     "Emacs")
    ((derived-mode-p 'eshell-mode) "EShell")
    ((derived-mode-p 'dired-mode) "Dired")
    ((memq major-mode '(org-mode org-agenda-mode diary-mode)) "OrgMode")
    (t (awesome-tab-get-group-name (current-buffer))))))

