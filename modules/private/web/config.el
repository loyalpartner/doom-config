;;; private/web/config.el -*- lexical-binding: t; -*-

(use-package! protobuf-mode
  :mode "\\.proto\\'")

(use-package! indium)
(add-hook 'js2-mode-hook #'indium-interaction-mode)

(map! :map indium-debugger-mode-map
      :n "h" #'indium-debugger-here
      :n "l" #'indium-debugger-locals
      :n "gs" #'indium-debugger-stack-frames)

(after! indium-repl-mode
  (set-company-backend! 'indium-repl-mode 'company-indium-repl))

(set-popup-rules!
  '(("^\\*JS REPL" :size 0.35 :select nil :modeline nil :quit t :ttl t)))

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

(setq js2-basic-offset 2)

(defun vue-lookup-point-path ()
  (interactive)
  (require 'english-teacher-core)
  (let ((path (english-teacher-string-at-point))
        (dir (locate-dominating-file "." "package.json"))
        result)
    (setq result path)
    (setq result (replace-regexp-in-string "\"" "" result))
    (setq result (replace-regexp-in-string "^@" (concat dir "src") result))
    ;; (setq result (concat result ".js"))
    (cond
     ((file-exists-p (concat result ".js")) (find-file (concat result ".js")))
     ((file-exists-p (concat result ".vue")) (find-file (concat result ".vue"))))))

(map! :map js2-mode-map
      :n "gh"  #'vue-lookup-point-path)
(map! :map web-mode-map
      :n "gh"  #'vue-lookup-point-path)

;; (use-package! vue-mode)

;; (add-hook 'vue-mode-hook (lambda ()
;;                            (lsp!)))
;; (add-hook 'vue-mode-hook (lambda () (setq syntax-ppss-table nil)))
