;;; private/translate/config.el -*- lexical-binding: t; -*-

(use-package! google-translate
  :commands google-translate-at-point google-translate-translate google-translate-request
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

(defun translate-chinese-word-p (word)
    (if (and word (string-match "\\cc" word)) t nil))

(defconst baidu-translate-api-host "https://api.fanyi.baidu.com/api/trans/vip/translate")

(defcustom baidu-translate-appid "20200607000488675"
  ""
  :type 'string)

(defcustom baidu-translate-secret-key "Nb_cT61hFraVEUpkvp33"
  ""
  :type 'string)


(defun baidu-translator-translate (from to text)
  (require 'request)
  (setq text (replace-regexp-in-string "\n\s*" " " text))
  (setq text (replace-regexp-in-string "\\.\s" ".\n" text))
  (setq text (replace-regexp-in-string ";" ";\n" text))
  (let ((salt (number-to-string (random))))
    (request baidu-translate-api-host
      :type "POST"
      :data (format "q=%s&salt=%s&appid=%s&sign=%s&from=%s&to=%s"
                    (url-encode-url text)
                    salt
                    baidu-translate-appid
                    (md5 (concat baidu-translate-appid text  salt baidu-translate-secret-key) nil nil (coding-system-from-name "utf-8"))
                    from to)
      :parser 'json-read
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  ;; (message "I sent: %S" (assoc-default 'trans_result data))
                  (when data
                    (with-current-buffer (get-buffer-create "*baidu translator*")
                      (setq buffer-read-only nil)
                      (erase-buffer)
                      (seq-each (lambda (t)
                                  (insert (concat (assoc-default 'src t) "\n"
                                                  (assoc-default 'dst t) "\n")))
                                (assoc-default 'trans_result data))
                      (setq buffer-read-only t)
                      (goto-char (point-min))
                      (pop-to-buffer (current-buffer)))))))))

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
(evil-define-operator evilnc-baidu-translate-operator (beg end type)
  "中英文互相翻译."
  (interactive "<R>")
  (let* ((text (buffer-substring-no-properties beg end))
         (word (thing-at-point 'word))
         (source (if (translate-chinese-word-p word) "zh" "en"))
         (target (if (translate-chinese-word-p word) "en" "zh")))
    (baidu-translator-translate source target text)))

;;;autoload
(evil-define-operator evilnc-translate-and-replace-operator (beg end type)
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
(evil-define-operator evilnc-sdcv-translate-operator (beg end type)
  "SDCV 查询短语"
  (message "%d %d" beg end)
  (let* ((text (buffer-substring-no-properties beg end)))
    (sdcv-search-pointer (format "\"%s\"" text))))

;;;autoload
(evil-define-operator evilnc-sdcv-add-link-operator (beg end type)
  "SDCV 添加链接"
  (interactive "<R>")
  (let ((text (buffer-substring-no-properties beg end)))
    (when (not (equal text ""))
      (progn
        (kill-region beg end)
        (insert (format "[[sdcv:%s][%s]]" text text))))))

;;;autoload
;;;https://emacs.stackexchange.com/questions/21626/how-to-apply-call-interactively-to-an-interactive-command-that-accepts-the-uni
(defun translate-sdcv-at-point(args)
  (interactive "P")
  (cond ((or (region-active-p) args) (execute-extended-command 'nil "evilnc-sdcv-translate-operator") )
        ;; ((region-active-p) (sdcv-search-detail (format "\"%s\"" (sdcv-region-or-word))))
        (t (sdcv-search-pointer+))))

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
      :leader
      :desc "添加单词到 word.org" "yc" #'translate-save-word
      :desc "添加单词链接" "yC" #'evilnc-sdcv-add-link-operator
      :desc "Google 翻译长句" "yy" #'evilnc-baidu-translate-operator
      :desc "中文英文互相转换" "yr" #'evilnc-translate-and-replace-operator
      :desc "SDCV 翻译短语" "yd" #'evilnc-sdcv-translate-operator)
