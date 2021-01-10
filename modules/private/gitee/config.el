;;; private/gitee/config.el -*- lexical-binding: t; -*-
(defun gitee--list-enterprise ()
  "return alist"
  (let ((enterprises (gitee-get "/user/enterprises" nil
                                :query '((page . 1)
                                         (per_page . 100)
                                         (admin . "false")))))
    (mapcar '(lambda (repo) (let-alist repo (cons .name .path))) enterprises)))

(defun gitee--list-enterprise-repos (org)
  (let ((repos (gitee-get (format "/enterprises/%s/repos" org) nil
                          :query '((type . "all")
                                   (page . 1)
                                   (per_page . 100)))))

    (mapcar '(lambda (repo) (let-alist repo (cons .human_name .full_name))) repos)
    ))

(defun gitee-list-enterprise-repos (enterprise-name)
  (interactive (list (or 'linakesi (let ((enterprise (gitee--list-enterprise)))
                                     (alist-get (completing-read "选择一个企业:" enterprise) enterprise nil nil 'string=)))))
  (let* ((repos-alist (gitee--list-enterprise-repos enterprise-name))
         (repo (completing-read "选择一个仓库:" repos-alist))
         (repo-name (alist-get repo repos-alist nil nil 'string=)))

    (browse-url (format "https://gitee.com/%s" repo-name))))
