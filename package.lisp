;;;; package.lisp

(defpackage #:weblocks-social-registration-widget
  (:use #:cl #:weblocks)
  (:export #:social-registration-widget #:start #:finish #:*social-auth-settings* #:get-social-auth-user-id #:*debug-mode*))

