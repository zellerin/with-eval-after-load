(in-package with-eval-after-load)

(mgl-pax:defsection @overview
    (:title "Overview")
  "Emacs provides at least two ways (customization and eval-after-load) for
user how to customize a package without actually loading it. I am not aware of
anything like that in Common Lisp.

This package imitates the with-eval-after-load macro."

  "Quick start example: Drakma by default considers Javascript to be a binary
format. I want it to handle it as text. This can be done by setting
DRAKMA:*TEXT-CONTENT-TYPES* appropriately.

So I have this in my ~/.sbclrc:

``` lisp
(with-eval-after-load (\"drakma\" drakma)
  (setf #:*text-content-types*
        (list* '(\"application\" . \"javascript\") '(\"application\" . \"json\") '(\"text\" . nil))))
```

It does not load Drakma and its dependencies, but it makes sure that when Drakma is loaded eventually, it will have it set. Note that as DRAKMA package does not exist yet, I cannot use it to name a symbol - so the package name as a parameter and #: in the setf.

The package also provides an autoload feature that is kind of experimental."
  (@dictionary mgl-pax:section))

(mgl-pax:defsection @Dictionary
    (:title "Dictionary")
  (with-eval-after-load mgl-pax:macro)
  (*root-package* variable)
  (define-autoload mgl-pax:macro))

(mgl-pax:update-asdf-system-readmes @overview "with-eval-after-load")
