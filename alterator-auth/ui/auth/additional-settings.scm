(document:surround "/std/frame")

(define (ui-exit)
    (document:end)
)

(define (ui-apply)
    (woo-catch/message
        (thunk
            (woo-write "/auth/set_settings_values"
            'sssd_ad_gpo_access_control (form-value "sssd_ad_gpo_access_control")
            'sssd_ad_gpo_ignore_unreadable (form-value "sssd_ad_gpo_ignore_unreadable")
            'sssd_cache_credentials (form-value "sssd_cache_credentials")
            'sssd_drop_privileges (form-value "sssd_drop_privileges")
            'sssd_dyndns_refresh_interval_status (form-value "sssd_dyndns_refresh_interval_status")
            'sssd_dyndns_refresh_interval_value (form-value "sssd_dyndns_refresh_interval_value")
            'sssd_dyndns_ttl_status (form-value "sssd_dyndns_ttl_status")
            'sssd_dyndns_ttl_value (form-value "sssd_dyndns_ttl_value")
            'sssd_dyndns_update (form-value "sssd_dyndns_update")
            'sssd_dyndns_update_ptr (form-value "sssd_dyndns_update_ptr"))
        )
    )
)

(define (list-sssd-ad-gpo-access-control)
    (form-update-enum "sssd_ad_gpo_access_control" (woo-list "/auth/sssd_ad_gpo_access_control"))
)

(define (list-sssd-ad-gpo-ignore-unreadable)
    (form-update-enum "sssd_ad_gpo_ignore_unreadable" (woo-list "/auth/sssd_ad_gpo_ignore_unreadable"))
)

(define (list-sssd-cache-credentials)
    (form-update-enum "sssd_cache_credentials" (woo-list "/auth/sssd_cache_credentials"))
)

(define (list-sssd-drop-privileges)
    (form-update-enum "sssd_drop_privileges" (woo-list "/auth/sssd_drop_privileges"))
)

(define (list-sssd-dyndns-refresh-interval)
    (form-update-enum "sssd_dyndns_refresh_interval_status" (woo-list "/auth/sssd_dyndns_refresh_interval"))
)

(define (list-sssd-dyndns-ttl)
    (form-update-enum "sssd_dyndns_ttl_status" (woo-list "/auth/sssd_dyndns_ttl"))
)

(define (list-sssd-dyndns-update)
    (form-update-enum "sssd_dyndns_update" (woo-list "/auth/sssd_dyndns_update"))
)

(define (list-sssd-dyndns-update-ptr)
    (form-update-enum "sssd_dyndns_update_ptr" (woo-list "/auth/sssd_dyndns_update_ptr"))
)

(define (dyndns-ttl-activity)
    (if (string=? (form-value "sssd_dyndns_ttl_status") "enabled")
        (form-update-activity '("sssd_dyndns_ttl_value") #t)
        (form-update-activity '("sssd_dyndns_ttl_value") #f)
    )
)

(define (dyndns-interval-activity)
    (if (string=? (form-value "sssd_dyndns_refresh_interval_status") "enabled")
        (form-update-activity '("sssd_dyndns_refresh_interval_value") #t)
        (form-update-activity '("sssd_dyndns_refresh_interval_value") #f)
    )
)

(define (get-additional-settings-values)
    (let ((data (woo-read-first "/auth/get_settings_values")))
        (form-update-value-list '("sssd_ad_gpo_access_control"
        "sssd_ad_gpo_ignore_unreadable" "sssd_cache_credentials"
        "sssd_drop_privileges"
        "sssd_dyndns_refresh_interval_status"
        "sssd_dyndns_refresh_interval_value"
        "sssd_dyndns_ttl_status"
        "sssd_dyndns_ttl_value"
        "sssd_dyndns_update" "sssd_dyndns_update_ptr") data)
    )
    (dyndns-ttl-activity)
    (dyndns-interval-activity)
)

width 600
height 400

(gridbox
    columns "100;0"
    margin 10

    (label text (_ "Group Policy enforcement rules:") align "right"
                    tooltip (_ "SSSD GPO-based access control rules"))
    (combobox name "sssd_ad_gpo_access_control" )

    (label text (_ "Ignore if Group Policies are not read:") align "right"
                    tooltip (_ "Access users when group policy templates are not readable"))
    (combobox name "sssd_ad_gpo_ignore_unreadable" )

    (label text (_ "Cache credentials:") align "right"
                    tooltip (_ "SSSD users credentials cached in the local LDB cache"))
    (combobox name "sssd_cache_credentials" )

    (label text (_ "Privileges of SSSD running:") align "right"
                    tooltip (_ "Set privileges to SSSD running"))
    (combobox name "sssd_drop_privileges" )

    (label text (_ "DNS records update interval:") align "right"
                    tooltip (_ "Set the value of refresh interval DNS records updated by SSSD in seconds"))
    (gridbox columns "0;100"
        (combobox name "sssd_dyndns_refresh_interval_status" (when changed (dyndns-interval-activity)))
        (spinbox name "sssd_dyndns_refresh_interval_value" minimum 60 step 1)
    )

    (label text (_ "TTL value of client DNS record:") align "right"
                    tooltip (_ "Set the TTL value of client DNS record updated by SSSD in seconds"))
    (gridbox columns "0;100"
        (combobox name "sssd_dyndns_ttl_status" (when changed (dyndns-ttl-activity)))
        (spinbox name "sssd_dyndns_ttl_value" step 1)
    )

    (label text (_ "Update the IP address in the DNS server:") align "right"
                    tooltip (_ "Automatically update DNS server with the IP address using SSSD"))
    (combobox name "sssd_dyndns_update" )

    (label text (_ "Update the PTR record in the DNS server:") align "right"
                    tooltip (_ "Automatically update DNS server with the PTR record using SSSD"))
    (combobox name "sssd_dyndns_update_ptr" )

    (label)(label)

    (hbox colspan 2 align "right"
        (button name "apply" text (_ "Apply") (when clicked (ui-apply)))
	    (button name "cancel" text (_ "Cancel") (when clicked (ui-exit))))
)

(document:root
    (when loaded
        (list-sssd-ad-gpo-access-control)
        (list-sssd-ad-gpo-ignore-unreadable)
        (list-sssd-cache-credentials)
        (list-sssd-drop-privileges)
        (list-sssd-dyndns-refresh-interval)
        (list-sssd-dyndns-ttl)
        (list-sssd-dyndns-update)
        (list-sssd-dyndns-update-ptr)
        (get-additional-settings-values)
    )
)
