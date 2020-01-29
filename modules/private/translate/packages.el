;; -*- no-byte-compile: t; -*-
;;; private/translate/packages.el

(package! google-translate
  :recipe (:host github :repo "loyalpartner/google-translate"))

(package! insert-translated-name
  :recipe (:host github :repo "manateelazycat/insert-translated-name"))
