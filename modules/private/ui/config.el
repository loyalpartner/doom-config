;;; private/ui/config.el -*- lexical-binding: t; -*-

(defun project-try-web (dir)
  (let ((root (or (vc-file-getprop dir 'project-npm-root)
                  (vc-file-setprop dir 'project-npm-root
                                   (locate-dominating-file dir "package.json")))))
    (and root (cons 'npm root))))

(after! project
  (add-to-list 'project-find-functions #'project-try-web))

(defun awesome-tab-evil-forward-tab (tab-number)
  (interactive "P")
  (cond ((not (numberp tab-number)) (awesome-tab-forward))
        ((> tab-number 0) (awesome-tab-select-visible-nth-tab tab-number))
        ((< tab-number 0) (awesome-tab-backward))))

(defun awesome-tab-evil-backward-tab ()
  (interactive)
  (awesome-tab-goto-tab -1))

(use-package! awesome-tab
  :init
  (setq awesome-tab-height 150
        awesome-tab-dark-active-bar-color "yellow"
        awesome-tab-dark-selected-foreground-color "green"
        awesome-tab-dark-unselected-foreground-color "white"
        awesome-tab-terminal-dark-select-background-color "red"
        awesome-tab-display-sticky-function-name nil
        awesome-tab-label-max-length 30
        awesome-tab-show-tab-index t
        awesome-tab-cycle-scope 'tabs)
  :config
  (awesome-tab-mode)
  (require 'project)
  (map! (:when t :map general-override-mode-map
         :nv "M-h" #'awesome-tab-backward-tab
         "s-j" #'awesome-tab-forward-group
         "s-k" #'awesome-tab-backward-group
         :nv "M-l" #'awesome-tab-forward-tab
         :nv "M-k" #'awesome-tab-move-current-tab-to-left
         :nv "M-L" #'awesome-tab-move-current-tab-to-right
         "s-a" #'awesome-tab-switch-group
         :nv "gt" #'awesome-tab-evil-forward-tab
         :nv "gT" #'awesome-tab-evil-backward-tab
         :nv "M-A" #'awesome-tab-move-current-tab-to-beg)))

(defun adviser-awesome-buffer-name (orig-fn buffer &rest args)
  (if-let* ((file-name (buffer-file-name buffer))
            (chunks (split-string file-name "/"))
            (second-last (if (equal (length chunks) 1)  "" (car (last chunks 2))))
            (buffer-name (buffer-name buffer))
            (short (substring second-last 0 (min 3 (length second-last)))))
      (if (and awesome-tab-display-sticky-function-name
               (boundp 'awesome-tab-last-sticky-func-name)
               awesome-tab-last-sticky-func-name
               (equal buffer (current-buffer)))
          (format "%s/%s [%s]" short buffer-name awesome-tab-last-sticky-func-name)
        (format "%s/%s" short buffer-name))
    (buffer-name buffer)))


(advice-add #'awesome-tab-buffer-name :around #'adviser-awesome-buffer-name)

;; (add-hook 'post-command-hook #'awesome-tab-monitor-window-scroll-for-modeline)

(defun awesome-tab-monitor-window-scroll-for-modeline ()
  "This function is used to monitor the window scroll.
Currently, this function is only use for option `awesome-tab-display-sticky-function-name'."
  (let ((scroll-y (window-start)))
    (when (and scroll-y
               (integerp scroll-y))
      (unless (equal scroll-y awesome-tab-last-scroll-y)
        (let ((func-name (save-excursion
                           (goto-char scroll-y)
                           (require 'which-func)
                           (which-function))))
          (when (or
                 (not (boundp 'awesome-tab-last-sticky-func-name))
                 (not (equal func-name awesome-tab-last-sticky-func-name)))
            (set (make-local-variable 'awesome-tab-last-sticky-func-name) func-name)

            ;; Use `ignore-errors' avoid integerp error when execute `awesome-tab-line-format'.
            (setq global-mode-string awesome-tab-last-sticky-func-name)
              
            ))))
    (setq awesome-tab-last-scroll-y scroll-y)))



(defun awesome-tab-buffer-groups ()
  (list
   (cond
    ;; ((derived-mode-p 'web-mode) "Web")
    ;; ((derived-mode-p 'js2-mode) "Js")
    ((derived-mode-p 'emacs-lisp-mode) "Elisp")
    ((derived-mode-p 'eaf-mode) "Eaf")
    ((derived-mode-p 'rfc-mode) "rfc")
    ((or (string-equal "*" (substring (buffer-name) 0 1))
         (memq major-mode '(magit-process-mode
                            magit-status-mode magit-diff-mode magit-log-mode
                            magit-file-mode magit-blob-mode magit-blame-mode
                            )))
     "Emacs")
    ((derived-mode-p 'eshell-mode) "EShell")
    ((derived-mode-p 'dired-mode) "Dired")
    ;; ((locate-dominating-file "vue.config.js") "VueJs")
    ((memq major-mode '(org-mode org-agenda-mode diary-mode)) "OrgMode")
    (t (awesome-tab-get-group-name (current-buffer))))))
