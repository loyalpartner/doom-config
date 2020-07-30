;;; private/rss/config.el -*- lexical-binding: t; -*-

(set-company-backend! 'emacs-lisp-mode '(company-capf :with company-yasnippet))
(remove-hook 'lsp-mode-hook #'+lsp-init-company-h)

(add-hook 'lsp-mode-hook
          (lambda ()
            (if (not (bound-and-true-p company-mode))
                (add-hook 'company-mode-hook #'+lsp-init-company-h t t)
              ;; Ensure `company-capf' is at the front of `company-backends'
              (setq-local company-backends
                          (cons '(company-capf :with company-yasnippet)
                                (remq 'company-capf company-backends)))
              (remove-hook 'company-mode-hook #'+lsp-init-company-h t))))
