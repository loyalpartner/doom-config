;;; private/web-search/config.el -*- lexical-binding: t; -*-


(use-package! web-search :commands web-search)

(after! web-search
  (push '("Emacs China" "https://emacs-china.org/search?q=%s") web-search-providers))

(map! :leader
      "so" #'web-search)
