;;; private/ctags/config.el -*- lexical-binding: t; -*-

(use-package! ahk-mode)

(use-package! ctags-update
  :commands (turn-on-ctags-auto-update-mode ctags-update)
  :hook (ahk-mode . turn-on-ctags-auto-update-mode)
  :config
  ;; (setq ctags-update-prompt-create-tags nil)
  )

(use-package! company-ctags
  :config
  (company-ctags-auto-setup))
