;;; private/tools/config.el -*- lexical-binding: t; -*-

(after! projectile
  (add-to-list 'projectile-project-search-path "~/Documents/work/damopan")
  ;; (add-to-list 'projectile-project-search-path "~/dot")
  (add-to-list 'projectile-project-search-path "~/Documents/study"))

(after! magit
  (setq magit-view-git-manual-method 'man))

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
    ("^\\*frequencies" :size 0.35 :select t :modeline nil :quit t :ttl t)
    ("^\\*rfc" :size 0.5 :select t :modeline t :quit t :ttl t :side right)
    ("^\\*Man" :size 0.99 :select t :modeline t :quit t :ttl t :side bottom)
    ("^\\*eww" :size 0.5 :select t :modeline t :quit t :ttl t :side bottom)
    ("^\\*compilation" :size 0.35 :select t :modeline t :quit t :ttl t :side bottom)
    ("^\\*Launch File" :ignore t :size 0 :select nil :modeline nil :quit t :ttl t :side bottom)
    ("^\\*SDCV" :size 0.35 :select t :modeline t :quit t :ttl t :side bottom)))

(use-package! mingus
  :commands (mingus)
  :init
  (map! :leader "oh" #'mingus)
  :config
  (add-to-list 'evil-emacs-state-modes 'mingus-playlist-mode))

(defun generate-pdf-file ()
  (call-process-shell-command (format "pdftex %s" (buffer-file-name)) nil 0))

(add-hook
 'plain-tex-mode-hook '(lambda ()
                         (add-hook 'after-save-hook #'generate-pdf-file nil t)
                         ))

(use-package! rfc-mode
  :commands (rfc-mode-browse)
  :config
  (setq rfc-mode-directory (expand-file-name "~/org/book/rfc")))

(map! (:when t
       :map rfc-mode-map
       :n "g" nil
       :nv "gm" #'rfc-mode-goto-section))

(use-package! mermaid-mode :commands (mermaid-mode))

(use-package! ob-mermaid
  :config
  (setq ob-mermaid-cli-path "/home/lee/.yarn/bin/mmdc"))

(defun rss-add-feed (url)
  (evil-set-register ?* url)
  (org-capture t "R")
  (message "add rss feed: %s" url))

;;
(defun adviser-browse-url (orig-fn url &rest args)
  (let ((uri-object (url-generic-parse-url url))
        (rss-files '("/feed.xml" "/atom.xml" "/rss.xml" "/index.rss" "/posts.atom" "/rss/")))
    (if (member (url-filename uri-object) rss-files)
        (rss-add-feed url)
      (apply orig-fn url args))))

(advice-add #'browse-url :around #'adviser-browse-url)
(advice-add #'eww :around #'adviser-browse-url)

;; disable evil in vterm mode
;; (add-hook 'evil-normal-state-entry-hook
;;           (lambda ()
;;             (when (derived-mode-p 'vterm-mode)
;;               ;; (define-key eaf-mode-map (kbd eaf-evil-leader-key) eaf-evil-leader-keymap)
;;               (setq-local emulation-mode-map-alists
;;                           (delq 'evil-mode-map-alist emulation-mode-map-alists)))))

(defun go-defun-name ()
  (save-excursion
    (beginning-of-defun)
    (re-search-forward "[^ ]+\(" nil t 1)
    (backward-char 1)
    (word-at-point t)))

(defun go-test-at-point (&optional verbose)
  (interactive "P")
  (setq counsel-compile--current-build-dir (counsel--compile-root))
  (let ((command-line-format "go test -v %s -run %s"))
    (counsel-compile--action
     (format command-line-format
             (buffer-file-name)
             (go-defun-name)))))
