;;; private/eaf/package.el -*- lexical-binding: t; -*-



(when (package! eaf :recipe (:host github
                             :repo "emacs-eaf/emacs-application-framework"
                             :files ("*.el" "*" "extension" "core" "app")
                             :build (:not compile)))

  (package! ctable :recipe (:host github :repo "kiwanami/emacs-ctable"))
  (package! deferred :recipe (:host github :repo "kiwanami/emacs-deferred"))
  (package! epc :recipe (:host github :repo "kiwanami/emacs-epc")))

(package! fuz)
(package! snails :recipe (:host github :repo "manateelazycat/snails" :build (:not compile)))
