;;; private/chinese/config.el -*- lexical-binding: t; -*-
(use-package! pyim-basedict
  :after pyim
  :when (featurep! :input chinese)
  :config
  (setq default-input-method "pyim"
        pyim-default-scheme 'xiaohe-shuangpin
        pyim-page-tooltip 'posframe
        pyim-page-length 5)
  (setq-default pyim-english-input-switch-functions (private/pyim-english-prober))
  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))
  (pyim-isearch-mode 1)
  (pyim-basedict-enable))

(use-package! emacs-request :commands request)

(defun private/pyim-english-prober ()
  (cond ((and (boundp 'insert-translated-name-active-overlay)
              insert-translated-name-active-overlay)
         nil)
        (t '(pyim-probe-dynamic-english
             pyim-probe-isearch-mode
             pyim-probe-program-mode
             pyim-probe-org-structure-template))))

;; https://support.google.com/websearch/forum/AAAAgtjJeM4P4qBTZlImoA/?hl=en&gpf=%23!topic%2Fwebsearch%2FP4qBTZlImoA
;; 替换默认的 google engine 建议，使其在国内也能用
(setq counsel-search-engines-alist
  '((google
     "https://suggestqueries.google.cn/complete/search?oe=utf-8"
     "https://www.google.com/search?q="
     counsel--search-request-data-google)
    (ddg
     "https://duckduckgo.com/ac/"
     "https://duckduckgo.com/html/?q="
     counsel--search-request-data-ddg)
    (zhihu
     "https://www.zhihu.com/api/v4/search/suggest"
     "https://www.zhihu.com/search?type=content&q="
     counsel--search-request-data-zhihu)))

(mapc (lambda (engine) (add-to-list '+lookup-provider-url-alist engine))
      '(("Baidu" "http://www.baidu.com?wd=%s")
        ("Emacs China" "https://emacs-china.org/search?q=%s")
        ("zhihu" +lookup--online-backend-zhihu "https://www.zhihu.com/search?type=content&q=%s")))

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

(map! :after pyim
      :g "M-c" #'pyim-convert-code-at-point)
