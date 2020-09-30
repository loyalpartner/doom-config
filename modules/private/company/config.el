;;; private/rss/config.el -*- lexical-binding: t; -*- 
(use-package! company-tabnine
  :config
  (add-to-list 'company-backends #'company-tabnine))



(after! company-mode
  (setq company-idle-delay 0)
  (setq company-show-numbers t)
  (set-company-backend! 'js2-mode '(company-tabnine :separate company-capf :with company-yasnippet))
  (set-company-backend! 'web-mode '(company-tabnine :with company-capf :with company-yasnippet))
  (setq +lsp-company-backend '(company-tabnine :with company-lsp))
  (set-company-backend! 'indium-repl-mode '(company-indium-repl))
  (set-company-backend! 'web-mode '(company-capf :separate company-etags :separate company-yasnippet))
  )
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




