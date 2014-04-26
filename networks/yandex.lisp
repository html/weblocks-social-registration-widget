(in-package :weblocks-social-registration-widget)

(defmethod social-auth-canceled-p ((network (eql :yandex)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")))

(defmethod get-social-auth-token ((social-network (eql :yandex)))
  (let ((settings (get-social-auth-settings social-network)))
    (oauth2:request-token 
      (getf settings :request-token-url)
      (weblocks::get-parameter "code")
      :redirect-uri (getf settings :redirect-uri)
      :method :post
      :other `(("client_id" .,(getf settings :client-id))
               ("client_secret" . ,(getf settings :client-secret)))
      :token-parser (lambda (item)
                      (list* (cons :token--type "Bearer") (oauth2::parse-json item))))))

(defun get-current-yandex-user (auth-token)
  (json:decode-json-from-string 
    (flexi-streams:octets-to-string 
      (apply
        'oauth2::http-request 
        "https://login.yandex.ru/info"  
        :additional-headers `((("Authorization" . ,(format nil "OAuth ~A" (oauth2:token-string auth-token))))))
      :external-format :utf-8)))

(defmethod get-social-auth-user-id ((network (eql :yandex)) auth-token)
  (cdr (assoc :id (get-current-yandex-user auth-token))))
