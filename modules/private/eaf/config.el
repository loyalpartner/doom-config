;;; private/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :when IS-LINUX
  :commands (eaf-open-browser)
  :init
  (map! :leader
        :desc "eaf open history" "eh" 'eaf-open-browser-with-history
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

  ;; TODO: 默认用 eaf 打开 pdf

  ;; 兼容 evil
  (defun generate-eaf-key-func (key)
    `(lambda () (interactive)
       (let* ((eaf-func (lookup-key (current-local-map) ,key)))
         (funcall (or eaf-func 'eaf-send-key)))))

  (mapc
   (lambda (k)
     (let* ((key (char-to-string k)))
       ;; (map! :map eaf-mode-map* :n key (generate-eaf-key-func key))
       (evil-define-key* 'normal eaf-mode-map* key (generate-eaf-key-func key))))
   (number-sequence ?: ?~)))
