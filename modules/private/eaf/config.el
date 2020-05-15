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

  (eaf-enable-evil-intergration)

  (defun sdcv-search-from-eaf ()
    (interactive)
    (let (text)
      (setq text (eaf-call "call_function" eaf--buffer-id "get_selection_text"))
      (when text
        (sdcv-search-input+ text ))))

  (map! :map eaf-mode-map* "C-." #'sdcv-search-from-eaf)

  )



(use-package! snails
  :bind (("s-y" . snails)
         ("s-Y" . snails-search-point))
  :config
  ;; (use-package! fuz)
  (add-to-list 'evil-emacs-state-modes 'snails-mode))
