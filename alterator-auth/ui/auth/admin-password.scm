(document:surround "/std/frame")

;;; Logic
(define (ui-write)
  (document:end (form-value-list '("admin_username" "admin_password" "group_policy" "use_krb_ccache"))))

;;; Default administrator name for domain types
(define (get-admin-name)
  (let ((type (global 'domain-type)))
  (if (string=? type "ad")
      "Administrator"
      (if (string=? type "freeipa")
          "admin"
          ""))))

;;; Group policy checkbox visibility for domain types
(define (get-gpupdate-visibility)
  (let ((type (global 'domain-type)))
  (if (string=? type "ad")
      (global 'gpupdate-available)
      #f )))

;;; Use default kerberos credential cache checkbox visibility for domain types
(define (get-krb-ccache-visibility)
  (let ((type (global 'domain-type)))
  (if (string=? type "ad")
      #t #f )))

;;; Init dialog
(define (ui-init)
  (gpupdate-checkbox visibility (get-gpupdate-visibility))
  (gpupdate-checkbox value (global 'gpupdate-available))
  (krb-ccache-checkbox visibility (get-krb-ccache-visibility))

  (form-update-value "admin_username" (get-admin-name))
  (form-bind "ok" "click" ui-write)
  (form-bind "cancel" "click" document:end))

;;; UI
(gridbox columns "0;0;100" margin 25 spacing 10
    (label align "center" rowspan 4 text " ")
    (label colspan 2 text (string-append (_ "Enter the name and password of an account") "\n" (_ "with permission to join the domain.")))
    (label text (_ "Username:"))
    (edit name "admin_username")
    (label text (_ "Password:"))
    (edit name "admin_password" echo "stars")

    (document:id gpupdate-checkbox
      (checkbox colspan 2 align "left" visibility #f text(_ "Enable Group Policy") name "group_policy" value #f))
    (spacer)

    (document:id krb-ccache-checkbox
      (checkbox colspan 2 align "left" visibility #t text(_ "Use default kerberos credential cache") name "use_krb_ccache" value #f))
    (spacer)

    (hbox colspan 2 align "left"
      (button name "ok" text (_ "OK"))
	  (button name "cancel" text (_ "Cancel"))))

;;; initialization
(document:root (when loaded (ui-init)))
