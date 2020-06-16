;;; private/tools/config.el -*- lexical-binding: t; -*-

;; (use-package! atomic-chrome :defer 10 :config (atomic-chrome-start-server))
;; (use-package! grip-mode :commands (grip-mode))
;; (use-package! posframe)

(use-package! auto-save
  :config
  (setq auto-save-silent t
        auto-save-delete-trailing-whitespace nil
        auto-save-disable-predicates
        '((lambda () (string-suffix-p "gpg" (buffer-name) t))
          (lambda () (string-suffix-p "lua" (buffer-name) t))))
  (remove-hook 'doom-first-buffer-hook #'ws-butler-global-mode)
  (auto-save-enable))

(use-package! mybigword
  :commands (mybigword-show-big-words-from-file))

(defun keyfreq-load-excluded-commands ()
  (let ((path (concat
               (file-name-directory (or load-file-name buffer-file-name))
               "exclude-commands"))) 
    (with-temp-buffer
      (insert-file-contents path)
      (mapcar #'intern (split-string (buffer-string) "\n" t)))))

(use-package! keyfreq
  :init
  (setq keyfreq-excluded-commands (keyfreq-load-excluded-commands))
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(set-popup-rules!
  '(("^\\*BigWords" :size 0.35 :select t :modeline t :quit t :ttl t)
    ("^\\*frequencies" :size 0.35 :select t :modeline nil :quit t :ttl t)))
