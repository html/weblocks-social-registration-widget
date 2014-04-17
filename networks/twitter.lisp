(in-package :weblocks-social-registration-widget)

(defmethod social-auth-canceled-p ((network (eql :twitter)))
  (weblocks::get-parameter "denied"))

(defmethod get-social-auth-token ((social-network (eql :twitter)))
  (let* ((settings (get-social-auth-settings social-network))
         (token (webapp-session-value 'twitter-auth-token)))

    (oauth:authorize-request-token-from-request 
      (lambda (rt-key)
        (unless (equal (oauth:url-encode rt-key)
                       (oauth:token-key token))
          (error "Keys differ" (oauth:url-encode rt-key)))
        token))
    
    (when (oauth:request-token-authorized-p token)
      (oauth:obtain-access-token 
        (getf settings :access-token-url)
        token))))

(defmethod get-redirect-url-for-social-auth ((social-network (eql :twitter)))
  (let ((settings (get-social-auth-settings social-network)))
    (puri:render-uri 
      (let ((request-token (oauth:obtain-request-token 
                             (getf settings :request-token-url)
                             (oauth:make-consumer-token :key (getf settings :client-id)
                                                        :secret (getf settings :client-secret))
                             :callback-uri (getf settings :redirect-uri))))

        (setf (webapp-session-value 'twitter-auth-token) request-token)

        (oauth:make-authorization-uri "https://api.twitter.com/oauth/authorize" request-token))
      nil)))

(defmethod get-social-auth-user-id ((network (eql :twitter)) auth-token)
  (cdr (assoc "user_id" (oauth:token-user-data auth-token) :test #'string=)))
