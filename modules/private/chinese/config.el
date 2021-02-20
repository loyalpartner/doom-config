;;; private/chinese/config.el -*- lexical-binding: t; -*-
(when (featurep! +pyim)
  (defun private/pyim-english-prober ()
    (cond ((and (boundp 'insert-translated-name-active-overlay)
                insert-translated-name-active-overlay)
           nil)
          ((eq major-mode 'eaf-mode) nil)
          (t '(
               pyim-probe-dynamic-english
               pyim-probe-isearch-mode
               ;; pyim-probe-program-mode
               pyim-probe-org-structure-template))))

  ;; (use-package! pyim)
  ;; 
  (use-package! pyim-basedict
    :after pyim
    :config
    (setq default-input-method "pyim"
          ;; pyim-default-scheme 'xiaohe-shuangpin
          pyim-page-tooltip 'posframe
          pyim-page-length 5)
    (setq-default pyim-english-input-switch-functions (private/pyim-english-prober))
    (setq-default pyim-punctuation-half-width-functions
                  '(pyim-probe-punctuation-line-beginning
                    pyim-probe-punctuation-after-punctuation))

    (map! "M-c" #'pyim-convert-code-at-point)
    ;; 使用 isearch-mode 的时候，
    ;; 如果 major-mode 是 `pdf-view-mode' 关闭 pyim-isearch-mode
    (add-hook 'isearch-mode-hook
              (lambda ()
                (when (and (boundp 'pdf-isearch-minor-mode)
                           (boundp 'pyim-isearch-mode))
                  (if (equal major-mode 'pdf-view-mode)
                      (pyim-isearch-mode -1)
                    (pyim-isearch-mode 1)))))
    (pyim-basedict-enable)))


(when (featurep! +rime)
  (use-package! rime
    :init
    (map! "M-c" #'toggle-input-method)
    :bind (:map rime-mode-map ("C-`" . 'rime-send-keybinding))
    :config
    (setq rime-show-candidate 'posframe)
    (setq default-input-method "rime")
    (setq rime-disable-predicates
          '(rime-predicate-evil-mode-p
            rime-predicate-after-alphabet-char-p
            rime-predicate-prog-in-code-p)))
  
  (define-key rime-active-mode-map (kbd "M-c") 'rime-inline-ascii)
  (define-key rime-mode-map (kbd "M-c") 'rime-force-enable))


;; https://support.google.com/websearch/forum/AAAAgtjJeM4P4qBTZlImoA/?hl=en&gpf=%23!topic%2Fwebsearch%2FP4qBTZlImoA
;; 替换默认的 google engine 建议，使其在国内也能用
(after! ivy
  (use-package! ace-pinyin
    :init (setq ace-pinyin-use-avy t)
    :config (ace-pinyin-global-mode t))

  (setf (alist-get 'zhihu counsel-search-engines-alist)
        '("https://www.zhihu.com/api/v4/search/suggest"
          "https://www.zhihu.com/search?type=content&q="
          counsel--search-request-data-zhihu))
  (setf (alist-get 'google counsel-search-engines-alist)
        '("https://suggestqueries.google.cn/complete/search?oe=utf-8&output=firefox"
          "https://www.google.com/search?q="
          counsel--search-request-data-google))
  
  (defun counsel--search-request-data-google (data)
    (mapcar #'identity (aref data 1)))

  (mapc (lambda (engine) (add-to-list '+lookup-provider-url-alist engine))
        '(("Baidu" "http://www.baidu.com?wd=%s")
          ("Emacs China" "https://emacs-china.org/search?q=%s")
          ("Arch Linux cn" "https://emacs-china.org/search?q=%s")
          ("zhihu" lookup-backend-zhihu "https://www.zhihu.com/search?type=content&q=%s")))

  (defun re-builder-extended-pattern (str)
    (require 'pinyinlib)
    (ivy--regex-plus
     (cond ((<= (length str) 0) str)
           ((string-prefix-p ";" str)
            (pinyinlib-build-regexp-string (substring str 1) t))
           (t str))))
  
  (setq ivy-re-builders-alist '((t . re-builder-extended-pattern)))

  (defun counsel--search-request-data-zhihu (data)
    (mapcar (apply-partially 'alist-get 'query)
            (alist-get 'suggest data)))

;;;###autoload
  (defun lookup-backend-zhihu (query)
    (cond ((fboundp 'counsel-search)
           (let ((ivy-initial-inputs-alist `((t . ,query)))
                 (counsel-search-engine 'zhihu))
             (call-interactively #'counsel-search)
             t)))))

(use-package sis
  ;; :hook
  ;; enable the /follow context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :config
  (sis-ism-lazyman-config "1" "2" 'fcitx5)
  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )


(setq ispell-extra-args '("--lang=en_US"))
