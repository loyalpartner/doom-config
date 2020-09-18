;;; private/web/config.el -*- lexical-binding: t; -*-

(setq web-mode-content-types-alist
      '(("vue" . "\\.vue\\'")))

(setq-default web-mode-markup-indent-offset 2
              web-mode-code-indent-offset 2
              web-mode-css-indent-offset 2)

(add-hook 'web-mode-hook
          (lambda ()
            (lsp!)
            (when (equal web-mode-content-type "vue")
              (setq web-mode-style-padding 0
                    web-mode-script-padding 0))))


;; (use-package! vue-mode)

;; (add-hook 'vue-mode-hook (lambda ()
;;                            (lsp!)))
;; (add-hook 'vue-mode-hook (lambda () (setq syntax-ppss-table nil)))
