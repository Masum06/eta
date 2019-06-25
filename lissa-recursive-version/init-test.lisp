;; File for testing the initial version of the spatial QA version of LISSA
;; June 10/19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "/p/nl/tools/ttt/src/load"); needed: lissa6.lisp references ttt:...
(setq *use-latency* nil)
(setq *count* 0)
(load "lissa6.lisp")
(load "general-word-data.lisp")
;(load "rules-for-spatial-questions.lisp")
;(load "rules-for-spatial-questions-v2.lisp")
;(load "rules-for-spatial-questions-v3.lisp")
;(load "rules-for-spatial-questions-v4.lisp");
;(load "rules-for-spatial-questions-v5.lisp");
(load "rules-for-spatial-questions-v7.lisp"); this sets *spatial-question-ulf-tree*
                                            ; in lissa6.lisp, 'form-ulf-from-clause';
                                            ; If changing the root for spatial 
                                            ; question interpretation, be sure to 
                                            ; edit 'form-ulf-from-clause'
(load "rules-for-between-questions.lisp"); ** NEW RULES -- STILL TO BE TESTED 
(load "eval-lexical-ulfs.lisp")
(load "stem.lisp")

;; A tracing combination I found to be good:
;; (trace match1 choose-result-for lex-ulf!); match1 is a top-level trace of 'match'
;;
;; Additional possibilities:
;; (trace match); gory details of pattern matching
;; (trace choose-result-for1); detailed recursion
;; (trace instance) ; some more information
;;
;; some test questions (more can be seen alongside the rules in the rule trees):
;; ````````````````````````````````````````````````````````````````````````````
;; (setq clause '(Is the Nvidia block on the Mercedes block ?)); ok
;; (setq clause '(Is there a red block on the Mercedes block ?)); ok
;; (setq clause '(Is there a red Nvidia block on top of the Mercedes block ?)); ok
;; (setq clause '(is the Mcdonalds block to the left of a red block ?)); ok
;; (setq clause '(Is there anything behind the NVidia block ?)); ok
;;    (((PRES BE.V) THERE.PRO ANYTHING.PRO (BEHIND.P (THE.D (|NVidia| BLOCK.N)))) ?)
;;    Should it perhaps be (ANY.D (N+PREDS THING.N (BEHIND.P (THE.D ...)))) ???
;; (setq clause '(Are the two green blocks touching ?)); ok
;; (setq clause '(are there two green blocks on the table that are near each other ?))
                                                                          ; ok  
;; (setq clause '(are there any clear blocks on the table ?)); ok
;; (setq clause '(which block is the mercedes block on top of ?)); ok
;; (setq clause '(What block is to the left of the Burger King block ?)); fails
                                               ; because "Burger King" is 2 words
;; (setq clause '(What block is to the left of the Burger_King block ?)); ok 
;; (setq clause '(Is the nvidia block visible ?)); ok

;; (setq clause '(Where is the NVidia block ?)); ok
;; (setq clause '(what is the highest red block ?))
;; (setq clause '(What color block is to the left of the NVidia block ?)); ok
;;                     ``````````` interpreted as (color.a block.n)
;; (setq clause '(What is the block next to the farthest blue block ?)); ok
;; (setq clause '(how many blocks are there ?)); ok
;; (setq clause '(How many blocks are there on the table ?)); ok
;; (setq clause '(How many blocks are there on red blocks ?)); ok
;; (setq clause '(what color is the NVidia block ?)); ok
;; (setq clause '(what block is on the red block ?)); ok
;; (setq clause '(is there a red block between a blue block and a green block ?); ok
;; (setq clause '(are there any red blocks between a blue and a green block ?));ok
;; (setq clause '(Is there anything between the NVidia and Mercedes blocks ?)); ok
;; (setq clause '(What red blocks are between the Nvidia and Mercedes blocks ?));ok
;; (setq clause '(what color block is between a red and a blue block ?)); ok
;; (setq clause '(what color is the block between the NVidia and Mercedes blocks ?));ok
;; (setq clause '(what is the block between a red block and a blue block ?)); ok
;; (setq clause '(How many blocks are there between a red block and a blue block ?)); ok
;; (setq clause '(On top of what object is the Nvidia block ?)); ok
;; (setq clause '(does any block support the NVidia block ?)); ok
;; (setq clause '(does any block sit between the Nvidia and Mercedes blocks ?)); ok


;; Computing the result:
;; `````````````````````
;; (format t "~s" (form-ulf-from-clause clause))
;;
;; or for convenience,
;; (out), where
;; (defun out () (format t "~s" (form-ulf-from-clause clause)))



;; Some results:
;;
;; are there two green blocks on the table that are near each other ?
;; (Initial quotes so as not to freak the Lisp reader when loading this file)
'(((PRES BE.V) THERE.PRO
  (TWO.D
   (N+PREDS (GREEN.A (PLUR BLOCK.N)) (ON.P (THE.D TABLE.N))
    (THAT.REL ((PRES BE.V) (NEAR.P (EACH.D OTHER.N)))))))
 ?)

;; are there any clear blocks on the table ?
'(((PRES BE.V) THERE.PRO (ANY.D (CLEAR.A (PLUR BLOCK.N)))
  (ON.P (THE.D TABLE.N)))
 ?)

;; Where is the Nvidia block ?
'((SUB (AT.P (WHAT.D PLACE.N))
  ((PRES BE.V) (THE.D |NVidia| BLOCK.N) *H))
 ?)

;; What is the highest red block ?
'((WHAT.PRO ((PRES BE.V) (THE.D (MOST-N HIGH.A (RED.A BLOCK.N))))) ?)

;; What is the block next to the farthest blue block ?
'((WHAT.PRO
  ((PRES BE.V)
   (THE.D
    (N+PREDS BLOCK.N
     (NEXT_TO.P (THE.D (MOST-N FAR.A (BLUE.A BLOCK.N))))))))
 ?)

;; (setq clause '(what color is the block between the NVidia and Mercedes blocks ?))
'((SUB ({OF}.P (WHAT.D COLOR.N))
  ((PRES BE.V)
   (THE.D
    (N+PREDS BLOCK.N
     (BETWEEN.P
      ((THE.D (|NVidia| BLOCK.N)) AND.CC
       (THE.D (|Mercedes| BLOCK.N))))))
   *H))
 ?)

;; (setq clause '(what is the block between a red block and a blue block ?))
'((WHAT.PRO
  ((PRES BE.V)
   (= (THE.D
       (N+PREDS BLOCK.N
        (BETWEEN.P
         ((A.D (RED.A BLOCK.N)) AND.CC (A.D (BLUE.A BLOCK.N)))))))))
 ?)

;; (setq clause '(On top of what object is the Nvidia block ?))
'((SUB (ON_TOP_OF.P (WHAT.D OBJECT.N))
  ((PRES BE.V) (THE.D (|NVidia| BLOCK.N)) *H))
 ?)

;; (setq clause '(does any block sit between the Nvidia and Mercedes blocks ?))
'((DOES.V (ANY.D BLOCK.N)
  (SIT.V
   (ADV-E
    (BETWEEN.P
     ((THE.D (|NVidia| BLOCK.N)) AND.CC
      (THE.D (|Mercedes| BLOCK.N)))))))
 ?)

