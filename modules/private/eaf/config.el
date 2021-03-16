;;; private/eaf/config.el -*- lexical-binding: t; -*-

;; open pdf with eaf
(when IS-LINUX
  ;; eaf 已经采用了这段代码
  ;; (defun adviser-find-file (orig-fn file &rest args)
  ;;   (let ((fn (if (commandp 'eaf-open) 'eaf-open orig-fn)))
  ;;     (pcase (file-name-extension file)
  ;;       ("pdf"  (apply fn file nil))
  ;;       ("epub" (apply fn file nil))
  ;;       (_      (apply orig-fn file args)))))
  ;; (advice-add #'find-file :around #'adviser-find-file)

  ;; 用 eaf 打开链接
  (defun adviser-browser-url (orig-fn url &rest args)
    (cond ((string-prefix-p "file:" url) (eww url))
          ((and (commandp 'eaf-open-browser)
                (display-graphic-p))
           (eaf-open-browser url))
          (t (apply orig-fn url args))))

  (advice-add #'browse-url :around #'adviser-browser-url))


(setq eaf-browser-keybinding
      '(("C--" . "zoom_out")
        ("C-=" . "zoom_in")
        ("C-0" . "zoom_reset")
        ("C-s" . "search_text_forward")
        ("C-r" . "search_text_backward")
        ("C-n" . "scroll_up")
        ("C-p" . "scroll_down")
        ("C-f" . "scroll_right")
        ("C-b" . "scroll_left")
        ("C-v" . "scroll_up_page")
        ("C-y" . "yank_text")
        ("C-w" . "kill_text")
        ("M-e" . "atomic_edit")
        ("M-c" . "caret_toggle_browsing")
        ("M-D" . "select_text")
        ("M-s" . "open_link")
        ("M-S" . "open_link_new_buffer")
        ("M-B" . "open_link_background_buffer")
        ("C-/" . "undo_action")
        ("M-_" . "redo_action")
        ("M-w" . "copy_text")
        ("M-f" . "history_forward")
        ("M-b" . "history_backward")
        ("M-q" . "clear_cookies")
        ("C-t" . "toggle_password_autofill")
        ("C-d" . "save_page_password")
        ("M-a" . "toggle_adblocker")
        ("C-M-q" . "clear_history")
        ("C-M-i" . "import_chrome_history")
        ("M-v" . "scroll_down_page")
        ("M-<" . "scroll_to_begin")
        ("M->" . "scroll_to_bottom")
        ("M-p" . "duplicate_page")
        ("M-t" . "new_blank_page")
        ("M-d" . "toggle_dark_mode")
        ("SPC" . "insert_or_scroll_up_page")
        ("J" . "insert_or_select_left_tab")
        ("K" . "insert_or_select_right_tab")
        ("j" . "insert_or_scroll_up")
        ("k" . "insert_or_scroll_down")
        ("h" . "insert_or_scroll_left")
        ("l" . "insert_or_scroll_right")
        ("f" . "insert_or_open_link")
        ("F" . "insert_or_open_link_new_buffer")
        ("B" . "insert_or_open_link_background_buffer")
        ("v" . "insert_or_caret_at_line")
        ("u" . "insert_or_scroll_down_page")
        ("d" . "insert_or_scroll_up_page")
        ("H" . "insert_or_history_backward")
        ("L" . "insert_or_history_forward")
        ("t" . "insert_or_new_blank_page")
        ("T" . "insert_or_recover_prev_close_page")
        ("i" . "insert_or_focus_input")
        ("I" . "insert_or_open_downloads_setting")
        ("r" . "insert_or_refresh_page")
        ("g" . "insert_or_scroll_to_begin")
        ("x" . "insert_or_close_buffer")
        ("G" . "insert_or_scroll_to_bottom")
        ("-" . "insert_or_zoom_out")
        ("=" . "insert_or_zoom_in")
        ("0" . "insert_or_zoom_reset")
        ("m" . "insert_or_save_as_bookmark")
        ("o" . "insert_or_open_browser")
        ("y" . "insert_or_download_youtube_video")
        ("Y" . "insert_or_download_youtube_audio")
        ("p" . "insert_or_toggle_device")
        ("P" . "insert_or_duplicate_page")
        ("1" . "insert_or_save_as_pdf")
        ("2" . "insert_or_save_as_single_file")
        ;; ("v" . "insert_or_view_source")
        ("e" . "insert_or_edit_url")
        ("," . "insert_or_switch_to_reader_mode")
        ("C-M-c" . "copy_code")
        ("C-M-l" . "copy_link")
        ("C-a" . "select_all_or_input_text")
        ("M-u" . "clear_focus")
        ("C-j" . "open_downloads_setting")
        ("M-o" . "eval_js")
        ("M-O" . "eval_js_file")
        ("<escape>" . "eaf-browser-send-esc-or-exit-fullscreen")
        ("M-," . "eaf-send-down-key")
        ("M-." . "eaf-send-up-key")
        ("M-m" . "eaf-send-return-key")
        ("<f5>" . "refresh_page")
        ("<f12>" . "open_devtools")
        ("<C-return>" . "eaf-send-ctrl-return-sequence")
        ))

(use-package! eaf
  :when IS-LINUX
  :commands (eaf-open-browser eaf-open find-file)
  :init
  (map! :leader
        :desc "eaf open history" "eh" 'eaf-open-browser-with-history
        :desc "eaf open terminal" "et" 'eaf-open-terminal
        :desc "eaf open rss" "er" 'eaf-open-rss-reader)

  :config
  (use-package! ctable)
  (use-package! deferred)
  (use-package! epc)
  ;; (setq eaf-proxy-type "socks5"
  ;;       eaf-proxy-host "127.0.0.1"
  ;;       eaf-proxy-port "1080")
  (eaf-setq eaf-browser-chrome-history-file "~/.config/chromium/Default/History")
  (eaf-bind-key insert_or_copy_text "y" eaf-browser-keybinding)
  (eaf-bind-key copy_text "y" eaf-browser-caret-mode-keybinding)
  (map! (:when t :map eaf-pdf-outline-mode-map
         :n "RET" 'eaf-pdf-outline-jump
         :n "q" '+popup/close))

  (define-key key-translation-map (kbd "SPC")
    (lambda (prompt)
      (if (derived-mode-p 'eaf-mode)
          (pcase eaf--buffer-app-name
            ("browser" (if (string= (eaf-call-sync "call_function" eaf--buffer-id "is_focus") "True")
                           (kbd "SPC")
                         (kbd eaf-evil-leader-key)))
            ("pdf-viewer" (kbd eaf-evil-leader-key))
            ("image-viewer" (kbd eaf-evil-leader-key))
            (_  (kbd "SPC")))
        (kbd "SPC"))))


  (defun buffer-mode-p (buffer mode)
    (eq (buffer-local-value 'major-mode buffer) mode))

  ;; 让 eaf buffer 支持 doom 的 leader b b 按键
  (advice-add '+ivy--is-workspace-other-buffer-p :around #'advicer-is-workspace-ther-buffer-p)
  (defun advicer-is-workspace-ther-buffer-p (orig-fn  &rest args)
    (let ((buffer (cdar args)))
      (if (derived-mode-p 'eaf-mode)
          (and (buffer-mode-p buffer 'eaf-mode)
               (not (eq buffer (current-buffer))))
        (apply orig-fn args))))

  (defun eaf--browser-display (buf)
    (let* ((split-direction 'right)
           (browser-window (or (get-window-with-predicate
                                (lambda (window)
                                  (with-current-buffer (window-buffer window)
                                    (string= eaf--buffer-app-name "browser"))))
                               (split-window-no-error nil nil split-direction))))
      (set-window-buffer browser-window buf)))

  ;; (add-to-list 'eaf-app-display-function-alist '("browser" . eaf--browser-display))



  (defun adviser-elfeed-show-entry (orig-fn entry &rest args)
    (if (featurep 'elfeed)
        (eaf-open-browser (elfeed-entry-link entry))
      (apply orig-fn entry args)))
  ;; (advice-add #'elfeed-show-entry :around #'adviser-elfeed-show-entry)

  ;;ivy 添加 action, 用 eaf-open 打开
  ;; (after! counsel
  ;;   (ivy-set-actions
  ;;    't
  ;;    (append '(("e" eaf-open))
  ;;            (plist-get ivy--actions-list 't))))


  (require 'eaf-evil)

  )

(use-package! fuz)
(use-package! snails
  :commands (snails snails-search-point)
  :init
  (map! "s-y" #'snails-search-point
        "s-a" #'snails)
  :config
  (setq snails-show-with-frame t)
  ;; (add-hook 'snails-mode-hook #'centaur-tabs-local-mode)
  (add-to-list 'evil-emacs-state-modes 'snails-mode))
