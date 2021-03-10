;; Aug 13/2020
;; ================================================
;;
;; Contains utility functions used for file IO
;;


(defun read-from-system (system)
;``````````````````````````````````
; Reads input (as a list of propositions) from given subsystem.
;
  (case system
    (|Audio| (read-audio))
    (|Terminal| (read-terminal))
    (otherwise (read-subsystem system)))
) ; END read-from-system



(defun read-terminal ()
;```````````````````````
; Scans input from the terminal. If the user presses enter, read the
; input, create and return a (^you say-to.v ^me '(...)) proposition.
; NOTE: previously in eta.lisp, it would call detach-final-punctuation
; after reading input. However, I suspect we want punctuation since Google ASR is
; capable of it. The pattern-matching files therefore need to take punctuation into account.
;
  (when (listen)
    (let ((text (parse-chars (coerce (read-line) 'list))))
      (if text `((^you say-to.v ^me ',text)))))
) ; END read-terminal



(defun read-audio ()
;`````````````````````
; Reads input from |Audio| subsystem (i.e., (^you say-to.v ^me '(...)), or
; possibly (^you say-to.v ^me "...")) propositions from io/in/Audio.lisp.
; NOTE: previously in eta.lisp, it would call detach-final-punctuation
; after reading input. However, I suspect we want punctuation since Google ASR is
; capable of it. The pattern-matching files therefore need to take punctuation into account.
; 
  ; Write empty star line to output to prompt avatar to listen
  ; TODO: there has to be a better way of doing this...
  (when (= *output-listen-prompt* 1)
    (setq *output-count* (1+ *output-count*))
    (with-open-file (outfile "./io/output.txt" :direction :output
                                               :if-exists :append
                                               :if-does-not-exist :create)
      (format outfile "~%*~D: dummy" *output-count*))
    (setq *output-listen-prompt* 2))

  ; Read from Audio input
  (setq *input* nil)
  (load "./io/in/Audio.lisp")
  (if *input*
    (with-open-file (outfile "./io/in/Audio.lisp" :direction :output
                                                  :if-exists :supersede
                                                  :if-does-not-exist :create)))
  (mapcar (lambda (wff)
      ; If say-to.v argument given in string form, parse it into list form
      (if (and (equal (butlast wff) '(^you say-to.v ^me)) (stringp (car (last wff))))
        (append (butlast wff) `(',(parse-chars (coerce (car (last wff)) 'list))))
        wff))
    *input*)
) ; END read-audio



