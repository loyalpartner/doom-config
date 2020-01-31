;;; private/translate/config.el -*- lexical-binding: t; -*-

(use-package! google-translate
  :commands google-translate-at-point google-translate-translate
  :init
  (setq google-translate-default-source-language "en"
        google-translate-default-target-language "zh-CN"
        google-translate--tkk-url "http://translate.google.cn"
        google-translate-base-url "http://translate.google.cn/translate_a/single"
        google-translate-listen-url "http://translate.google.cn/translate_tts"))
(use-package! insert-translated-name :commands insert-translated-name-insert)

(use-package! company-english-helper :commands toggle-company-english-helper company-english-helper-search)

;; sdcv翻译当前单词
(use-package! sdcv
  :commands sdcv-search-pointer+ sdcv-search-pointer
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
  (setq sdcv-dictionary-complete-list   ;setup dictionary list for complete search
        '("懒虫简明英汉词典"
          "懒虫简明汉英词典"
          "朗道英汉字典5.0"
          "朗道汉英字典5.0"
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

(defun translate-chinese-word-p (word)
    (if (and word (string-match "\\cc" word)) t nil))

(evil-define-operator evilnc-translate-operator (beg end type)
  "中英文互相翻译."
  (interactive "<R>")
  (let* ((text (buffer-substring-no-properties beg end))
         (source (if (translate-chinese-word-p text) "zh-CN" "en"))
         (target (if (translate-chinese-word-p text) "en" "zh-CN")))
    (google-translate-translate source target text)))

(evil-define-operator evilnc-search-and-replace-operator (beg end type)
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

(map! :g "C-c ." #'insert-translated-name-insert
      :i "C-x C-y" #'company-english-helper-search
      :n  "g." #'sdcv-search-pointer+
      :leader :desc "Google 翻译长句" "yy" #'evilnc-translate-operator
      :leader :desc "中文英文互相转换" "yr" #'evilnc-search-and-replace-operator
      :leader :desc "SDCV 单词翻译" "yd" #'sdcv-search-pointer+)
