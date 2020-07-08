;; -*- no-byte-compile: t; -*-
;;; private/chinese/packages.el

(when (featurep! +pyim)
  (package! pyim)
  (package! pyim-basedict))

(package! ace-pinyin)

(when (featurep! +rime)
  (package! emacs-rime
    :recipe (:host github :repo "DogLooksGood/emacs-rime"
             :files ("*.el" "Makefile" "lib.c"))))
