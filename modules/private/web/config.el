;;; private/web/config.el -*- lexical-binding: t; -*-

(use-package! protobuf-mode
  :mode "\\.proto\\'")

;; (use-package! indium
;;   :hook ((js2-mode . indium-interaction-mode)
;;          (web-mode . indium-interaction-mode))
;;   :config
;;   (add-to-list 'evil-insert-state-modes 'indium-repl-mode))

;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (lsp!)
;;             (js2-refactor-mode 1)
;;             (js2-minor-mode 1)
;;             ;; (when (equal web-mode-content-type "vue")
;;             ;;   )
;;             ))

(setq web-mode-content-types-alist
      '(("vue" . "\\.vue\\'")))

(add-hook 'web-mode-hook #'web-mode-setup)
(defun web-mode-setup ()
  (lsp!)
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-style-padding 0
        web-mode-script-padding 0)
  (when (string= web-mode-content-type "vue")
    (require 'dap-chrome)
    ;; https://emacs-lsp.github.io/dap-mode/page/adding-debug-server/
    (dap-register-debug-template
     "Vue Debug in chrome"
     (list :type "chrome"
           :cwd nil
           :mode "url"
           :request "launch"
           :webRoot "${workspaceFolder}"
           :runtimeExecutable "/usr/bin/chromium"
           :url "http://localhost:8080"
           :sourceMapPathOverrides (list
                                    :webpack:///src/* "${workspaceFolder}/src/*"
                                    :webpack:///\./~/* "${workspaceFolder}/node_modules/*"
                                    :webpack:///\./* "${workspaceFolder}/*"
                                    :webpack:///* "/*")
           :name "Chrome Browse URL")))
  (map! :map dap-mode-map
        "C-c C-d" #'dap-debug
        "C-c C-z" #'dap-ui-repl
        "C-c C-r" #'dap-debug-recent
        "C-c C-s" #'dap-debug-last
        "C-c C-k" #'dap-debug-restart)

  )

(defun toggle-debugger ()
  (interactive)
  (let ((line-text (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
    (if (string-match-p "^\s*debugger" line-text)
        (kill-whole-line)
      (save-excursion
        (insert "debugger\n")))))


;; (map! :map indium-debugger-mode-map
;;       :n "h" #'indium-debugger-here
;;       :n "l" #'indium-debugger-locals
;;       :n "gs" #'indium-debugger-stack-frames
;;       :map (web-mode-map js2-mode-map indium-repl-mode-map indium-debugger-mode-map)
;;       "C-c C-r" #'indium-reload
;;       "C-c q" #'indium-quit
;;       "C-c r" #'indium-launch
;;       :map (web-mode-map js2-mode-map)
;;       "C-c t" #'toggle-debugger)

;; (after! indium-repl-mode
;;   (set-company-backend! 'indium-repl-mode 'company-indium-repl))

;; (set-popup-rules!
;;   '(("^\\*JS REPL"
;;      :size 0.2 :select nil :modeline nil :quit t :ttl t)))

(setq-default js2-use-font-lock-faces t
              js2-mode-must-byte-compile nil
              ;; {{ comment indention in modern frontend development
              javascript-indent-level 2
              js-indent-level 2
              css-indent-offset 2
              typescript-indent-level 2
              ;; }}
              js2-strict-trailing-comma-warning nil ; it's encouraged to use trailing comma in ES6
              js2-idle-timer-delay 0.5 ; NOT too big for real time syntax check
              js2-auto-indent-p nil
              js2-indent-on-enter-key nil ; annoying instead useful
              js2-skip-preprocessor-directives t
              js2-strict-inconsistent-return-warning nil ; return <=> return null
              js2-enter-indents-newline nil
              js2-bounce-indent-p t)



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
