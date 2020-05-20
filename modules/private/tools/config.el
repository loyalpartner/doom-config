;;; private/tools/config.el -*- lexical-binding: t; -*-

;; (use-package! atomic-chrome :defer 10 :config (atomic-chrome-start-server))
;; (use-package! grip-mode :commands (grip-mode))
(use-package! posframe)

(use-package! auto-save
  :config
  (setq auto-save-silent t
        auto-save-delete-trailing-whitespace nil
        auto-save-disable-predicates
        '((lambda ()
            (string-suffix-p "gpg" (buffer-name) t))
          (lambda ()
            (string-suffix-p "lua" (buffer-name) t))))
  (auto-save-enable))

;; (use-package! awesome-tab
;;   ;; :after-call find-file-hook
;;   :init
;;   (awesome-tab-mode)
;;   :config
;;   ;; (setq awesome-tab-show-tab-index t)
;;   (map! "s-j" 'awesome-tab-forward-group
;;         "s-k" 'awesome-tab-backward-group
;;         "s-," 'awesome-tab-backward-tab
;;         "s-." 'awesome-tab-forward-tab))

;; (use-package! awesome-tray)

;; (use-package!)
;; (use-package! flycheck
;;   :config
;;   (global-flycheck-mode))

;; (add-hook 'evil-insert-state-exit-hook
;;           (lambda () (when (and
;;                             (buffer-file-name)
;;                             (buffer-modified-p))
;;                        (basic-save-buffer))))

