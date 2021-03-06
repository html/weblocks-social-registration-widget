# Weblocks Social Registration Widget

This is a widget for registration via social networks. 
It allows to easily set up social auth login or registration on the site.

## Compatibility

Currently Weblocks Social Registration widget works with `weblocks-routes` branch of https://github.com/html/weblocks repository

## Configuration

For setting up networks override `weblocks-social-registration-widget:*social-auth-settings*` located in config.lisp

## Usage

* Create widget `weblocks-social-registration-widget:social-registration-widget` (with `:on-success` `:on-cancel` and `:on-fail` callbacks and `:uri-id` parameter set)

* Define routes for `uri-id` chosen 

```lisp 
(connect *routes-mapper* (routes:make-route "/login-by-:(social-login.start)"))
(connect *routes-mapper* (routes:make-route "/finish-:(social-login.finish)-login"))
```

* Use routes to redirect user to login/registration page with `(url-for :social-login.start "facebook")
