;;; private/eaf/config.el -*- lexical-binding: t; -*-

;; open pdf with eaf
(when IS-LINUX
  (defun adviser-find-file (orig-fn file &rest args)
    (let ((fn (if (commandp 'eaf-open) 'eaf-open orig-fn)))
      (pcase (file-name-extension file)
        ("pdf"  (apply fn file nil))
        ("epub" (apply fn file nil))
        (_      (apply orig-fn file args)))))
  (advice-add #'find-file :around #'adviser-find-file)

  ;; 用 eaf 打开链接
  (defun adviser-browser-url (orig-fn url &rest args)
    (cond ((string-prefix-p "file:" url) (eww url))
          ((and (commandp 'eaf-open-browser)
                (display-graphic-p))
           (eaf-open-browser url))
          (t (apply orig-fn url args))))

  (advice-add #'browse-url :around #'adviser-browser-url)

  (defun eaf-open-with-other-browser ()
    (interactive)
    (browse-url-chrome (eaf-get-path-or-url)))
  )

(use-package! eaf
  :when IS-LINUX
  :commands (eaf-open-browser eaf-open find-file)
  :init
  (map! :map eaf-mode-map* "C-." 'eaf-open-with-other-browser
        :leader
        :desc "eaf open history" "eh" 'eaf-open-browser-with-history
        :desc "eaf open terminal" "et" 'eaf-open-terminal
        :desc "eaf open rss" "er" 'eaf-open-rss-reader)

  :config
  (eaf-setq eaf-browser-chrome-history-file "~/.config/chromium/Default/History")
  (map! (:when t :map eaf-pdf-outline-mode-map
         :n "RET" 'eaf-pdf-outline-jump
         :n "q" '+popup/close)
        ;; (:when t :map eaf-mode-map
        ;;  "C-." #'awesome-tab-forward-tab
        ;;  "C-," #'awesome-tab-backward-tab)
        )

  (define-key key-translation-map (kbd "SPC")
    (lambda (prompt)
      (if (derived-mode-p 'eaf-mode)
          (pcase eaf--buffer-app-name
            ("browser" (if (eaf-call "call_function" eaf--buffer-id "is_focus")
                           (kbd "SPC")
                         (kbd "C-SPC")))
            ("pdf-viewer" (kbd "C-SPC"))
            (_  (kbd "SPC")))
        " ")))


  (defun buffer-mode-p (buffer mode)
    (eq (buffer-local-value 'major-mode buffer) mode))

  ;; eaf buffer look as workspace buffer
  (advice-add '+ivy--is-workspace-other-buffer-p :around #'advicer-is-workspace-ther-buffer-p)
  (defun advicer-is-workspace-ther-buffer-p (orig-fn  &rest args)
    (let ((buffer (cdar args)))
      (if (derived-mode-p 'eaf-mode)
          (and (buffer-mode-p buffer 'eaf-mode)
               (not (eq buffer (current-buffer))))
        (apply orig-fn args))))

  (defun eaf--browser-get-window ()
    (get-window-with-predicate
     (lambda (window)
       (with-current-buffer (window-buffer window)
         (string= eaf--buffer-app-name "browser")))))

  (defun eaf--browser-display (buf)
    (let ((browser-window (eaf--browser-get-window)))
      (if browser-window
          (unless (eq (selected-window) browser-window)
            (switch-to-buffer-other-window (window-buffer browser-window)))
        (progn
          (select-window (split-window-no-error (selected-window) nil 'left))))
      (switch-to-buffer buf)))

  (add-to-list 'eaf-app-display-function-alist '("browser" . eaf--browser-display))

  ;;ivy 添加 action, 用 eaf-open 打开
  (after! counsel
    (ivy-set-actions
     't
     (append '(("e" eaf-open))
             (plist-get ivy--actions-list 't))))

  (setq eaf-proxy-type "socks5"
        eaf-proxy-host "127.0.0.1"
        eaf-proxy-port "1080")

  (require 'eaf-evil)

  ;; (defun sdcv-search-from-eaf ()
  ;;   (interactive)
  ;;   (let (text)
  ;;     (setq text (eaf-call "call_function" eaf--buffer-id "get_selection_text"))
  ;;     (when text
  ;;       (sdcv-search-input+ text ))))

  ;; (map! :map eaf-mode-map* "C-." #'sdcv-search-from-eaf))
  )
(use-package! snails
  :commands (snails)
  :bind (("s-y" . snails)
         ("s-Y" . snails-search-point))
  :config
  (use-package! fuz)
  ;; (add-hook 'snails-mode-hook #'centaur-tabs-local-mode)
  (add-to-list 'evil-emacs-state-modes 'snails-mode))
