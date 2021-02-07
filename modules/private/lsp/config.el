;;  private/lsp/config.el -*- lexical-binding: t; -*-

(setq lsp-auto-guess-root t)

(set-company-backend! 'indium-repl-mode '(company-indium-repl))
(set-company-backend! 'dap-ui-repl-mode '(company-dap-ui-repl))
