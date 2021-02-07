;;; private/rss/config.el -*- lexical-binding: t; -*-

(defvar +rss-workspace-name "*RSS*")

;; (setenv "ALL_PROXY" "socks5://localhost:1080")

(defun +rss-setup-wconf (&optional inhibit-workspace)
  (when (and (featurep! :ui workspaces)
             (not inhibit-workspace))
    (+workspace-switch +rss-workspace-name 'auto-create))
  (let ((buffers (doom-buffers-in-mode 'elfeed-search-mode nil t)))
    (if buffers
        (ignore (switch-to-buffer (car buffers)))
      (delete-other-windows)
      (switch-to-buffer (doom-fallback-buffer))
      t)))

;;;###autoload
(defun =rss+ (&optional inhibit-workspace)
  (interactive "P")
  (+rss-setup-wconf inhibit-workspace)
  (cond ((doom-buffers-in-mode 'elfeed-search-mode (doom-buffer-list) t)
         (message "elfeed buffers are already open"))
        ((call-interactively #'elfeed))))

;;;###autoload
(defun +rss/quit ()
  (interactive)
  (when (and (featurep! :ui workspaces)
             (+workspace-switch +rss-workspace-name))
    (mapc #'kill-buffer
          (doom-buffers-in-mode '(elfeed-search-mode elfeed-show-mode)
                                (buffer-list) t))
    (+workspace/delete +rss-workspace-name)))

;; (defun browse-url-eww (url &optional _)
;;   (interactive)
;;   (eww url))

;; (add-hook 'elfeed-show-mode-hook
;;           (lambda ()
;;             (setq-local browse-url-browser-function #'browse-url-eww)))

;; (add-hook 'eww-mode-hook
;;           (lambda ()
;;             (setq-local url-gateway-method 'socks)
;;             (setq-local socks-server '("Default server" "127.0.0.1" 1080 5))))

(map! (:when (featurep! :app rss)
        :map elfeed-search-mode-map
        :n "gu" #'elfeed-update
        :n "c" #'elfeed-search-clear-filter
        :n [remap elfeed-kill-buffer] #'+rss/quit )
      :leader "on" '=rss+)
