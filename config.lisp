(in-package :weblocks-social-registration-widget)

(defparameter *social-auth-settings* 
  `(:odnoklassniki 
     (
      ; Redirect settings
      :url "http://www.odnoklassniki.ru/oauth/authorize"
      :client-id "..."
      :redirect-uri  nil
      ; Token settings
      :request-token-url "http://api.odnoklassniki.ru/oauth/token.do"
      :client-secret "...")
     :googleplus 
     (
      ; Redirect settings
      :url "https://accounts.google.com/o/oauth2/auth"
      :client-id "..."
      :scope "https://www.googleapis.com/auth/userinfo.profile"
      :redirect-uri nil
      ; Token settings
      :request-token-url "https://accounts.google.com/o/oauth2/token"
      :client-secret "..."
      )
     :facebook 
     (
      ; Redirect settings
      :url "https://www.facebook.com/dialog/oauth"
      :client-id "..."
      :redirect-uri nil
      ; Token settings
      :request-token-url "https://graph.facebook.com/oauth/access_token"
      :client-secret "..."
      )
     :mailru 
     (
      ; Redirect settings
      :url "https://connect.mail.ru/oauth/authorize"
      :client-id "..."
      :redirect-uri nil
      ; Token settings
      :request-token-url "https://connect.mail.ru/oauth/token"
      :client-secret "..."
      )
     :twitter 
     (
      ; Redirect settings
      :request-token-url "https://api.twitter.com/oauth/request_token"
      :client-id  "..."
      :redirect-uri nil 
      :client-secret "..."
      ; Token settings
      :access-token-url "https://api.twitter.com/oauth/access_token"
      )
     :vkontakte 
     (
      ; Redirect settings
      :url "https://oauth.vk.com/authorize"
      :client-id "..."
      :redirect-uri nil
      ; Token settings
      :request-token-url "https://oauth.vk.com/access_token"
      :client-secret "..."
      )
     :yandex 
     (
      ; Redirect settings
      :url "https://oauth.yandex.com/authorize"
      :client-id "..."
      :redirect-uri nil
      ; Token settings
      :request-token-url "https://oauth.yandex.com/token"
      :client-secret "..."
      )))
