;;; private/web/config.el -*- lexical-binding: t; -*-

(use-package! protobuf-mode
  :mode "\\.proto\\'")

(after! projectile
  (projectile-register-project-type 'vue '("vue.config.js" "package.json" "src")
                                    :project-file "vue.config.js"
                                    :run "npm run serve"
                                    :test "npm run test:unit"
                                    :test-suffix ".spec")

  (map! :leader "p." #'projectile-toggle-between-implementation-and-test)
  (mapc (apply-partially #'add-to-list 'projectile-other-file-alist)
        '(("js" "spec.js")
          ("spec.js" "js"))))

;; (add-hook 'js-mode-hook (setq))
;; (use-package! indium
;;   :hook ((js2-mode . indium-interaction-mode)
;;          (web-mode . indium-interaction-mode))
;;   :config
;;   (add-to-list 'evil-insert-state-modes 'indium-repl-mode))

(setq web-mode-content-types-alist
      '(("vue" . "\\.vue\\'")))

(add-hook 'web-mode-hook #'web-mode-setup)

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (js-mode)
;;             (tide-setup)
;;             (js2-minor-mode 1)
;;             (setq rotate-text-local-words
;;                   '(("log" "error" "info" "warn")))))

(defun web-mode-setup ()
  (lsp!)
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-style-padding 0
        web-mode-script-padding 0)
  ;; (map! :map dap-mode-map)
        ;; "C-c C-d" #'dap-debug
        ;; "C-c C-z" #'dap-ui-repl
        ;; "C-c C-r" #'dap-debug-recent
        ;; "C-c C-s" #'dap-debug-last
        ;; "C-c C-k" #'dap-debug-restart)

  )

(defun toggle-debugger ()
  (interactive)
  (let ((line-text (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
    (if (string-match-p "^\s*debugger" line-text)
        (kill-whole-line)
      (save-excursion
        (insert "debugger\n")))))


(setq-default js2-use-font-lock-faces t
              js2-mode-must-byte-compile nil
              ;; {{ comment indention in modern frontend development
              javascript-indent-level 2
              js-indent-level 2
              css-indent-offset 2
              typescript-indent-level 2
              ;; }}
              js2-strict-trailing-comma-warning nil ; it's encouraged to use trailing comma in ES6
              js2-idle-timer-delay 0.1 ; NOT too big for real time syntax check
              js2-auto-indent-p nil
              js2-indent-on-enter-key nil ; annoying instead useful
              js2-skip-preprocessor-directives t
              js2-strict-inconsistent-return-warning nil ; return <=> return null
              js2-enter-indents-newline nil
              js2-bounce-indent-p t)


(defun vue-find-file (path)
  (let ((file (seq-find 'file-exists-p
                        (mapcar (apply-partially 'concat path)
                                '("" ".js" ".vue")))))
    (if file (find-file file))))

(defun vue-lookup-point-path ()
  (interactive)
  (require 'english-teacher-core)
  (let ((path (english-teacher-string-at-point))
        (dir (locate-dominating-file "." "package.json"))
        result)
    (vue-find-file
     (replace-regexp-in-string "^@" (concat dir "src") path))))

(map! :map js2-mode-map
      :n "gh"  #'vue-lookup-point-path)
(map! :map web-mode-map
      :n "gh"  #'vue-lookup-point-path)


(use-package! eacl
  :commands (eacl-complete-line eacl-complete-multiline)
  :init
  (map!  :i "C-x C-l" #'eacl-complete-line
         :i "C-x C-/" #'eacl-complete-multiline))



(with-eval-after-load 'grep
  (dolist (v '("node_modules"
               "bower_components"
               ".sass_cache"
               ".cache"
               ".npm"))
    (add-to-list 'grep-find-ignored-directories v))
  (dolist (v '("*.min.js"
               "*.bundle.js"
               "*.min.css"
               "*.json"
               "*.log"))
    (add-to-list 'grep-find-ignored-files v)))
;; (add-hook 'vue-mode-hook (lambda ()
;;                            (lsp!)))
;; (add-hook 'vue-mode-hook (lambda () (setq syntax-ppss-table nil)))
(use-package! restclient)
(set-popup-rules!
  '(("^\\*HTTP Response" :size 0.5 :select t :modeline t :quit t :ttl t :side right)
    ("^\\*info" :size 0.5 :select t :modeline t :quit t :ttl t :side right)))
