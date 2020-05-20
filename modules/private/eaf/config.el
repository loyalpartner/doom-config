;;; private/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :when IS-LINUX
  :commands (eaf-open-browser)
  :init
  (map! :leader
        :desc "eaf open history" "eh" 'eaf-open-browser-with-history
        :desc "eaf open terminal" "et" 'eaf-open-terminal
        :desc "eaf open rss" "er" 'eaf-open-rss-reader)
  :config
  (setq eaf-proxy-type "socks5"
        eaf-proxy-host "127.0.0.1"
        eaf-proxy-port "1080")


  ;; 用 eaf 打开链接
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-brower)

  ;;ivy 添加 action, 用 eaf-open 打开
  (ivy-set-actions t '(("p" eaf-open "eaf open")))

  (require 'evil-eaf)
  ;; (eaf-enable-evil-intergration)
  ;; (add-hook 'eaf-browser-hook
  ;;           (lambda ()
  ;;             ;; browser toggle insert/normal state except in devtool
  ;;             ;; devtool buffer will first open about:blank page and then redirect to devltools:// path
  ;;             (unless (string-prefix-p "about:blank" eaf--buffer-url)
  ;;               (evil-local-set-key 'insert (kbd "<escape>") 'eaf-proxy-clear_focus)
  ;;               (add-hook 'post-command-hook 'eaf-is-focus-toggle nil t))))

  ;; (defun eaf-is-focus-toggle ()
  ;;   "Toggle is-focus behavior in eaf-mode buffers."
  ;;   (if (eaf-call "call_function" eaf--buffer-id "is_focus")
  ;;       (unless (evil-insert-state-p)
  ;;         (evil-insert-state))
  ;;     (when (evil-insert-state-p)
  ;;       (evil-normal-state))))

  (defun sdcv-search-from-eaf ()
    (interactive)
    (let (text)
      (setq text (eaf-call "call_function" eaf--buffer-id "get_selection_text"))
      (when text
        (sdcv-search-input+ text ))))

  (map! :map eaf-mode-map* "C-." #'sdcv-search-from-eaf)

  )


(use-package! fuz)
(use-package! snails
  :bind (("s-y" . snails)
         ("s-Y" . snails-search-point))
  :config
  ;; (use-package! fuz)
  (add-to-list 'evil-emacs-state-modes 'snails-mode))
