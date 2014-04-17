;;;; weblocks-social-registration-widget.asd

(asdf:defsystem #:weblocks-social-registration-widget
  :serial t
  :description "Describe weblocks-social-registration-widget here"
  :author "Olexiy Zamkoviy <olexiy.z@gmail.com>"
  :version (:read-from-file "version.lisp-expr")
  :license "LLGPL"
  :depends-on (#:oauth2 #:cl-oauth #:weblocks)
  :components 
  ((:file "package")
   (:file "config" :depends-on ("package"))
   (:file "weblocks-social-registration-widget" :depends-on ("config"))
   (:module "networks"
    :depends-on ("package") 
    :components 
    ((:file "facebook")
     (:file "vkontakte")
     (:file "twitter")
     (:file "google")
     (:file "yandex")
     (:file "mailru")
     (:file "odnoklassniki")))))

