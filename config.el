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
;; test
(setq doom-font (font-spec :family "SauceCodePro NF" :size 11)
      ;; doom-variable-pitch-font (font-spec :family "SauceCodePro NF")
      )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/"
      elfeed-db-directory "~/org/elfeeddb")

(after! org
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

(setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))
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

(use-package! atomic-chrome :defer 10 :config (atomic-chrome-start-server))
(use-package! grip-mode :commands (grip-mode))
(use-package! posframe)

(after! evil-embrace
  (setq evil-embrace-show-help-p t))


(map! :i "C-b" 'backward-char
      :i "C-f" 'forward-char

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
      :v "w" #'evil-forward-word-end

      :leader
      "/" 'google-this

      (:when (featurep! :ui window-select +numbers)
        :leader
        "0" 'winum-select-window-0-or-10
        "1" 'winum-select-window-1
        "2" 'winum-select-window-2
        "3" 'winum-select-window-3
        "4" 'winum-select-window-4
        "5" 'winum-select-window-5
        "6" 'winum-select-window-6
        "7" 'winum-select-window-7
        "8" 'winum-select-window-8
        "9" 'winum-select-window-9))

;; (setq org-use-sub-superscripts t)

;; exit insert mode save buffer
(add-hook 'evil-insert-state-exit-hook
          (lambda () (when (and
                            (buffer-file-name)
                            (buffer-modified-p))
                       (basic-save-buffer))))

