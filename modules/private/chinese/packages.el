;; -*- no-byte-compile: t; -*-
;;; private/chinese/packages.el

(when (featurep! +pyim)
  (package! pyim)
  (package! pyim-basedict))

(package! emacs-request
  :recipe (:host github :repo "tkf/emacs-request"))

(when (featurep! +rime)
  (package! emacs-rime
    :recipe (:host github :repo "DogLooksGood/emacs-rime"
             :files ("*.el" "Makefile" "lib.c"))))
