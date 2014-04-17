(in-package :weblocks-social-registration-widget)

(defmethod social-auth-canceled-p ((network (eql :facebook)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")
    (weblocks::get-parameter "error_code")
    (string= (weblocks::get-parameter "error_code") "200")))

(defmethod get-social-auth-token ((social-network (eql :facebook)))
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-token 
      (getf settings :request-token-url)
      (weblocks::get-parameter "code")
      :redirect-uri (getf settings :redirect-uri)
      :method :post
      :other `(("client_id" .,(getf settings :client-id))
               ("client_secret" . ,(getf settings :client-secret)))
      :token-parser 'oauth2:facebook-token->alist)))

(defmethod get-social-auth-user-id ((network (eql :facebook)) auth-token)
  (let ((token (oauth2:token-string auth-token)))
    (cdr (assoc :id 
              (json:decode-json-from-string 
                (flexi-streams:octets-to-string 
                  (drakma:http-request (format nil "https://graph.facebook.com/me?access_token=~A" token))
                  :external-format :utf-8))))))
