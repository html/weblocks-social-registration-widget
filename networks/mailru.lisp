(in-package :weblocks-social-registration-widget)

(defmethod get-redirect-url-for-social-auth ((social-network (eql :mailru)))
  (let ((settings (get-social-auth-settings social-network)))
    (format nil "~A?client_id=~A&redirect_uri=~A&response_type=code" 
            (getf settings :url)
            (getf settings :client-id)
            (hunchentoot:url-encode (getf settings :redirect-uri))
            (getf settings :client-id)))) 

(defmethod social-auth-canceled-p ((network (eql :mailru)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")))

(defmethod get-social-auth-token ((social-network (eql :mailru)))
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-token 
      (getf settings :request-token-url)
      (weblocks::get-parameter "code")
      :redirect-uri (getf settings :redirect-uri)
      :method :post
      :other `(("client_id" .,(getf settings :client-id))
               ("client_secret" . ,(getf settings :client-secret)))
      :token-parser (lambda (item)
                      (let ((data (json:decode-json-from-string item)))
                        (setf (cdr (assoc :token--type data)) "Bearer")
                        (setf (get 'user-id :mailru) (cdr (assoc :x--mailru--vid data)))
                        data)))))

(defmethod get-social-auth-user-id ((network (eql :mailru)) auth-token)
  (get 'user-id :mailru))
