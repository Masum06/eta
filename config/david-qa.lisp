;;
;; *avatar* : specify the name of one of the available avatars to use
;;
;; *read-log-mode* : If T, reads and emulates each of the log files in logs/ directory, allows user corrections, and outputs new
;;                   log files in logs_out/
;;                   If a string corresponding to a file name, read just that file from logs/
;;                   (NOTE: currently only relevant to david/blocks world)
;;
;; *subsystems-perception* : A list of perception subsystems registered with Eta.
;;                           Supported: |Audio|, |Terminal|, |Blocks-World-System|
;;
;; *subsystems-specialist* : A list of specialist subsystems registered with Eta.
;;                           Supported: |Spatial-Reasoning-System|
;;
;; *emotion-tags* : T to allow insertion of emotion tags (e.g., [SAD]) at beginning of outputs. If no emotion tag is
;;                  explicitly specified in the output, a default [NEUTRAL] tag will be prepended.
;;                  NIL to disable emotion tags. Any tags at the beginning of :out directives will be stripped.
;;
;; *dependencies* : NIL to only include local packages (note that some applications may not work without Quicklisp dependencies).
;;                  Otherwise provide a list of quicklisp packages to be loaded at runtime.
;;
;; *safe-mode* : T to exit smoothly if exception is thrown during execution,
;;               NIL otherwise
;;
;; *user-id* : unique ID of user (potentially overwritten by sessionInfo.lisp if in live mode)
;;
;; *session-number* : the number session to load (a session-number of 1 corresponds to the files in the day1 directory of an avatar)
;;                    in a multi-session dialogue (potentially overwritten by sessionInfo.lisp if in live mode)
;;

(defparameter *avatar* "david-qa")
(defparameter *read-log-mode* NIL)
(defparameter *subsystems-perception* '(|Terminal| |Audio| |Blocks-World-System|))
(defparameter *subsystems-specialist* '(|Spatial-Reasoning-System|))
(defparameter *emotion-tags* NIL)
(defparameter *dependencies* '("ttt" "ulf-lib" "ulf2english" "ulf-pragmatics" "timegraph"))
(defparameter *safe-mode* NIL)
 