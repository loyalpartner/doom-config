;;  private/lsp/config.el -*- lexical-binding: t; -*-

(setq lsp-auto-guess-root t
      lsp-keymap-prefix "s-o"
      gc-cons-threshold 100000000

      )

(with-eval-after-load 'lsp-mode
  (setq dap-auto-configure-features '(locals controls tooltip))
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  )

(with-eval-after-load 'dap-mode
  (add-hook 'dap-terminated-hook (lambda (arg) (call-interactively #'dap-hydra/nil)))
  (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
  (map! :map +dap-running-session-mode-map :nv "'" #'dap-hydra
        :map dap-hydra/keymap "'" #'dap-hydra/nil))

;; (set-company-backend! 'indium-repl-mode '(company-indium-repl))
;; (set-company-backend! 'dap-ui-repl-mode '(company-dap-ui-repl))
