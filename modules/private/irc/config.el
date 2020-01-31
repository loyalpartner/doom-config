;;; private/irc/config.el -*- lexical-binding: t; -*-

(after! circe
  (set-irc-server! "irc.freenode.net"
                   `(:tls t
                          :port 6697
                          :nick "likaikai"
                          :sasl-username "likaikai"
                          :sasl-password "1234qaz"
                          :channels ("#emacs" "#archlinux-cn" "#vim")))
  (set-irc-server! "irc.gitter.im"
                   `(:tls t
                          :port 6697
                          :nick "loyalpartner"
                          :pass "b878503553ccb36ab8e61de3424643896e777626")))