(defun read-subsystem (system &key block)
;``````````````````````````````````````````
; Reads input ULF propositions from io/in/<system>.lisp.
; If :block t is given, loop until a non-nil value is set for *input*.
;
  (let ((fname (concatenate 'string "./io/in/" (string system) ".lisp")))
  (setq *input* nil)
  (cond
    ; If :block t is given, loop until non-nil input
    (block
      (loop while (and block (null *input*)) do
        (load fname)))
    ; Otherwise, load file once
    (t (load fname)))
  (if *input*
    (with-open-file (outfile fname :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)))
  *input*
)) ; END read-subsystem



(defun write-subsystem (output system)
;`````````````````````````````````````````
; Writes output/"query" ULF propositions to io/out/<system>.lisp.
; output should be a list of propositions.
;
  (let ((fname (concatenate 'string "./io/out/" (string system) ".lisp")))
    (with-open-file (outfile fname :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
      (format outfile "(setq *output* '~a)" output))
)) ; END write-subsystem



(defun user-log (logfile content)
;`````````````````````````````````````
; Logs some user data in the corresponding log file (i.e., text, gist, or ulf).
; Temporarily disable pretty-printing so each line in the log file corresponds to a single turn.
;
  (let ((fname (concatenate 'string "./io/user-log/" (string-downcase (string logfile)) ".txt")))
    (setq *print-pretty* nil)
    (with-open-file (outfile fname :direction :output
                                   :if-exists :append
                                   :if-does-not-exist :create)
      (format outfile "~a~%" content))
    (setq *print-pretty* t)
)) ; END user-log



(defun print-words (wordlist)
;``````````````````````````````
; This is intended for the keyboard-based mode of interaction,
; i.e., with *live* = nil.
;
  (format t "~%...")
  (dolist (word wordlist)
    (princ " ")
    (princ word)
    (if (or (member word '(? ! \.))
            (member (car (last (explode word))) '(#\? #\! #\.)))
      (format t "~%")))
) ; END print-words



(defun say-words (wordlist)
;````````````````````````````
; This is intended for th *live* = T mode of operation, i.e., I/O
; is via the virtual agent; (but the output is printed as well).
; For terminal mode only, we use 'print-words'.
;
  (let (wordstring)
    ; Write ETA's words to "./io/output.txt" as a continuous string
    ; (preceded by the output count and a colon)
    (dolist (word wordlist)
      (push (string word) wordstring)
      (push " " wordstring))
    (setq wordstring (reverse (cdr wordstring)))
    (setq wordstring (eval (cons 'concatenate (cons ''string wordstring))))

    ; Increment output number
    (setq *output-count* (1+ *output-count*))
	  
    ; Output words
    (with-open-file (outfile "./io/output.txt" :direction :output
                                               :if-exists :append
                                               :if-does-not-exist :create)
      (format outfile "~%#~D: ~a" *output-count* wordstring))

    ; Also write ETA's words to standard output:
    (format t "~% ... ")
    (dolist (word wordlist)
      (format t "~a " word)
      (if (or (member word '(? ! \.))
              (member (car (last (explode word))) '(#\? #\! #\.)))
        (format t "~%")))
    (format t "~%")
)) ; END say-words





;; --------------------------------------------------
;; The functions after this point need to be vetted.
;; --------------------------------------------------





(defun read-input-timeout (n)
;``````````````````````````````
; Reads terminal input for n seconds and returns accumulated string.
;
  (finish-output)
  (let ((i 0) result)
    (loop while (< i n) do
      (sleep 1)
      (if (listen) (setq result (cons " " (cons (read-line) result))))
      (setq i (+ 1 i)))
    (if (listen) (setq result (cons (read-line) result)))
    (eval (append '(concatenate 'string) (reverse result))))
) ; END read-input-timeout



(defun read-log-contents (log)
;```````````````````````````````
; Reads the contents of a given log file and converts to list.
;
  (let (result)
    (with-open-file (logfile log :if-does-not-exist :create)
      (do ((l (read-line logfile) (read-line logfile nil 'eof)))
          ((eq l 'eof) "Reached end of file.")
        (setq result (concatenate 'string result " " l))))
    (read-from-string (concatenate 'string "(" result ")")))
) ; END read-log-contents



(defun load-obj-schemas ()
;```````````````````````````````````````````````
; Load core object schemas
; (in directory 'core/resources/obj-schemas')
; NOTE: I don't like having this here (loaded during Eta's
; 'init' function), but it's currently necessary since
; the equality sets and context are only defined in 'init'.
;
(mapcar (lambda (file) (load file))
    (directory "core/resources/obj-schemas/*.lisp"))
) ; END load-obj-schemas



(defun request-goal-rep (wff)
;`````````````````````````````
; Writes a formula (containing an indefinite quantifier with a lambda abstract)
; to the file goal-request.lisp, so that it can be processed by BW system.
;
  (with-open-file (outfile "./io/goal-request.lisp" :direction :output
                                                    :if-exists :supersede
                                                    :if-does-not-exist :create)
    (format outfile "(setq *goal-request* '~s)" wff))
) ; END request-goal-rep



(defun get-goal-rep ()
;```````````````````````
; This waits until it can load a goal representation from "./io/goal-rep.lisp".
;
  (setq *goal-rep* nil)
  (loop while (not *goal-rep*) do
    (sleep .5)
    (progn
      (load "./io/goal-rep.lisp")
		  (if *goal-rep*
        (with-open-file (outfile "./io/goal-rep.lisp" :direction :output 
                                                      :if-exists :supersede
                                                      :if-does-not-exist :create)))))
  *goal-rep*
) ; END get-goal-rep



(defun planner-input-to-ka (planner-input)
;```````````````````````````````````````````
; Converts planner input to the appropriate reified action.
; e.g.:
; Failure -> nil
; None -> (ka (do2.v nothing.pro))
; (|B1| on.p |B2|) -> (ka (put.v |B1| (on.p |B2|)))
; ((|B1| on.p |B2|) (|B1| behind.p |B3|))
;   -> (ka (put.v |B1| (set-of (on.p |B2|) (behind.p |B3|))))
; (undo (|B1| on.p |B2|)) -> (ka (move.v |B1| (back.mod-a (on.p |B2|))))
; (clarification (|B1| touching.p |B2|)) -> (ka (make.v |B1| (touching.p |B2|)))
; (clarification (|B1| ((mod-a (by.p (one.d (half.a block.n)))) to_the_left.a)))
;   -> (ka (make.v |B1| ((mod-a (by.p (one.d (half.a block.n)))) to_the_left.a)))
;
  (cond
    ((equal planner-input 'Failure) nil)
    ((equal planner-input 'None)
      '(ka (do2.v nothing.pro)))
    ((atom planner-input) nil)
    ; If single relation, convert to put.v ka
    ((relation-prop? planner-input)
      `(ka (put.v ,(car planner-input)
                  ,(cdr1 planner-input))))
    ; If multiple relations, convert to put.v ka with plural argument
    ((every #'relation-prop? planner-input)
      `(ka (put.v ,(caar planner-input)
                  ,(make-set (mapcar #'cdr1 planner-input)))))
    ; If undo step, generate put.v ka and transform to 'move back' ka
    ((undo-relation-prop? planner-input)
      (ttt:apply-rule
          '(/ (put.v _!1 _!2) (move.v _!1 (back.mod-a _!2)))
        (planner-input-to-ka (second planner-input))))
    ; If clarification step, generate put.v ka and transform to make.v ka
    ((clarification-relation-prop? planner-input)
      (ttt:apply-rule
          '(/ (put.v _!1 _!2) (make.v _!1 _!2))
        (planner-input-to-ka (second planner-input)))))
) ; END planner-input-to-ka



(defun get-planner-input ()
;````````````````````````````
; This waits until it can load a goal representation from "./io/planner-input.lisp".
; The value of *planner-input* is a list of relations that hold after the proposed
; action, e.g., ((|B1| to-the-left-of.p |B2|) (|B1| touching.p |B2|))
; Each relation is assumed to have the same subject.
;
  (setq *planner-input* nil)
  (loop while (not *planner-input*) do
    (sleep .5)
    (progn
      (load "./io/planner-input.lisp")
		  (if *planner-input*
        (with-open-file (outfile "./io/planner-input.lisp" :direction :output 
                                                           :if-exists :supersede
                                                           :if-does-not-exist :create)))))
  (planner-input-to-ka *planner-input*)
) ; END get-planner-input



(defun get-planner-input-offline () 
;````````````````````````````````````
; This is the planner input when ETA is used with argument live =
; nil (hence also *live* = nil)
; The input should be a list of relations that hold after the proposed action,
; e.g., ((|B1| to-the-left-of.p |B2|) (|B1| touching.p |B2|))
; Each relation is assumed to have the same subject.
;
  (finish-output)
  (format t "enter planner input below:~%")
  (finish-output)
  (planner-input-to-ka (read-from-string (read-line)))
) ; END get-planner-input-offline



(defun get-user-try-ka-success () 
;``````````````````````````````````
; This waits until it can load a list of relations from "./io/user-try-ka-success.lisp".
;
  (setq *user-try-ka-success* nil)
  (loop while (not *user-try-ka-success*) do
    (sleep .5)
    (progn
      (load "./io/user-try-ka-success.lisp")
		  (if *user-try-ka-success*
        (with-open-file (outfile "./io/user-try-ka-success.lisp" :direction :output 
                                                                 :if-exists :supersede
                                                                 :if-does-not-exist :create)))))
          
  (if (equal *user-try-ka-success* 'Failure) nil
    *user-try-ka-success*)
) ; END get-user-try-ka-success



(defun get-user-try-ka-success-offline () 
;```````````````````````````````````````````
; This is the user-try-ka-success reader when ETA is 
; used with argument live = nil (hence also *live* = nil)
;
  (finish-output)
  (format t "enter user-try-ka-success below:~%")
  (finish-output)
  (let ((user-try-ka-success (read-from-string (read-line))))
    (if (equal user-try-ka-success 'Failure) nil user-try-ka-success))
) ; END get-user-try-ka-success-offline



(defun update-block-coordinates (moves)
;````````````````````````````````````````
; Given a list of moves (in sequential order), update *block-coordinates*. Return a list of
; perceptions, i.e. the given moves combined with the current block coordinates.
;
  (mapcar (lambda (move)
    (setq *block-coordinates* (mapcar (lambda (coordinate)
        (if (equal (car move) (car coordinate))
          (list (car coordinate) 'at-loc.p (cadar (cddadr move)))
          coordinate))
      *block-coordinates*))) moves)
  (append *block-coordinates* moves)
) ; END update-block-coordinates



(defun verify-log (answer-new turn-tuple filename)
;```````````````````````````````````````````````````
; Given Eta's answer for a turn, allow the user to compare to the answer in the log
; and amend the correctness judgment for that turn. Output to the corresponding
; filename in log_out/ directory.
;
  (let ((filename-out (concatenate 'string "logs/logs_out/" (pathname-name filename)))
        (answer-old (parse-chars (coerce (third turn-tuple) 'list)))
        (feedback-old (fourth turn-tuple)) feedback-new)
    ;; (format t "/~a~%\\~a~%" answer-old answer-new)
    (with-open-file (outfile filename-out :direction :output :if-exists :append :if-does-not-exist :create)
      (cond
        ; If answer is the same, just output without modification
        ((equal answer-old answer-new)
          (format outfile "(\"~a\" ~S \"~a\" ~a)~%" (first turn-tuple) (second turn-tuple) (third turn-tuple) (fourth turn-tuple)))
        ; If question was marked as non-historical, also skip
        ((member (fourth turn-tuple) '(XC XI XP XE))
          (format outfile "(\"~a\" ~S \"~a\" ~a)~%" (first turn-tuple) (second turn-tuple) (third turn-tuple) (fourth turn-tuple)))
        ; If "when" question with specific time, also skip
        ((and (equal "when" (string-downcase (subseq (first turn-tuple) 0 4)))
              (find-if (lambda (x) (member x '(zero one two three four five six seven eight nine ten eleven twelve thirteen
                                               fourteen fifteen sixteen seventeen eighteen nineteen twenty thirty forty
                                               fifty sixty seventy eighty ninety hundred))) answer-old))
          (format outfile "(\"~a\" ~S \"~a\" ~a)~%" (first turn-tuple) (second turn-tuple) (third turn-tuple) (fourth turn-tuple)))
        ; Otherwise, check the new output with the user and prompt them to change feedback

        (t
          (format t " ----------------------------------------------------------~%")
          (format t "| A CHANGE WAS DETECTED IN LOG '~a':~%" (pathname-name filename))
          (format t "| * question: ~a~%" (first turn-tuple))
          (format t "| * old answer: ~a~%" answer-old)
          (format t "| * old feedback: ~a~%" (fourth turn-tuple))
          (format t "| * new answer: ~a~%" answer-new)
          (format t "| > new feedback: ")
          (finish-output) (setq feedback-new (read-from-string (read-line)))
          (format t " ----------------------------------------------------------~%")
          (if (not (member feedback-new '(C I P F E))) (setq feedback-new 'E))
          (format outfile "(\"~a\" ~S \"~a\" ~a)~%"
            (first turn-tuple) (second turn-tuple) (format nil "~{~a~^ ~}" answer-new) feedback-new)))))
) ; END verify-log