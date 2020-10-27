;;; private/tools/config.el -*- lexical-binding: t; -*-

(after! projectile
  (add-to-list 'projectile-project-search-path "~/Documents/work")
  (add-to-list 'projectile-project-search-path "~/Documents/study")
  (add-to-list 'projectile-project-search-path "~/dot"))

(use-package! auto-save
  :config
  (setq auto-save-silent t
        auto-save-delete-trailing-whitespace nil
        auto-save-disable-predicates
        '((lambda () (string-suffix-p "gpg" (buffer-name)))
          (lambda () (string-suffix-p "lua" (buffer-name)))
          (lambda () (string-suffix-p "spec.js" (buffer-name)))))

  (remove-hook 'doom-first-buffer-hook #'ws-butler-global-mode)
  (auto-save-enable))

(use-package! mybigword
  :commands (mybigword-show-big-words-from-file mybigword-play-video-of-word-at-point)
  :init
  (setq mybigword-upper-limit 4)
  (map! :leader "tp" #'mybigword-play-video-of-word-at-point)
  (setq mybigword-default-format-function (lambda (word zipf) (format "%s \n" word))))

(defun keyfreq-load-excluded-commands ()
  (let ((path (concat
               (file-name-directory (or load-file-name buffer-file-name))
               "exclude-commands")))
    (with-temp-buffer
      (insert-file-contents path)
      (mapcar #'intern (split-string (buffer-string) "\n" t)))))

(use-package! evil-matchit
  :config
  (global-evil-matchit-mode))

(use-package! keyfreq
  :init
  (setq keyfreq-excluded-commands (keyfreq-load-excluded-commands))
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package! baidu-ocr
  :commands (baidu-ocr-ocr-page)
  :init
  (setq baidu-ocr-client-id "GT2oXlZprvaxER2ZG0fiBxGD"
        baidu-ocr-seceret-key "d13PpamkalDP7XdPKUQd3MHNffGGEZjN"))


(set-popup-rules!
  '(("^\\*BigWords" :size 0.35 :select t :modeline t :quit t :ttl t)
    ("^\\*frequencies" :size 0.35 :select t :modeline nil :quit t :ttl t)))

(use-package mingus
  :commands (mingus)
  :init
  (map! :leader "oh" #'mingus)
  :config
  (add-to-list 'evil-emacs-state-modes 'mingus-playlist-mode))
