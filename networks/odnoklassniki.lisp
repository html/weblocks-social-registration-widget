(in-package :weblocks-social-registration-widget)

(defmethod social-auth-canceled-p ((network (eql :odnoklassniki)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")))

(defun odnoklassniki-query (params app-key app-secret access-token)
  (labels ((calculate-hash (app-key app-secret access-token)
             (string-downcase 
               (weblocks-util::md5 
                 (format nil "application_key=~Amethod=users.getCurrentUser~A" app-key
                         (string-downcase (weblocks-util::md5 (concatenate 'string access-token app-secret))))))))
    (json:decode-json-from-string 
      (flexi-streams:octets-to-string 
        (let* ((str params)
               (url))
          (setf url (format nil "http://api.odnoklassniki.ru/fb.do?access_token=~A&~A&sig=~A" 
                            access-token str (calculate-hash app-key app-secret access-token)))

          (drakma:http-request url))
        :external-format :utf-8))))

(defun get-current-odnoklassniki-user (auth-token)
  (let ((settings (get-social-auth-settings :odnoklassniki)))
    (odnoklassniki-query 
      (format nil "application_key=~A&method=users.getCurrentUser" 
              (getf settings :application-key))
      (getf settings :application-key)
      (getf settings :client-secret)
      (oauth2:token-string auth-token))))

(defmethod get-social-auth-user-id ((network (eql :odnoklassniki)) auth-token)
  (cdr (assoc :uid (get-current-odnoklassniki-user auth-token))))
