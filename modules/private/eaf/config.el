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

  ;; open pdf with eaf
  (advice-add 'find-file :around #'open-with-eaf)
  (defun open-with-eaf (orig-fun file &rest args)
    (pcase (file-name-extension file)
      ("pdf"  (eaf-open file))
      ("epub" (eaf-open file))
      (_      (apply orig-fun file args))))

  (defun buffer-mode-p (buffer mode)
    (eq (buffer-local-value 'major-mode buffer) mode))

  ;; eaf buffer look as workspace buffer
  (advice-add '+ivy--is-workspace-other-buffer-p :around #'is-workspace-other-buffer-p-advice)
  (defun is-workspace-other-buffer-p-advice (orig-fun  &rest args)
    (let ((buffer (cdar args)))
      (or (and (buffer-mode-p buffer 'eaf-mode)
               (not (eq buffer (current-buffer))))
          (apply orig-fun args))))

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

  (require 'eaf-evil)
  ;; 用 eaf 打开链接
  ;; http://www.baidu.com
  ;; http://www.github.com
  (defun adviser-browser-url (orig-fn url &rest args)
    (let ((whitelist '("github" "wikipekia" "planet")))
      (cond ((derived-mode-p 'elfeed-show-mode) (eww-browse-url url))
            ((string-match-p (regexp-opt whitelist) url) (eaf-open-browser url))
            (t (apply orig-fn url args)))))
  (advice-add #'browse-url :around #'adviser-browser-url) 
  
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
