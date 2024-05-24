;;;; with-eval.asd
;;
;;;; Copyright (c) 2024 Tomáš Zellerin <tomas@zellerin.cz>


(asdf:defsystem #:with-eval-after-load
  :description "Describe with-eval here"
  :author "Tomáš Zellerin <tomas@zellerin.cz>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:mgl-pax)
  :components ((:file "package")
               (:file "with-eval")
               (:static-file "README")))

(asdf:defsystem #:with-eval-after-load/doc
  :description "Describe with-eval here"
  :author "Tomáš Zellerin <tomas@zellerin.cz>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:mgl-pax #:with-eval-after-load)
  :components ((:file "doc")))
