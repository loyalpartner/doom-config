;;; private/rss/config.el -*- lexical-binding: t; -*-

(map! (:when (featurep! :app rss)
        :map elfeed-search-mode-map
        :n "gu" #'elfeed-update
        :n "c" #'elfeed-search-clear-filter)
      :leader "on" '=rss)
