;; -*- no-byte-compile: t; -*-
;;; private/chinese/packages.el
(package! pyim)

(package! pyim-basedict)

(package! emacs-request
  :recipe (:host github :repo "tkf/emacs-request"))

(package! emacs-rime
  :recipe (:host github :repo "DogLooksGood/emacs-rime"
                 :files ("*.el" "Makefile" "lib.c")))
