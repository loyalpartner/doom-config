;;; private/chinese/config.el -*- lexical-binding: t; -*-
;; TODO: add pyim package
(when (featurep! +pyim)
  (defun private/pyim-english-prober ()
    (cond ((and (boundp 'insert-translated-name-active-overlay)
                insert-translated-name-active-overlay)
           nil)
          ((eq major-mode 'eaf-mode) nil)
          (t '(pyim-probe-dynamic-english
               pyim-probe-isearch-mode
               pyim-probe-program-mode
               pyim-probe-org-structure-template))))

  (use-package! pyim)
  (use-package! pyim-basedict
    :after pyim
    :config
    (setq default-input-method "pyim"
          pyim-default-scheme 'xiaohe-shuangpin
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

;; TODO: maybe delete it
(use-package! emacs-request
  :commands request)


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
            rime-predicate-prog-in-code-p
            rime-predicate-auto-english-p)))
  
  (define-key rime-active-mode-map (kbd "M-c") 'rime-inline-ascii)
  (define-key rime-mode-map (kbd "M-c") 'rime-force-enable))

;; https://support.google.com/websearch/forum/AAAAgtjJeM4P4qBTZlImoA/?hl=en&gpf=%23!topic%2Fwebsearch%2FP4qBTZlImoA
;; 替换默认的 google engine 建议，使其在国内也能用
(after! ivy
  (setcar (cdr (assoc 'google counsel-search-engines-alist)) "https://suggestqueries.google.cn/complete/search?oe=utf-8")
  (setcar (cdr (assoc 'ddg counsel-search-engines-alist)) "https://duckduckgo.com/ac/")
  (add-to-list 'counsel-search-engines-alist
               '(zhihu "https://www.zhihu.com/api/v4/search/suggest"
                       "https://www.zhihu.com/search?type=content&q="
                       counsel--search-request-data-zhihu))

  (mapc (lambda (engine) (add-to-list '+lookup-provider-url-alist engine))
        '(("Baidu" "http://www.baidu.com?wd=%s")
          ("Emacs China" "https://emacs-china.org/search?q=%s")
          ("Arch Linux cn" "https://emacs-china.org/search?q=%s")
          ("zhihu" +lookup--online-backend-zhihu "https://www.zhihu.com/search?type=content&q=%s"))))

(defun counsel--search-request-data-zhihu (data)
  (mapcar (lambda (elt)
            (alist-get 'query elt))
          (alist-get 'suggest data)))

;;;###autoload
(defun +lookup--online-backend-zhihu (query)
  "Search google, starting with QUERY, with live autocompletion."
  (cond ((fboundp 'counsel-search)
         (let ((ivy-initial-inputs-alist `((t . ,query)))
               (counsel-search-engine 'zhihu))
           (call-interactively #'counsel-search)
           t))))
