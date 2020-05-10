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
  (defalias 'browse-url #'eaf-open-browser)

  (defun generate-eaf-key-func (key)
    `(lambda () (interactive)
       (let* ((eaf-func (lookup-key (current-local-map) ,key)))
         (funcall (if eaf-func eaf-func
                    'eaf-send-key)))))

  (mapc
   (lambda (k)
     (let* ((key (char-to-string k)))
       ;; (map! :map eaf-mode-map* :n key (generate-eaf-key-func key))
       (evil-define-key* 'normal eaf-mode-map* key (generate-eaf-key-func key))
       ))
   (number-sequence ?: ?~))
  )
