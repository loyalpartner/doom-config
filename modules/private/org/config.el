;;; private/org/config.el -*- lexical-binding: t; -*-

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)
     (protobuf . t)))

  (setq org-plantuml-jar-path
        (expand-file-name
         (concat doom-private-dir "bin/plantuml.jar")))

  (let ((templates
         '(("l" "links" item (file+olp "~/org/inbox.org" "Links" ) "- %:annotation \n\n")
           ("R" "RSS" entry (file+olp "~/org/elfeed.org" "Links" "blogs" ) "** %x\n\n" :immediate-finish t))))
    (dolist (template templates)
      (unless (member template org-capture-templates)
        (add-to-list 'org-capture-templates template))))

  (setq org-clock-idle-time 15
        calendar-day-abbrev-array ["周日" "周一" "周二" "周三" "周四" "周五" "周六"]
        calendar-day-name-array ["周日" "周一" "周二" "周三" "周四" "周五" "周六"]
        calendar-month-name-array ["一月" "二月" "三月" "四月" "五月" "六月" "七月" "八月" "九月" "十月" "十一月" "十二月"]
        org-agenda-deadline-leaders (quote ("截止日期:  " "%3d 天后到期: " "%2d 天前: "))
        org-agenda-scheduled-leaders '("预 " "应%02d天前开始 ")
        calendar-week-start-day 1)
  (setq org-time-stamp-custom-formats '("<%y/%m/%y %d>" . "<%y/%m/%d %a %H:%M>"))


  (setq elfeed-db-directory "~/org/elfeeddb")

  (mapc (lambda (mode)
          (add-to-list 'org-modules mode))
        '(ol-info ol-irc)))
