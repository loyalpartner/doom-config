;;; private/translate/config.el -*- lexical-binding: t; -*-

(use-package! insert-translated-name :commands insert-translated-name-insert)

(use-package! company-english-helper :commands toggle-company-english-helper company-english-helper-search)

;; sdcv翻译当前单词
(use-package! sdcv
  :commands
  sdcv-search-pointer+ sdcv-search-pointer sdcv-search-input sdcv-search-input+ sdcv-translate-result
  sdcv-pick-word
  :config
  (setq sdcv-dictionary-data-dir (expand-file-name "~/.stardict/dic")
        sdcv-say-word-p t
        sdcv-tooltip-timeout 20)
  (setq sdcv-dictionary-simple-list     ;setup dictionary list for simple search
        '("懒虫简明英汉词典"
          "懒虫简明汉英词典"
          "朗道英汉字典5.0"
          "朗道汉英字典5.0"
          "新华字典"))
  (setq sdcv-dictionary-complete-list ;setup dictionary list for complete search
        '("懒虫简明英汉词典"
          "懒虫简明汉英词典"
          "朗道英汉字典5.0"
          "朗道汉英字典5.0"
          "牛津英汉双解美化版"
          "新华字典"
          ;; "KDic11万英汉词典"
          ;; "XDICT英汉辞典"
          ;; "XDICT汉英辞典"
          ;; "21世纪英汉汉英双向词典"
          ;; "21世纪双语科技词典"
          ;; "牛津英汉双解美化版"
          ;; "英汉汉英专业词典"
          ;; "新世纪英汉科技大词典"
          ;; "新世纪汉英科技大词典"
          ;; "现代汉语词典"
          ;; "高级汉语大词典"
          )))


(add-hook 'english-teacher-follow-mode-hook
            (lambda ()
              (setq-local url-gateway-method 'native
                          socks-server '("Default server" "socks" 1080 5))))

(use-package! english-teacher
  :commands (english-teacher-smart-translate)
  :hook ((Info-mode
          elfeed-show-mode
          eww-mode
          Man-mode
          Woman-Mode) . english-teacher-follow-mode)
  :config
  (setq english-teacher-show-result-function 'english-teacher-eldoc-show-result-function
        english-teacher-backend 'tencent))

(defun translate-chinese-word-p (word)
  (if (and word (string-match "\\cc" word)) t nil))

;;;autoload
(evil-define-operator evilnc-translate-operator (beg end type)
  "中英文互相翻译."
  (interactive "<R>")
  (let* ((text (buffer-substring-no-properties beg end))
         (word (thing-at-point 'word))
         (source (if (translate-chinese-word-p word) "zh-CN" "en"))
         (target (if (translate-chinese-word-p word) "en" "zh-CN")))
    (google-translate-translate source target text)))

;;;autoload
(evil-define-operator evil-translate-and-replace-operator (beg end type)
  "查询并替换."
  (interactive "<R>")
  (let* ((text (buffer-substring-no-properties beg end))
         (source (if (translate-chinese-word-p text) "zh-CN" "en"))
         (target (if (translate-chinese-word-p text) "en" "zh-CN"))
         (json (google-translate-request source target text))
         (result (google-translate-json-translation json)))
    (when result
      (kill-region beg end)
      (insert result))))

;;;autoload
(evil-define-operator evil-sdcv-translate-operator (beg end type)
  "SDCV 查询短语"
  (message "%d %d" beg end)
  (let* ((text (buffer-substring-no-properties beg end)))
    (sdcv-search-pointer (format "\"%s\"" text))))

;;;autoload
(evil-define-operator evil-sdcv-add-link-operator (beg end type)
  "SDCV 添加链接"
  (interactive "<R>")
  (let ((text (buffer-substring-no-properties beg end)))
    (when (not (equal text ""))
      (progn
        (kill-region beg end)
        (insert (format "[[sdcv:%s][%s]]" text text))))))

;;; 定义 sdcv:key 链接，方便查询
(after! org
  (org-link-set-parameters "sdcv"
                           :follow #'org-link--sdcv-query
                           :export #'org-link--words-export)

  (add-to-list 'org-capture-templates
               '("w" "save word" plain
                 (file "~/org/word.org")
                 "[[sdcv:%c][%c]]"))

  (defun translate-save-word ()
    (interactive)
    (let ((text (if mark-active
                    (buffer-substring-no-properties (region-beginning)
                                                    (region-end))
                  (thing-at-point 'word))))
      (kill-new (sdcv-pick-word text))
      (org-capture 'nil "w")
      (yank-pop)))

  (defun org-link--sdcv-query (word)
    (sdcv-search-input+ (format "\"%s\"" word)))
  
  (defun org-link--words-export (path desc format)
    (let* ((result (sdcv-translate-result
                    (format "%s" desc) sdcv-dictionary-simple-list)))
      (format "<div>%s<div>%s</div><br></div>" desc
              (s-replace "-->" "<br>" result)))))

;; (s-replace "abc" "" "abcd")
(map! :g "C-c ." #'insert-translated-name-insert
      :i "C-x C-y" #'company-english-helper-search
      :nv  "g." #'sdcv-search-pointer+
      :map english-teacher-follow-mode-map :n "." 'english-teacher-next-backend
      :map baidu-translator-map :n "q" 'baidu-translator-quit
      :map Info-mode-map
      :leader
      :desc "添加单词到 word.org" "yc" #'translate-save-word
      :desc "添加单词链接" "yC" #'evil-sdcv-add-link-operator
      :desc "翻译长句" "yy" #'english-teacher-smart-translate
      :desc "翻译长句" "yY" #'evil-baidu-translator-translate-operator
      :desc "中文英文互相转换" "yr" #'evil-translate-and-replace-operator
      :desc "SDCV 翻译短语" "yd" #'evil-sdcv-translate-operator
      )

;; (evil-define-key '(normal visual) Info-mode-map "gs" #'evil-baidu-translate-operator)
