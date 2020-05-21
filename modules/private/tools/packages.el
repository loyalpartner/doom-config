;; -*- no-byte-compile: t; -*-
;;; private/tools/packages.el

(package! posframe)

(package! atomic-chrome)

(package! grip-mode)

(package! auto-save :recipe (:host github :repo "loyalpartner/auto-save"))

(package! awesome-tab :recipe (:host github :repo "manateelazycat/awesome-tab" :no-byte-compile t))

(package! awesome-tab :recipe (:host github :repo "manateelazycat/awesome-tray"))

(package! mybigword
  :recipe (:host github :repo "redguardtoo/mybigword"
           :files ("*.el" "*.py" "*.zipf")))
