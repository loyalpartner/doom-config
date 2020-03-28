;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "lee"
      user-mail-address "loyalpartner@163.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(defvar my-font (cond (IS-MAC "SauceCodePro NF")
                      (IS-LINUX "SauceCodePro Nerd Font")
                      (t "SauceCodePro NF")))
(setq doom-font (font-spec :family my-font :size 18)
      ;; doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font Mono")
      )
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; (setq doom-scratch-buffer-major-mode 'lisp-interaction-mode)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

(after! org
  (setq elfeed-db-directory "~/org/elfeeddb")
  (add-to-list 'org-capture-templates
               '("l" "links" item
                 (file+olp "~/org/inbox.org" "Links" )
                 "- %:annotation \n\n"))
  (add-to-list 'org-capture-templates
               '("R" "RSS" entry
                 (file+olp "~/org/elfeed.org" "Links" "blogs" )
                 "** %:annotation \n\n"))

  (mapc (lambda (mode)
            (add-to-list 'org-modules mode))
        '(ol-info ol-irc)))
  ;; (dolist (module '(ol-info ol-irc)) (add-to-list 'org-modules module)))

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

(setq evil-embrace-show-help-p t
      evil-escape-key-sequence "hh"
      evil-escape-delay 0.3)

(setq mac-option-modifier 'super
      mac-command-modifier 'meta)

(setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s)
      avy-style 'pre)

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


(after! evil-embrace
  (setq evil-embrace-show-help-p t))

(map! :i "C-b" 'backward-char
      :i "C-f" 'forward-char
      :v "v" #'er/expand-region

      ;; info-mode 使用 gss gs-SPC 定位
      ;; :n "gss" #'evil-avy-goto-char-2
      ;; :n "gs SPC" (λ!! #'evil-avy-goto-char-timer t)

      (:when (featurep! :term vterm)
        :map vterm-mode-map  "C-`" #'+vterm/toggle
        :n "C-p" #'vterm--self-insert)
      (:when (featurep! :editor lispy)
        :map lispy-mode-map
        :i "C-e" #'lispy-move-end-of-line
        :i "C-d" #'lispy-delete
        :i "C-k" #'lispy-kill
        :i "C-y" #'lispy-yank)

      (:when (and (featurep! :tools lsp) (featurep! :tools debugger))
        :map dap-mode-map
        :n "'" #'dap-hydra)

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


      :leader
      "/" 'google-this

      (:when (featurep! :ui window-select +numbers)
        :leader
        :desc "[0]" "0" 'winum-select-window-0-or-10
        :desc "[1]" "1" 'winum-select-window-1
        :desc "[2]" "2" 'winum-select-window-2
        :desc "[3]" "3" 'winum-select-window-3
        :desc "[4]" "4" 'winum-select-window-4
        :desc "[5]" "5" 'winum-select-window-5
        :desc "[6]" "6" 'winum-select-window-6
        :desc "[7]" "7" 'winum-select-window-7
        :desc "[8]" "8" 'winum-select-window-8
        :desc "[9]" "9" 'winum-select-window-9))

;; (mapc (lambda (n)
;;         (let* ((key (number-to-string n))
;;                 (func (intern (format "winum-select-window-%d" n))))
;;           (map! :leader
;;             :desc (format "win%s" n) key func)))
;;       (number-sequence 1 9))

;; (setq org-use-sub-superscripts t)
