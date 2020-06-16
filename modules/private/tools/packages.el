;; -*- no-byte-compile: t; -*-
;;; private/tools/packages.el

(package! posframe)

;; (package! atomic-chrome)

(package! auto-save :recipe (:host github :repo "loyalpartner/auto-save"))

(package! mybigword
  :recipe (:host github :repo "redguardtoo/mybigword"
           :files ("*.el" "*.py" "*.zipf")))

(package! keyfreq :recipe (:host github :repo "dacap/keyfreq"))
