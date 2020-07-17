;; -*- no-byte-compile: t; -*-
;;; private/translate/packages.el

(package! google-translate
  :recipe (:host github :repo "loyalpartner/google-translate"))

(package! insert-translated-name
  :recipe (:host github :repo "manateelazycat/insert-translated-name"))

(package! sdcv
  :recipe (:host github :repo "loyalpartner/sdcv"))

(package! company-english-helper
  :recipe (:host github :repo "manateelazycat/company-english-helper"))

(package! baidu-translator
  :recipe (:host github :repo "loyalpartner/baidu-translator.el" :no-byte-compile t))

(package! english-teacher
  :recipe (:host github :repo "loyalpartner/english-teacher.el" :files ("*.el") :no-byte-compile t))
