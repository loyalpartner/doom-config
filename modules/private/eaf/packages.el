;;; private/eaf/package.el -*- lexical-binding: t; -*-

(package! eaf :recipe (:host github
                       :repo "loyalpartner/emacs-application-framework"
                       :files ("*.el" "*.py" "app" "core")
                       :no-byte-compile t))

(package! fuz)
(package! snails :recipe (:host github :repo "manateelazycat/snails" :no-byte-compile t))
