;;; private/ctags/config.el -*- lexical-binding: t; -*-


(use-package! company-ctags
  :config
  (company-ctags-auto-setup))

(use-package! counsel-etags
  :commands (counsel-etags-find-tag-at-point)
  :init
  (map! :n "C-]" #'counsel-etags-find-tag-at-point)
  (add-hook 'ahk-mode-hook
        (lambda ()
          (add-hook 'after-save-hook
            'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (push "build" counsel-etags-ignore-directories))