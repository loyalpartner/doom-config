;; -*- no-byte-compile: t; -*-
;;; private/translate/packages.el

(package! insert-translated-name
  :recipe (:host github :repo "manateelazycat/insert-translated-name"))

(package! sdcv
  :recipe (:host github :repo "loyalpartner/sdcv"))

(package! company-english-helper
  :recipe (:host github :repo "manateelazycat/company-english-helper"))

(package! english-teacher
  :recipe (:host github :repo "loyalpartner/english-teacher.el" :files ("*.el")))
