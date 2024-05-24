(in-package with-eval-after-load)

(defvar *after-system-hooks* (make-hash-table :test 'equal))
(defvar *root-package* "CL-USER"
  "Package to which are the function autoloaded. This is by default CL-USER as
reasonable baseline. I create and use custom package, but the name depends on
circumstances.")

(defmethod asdf:perform :after ((op asdf:load-op) (component asdf:system))
  (let* ((name (asdf:component-name component)))
    (dolist (hook (gethash name *after-system-hooks*))
      (funcall hook))
    (setf (gethash name *after-system-hooks*) nil)))

(defun intern-uninterned (code package)
  "Replace all uninterned symbols in CODE with symbols interned in PACKAGE.

CODE is a tree that possibly contains symbols."
  (typecase code
    (cons (cons (intern-uninterned (car code) package)
                (intern-uninterned (cdr code) package)))
    (symbol (if (symbol-package code) code (intern (symbol-name code) package)))
    (t code)))

(defmacro define-autoload (name source-system)
  "Define a function NAME that when called loads SOURCE-SYSTEM and then calls
itself again, expecting to be changed.

This is used internally by WITH-EVAL-AFTER-LOAD, but can be used independently
as well if you handle package creation in a different way."
  `(unless (fboundp ',name)
     (defun ,name (&rest args)
       (declare (notinline ,name))
       (unintern ',name *root-package*)
       (ql:quickload ',source-system)
       (apply (find-symbol ,(symbol-name name) ,(package-name (symbol-package name))) args))))

(defmacro with-eval-after-load ((asdf-system package &key autoload) &body body)
  "Set up modified BODY to be evaluated (using EVAL) either immediately (if the ASDF-SYSTEM is already loaded), or when it is loaded in future.

Each occurence of uninterned symbol (that is, symbol prefixed with #:) in BODY
is replaced by symbol of same name in the PACKAGE before evaluation.

Symbols from AUTOLOAD list are then imported to the *ROOT-PACKAGE*.

In addition, for each symbol in the AUTOLOAD list (also uninterned) there is a
function defined in *ROOT-PACKAGE* that loads the ASDF-SYSTEM (this implicitly
replaces the function binding) and then calls the newly defined function on same
parameters."
  `(progn
     (let ((fn (lambda ()
                 (eval  (intern-uninterned '(progn ,@body) ',package))
                 (dolist (fn-name (intern-uninterned ',autoload ',package))
                   (format t "~&Importing ~a~%" fn-name)
                   (shadowing-import fn-name *root-package*)))))
       (if (member ,asdf-system (asdf:already-loaded-systems) :test 'equal)
           (funcall fn)
           (push fn (gethash ,asdf-system *after-system-hooks*))))
     ,@(mapcar (lambda (fn-name)
                 `(define-autoload ,(intern (symbol-name fn-name) *root-package*)
                    ,asdf-system))
               autoload)))
