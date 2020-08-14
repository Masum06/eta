;; Aug 13/2020
;; ================================================
;;
;; Contains utility functions used for file IO
;;


(defun read-from-system (system)
;``````````````````````````````````
; Reads input (as a list of propositions) from given subsystem.
; Currently supports |Audio| and |Blocks-World-System|.
;
  (case system
    (|Audio| (read-audio))
    (|Blocks-World-System| (read-blocks-world-system)))
) ; END read-from-system



(defun read-audio ()
;`````````````````````
; Reads input from |Audio| subsystem (i.e., (^you say.v '(...)), or
; possibly (^you say.v "...")) propositions from io/Audio.lisp.
; 
  (setq *input* nil)
  (load "./io/Audio.lisp")
  (if *input*
    (with-open-file (outfile "./io/Audio.lisp" :direction :output
                                               :if-exists :supersede
                                               :if-does-not-exist :create)))
  (mapcar (lambda (wff)
      ; If say.v argument given in string form, parse it into list form
      (if (and (equal (second wff) 'say.v) (stringp (third wff)))
        (list (first wff) (second wff) (parse-chars (coerce (third wff) 'list)))
        wff))
    *input*)
) ; END read-audio



(defun read-blocks-world-system ()
;```````````````````````````````````
; Reads input from |Blocks-World-System| subsystem (i.e., (^you ((past move.v) ...)),
; or ((the.d (|Twitter| block.n)) ((past move.v) ...))) propositions
; from io/Blocks-World-System.lisp.
;
  (setq *input* nil)
  (load "./io/Blocks-World-System.lisp")
  (if *input*
    (with-open-file (outfile "./io/Blocks-World-System.lisp" :direction :output
                                                             :if-exists :supersede
                                                             :if-does-not-exist :create)))
  *input*
) ; END read-blocks-world-system



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



