;;; private/gitee/config.el -*- lexical-binding: t; -*-
;; (require 'gitee)

(defface gitee-mode-face
  '((t :inherit font-lock-preprocessor-face))
  "Face used to highlight gitee string.")

(cl-defstruct (gitee-enterprise (:constructor gitee-enterprise-create))
  company-name
  owner
  name
  open-issues-count
  url)

(defvar gitee--enterprise-list-cache (make-hash-table :test 'equal))

;; (run-with-idle-timer 3 nil #'gitee-pull-enterprise-repos 'linakesi)

(defun gitee-pull-enterprise-repos (name)
  (interactive (list 'linakesi))
  (let ((response (gitee-get
                   (format "/enterprises/%s/repos" name) nil
                   :query '((page . 1)
                            (per_page . 100)
                            (admin . "false")))))
    (puthash name
             (mapcar #'(lambda (repo)
                         (let-alist repo
                           (gitee-enterprise-create
                            :company-name .namespace.name
                            :owner .owner.name
                            :name .name
                            :open-issues-count .open_issues_count
                            :url .html_url))) response)
             gitee--enterprise-list-cache)))

(defun gitee-pad-string (string width)
  (truncate-string-to-width string width 0 ?\s))

(defun gitee--highlight-string (string face)
  (put-text-property 0 (length string) 'face face string)
  string)

(defun gitee-enterprise-format-candidate (entry)
  (let* ((company-name (gitee-pad-string (gitee-enterprise-company-name entry) 40))
         (owner (gitee-pad-string (gitee-enterprise-owner entry) 40))
         (open-issues-count (gitee-enterprise-open-issues-count entry))
         (name (gitee-pad-string (format "%s [%d]"
                                         (gitee-enterprise-name entry)
                                         open-issues-count) 60)))
    (cons (format "%s %s %s"
                  (gitee--highlight-string company-name 'gitee-font-face)
                  owner name open-issues-count)
          entry)))


(defun gitee-list-enterprise-repos (enterprise-name)
  (interactive (list 'linakesi))
  ;; (gitee-pull-enterprise-repos enterprise-name)
  (let* ((enterprise-alist
          (mapcar #'gitee-enterprise-format-candidate
                  (gethash enterprise-name gitee--enterprise-list-cache)))
         (choice (completing-read
                  "Select repo: "
                  enterprise-alist)))

    (browse-url (gitee-enterprise-url (alist-get choice enterprise-alist nil nil 'string=)))))
