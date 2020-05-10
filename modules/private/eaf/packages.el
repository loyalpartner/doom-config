;;; private/eaf/package.el -*- lexical-binding: t; -*-

(package! eaf :recipe (:host github
                       :repo "manateelazycat/emacs-application-framework"
                       :files ("*.el" "*.py" "app/**/*.el" "app/core/**/*")))
