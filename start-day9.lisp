;;
;; Day 9
;;

;in the new dialogues take care of
;./input.lisp
;./output.txt
;(load "C:/inetpub/wwwroot/RocSpeakRafayet/ttt/ttt/src/load")

(defvar *gist-kb* (make-hash-table :test #'equal)); for storage of gist
                ; clauses, particularly ones obtained from user inputs;
(clrhash *gist-kb*)

;; (setf *mode* nil)
(setf *root-dir* *default-pathname-defaults*)

; global counter for the output file
(defvar *global-count*); 
(setq *global-count* 0)

; ************ clear the output.txt file if it exists, if it doesn't create one
(with-open-file (outfile "./output.txt" :direction :output :if-exists 
                               :supersede :if-does-not-exist :create))


;
; load ttt
;

(setf *temp-dir* "ttt/src")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "load")
(setf *default-pathname-defaults* *root-dir*)

;(setq *ttt-addr* "C:/inetpub/wwwroot/RocSpeakRafayet/ttt/ttt/src/load")


;
; load shared code
;

(setf *temp-dir* "elderly/SharedCode")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "lissa5"); lissa5.lisp is the main Lissa code
(load "choose-doolittle-response-1.lisp")  ; rule part of original data.lisp
(load "general-word-data-5.lisp") ; generic word-level stuff from data.lisp
(load "choose-reactions-to-input.lisp")
(load "choose-reaction-to-question.lisp")
(load "choose-wff-extraction-trees-for-input.lisp")
(load "schema-for-reactions-to-answer-plus-question.lisp")
(load "schema-for-reactions-to-question+clause.lisp")
(setf *default-pathname-defaults* *root-dir*)


;================================
;    Sleep
;================================

(setf *temp-dir* "elderly/Day9/Sleep")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "start-lissa5")
(setf *default-pathname-defaults* *root-dir*)


;================================
;    Health
;================================
(setf *temp-dir* "elderly/Day9/Health")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "start-lissa5")
(setf *default-pathname-defaults* *root-dir*)

;================================
;    Exercise
;================================

(setf *temp-dir* "elderly/Day9/Exercise")
(setf *default-pathname-defaults* (truename *temp-dir*))
(load "start-lissa5")
(setf *default-pathname-defaults* *root-dir*)

; store the extracted knowledge
; append the content of the hash table *gist-kb* to the file "gist-kb/X.txt" in which X is the user's id (get it from *user-id*)
;

;delete the content of the sessionInfo.lisp file
(with-open-file (outfile "./sessionInfo.lisp" :direction :output :if-exists :supersede :if-does-not-exist :create))


(setq kb-file-name (ensure-directories-exist (concatenate 'string "gist-kb/" *user-id* ".txt")))

(maphash #'(lambda (key val)
                   (with-open-file (outfile kb-file-name :direction :output :if-exists
                           :append :if-does-not-exist :create)
                   (format outfile "~% ~a   ~a" key val)))
           *gist-kb*)

