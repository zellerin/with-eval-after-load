;;;; package.lisp
;;
;;;; Copyright (c) 2024 Tomáš Zellerin <tomas@zellerin.cz>


(cl:defpackage #:with-eval-after-load
  (:use #:cl)
  (:export #:with-eval-after-load)
  (:documentation "Imitate emacs with-eval-after-load functionality in CL"))
