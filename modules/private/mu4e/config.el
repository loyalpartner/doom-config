;; https://pengpengxp.github.io/archive/before-2018-11-10/2017-08-24-emacs-use-mu4e.html
(setenv "XAPIAN_CJK_NGRAM" "1")

(when IS-MAC
    (add-to-list 'load-path
                 "/usr/local/Cellar/mu/1.2.0_1/share/emacs/site-lisp/mu/mu4e"))

(setq +mu4e-backend 'offlineimap)

(after! mu4e
  (remove-hook! 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode))

(setq smtpmail-smtp-server "smtp.163.com"
      smtpmail-default-smtp-server  "smtp.163.com"
      smtpmail-smtp-service  25)

(set-email-account! "163"
                    '((mu4e-sent-folder       . "/163/Sent Mail")
                      (mu4e-drafts-folder     . "/163/Drafts")
                      (mu4e-trash-folder      . "/163/Trash")
                      (mu4e-refile-folder     . "/163/All Mail")
                      (smtpmail-smtp-user     . "loyalpartner@163.com")
                      (user-mail-address      . "loyalpartner@163.com")
                      (smtpmail-smtp-server   . "smtp.163.com")
                      (mu4e-compose-signature . "---\nlee"))
                    t)


(set-email-account! "qq"
                    '((mu4e-sent-folder       . "/qq/Sent Mail")
                      (mu4e-drafts-folder     . "/qq/Drafts")
                      (mu4e-trash-folder      . "/qq/Trash")
                      (mu4e-refile-folder     . "/qq/All Mail")
                      (smtpmail-smtp-user     . "986374081@qq.com")
                      (user-mail-address      . "986374081@qq.com")
                      (smtpmail-smtp-server   . "smtp.qq.com")
                      ;; (smtpmail-stream-type . 'starttls)
                      (mu4e-compose-signature . "---\n凯"))
                    t)
