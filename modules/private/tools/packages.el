;; -*- no-byte-compile: t; -*-
;;; private/tools/packages.el

(package! evil-matchit :recipe (:host github :repo "redguardtoo/evil-matchit"))

(package! auto-save :recipe (:host github :repo "loyalpartner/auto-save"))

(package! mybigword
  :recipe (:host github :repo "loyalpartner/mybigword"
           :files ("*.el" "*.py" "*.zipf")
           :build (:not compile)))

(package! keyfreq :recipe (:host github :repo "dacap/keyfreq"))

(package! baidu-ocr :recipe (:host github :repo "loyalpartner/baidu-ocr" :build (:not compile)))

(package! mingus)

(package! rfc-mode)

(package! mermaid-mode)
(package! ob-mermaid)
;; (package! valign :recipe (:host github :repo "casouri/valign"))
