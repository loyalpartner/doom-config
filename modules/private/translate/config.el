;;; private/translate/config.el -*- lexical-binding: t; -*-

(use-package! google-translate
  :commands (google-translate-at-point google-translate-translate)
  :init
  (setq google-translate-default-source-language "en"
        google-translate-default-target-language "zh-CN"
        google-translate--tkk-url "http://translate.google.cn"
        google-translate-base-url "http://translate.google.cn/translate_a/single"
        google-translate-listen-url "http://translate.google.cn/translate_tts"))
(use-package! insert-translated-name :commands (insert-translated-name-insert))

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
      :leader :desc "翻译" "yy" #'evilnc-translate-operator
      :leader :desc "中文英文互相转换" "yr" #'evilnc-search-and-replace-operator)
