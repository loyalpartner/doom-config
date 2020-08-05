;;; private/rss/config.el -*- lexical-binding: t; -*-

(set-company-backend! 'emacs-lisp-mode '(company-capf :separate company-yasnippet))
;; (set-company-backend! 'web-mode '(company-capf :with company-yasnippet :with company-css :with company-web))
;; (remove-hook 'lsp-mode-hook #'+lsp-init-company-h)

;; (defun lsp-init-company ()
;;   (if (not (bound-and-true-p company-mode))
;;       (add-hook 'company-mode-hook #'lsp-init-company t t)
;;     ;; Ensure `company-capf' is at the front of `company-backends'
;;     (setq-local company-backends
;;                 '(company-capf :with company-yasnippet)))
;;     (remove-hook 'company-mode-hook #'lsp-init-company t)) 
;; (add-hook 'lsp-mode-hook #'lsp-init-company)



