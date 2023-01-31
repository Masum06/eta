;; *ETA-SCHEMA*: development version 6
;;
;; TODO
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defparameter *eta-schema*

'(event-schema :header (((set-of ^me ^you) have-eta-dialog.v) ** ?e)
;`````````````````````````````````````````````````````````````````````
; An Eta dialogue focused around a simple doctor-patient discussion, intended to test the integration
; of GPT-3 with response generation.
;
; The dialogue follows a simple sequence of phases:
; 1. The patient asks about her pain (proceeds once doctor is sufficiently empathetic)
; 2. The patient asks about her prognosis (proceeds once doctor is sufficiently explicit)
; 3. The patient asks about her treatment options (proceeds once the doctor is sufficiently empowering)
; 4. The patient tries to close the conversation (ends once the doctor says some variant of "goodbye")
;

:types (
  !t1 (^me person.n)
  !t2 (^you person.n)
)

:rigid-conds (
  ; Sophie is a woman
  !r1 (^me ((pres be.v) (= (a.d woman.n))))
  ; Sophie is 65 years old
  !r2 (^me ((pres be.v) ((mod-a (65.a (plur year.n))) old.a)))
)

:static-conds (
  ; Sophie has lung cancer
  ?s1 (^me ((pres have.v) (k (lung.n cancer.n))))
)

:episodes (

?e1 (^me say-to.v ^you '(Hi\, doctor\. I\'m meeting with you today to help get some questions answered about my condition\.))
;; ?e1 (^me say-to.v ^you '(Hi\, doctor\. I\'m Sophie\. I\'m meeting with you today to help get some questions answered about my condition\.))
;; ?e1 (^me say-to.v ^you '(Hi\, my name is Sophie\. I\'m meeting with you today to help get some questions answered about my options and my future\.))

; For testing schemas
;; ?e2 (:repeat-until ((the.d conversation.n) be.v over.a)
;;   ?e3 ((set-of ^me ^you) ask-about-narcotic-addiction.v)
;; )

;; (pain)
?e2 ((set-of ^me ^you) ask-about-pain.v)


;; (prognosis)
;; ?e3 ((set-of ^me ^you) ask-about-prognosis.v)


;; (options)
;; ?e4 ((set-of ^me ^you) ask-about-options.v)


;; (say-bye)
?e5 ((set-of ^me ^you) say-bye.v)

)

)) ; END defparameter *eta-schema*



;````````````````````````````````````````````````````````
; Store schema variable name under header in *schemas*
;
(store-schema-name 'have-eta-dialog.v '*eta-schema*)



;````````````````````````````````````````````````````````
; Create empty hash tables for semantics,
; gist-clauses, and topic-keys
;
(setf (get '*eta-schema* 'semantics) (make-hash-table))
(setf (get '*eta-schema* 'gist-clauses) (make-hash-table))
(setf (get '*eta-schema* 'topic-keys) (make-hash-table))



;````````````````````````````````````````````````````````
; EL Semantics - Not yet used
;
(mapcar #'(lambda (x)
      (store-output-semantics (first x) (second x) '*eta-schema*))
  '()
) ; END mapcar #'store-output-semantics



;````````````````````````````````````````````````````````
; Gist clauses
;
(mapcar #'(lambda (x) 
      (store-output-gist-clauses (first x) (second x) '*eta-schema*))
  '()
) ; END mapcar #'store-output-gist-clauses



;````````````````````````````````````````````````````````
; Topic keys
;
(mapcar #'(lambda (x) 
      (store-topic-keys (first x) (second x) '*eta-schema*))
  '(
    (?e2 (Pain))
    (?e3 (Prognosis))
    (?e4 (Options))
    (?e5 (Say-bye))
  )
) ; END mapcar #'store-topic-keys