(defun process-buffer ()
;``````````````````````````
; Processes and clears input buffer.
;
  (let ((buffer *input-buffer*))
    (setq *input-buffer* nil)
    (parse-chars (coerce buffer 'list)))
) ; END process-buffer



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



(defun write-ulf (ulf)
;````````````````````````
; Writes a ulf to the file ulf.lisp, so that it can be used
; by the blocksworld system.
;
  (with-open-file (outfile "./io/ulf.lisp" :direction :output
                                        :if-exists :supersede
                                        :if-does-not-exist :create)
    (format outfile "(setq *next-ulf* ~a)" ulf))
) ; END write-ulf



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



(defun read-words (&optional str) 
;``````````````````````````````````
; This is the input reader when ETA is used with argument live =
; nil (hence also *live* = nil), i.e., with terminal input rather
; than live spoken input.
; If optional str parameter given, simply read words from str.
;
  (finish-output)
  (parse-chars (coerce (if str str (read-line)) 'list))
) ; END read-words



(defun hear-words (&key (delay nil)) 
;`````````````````````````````````````
; This waits until it can load a character sequence from "./io/input.lisp",
; which will set the value of *next-input*, and then processes *input*
; in the same way as the result of (read-line) is processed in direct
; terminal input mode.
; If some delay (an integer) is given, move on if no words heard after that
; number of seconds.
;
  (let ((s 0))
    ; Write empty star line to output to prompt avatar to listen
    ; TODO: there has to be a better way of doing this...
    (setq *output-count* (1+ *output-count*))
    (with-open-file (outfile "./io/output.txt" :direction :output
                                               :if-exists :append
                                               :if-does-not-exist :create)
      (format outfile "~%*~D: dummy" *output-count*))

    (setq *next-input* nil)
    (loop while (and (not *next-input*) (or (not delay) (< s delay))) do
      (sleep .5)
      (setq s (+ s .5))
      (progn
        (load "./io/input.lisp")
		    (if *next-input*
          (progn
            (format t "~a~%" *next-input*)
            (with-open-file (outfile "./io/input.lisp" :direction :output 
                                                       :if-exists :supersede
                                                       :if-does-not-exist :create))))))
          
  (parse-chars (coerce *next-input* 'list))
)) ; END hear-words



(defun get-perceptions () 
;``````````````````````
; This waits until it can load a list of block perceptions from "./io/perceptions.lisp".
; This should have a list of relations of the following two forms:
; ((the.d (|Twitter| block.n)) at-loc.p ($ loc ?x ?y ?z))
; ((the.d (|Toyota| block.n)) ((past move.v) (from.p-arg ($ loc ?x1 ?y1 ?z1)) (to.p-arg ($ loc ?x2 ?y2 ?z2))))
;
  (setq *next-perceptions* nil)
  (loop while (not *next-perceptions*) do
    (sleep .5)
    (progn
      (load "./io/perceptions.lisp")
		  (if *next-perceptions*
        (with-open-file (outfile "./io/perceptions.lisp" :direction :output 
                                                 :if-exists :supersede
                                                 :if-does-not-exist :create)))))
          
  *next-perceptions*
) ; END get-perceptions



(defun get-perceptions-offline () 
;``````````````````````````````````
; This is the perceptions reader when ETA is used with argument live =
; nil (hence also *live* = nil)
;
  (finish-output)
  (format t "enter perceptions below:~%")
  (finish-output)
  (read-from-string (read-line))
) ; END get-perceptions-offline



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



(defun get-answer () 
;``````````````````````
; This waits until it can load a list of relations from "./io/answer.lisp".
;
  (setq *next-answer* nil)
  (loop while (not *next-answer*) do
    (sleep .5)
    (progn
      (load "./io/answer.lisp")
		  (if *next-answer*
        (with-open-file (outfile "./io/answer.lisp" :direction :output 
                                                    :if-exists :supersede
                                                    :if-does-not-exist :create)))))
          
  (if (equal *next-answer* 'None) nil
    *next-answer*)
) ; END get-answer



(defun get-answer-offline () 
;`````````````````````````````
; This is the answer reader when ETA is used with argument live =
; nil (hence also *live* = nil)
;
  (finish-output)
  (format t "enter answer relations below:~%")
  (finish-output)
  (let ((ans (read-from-string (read-line))))
    (if (equal ans 'None) nil ans))
) ; END get-answer-offline



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



(defun get-answer-string () 
;````````````````````````````
; This waits until it can load a character sequence from "./io/answer.lisp",
; which will set the value of *next-answer*, and then processes it.
;
  (setq *next-answer* nil)
  (loop while (not *next-answer*) do
    (sleep .5)
    (progn
      (load "./io/answer.lisp")
		  (if *next-answer*
        (with-open-file (outfile "./io/answer.lisp" :direction :output 
                                                   :if-exists :supersede
                                                   :if-does-not-exist :create)))))
          
  ;; (parse-chars (if (stringp *next-answer*) (coerce *next-answer* 'list)
  ;;                                            (coerce (car *next-answer*) 'list)))
  (cond
    ((stringp *next-answer*) (list (parse-chars (coerce *next-answer* 'list))))
    ((listp *next-answer*) (cons (parse-chars (coerce (car *next-answer*) 'list))
                            (cdr *next-answer*))))
) ; END get-answer-string



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
        (answer-old (read-words (third turn-tuple))) (feedback-old (fourth turn-tuple)) feedback-new)
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



(defun parse-chars (chars) 
;```````````````````````````
; Parses a list of chars by forming a list of character sublists,
; where each sublist is made into an atom (taking into account
; special characters)
;
; Takes a character list as input. Then tokenize into a list of
; upper-case atoms, treating (i) any nonblank character following a
; blank, (ii) any non-blank nonalphanumeric character other than
; #\', #\-, #\_ following an alphanumeric character, and (iii) any
; alphanumeric character following a nonalphanumeric character other
; than #\', #\-, #\_, as the start of a new atom.
;
  (let (prevch chlist chlists)
    (if (null chars) (return-from parse-chars nil))
    ; Form a list of character sublists, each sublist to be made
    ; into an atom; (the list & sublists will at first be backward,
    ; and so have to be reversed before interning & output)
    (setq prevch #\Space)
    (dolist (ch chars)
      ; Do we have the start of a new word?
      (if
        (or
          (and
            (char-equal prevch #\Space) 
            (not (char-equal ch #\Space)))
          (and
            (alphanumericp prevch)
            (not (alphanumericp ch))
            (not (member ch '(#\Space #\' #\- #\_) :test #'char-equal)))
          (and
            (not (alphanumericp prevch))
            (not (member prevch '(#\' #\- #\_) :test #'char-equal))
            (alphanumericp ch)))
        ; If so, push the current chlist (if nonempty) onto 
        ; chlists, and start a new chlist containing ch
        (progn (if chlist (push (reverse chlist) chlists))
          (setq chlist (list (char-upcase ch))))
        ; If not, push ch (if nonblank) onto the current chlist
        (if (not (char-equal ch #\Space))
          (push (char-upcase ch) chlist)))
      (setq prevch ch))
        
    ; Push the final chlist (if nonempty) onto chlists (in reverse)
    (if chlist (push (reverse chlist) chlists))
    ; Return the reverse of chlists, where each sublist has been
    ; interned into an atom
    (reverse (mapcar (lambda (x) (intern (coerce x 'string))) chlists))
)) ; END parse-chars



(defun str-to-output (str)
; ``````````````````````````
; Converts a string to a list of words/punctuation to output
; TEST: "The next step be putting the Twitter block on the Texaco block."
; 
  (let ((char-list (coerce str 'list)) word words)
    (dolist (c char-list)
      (cond
        ; If space, add accumulated word to word list and clear word
        ((member c '(#\ ) :test #'char-equal)
          (if word (setq words (cons (reverse word) words)))
          (setq word nil))
        ; If punctuation, add accumulated word to word list, clear word,
        ; and add punctuation to word list
        ((member c '(#\. #\, #\' #\") :test #'char-equal)
          (if word (setq words (cons (reverse word) words)))
          (setq word nil)
          (setq words (cons (intern (coerce (list c) 'string)) words)))
        ; Otherwise, add current character to accumulated word
        (t
          (setq word (cons c word)))))
    ; Read list of word symbols from list of strings.
    (reverse (mapcar (lambda (w)
      (if (listp w) (read-from-string (coerce w 'string)) w)) words)))
) ; END str-to-output