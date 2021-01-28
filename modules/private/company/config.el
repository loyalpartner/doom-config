;;; private/rss/config.el -*- lexical-binding: t; -*-

;; https://github.com/emacs-lsp/lsp-mode/issues/533
(after! lsp-mode
  (setq lsp-auto-guess-root t))

;; (setq +lsp-company-backends '(company-yasnippet :separate company-capf))

;; (setq company-idle-delay 0
;;       company-show-numbers nil)

(set-company-backend! 'indium-repl-mode '(company-indium-repl))
(set-company-backend! 'dap-ui-repl-mode '(company-dap-ui-repl))

;; (add-hook 'tide-mode-hook
;;           (lambda ()
;;             (run-at-time 2 nil
;;                          (lambda ()
;;                            (set-company-backend! 'js2-mode '(company-yasnippet :with company-tide))))))

;; (set-company-backend! 'web-mode '(company-capf :with company-yasnippet :with company-css :with company-web))

(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))
