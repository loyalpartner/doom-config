;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "lee"
      user-mail-address "loyalpartner@163.com")


;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "127.0.0.1" 1080 5))


(defun set-proxy ()
  "Set http/https proxy."
  (interactive)
  (setq url-gateway-method 'socks)
  (setq socks-server '("Default server" "127.0.0.1" 1080 5))
  (message "enabled proxy"))

(defun unset-proxy ()
  "Unset http/https proxy."
  (interactive)
  (setq url-gateway-method 'native)
  (setq socks-server nil)
  (message "disabled proxy."))

(defun toggle-proxy ()
  "Toggle http/https proxy."
  (interactive)
  (if (and (boundp 'socks-server) socks-server)
      (unset-proxy)
    (set-proxy)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)
   (protobuf . t)))

(setq org-plantuml-jar-path
      (expand-file-name
       (concat doom-private-dir "bin/plantuml.jar")))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;
(defvar font-size (cond ((> (display-pixel-width) 1920) 22)
                        (t 16)))
(defun default-font (font-name)
  (if (font-info font-name) font-name nil))

(defvar font
  (cond (IS-MAC `(:family ,(default-font "SauceCodePro NF") :size ,font-size))
        (IS-LINUX `(:family ,(default-font "Sarasa Mono SC") :size ,font-size))
        (t `(:family ,(default-font "SauceCodePro NF") :size ,font-size))))

(setq doom-font (apply #'font-spec font)
      ;; doom-variable-pitch-font (font-spec :family "Sarasa Fixed SC")
      ;; doom-unicode-font (font-spec :family "Sarasa Fixed SC")
      )


(when IS-LINUX
  (setq browse-url-browser-function 'browse-url-chrome))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; (setq doom-scratch-buffer-major-mode 'lisp-interaction-mode)



;; (with-eval-after-load "evil"
;;   (add-to-list 'evil-emacs-state-modes 'debugger-mode)
;;   (delete 'debugger-mode evil-normal-state-modes))


;; (setq +ivy-buffer-preview t)
;; (after! ivy
;;   (when IS-MAC
;;     (setq counsel-locate-cmd #'counsel-locate-cmd-noregex)))

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

(setq evil-escape-key-sequence "hh"
      evil-escape-delay 0.3)

(setq mac-option-modifier 'super
      mac-command-modifier 'meta
      x-hyper-keysym 'super)

(setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s)
      avy-style 'pre)

(setq which-key-idle-delay 0.1)

(defun next-theme ()
  (if (custom-theme-enabled-p 'doom-one)
      'doom-one-light
    'doom-one))

(defun toggle-theme ()
  (interactive)
  (load-theme (next-theme) t))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; (setq lsp-enable-snippet nil)

(defun copy-string (text)
  (with-temp-buffer
    (insert text)
    (clipboard-kill-region (point-min) (point-max))))

(defun copy-file-path ()
  (interactive)
  (copy-string (buffer-file-name)))

;; use \ instead of c-x
(define-key key-translation-map (kbd "\\")
  (lambda (prompt)
    (if (or (evil-normal-state-p)
            (evil-visual-state-p)
            (evil-motion-state-p))
        (kbd "C-x") "\\")))

(setq overriding-terminal-local-map
      (make-sparse-keymap))

(map! :i "C-b" 'backward-char
      :i "C-f" 'forward-char
      :v "v" #'er/expand-region

      (:when t :i "C-s" #'company-yasnippet)

      (:when t :map (overriding-terminal-local-map ) 

       "C-l" #'evil-window-right
       "C-h" #'evil-window-left
       "C-k" #'evil-window-up
       "C-j" #'evil-window-down

       "M-h" #'awesome-tab-backward-tab
       "M-l" #'awesome-tab-forward-tab)

      ;; info-mode 使用 gss gs-SPC 定位
      ;; :n "gss" #'evil-avy-goto-char-2
      ;; :n "gs SPC" (λ!! #'evil-avy-goto-char-timer t)

      (:when t
       "s-u" nil
       :desc "book" "s-u b" (lambda () (interactive) (dired "~/book"))
       :desc "org" "s-u o" (lambda () (interactive) (dired "~/org"))
       :desc "home" "s-u h" (lambda () (interactive) (dired "~/"))
       :desc "emacs directory" "s-u e" (lambda () (interactive) (dired user-emacs-directory)))

      (:when (featurep! :term vterm)
       :map vterm-mode-map  "C-`" #'+vterm/toggle
       :n "C-p" #'vterm--self-insert)

      (:when (featurep! :editor lispy)
       :map lispy-mode-map
       :i "C-e" #'lispy-move-end-of-line
       :i "C-d" #'lispy-delete
       :i "C-k" #'lispy-kill
       :i "C-y" #'lispy-yank)

      ;; (:when (and (featurep! :tools lsp) (featurep! :tools debugger))
      ;;  :map dap-mode-map
      ;;  :n "C-c '" #'dap-hydra)

      (:when (featurep! :tools gist)
       :map gist-mode-map
       :n "go" #'gist-fetch-current)

      :map Man-mode-map :n "RET" #'man-follow

      :map Info-mode-map
      :nv "w" #'evil-forward-word-begin
      :nv "W" #'evil-forward-WORD-begin
      :nv "e" #'evil-forward-word-end
      :nv "E" #'evil-forward-WORD-end
      :nv "b" #'evil-backward-word-begin
      :nv "B" #'evil-backward-WORD-begin
      :nv "h" #'evil-backward-char
      :nv "j" #'evil-next-line
      :nv "k" #'evil-previous-line
      :nv "l" #'evil-forward-char
      :nv "gv" #'evil-visual-restore
      :nv "gf" #'Info-follow-reference
      :nv "gn" #'Info-goto-node
      :nv "C-i" #'Info-history-forward
      :n "gd" (lambda () (interactive) (elisp-index-search (thing-at-point 'word t)))

      :leader
      :desc "copy file path" "by" #'copy-file-path
      :desc "split window" "ws" (lambda () (interactive) (split-window-vertically) (select-window (next-window)))
      :desc "vsplit window" "wv" (lambda () (interactive) (split-window-horizontally) (select-window (next-window)))
      :desc "toggle et" "te" #'english-teacher-follow-mode)
