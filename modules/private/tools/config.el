;;; private/tools/config.el -*- lexical-binding: t; -*-


(use-package! atomic-chrome :defer 10 :config (atomic-chrome-start-server))
(use-package! grip-mode :commands (grip-mode))
(use-package! posframe)

(use-package! auto-save
  :config
  (setq auto-save-silent t)
  (auto-save-enable))

;; exit insert mode save buffer
(add-hook 'evil-insert-state-exit-hook
          (lambda () (when (and
                            (buffer-file-name)
                            (buffer-modified-p))
                       (basic-save-buffer))))
