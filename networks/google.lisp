(in-package :weblocks-social-registration-widget)

(defmethod get-social-auth-settings ((network (eql :google)))
  (get-social-auth-settings :googleplus))

(defmethod social-auth-canceled-p ((network (eql :googleplus)))
  (and 
    (weblocks::get-parameter "error")
    (string= (weblocks::get-parameter "error") "access_denied")))

(defmethod social-auth-canceled-p ((network (eql :google)))
  (social-auth-canceled-p :googleplus))

(defmethod get-social-auth-user-id ((network (eql :googleplus)) auth-token)
  (cdr (assoc :id 
              (json:decode-json-from-string 
                (flexi-streams:octets-to-string 
                  (oauth2:request-resource "https://www.googleapis.com/oauth2/v1/userinfo" auth-token)
                  :external-format :utf-8)))))

(defmethod get-social-auth-user-id ((network (eql :google)) auth-token)
  (get-social-auth-user-id :googleplus auth-token))
