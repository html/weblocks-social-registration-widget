(in-package :weblocks-social-registration-widget)

(defmethod get-redirect-url-for-social-auth ((social-network (eql :vkontakte)))
  (let ((settings (get-social-auth-settings social-network)))
    (format nil "~A?client_id=~A&redirect_uri=~A&response_type=code&scope=~A" 
            (getf settings :url)
            (getf settings :client-id)
            (hunchentoot:url-encode (getf settings :redirect-uri))
            (or (getf settings :scope) ""))))

(defmethod social-auth-canceled-p ((network (eql :vkontakte)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")
    (weblocks::get-parameter "error_reason")
    (string= (weblocks::get-parameter "error_reason") "user_denied")))

(defmethod get-social-auth-token ((social-network (eql :vkontakte)))
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-token 
      (getf settings :request-token-url)
      (weblocks::get-parameter "code")
      :redirect-uri (getf settings :redirect-uri)
      :method :post
      :other `(("client_id" .,(getf settings :client-id))
               ("client_secret" . ,(getf settings :client-secret)))
      :token-parser (lambda (item)
                      (let ((data (oauth2::parse-json item)))
                        (setf (get 'user-id :vkontakte) (cdr (assoc :user--id data)))
                        (list* (cons :token--type "Bearer") data))))))

(defmethod get-social-auth-user-id ((network (eql :vkontakte)) auth-token)
  (get 'user-id :vkontakte))
