;;; private/rss/config.el -*- lexical-binding: t; -*-

(defvar +rss-workspace-name "*RSS*")

(defun +rss-setup-wconf (&optional inhibit-workspace)
  (when (and (featurep! :ui workspaces)
             (not inhibit-workspace))
    (+workspace-switch +rss-workspace-name 'auto-create))
  (let ((buffers (doom-buffers-in-mode 'elfeed-search-mode nil t)))
    (if buffers
        (ignore (switch-to-buffer (car buffers)))
      (require 'elfeed)
      (delete-other-windows)
      (switch-to-buffer (doom-fallback-buffer))
      t)))

;;;###autoload
(defun =rss (&optional inhibit-workspace)
  (interactive "P")
  (+rss-setup-wconf inhibit-workspace)
  (cond ((doom-buffers-in-mode 'elfeed-search-mode (doom-buffer-list) t)
         (message "elfeed buffers are already open"))
        ((call-interactively #'elfeed))))

(map! (:when (featurep! :app rss)
        :map elfeed-search-mode-map
        :n "gu" #'elfeed-update
        :n "c" #'elfeed-search-clear-filter)
      :leader "on" '=rss)
