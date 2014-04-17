;;;; weblocks-social-registration-widget.lisp

(in-package #:weblocks-social-registration-widget)

(defvar *social-widget* nil)
(defvar *debug-mode* nil 
  "When true, does not ignore errors during registration")

(defmacro with-social-widget (widget &body body)
  `(locally 
     (declare (special *social-widget*))
     (let ((*social-widget* ,widget))
       ,@body)))

(defwidget social-registration-widget ()
  ((site-url-template :initform nil :initarg :site-url-template)
   (start :initform nil :accessor social-registration-widget-start)
   (finish :initform nil :accessor social-registration-widget-finish)
   (on-registration-success :initform nil :initarg :on-success)
   (on-registration-fail :initform nil :initarg :on-fail)
   (on-registration-cancel :initform nil :initarg :on-cancel)))

(defmethod social-registration-widget-uri-key ((widget social-registration-widget) param)
  (weblocks-util:concatenate-keywords (weblocks::widget-uri-id widget) :.  param))

(defmethod render-widget-body ((obj social-registration-widget) &rest args)
  (with-slots (start finish on-registration-success on-registration-fail on-registration-cancel) obj
    (when start 
      (redirect 
        (with-social-widget obj 
          (get-redirect-url-for-social-auth (alexandria:make-keyword (string-upcase start)))))
      (setf start nil))

    (when finish 
      (unwind-protect 
        (let* ((network (alexandria:make-keyword (string-upcase finish)))
               (token))

          (if (social-auth-canceled-p network)
            (weblocks-util:safe-funcall on-registration-cancel network))

          (setf token (eval `(,(if *debug-mode* 'identity 'ignore-errors) ,(with-social-widget obj (get-social-auth-token network)))))

          (cond 
            (token (weblocks-util:safe-funcall on-registration-success network token))
            (t (weblocks-util:safe-funcall on-registration-fail network))))
        (setf finish nil)))))

(defun make-social-registration-widget (children &key on-success on-fail on-cancel)
  (make-instance 'social-registration-widget :children children 
                 :uri-id :social-registration 
                 :on-success on-success 
                 :on-fail on-fail 
                 :on-cancel on-cancel))

(defmethod get-redirect-url-for-social-auth ((social-network t))
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-code 
      (getf settings :url)
      (getf settings :client-id)
      :scope (getf settings :scope)
      :redirect-uri (getf settings :redirect-uri))))

(defmethod get-social-auth-token (social-network)
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-token 
      (getf settings :request-token-url)
      (weblocks::get-parameter "code")
      :redirect-uri (getf settings :redirect-uri)
      :method :post
      :other `(("client_id" .,(getf settings :client-id))
               ("client_secret" . ,(getf settings :client-secret))))))

(defmethod get-social-auth-settings (network)
  (let ((settings (getf *social-auth-settings* network)))
    (setf (getf settings :redirect-uri) 
          (format nil 
                  (slot-value *social-widget* 'site-url-template)
                  (url-for (social-registration-widget-uri-key *social-widget* :finish) (string-downcase network))))
    settings))
