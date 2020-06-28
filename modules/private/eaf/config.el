;;; private/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :when IS-LINUX
  :commands (eaf-open-browser eaf-open)
  :init
  (map! :leader
        :desc "eaf open history" "eh" 'eaf-open-browser-with-history
        :desc "eaf open terminal" "et" 'eaf-open-terminal
        :desc "eaf open rss" "er" 'eaf-open-rss-reader)

  (map! :map eaf-pdf-outline-mode-map
        :n "RET" 'eaf-pdf-outline-jump
        :n "q" '+popup/close)

  ;;ivy 添加 action, 用 eaf-open 打开
  (after! counsel
    (ivy-set-actions
     't
     (append '(("e" eaf-open "eaf open"))
             (plist-get ivy--actions-list 't))))
  :config
  (setq eaf-proxy-type "socks5"
        eaf-proxy-host "127.0.0.1"
        eaf-proxy-port "1080")

  ;; 用 eaf 打开链接
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-brower)

  (defun eaf-org-open-file (file &optional link)
    "An wrapper function on `eaf-open'."
    (eaf-open file))

  ;; use `emacs-application-framework' to open PDF file: link
  (add-to-list 'org-file-apps '("\\.pdf\\'" . eaf-org-open-file))

  (require 'eaf-evil)

  ;; open pdf with eaf
  (advice-add 'find-file :around #'open-with-eaf)
  (defun open-with-eaf (orig-fun file &rest args)
    (if (seq-some (lambda (suffix)
                    (string-suffix-p suffix file))
                  '(".pdf" ".epub")) 
        (eaf-open file)
      (apply orig-fun file args)))
  
  (defun sdcv-search-from-eaf ()
    (interactive)
    (let (text)
      (setq text (eaf-call "call_function" eaf--buffer-id "get_selection_text"))
      (when text
        (sdcv-search-input+ text ))))

  (map! :map eaf-mode-map* "c-." #'sdcv-search-from-eaf))


(use-package! fuz)
(use-package! snails
  :commands (snails)
  :bind (("s-y" . snails)
         ("s-Y" . snails-search-point))
  :config
  ;; (use-package! fuz)
  (add-to-list 'evil-emacs-state-modes 'snails-mode))
