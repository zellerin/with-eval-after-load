(in-package cl-user)
(load "~/quicklisp/setup")
(ql:quickload "with-eval-after-load")
(setf *root-package* "CL-USER")

(with-eval-after-load ("drakma" drakma :autoload (#:http-request))
  (setf #:*text-content-types*
        (list* '("application" . "javascript") '("application" . "json") '("text" . nil)))
  (setq #:*drakma-default-external-format* :utf8))

(assert
 (stringp (http-request "https://github.githubassets.com/assets/chunk-app_components_site_header_user-drawer-side-panel-element_ts-117a9748b7ce.js")))
