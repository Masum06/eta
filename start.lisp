
; NIL for text mode
; T for speak mode
;; (defparameter *mode* t)
(defparameter *mode* NIL)
(defparameter *user-id* NIL)

; sessionInfo.lisp should be as following
; (setq *user-id* "456")

(setf *root-dir* *default-pathname-defaults*)

;-----------Text Mode-----------
  (if (or (not *mode*) (not (probe-file "sessionInfo.lisp")))
    (progn
      (format t "~%~%Enter user-id ~%")
      (princ "user id: ") (finish-output)
      (setq *user-id* (write-to-string (read))))
;----------Speak Mode-----------
    (progn
      (load "sessionInfo.lisp")))
;-------------------------------

; Delete the content of the sessionInfo.lisp file after reading
(with-open-file (outfile "./sessionInfo.lisp" :direction :output :if-exists :supersede :if-does-not-exist :create))

; Delete the content of output.txt, if it exists, otherwise create
(with-open-file (outfile "./output.txt" :direction :output :if-exists 
                               :supersede :if-does-not-exist :create))

; Delete the content of input.lisp, if it exists, otherwise create
(with-open-file (outfile "./input.lisp" :direction :output :if-exists 
                               :supersede :if-does-not-exist :create))

; Delete the content of ulf.lisp, if it exists, otherwise create
(with-open-file (outfile "./ulf.lisp" :direction :output :if-exists 
                               :supersede :if-does-not-exist :create))

; Delete the content of reaction.lisp, if it exists, otherwise create
(with-open-file (outfile "./reaction.lisp" :direction :output :if-exists 
                               :supersede :if-does-not-exist :create))



; Create hash table to store gist clauses
(defvar *gist-kb* (make-hash-table :test #'equal)); for storage of gist
                ; clauses, particularly ones obtained from user inputs;
(clrhash *gist-kb*)


;
; Load ttt
;
(setf *temp-dir* "ttt/src")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "load")
(setf *default-pathname-defaults* *root-dir*)


;
; Load shared code
;
(setf *temp-dir* "core")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "eta.lisp")
(load "util.lisp")
(load "eta-schema.lisp")
(load "general-word-data.lisp")
(load "schema-for-reactions-to-answer-plus-question.lisp")
(load "schema-for-reactions-to-question+clause.lisp")
(load "eval-lexical-ulfs.lisp")
(load "stem.lisp")
(setf *default-pathname-defaults* *root-dir*)


;
; Start dialogue
;
(setf *temp-dir* "rules")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "choose-clause-ulf-tree.lisp")
(load "choose-gist-clause-trees-for-input.lisp")
(load "choose-reaction-to-input.lisp")
(load "choose-reactions-to-input.lisp")
(load "rules-for-question-reaction.lisp")

(load "getting-to-know/family-out.lisp")
(load "getting-to-know/female-out.lisp")
(load "getting-to-know/male-out.lisp")
(load "getting-to-know/rules-for-name-input.lisp")

(load "spatial-question/rules-for-spatial-question-input.lisp")
(load "spatial-question/rules-for-spatial-question-reaction.lisp")
(load "spatial-question/rules-for-spatial-question-ulf.lisp")
(load "spatial-question/rules-for-spatial-question-ulf-between.lisp")
(setf *default-pathname-defaults* *root-dir*)

(eta *mode*)

(setf *default-pathname-defaults* *root-dir*)