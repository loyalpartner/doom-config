;; -*- no-byte-compile: t; -*-
;;; private/tools/packages.el

(package! posframe)

;; (package! atomic-chrome)

(package! auto-save :recipe (:host github :repo "loyalpartner/auto-save"))

(package! mybigword
  :recipe (:host github :repo "loyalpartner/mybigword"
           :files ("*.el" "*.py" "*.zipf")
           :no-byte-compile t))

(package! keyfreq :recipe (:host github :repo "dacap/keyfreq"))

(package! baidu-ocr :recipe (:host github :repo "loyalpartner/baidu-ocr" :no-byte-compile t))

;; (package! valign :recipe (:host github :repo "casouri/valign"))
