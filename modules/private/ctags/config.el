;;; private/ctags/config.el -*- lexical-binding: t; -*-


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
