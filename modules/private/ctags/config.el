;;; private/ctags/config.el -*- lexical-binding: t; -*-

;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)
;; Do case-sensitive tag searches
(setq tags-case-fold-search nil) ;; t=case-insensitive, nil=case-sensitive
;; Don't warn when TAGS files are large
(setq large-file-warning-threshold nil)

;; (when IS-MAC
;;   ;; Mac's default ctags does not support -e option
;;   ;; If you install Emacs by homebrew, another version of etags is already installed which does not need -e too
;;   ;; the best option is to install latest ctags from sf.net
;;   (setq ctags-command "/usr/local/bin/ctags -e -R "))

(use-package! company-ctags
  :config
  (company-ctags-auto-setup))

(use-package! counsel-etags
  :commands (counsel-etags-find-tag-at-point)
  :init
  (map! :n "C-]" #'counsel-etags-find-tag-at-point)
  (add-hook! '(ahk-mode-hook js2-mode-hook)
        (lambda ()
          (add-hook 'after-save-hook
            'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60
        tags-revert-without-query t)
  (setq counsel-etags-update-tags-backend (lambda (src-dir) (shell-command "/usr/bin/ctags -e -R")))
  (push "build" counsel-etags-ignore-directories))
