; Ben Kane 7-16-2019
;
; Helper functions for working with ulf.
;

(defun special-op? (ulf)
; ````````````````````````
; Checks whether a ULF is a special operator or macro, e.g. sub, k, set-of, etc.
;
  (and (atom ulf) (member ulf '(not plur past pres perf prog pasv k ka ke to that tht fquan nquan nmod amod
                                *h *s *p set-of n+preds np+preds sub rep 's poss-by adv-a adv-e adv-f adv-s
                                ? ! = voc voc-O ds ans-to pu cf mod-a mod-n most-n poss-ques poss-ans)))
) ; END special-op?


(defun indiv? (ulf)
; ```````````````````
; Checks whether a ulf segment is an individual type (noun phrase,
; reified noun/action/sentence, etc.)
; TODO: until coref is improved, reified propositions/events/actions are not
; considered individual types
;
  (or
    ; Compound types
    (quan? ulf)
    ;; (reified-sentence? ulf)
    ;; (reified-action? ulf)
    ;; (reified-event? ulf)
    (det-np? ulf)
    (set-of? ulf)
    (kind? ulf)
    ; Atomic types
    (pron? ulf)
    (proper-name? ulf))
) ; END indiv?


(defun reference? (ulf)
; ```````````````````````
; TTT predicate to match a reference (anything that's an individual
; and not a pronoun).
;
  (and (indiv? ulf) (not (pron? ulf)))
) ; END reference?


(defun pron? (ulf)
; ````````````````````
; TTT predicate to match a pronoun (anything ending in .PRO, or a
; relative pronoun).
;
  (or (relative? ulf) (equal (second (sym-split ulf 4)) '.PRO))
) ; END pron?


(defun pronoun-perspective (pron)
; `````````````````````````````````
; Gets the perspective of a pronoun, i.e. '1s for first person singular,
; '2s for second person singular, '1p for first person plural, etc.
;
  (cond
    ((member pron '(I.pro me.pro myself.pro)) '1s)
    ((member pron '(you.pro yourself.pro)) '2s)
    ((member pron '(he.pro him.pro himself.pro she.pro her.pro herself.pro
                    one.pro oneself.pro themself.pro it.pro itself.pro that.pro)) '3s)
    ((member pron '(we.pro us.pro ourselves.pro)) '1p)
    ((member pron '(yourselves.pro)) '2p)
    ((member pron '(they.pro those.pro these.pro them.pro themselves.pro)) '3p))
) ; END pronoun-perspective


(defun male-pron? (pron)
; ````````````````````````
; Checks if a pronoun is male.
;
  (and (atom pron) (member pron '(he.pro him.pro himself.pro)))
) ; END male-pron?


(defun female-pron? (pron)
; `````````````````````````
; Checks if a pronoun is female.
;
  (and (atom pron) (member pron '(she.pro her.pro herself.pro)))
) ; END female-pron?


(defun person-pron? (pron)
; `````````````````````````
; Checks if a pronoun is person (singular).
;
  (and (atom pron) (member pron '(I.pro you.pro me.pro myself.pro yourself.pro one.pro oneself.pro themself.pro)))
) ; END person-pron?


(defun person-plur-pron? (pron)
; ``````````````````````````````
; Checks if a pronoun is person (plural).
;
  (and (atom pron) (member pron '(we.pro us.pro yourselves.pro)))
) ; END person-plur-pron?


(defun neutral-pron? (pron)
; ```````````````````````````
; Checks if a pronoun is neutral.
;
  (and (atom pron) (member pron '(it.pro that.pro itself.pro)))
) ; END neutral-pron?


(defun neutral-plur-pron? (pron)
; ```````````````````````````````
; Checks if a pronoun is neutral (plural).
;
  (and (atom pron) (member pron '(they.pro those.pro these.pro them.pro themselves.pro)))
) ; END neutral-plur-pron?


(defun existential-pron? (pron)
; ``````````````````````````````
; Checks if a pronoun is an existential pronoun.
;
  (and (atom pron) (member pron '(what.pro which.pro there.pro)))
) ; END existential-pron?


(defun ellipsis? (ulf)
; `````````````````````
; Check if a ULF is an ellipsis (i.e. curly brackets).
;
  (and (atom ulf) (equal (first (sym-split ulf 1 :front t)) '{))
) ; END ellipsis?


(defun replace-ellipsis! (ellipsis)
; ``````````````````````````````````
; Replaces an ellipsed item with entity.n in the case of nouns (e.g. {ref1}.n to entity.n),
; or the item without curly brackets otherwise (e.g. {you}.pro).
;
  (if (noun? ellipsis) 'entity.n
    (implode (remove-if (lambda (x) (member x '(#\{ #\}) :test #'char-equal)) (explode ellipsis))))
) ; END replace-ellipsis!


(defun det? (ulf)
; ```````````````````````
; Checks if a ULF is a determiner.
;
  (and (atom ulf) (equal (second (sym-split ulf 2)) '.D))
) ; END det?


(defun mod? (ulf)
; ````````````````
; Checks if a ULF is some simple noun phrase modifier (either adj or nominal predicate)
;
  (or (adj? ulf) (noun? ulf) (and (no-type? ulf) (not (proper-name? ulf))))
) ; END mod?


(defun adj? (ulf)
; ````````````````
; Checks if a ULF is an adjective.
;
  (and (atom ulf) (equal (second (sym-split ulf 2)) '.A))
) ; END adj?


(defun color? (ulf)
; ``````````````````
; Checks if ULF is a color adjective.
; NOTE: in the future, we may want to do this using an ontology instead.
;
  (and (atom ulf) (member ulf '(red.a orange.a yellow.a green.a blue.a
    indigo.a violet.a purple.a pink.a black.a gray.a grey.a white.a)))
) ; END color?


(defun color-prop? (ulf)
; ```````````````````````
; Checks if a ULF is a proposition about color.
;
  (and (listp ulf) (= 2 (length ulf)) (listp (second ulf)) (color? (first (second ulf))))
) ; END color-prop?


(defun adv-e? (ulf)
; ``````````````````
; Checks if a ULF is an adv-e word or phrase.
;
  (or (adv-e-lex? ulf)
      (and (listp ulf) (equal (car ulf) 'ADV-E)))
) ; END adv-e?


(defun adv-e-lex? (ulf)
; ```````````````````````
; Checks if a ULF is an adv-e word.
;
  (and (atom ulf) (equal (second (sym-split ulf 6)) '.ADV-E))
) ; END adv-e-lex?


(defun adv-a? (ulf)
; ``````````````````
; Checks if a ULF is an adv-a word or phrase.
;
  (or (adv-a-lex? ulf)
      (and (listp ulf) (equal (car ulf) 'ADV-A)))
) ; END adv-a?


(defun adv-a-lex? (ulf)
; ```````````````````````
; Checks if a ULF is an adv-a word.
;
  (and (atom ulf) (equal (second (sym-split ulf 6)) '.ADV-A))
) ; END adv-a-lex?


(defun noun? (ulf)
; `````````````````
; Checks if a ULF is a nominal predicate.
;
  (or (and (atom ulf) (equal (second (sym-split ulf 2)) '.N))
    (and (plur? ulf) (equal (second (sym-split (second ulf) 2)) '.N)))
) ; END noun?


(defun verb-untensed? (ulf)
; ``````````````````````````
; Checks if a ULF is an untensed verb.
;
  (and (atom ulf) (equal (second (sym-split ulf 2)) '.V))
) ; END verb-untensed?


(defun verb-pres? (ulf)
; ``````````````````````
; Checks if a ULF is a verb in present tense (no aspect).
;
  (and (listp ulf) (equal (first ulf) 'PRES) (verb-untensed? (second ulf)))
) ; END verb-pres?


(defun verb-past? (ulf)
; ``````````````````````
; Checks if a ULF is a verb in past tense (no aspect).
;
  (and (listp ulf) (equal (first ulf) 'PAST) (verb-untensed? (second ulf)))
) ; END verb-past?


(defun verb? (ulf)
; ``````````````````
; Checks if a ULF is a verb in any tense.
; TODO: incomplete, needs aspects still. Might get a bit messy with both tense & aspect.
;
  (or (verb-untensed? ulf) (verb-pres? ulf) (verb-past? ulf))
) ; END verb?


(defun spatial-verb? (ulf)
; `````````````````````````
; Checks if a ULF is a spatial verb.
;
  (if (and (atom ulf)
    (member ulf '(touch.v support.v connect.v consist_of.v sit.v adjoin.v flank.v face.v))) t nil)
) ; END spatial-verb?


(defun action-verb? (ulf)
; ````````````````````````
; Checks if a ULF is an action verb.
;
  (if (and (atom ulf)
    (member ulf '(move.v put.v change.v pick_up.v rotate.v place.v))) t nil)
) ; END action-verb?


(defun spatial-verb-to-prep! (ulf)
; `````````````````````````````````
; Converts some spatial verbs to relational prepositions, e.g. touch.v => touching.p.
;
  (if (verb-untensed? ulf)
    (let* ((verb-rel-pairs '((touch.v touching.p) (support.v supporting.p) (connect.v connecting.p)
                            (consist_of.v consisting_of.p) (sit.v sitting.p) (adjoin.v adjoining.p)
                            (flank.v flanking.p) (face.v facing.p)))
          (pair (find ulf verb-rel-pairs :key #'car)))
      (second pair)))
) ; END spatial-verb-to-prep


;; (verb-rel touch support connect consist_of sit adjoin flank face
;;       move put change pick_up rotate place)


(defun aux? (ulf)
; `````````````````
; Checks if a ULF is an auxiliary verb (untensed).
;
  (and (atom ulf) (member (second (sym-split ulf 6)) '(.AUX-S .AUX-V)))
) ; END aux?


(defun verb-phrase? (ulf)
; ````````````````````````
; Checks if a ULF is a verb phrase.
; NOTE: no verb categorization checks are done here, this simply returns true if the car of the list
; is some individual, and the car of the second element of the list is a verb.
; TODO: the indiv? condition is skipped currently due to the current exclusion of block names in the indiv? function.
;
  (and (listp ulf) (= 2 (length ulf)) (listp (second ulf)) (verb? (car (second ulf)))
      ;;  (indiv? (car ulf))
       )
) ; END verb-phrase?


(defun add-vp-tense! (vp+ tense)
; ````````````````````````````````
; Adds the given tense marker to the given verb phrase.
; Recursively search for first *.v or *.aux in depth first search.
;
; The first argument is a list of a verb phrase plus additional
; phrases that are wrapped around the vp at the end.
;
; (run.v) past -> (past run.v)
; ((run.v (k home.n))) past -> ((past run.v) (k home.n))
; (((call.v again.adv-a) later.adv-e)) pres
;   -> (((pres call.v) again.adv-a) later.adv-e)
;
; NOTE: Taken from Gene Kim's ulf-pragmatics library.
;
  (labels 
    ((rechelper (vp)
       (cond 
         ;; Base case: found the verb/aux -- add tense and return.
         ((and (atom vp) (or (verb-untensed? vp) (aux? vp))) (list tense vp))
         ;; Base case: other atom, simply return value.
         ((atom vp) vp)
         ;; Recursive case:
         ;;  recurse left, 
         ;;    if returned val is diff, reconstruct and return
         ;;    else recurse to right.
         (t 
           (let ((leftrec (rechelper (car vp))))
             (if (not (equal leftrec (car vp)))
               (cons leftrec (cdr vp))
               (cons (car vp) (rechelper (cdr vp))))))))
     ) ; end of labels definitions.
   
    ;; Main body.
    (if (not (listp vp+))
      (setf vp+ (list vp+)))
    (let ((tvp (rechelper (car vp+)))
          (additional (cdr vp+)))
      (reduce #'list additional :initial-value tvp)))
) ; END add-vp-tense!


(defun remove-question-do (ulf)
; ``````````````````````````````
; Removes any 'do' auxiliaries in a question ULF, unless followed by a negation.
; 
  (if (ttt:match-expr '(^* ((tense? do.aux-s) not _*)) ulf)
    ulf
    (ttt:apply-rule '(/ ((tense? do.aux-s) _* (verb-untensed? _*1)) (_* ((tense? verb-untensed?) _*1))) ulf))
) ; END remove-question-do


(defun remove-question-mark (ulf)
; `````````````````````````````````
; Removes question mark in ULF.
;
  (ttt:apply-rule '(/ (_* qmark?) _*) ulf)
) ; END remove-question-mark


(defun apply-sub-macro (ulf)
; ````````````````````````````
; Applies the sub macro to a ULF.
;
  (nth-value 1 (ulf-lib:apply-sub-macro ulf :calling-package *package*))
) ; END apply-sub-macro


(defun uninvert-question (ulf)
; ``````````````````````````````
; Uninvert a ULF question by removing the question mark, applying sub macros, and removing auxiliary verbs such as "do".
;
  (setq ulf (remove-question-mark ulf))
  (setq ulf (remove-question-do ulf))
  (apply-sub-macro ulf)
) ; END uninvert-question


(defun existential-there? (ulf)
; ``````````````````````````````
; Checks if ULF is an existential 'there'.
;
  (and (atom ulf) (equal ulf 'THERE.PRO))
) ; END existential-there?


(defun relative? (ulf)
; `````````````````````
; Checks if a ULF is a relative pronoun.
;
  (and (atom ulf) (equal (second (sym-split ulf 4)) '.REL))
) ; END relative?


(defun reflexive? (ulf)
; ``````````````````````
; Checks if a ULF is a reflexive pronoun.
;
  (and (pron? ulf)
    (if (member ulf '(myself.pro yourself.pro yourselves.pro himself.pro herself.pro
                  oneself.pro itself.pro ourselves.pro themselves.pro)) t))
) ; END relative?


(defun anaphor? (ulf)
; ``````````````````````
; Checks if a ULF is an anaphoric pronoun.
;
  (and (pron? ulf)
    (not (relative? ulf)) (not (reflexive? ulf)) (not (wh-pron? ulf)))
) ; END relative?


(defun prep? (ulf)
; `````````````````
; Checks if a ULF is a preposition, e.g. on.p
;
  (and (symbolp ulf) (equal (second (sym-split ulf 2)) '.P))
) ; END prep?


(defun prep-phrase? (ulf)
; ````````````````````````````````
; Checks if a ULF is a prepositional phrase, e.g. (on.p (the.d table.n)).
;
  (and (listp ulf) (atom (car ulf)) (prep? (car ulf)))
) ; END prep-phrase?


(defun prep-conjunction? (ulf)
; `````````````````````````````
; Checks if a ULF is a conjunction of two prepositions,
; e.g. ((before.p ...) and.cc (after.p ...))
;
  (and (listp ulf) (= 3 (length ulf)) (prep-phrase? (first ulf))
       (equal 'and.cc (second ulf)) (prep-phrase? (third ulf)))
) ; END prep-conjunction?


(defun sentential-preposition? (ulf)
; ````````````````````````````````````
; Checks if a ULF is a sentential preposition (because.ps, while.ps, etc.).
;
  (and (atom ulf) (equal (second (sym-split ulf 3)) '.PS))
) ; END sentential-preposition?


(defun discourse-entity? (ulf)
; ````````````````````````````
; Checks if a ULF is a discourse entity (ends in .de).
;
  (and (atom ulf) (equal (second (sym-split ulf 3)) '.DE))
) ; END discourse-entity?


(defun reified-sentence? (ulf)
; `````````````````````````````
; Checks if a ULF is a reified sentence ("that ...").
;
  (and (listp ulf) (member (car ulf) '(that tht ans-to whether)))
) ; END reified-sentence?


(defun reified-action? (ulf)
; `````````````````````````````
; Checks if a ULF is a reified action ("to ...")
;
  (and (listp ulf) (member (car ulf) '(ka to)))
) ; END reified-action?


(defun reified-event? (ulf)
; `````````````````````````````
; Checks if a ULF is a reified event ("ke ...")
;
  (and (listp ulf) (member (car ulf) '(ke)))
) ; END reified-event?


(defun no-type? (ulf)
; ````````````````````
; Checks whether ULF is a symbol with no type, e.g. |NVidia|, |Ben|, etc.
;
  (and (symbolp ulf) (not (special-op? ulf)) (not (sym-contains ulf #\.)))
) ; END no-type?


(defun nnp? (ulf)
; `````````````````
; Check if ULF is a proper names which can act as an nnp.
; TODO: See comment on proper-name?
;
  (and (symbolp ulf)
    (member ulf '(|Adidas| |Burger King| |Esso| |Heineken| |HP | |HP| |McDonalds| |Mercedes|
                  |NVidia| |Pepsi| |SRI | |SRI| |Starbucks| |Texaco| |Target| |Toyota| |Shell| |Twitter|)))
) ; END nnp?


(defun proper-name? (ulf)
; `````````````````````````
; Checks if a ULF is a proper name.
; TODO: Due to the way company names act as modifiers in the blocks world ULF, we have to do
; a check here so these aren't counted as individuals. This is a bit odd and should be changed
; in the future.
;
  (and (no-type? ulf)
    (not (nnp? ulf)))
) ; END proper-name?


(defun det-np? (ulf)
; ````````````````
; Checks if a ULF is a noun phrase starting with a determiner.
;
  (and (listp ulf) (det? (car ulf)))
) ; END det-np?


(defun definite-np? (ulf)
; `````````````````````````
; Checks if a ULF is a definite noun phrase.
;
  (and (det-np? ulf) (or
    (member (first ulf) '(the.d))
    (and (equal (first ulf) 'np+preds) (definite-np? (second ulf)))))
) ; END definite-np?


(defun quant-np? (ulf)
; `````````````````````
; Checks if a ULF is a quantificational noun phrase.
;
  (and (listp ulf) (numerical-det? (first ulf)))
) ; END quant-np?


(defun indexical-np? (ulf)
; `````````````````````````
; Checks if a ULF is an indexical noun phrase (e.g. "that block")
;
  (and (det-np? ulf) (or
    (member (first ulf) '(that.d this.d those.d))
    (and (equal (first ulf) 'np+preds) (indexical-np? (second ulf)))))
) ; END indexical-np?


(defun wh-np? (ulf)
; `````````````````````````
; Checks if a ULF is an wh-question noun phrase (e.g. "what block")
;
  (and (det-np? ulf) (or
    (member (first ulf) '(which.d what.d whichever.d whatever.d))
    (and (equal (first ulf) 'np+preds) (wh-np? (second ulf)))))
) ; END wh-np?


(defun wh-pron? (ulf)
; `````````````````````````
; Checks if a ULF is an wh-question noun phrase (e.g. "what block")
;
  (and (pron? ulf) (member ulf '(what.pro which.pro)))
) ; END wh-pron?


(defun indefinite-np? (ulf)
; ``````````````````````````
; Checks if a ULF is an indefinite noun phrase.
;
  (and (det-np? ulf) (or
    (member (first ulf) '(a.d some.d any.d))
    (set-of? ulf)
    (kind? ulf)
    (quan? ulf)
    (and (equal (first ulf) 'np+preds) (indefinite-np? (second ulf)))))
) ; END indefinite-np?


(defun set-of? (ulf)
; ```````````````````
; Checks if a ULF is a set-of some individuals.
;
  (and (listp ulf) (equal (first ulf) 'set-of))
) ; END set-of?


(defun kind? (ulf)
; ``````````````````
; Checks if a ULF is a kind (e.g. using the k operator).
;
  (and (listp ulf) (equal (first ulf) 'k))
) ; END kind?


(defun quan? (ulf)
; ``````````````````
; Checks if a ULF has fquan or nquan.
;
  (and (listp ulf) (listp (first ulf)) (member (first (first ulf)) '(fquan nquan)))
) ; END quan?


(defun plur? (ulf)
; `````````````````
; Checks if a ULF is plural (recursively)
;
  (if (atom ulf) (equal ulf 'plur)
    (some #'plur? ulf))
) ; END plur?


(defun remove-plur (ulf)
; ```````````````````````
; Removes plur from ULF.
;
  (if (atom ulf) (if (equal ulf 'plur) nil ulf)
    (let ((tmp (remove nil (mapcar #'remove-plur ulf))))
      (if (and (listp tmp) (= (length tmp) 1)) (car tmp) tmp)))
) ; END remove-plur


(defun numerical-adj! (ulf)
; ``````````````````````````
; If ULF is a numerical adjective (e.g. "5.a" or "five.a"), return the corresponding
; number, or nil otherwise.
; 
  (if (numberp ulf) (return-from numerical-adj! ulf))
  (if (not (adj? ulf)) (return-from numerical-adj! nil))
  (let ((adj (read-from-string (string (first (sym-split ulf 2))))))
    (cond
      ((numberp adj) adj) ((equal adj 'zero) 0) ((equal adj 'one) 1)
      ((equal adj 'two) 2) ((equal adj 'three) 3) ((equal adj 'four) 4)
      ((equal adj 'five) 5) ((equal adj 'six) 6) ((equal adj 'seven) 7)
      ((equal adj 'eight) 8) ((equal adj 'nine) 9) ((equal adj 'ten) 10)
      ((equal adj 'first) 1) ((equal adj 'second) 2) ((equal adj 'third) 3)
      ((equal adj 'fourth) 4) ((equal adj 'fifth) 5) ((equal adj 'sixth) 6)
      ((equal adj 'seventh) 7) ((equal adj 'eigth) 8) ((equal adj 'ninth) 9)
      ((equal adj 'tenth) 10)))
) ; END numerical-adj!


(defun numerical-adj? (ulf)
; ``````````````````````````
; Check if ULF is a numerical adjective.
;
  (if (and (symbolp ulf) (or
    (member ulf '(zero.a one.a two.a three.a four.a five.a six.a seven.a eight.a nine.a ten.a
                  eleven.a twelve.a thirteen.a fourteen.a fifteen.a sixteen.a seventeen.a
                  eighteen.a nineteen.a twenty.a thirty.a forty.a fifty.a sixty.a seventy.a
                  eighty.a ninety.a one_hundred.a first.a second.a third.a fourth.a fifth.a
                  sixth.a seventh.a eighth.a ninth.a tenth.a))
    (numberp (read-from-string (format nil "~a" (car (sym-split ulf 2))))))) t)
) ; END numerical-adj?


(defun num-to-adj (num)
; ````````````````````````
; Converts a number to a ULF adjective (e.g. 5 => FIVE.A)
; 
  (cond
    ((= num 0) 'zero.a) ((= num 1) 'one.a)  ((= num 2) 'two.a) ((= num 3) 'three.a)
    ((= num 4) 'four.a) ((= num 5) 'five.a) ((= num 6) 'six.a) ((= num 7) 'seven.a)
    ((= num 8) 'eight.a) ((= num 9) 'nine.a) ((= num 10) 'ten.a) ((= num 11) 'eleven.a)
    ((= num 12) 'twelve.a) ((= num 13) 'thirteen.a) ((= num 14) 'fourteen.a)
    ((= num 15) 'fifteen.a) ((= num 16) 'sixteen.a) ((= num 17) 'seventeen.a)
    ((= num 18) 'eighteen.a) ((= num 19) 'nineteen.a) ((= num 20) 'twenty.a)
    ((= num 30) 'thirty.a) ((= num 40) 'forty.a) ((= num 50) 'fifty.a)
    ((= num 60) 'sixty.a) ((= num 70) 'seventy.a) ((= num 80) 'eighty.a)
    ((= num 90) 'ninety.a) ((= num 100) 'one_hundred.a)
    (t (intern (format nil "~a.A" num))))
) ; END num-to-adj


(defun numerical-det! (ulf)
; ``````````````````````````
; If ULF is a numerical determiner (e.g. "two.d"), return the corresponding
; number, or nil otherwise.
; 
  (if (not (det? ulf)) (return-from numerical-det! nil))
  (cond
    ((equal ulf 'zero.d) 0) ((equal ulf 'one.d) 1) ((equal ulf 'two.d) 2)
    ((equal ulf 'three.d) 3) ((equal ulf 'four.d) 4) ((equal ulf 'five.d) 5)
    ((equal ulf 'six.d) 6) ((equal ulf 'seven.d) 7) ((equal ulf 'eight.d) 8)
    ((equal ulf 'nine.d) 9) ((equal ulf 'ten.d) 10))
) ; END numerical-det!


(defun numerical-det? (ulf)
; ``````````````````````````
; Check if ULF is a numerical determiner.
;
  (and (symbolp ulf)
    (member ulf '(zero.d one.d two.d three.d four.d five.d six.d
                  seven.d eight.d nine.d ten.d eleven.d twelve.d
                  thirteen.d fourteen.d fifteen.d sixteen.d seventeen.d
                  eighteen.d nineteen.d twenty.d thirty.d forty.d fifty.d
                  sixty.d seventy.d eighty.d ninety.d one_hundred.d)))
) ; END numerical-det?


(defun tense? (ulf)
; ```````````````````
; Checks if ULF is a tense operator
; 
  (if (member ulf '(past pres)) t nil)
) ; END tense?


(defun aspect? (ulf)
; ```````````````````
; Checks if ULF is an aspect operator
; 
  (if (member ulf '(perf prog)) t nil)
) ; END aspect?


(defun get-tense (ulf)
; `````````````````````
; Gets the tense of a sentence ULF.
;
  (cond
    ((tense? ulf) ulf)
    ((atom ulf) nil)
    (t (some #'get-tense ulf)))
) ; END get-tense


(defun get-aspect (ulf)
; ``````````````````````
; Gets the aspect of a sentence ULF.
;
  (cond
    ((aspect? ulf) ulf)
    ((atom ulf) nil)
    (t (some #'get-aspect ulf)))
) ; END get-aspect


(defun get-quan (ulf)
; ````````````````````
; Gets the quantity of a quantificational noun phrase. Returns the
; noun phrase without the quantificational modifier.
; NODE: Modify to return quantificational noun phrase without quant adj, along with number
;
  (if (atom ulf) (numerical-adj! ulf)
    (some #'get-quan ulf))
) ; END get-quan


(defun remove-quan (ulf)
; ```````````````````````
; Removes quantificational modifier from ULF.
;
  (if (atom ulf) (if (numerical-adj! ulf) nil ulf)
    (let ((tmp (remove nil (mapcar #'remove-quan ulf))))
      (if (and (listp tmp) (= (length tmp) 1)) (car tmp) tmp)))
) ; END remove-quan


(defun copulative? (v)
; `````````````````````
; Checks whether v is a copulative verb, e.g. be.v
;
  (member v '(be.v))
) ; END copulative?


(defun relation-prop? (prop)
; ````````````````````````````
; Checks whether a proposition is a relation, i.e. (|Twitter| on.p |Texaco|).
;
  (and (listp prop) (or (nnp? (first prop)) (restricted-variable? (first prop)))
    (or (nnp? (third prop)) (restricted-variable? (third prop))) (prep? (second prop)))
) ; END relation-prop?


(defun after-prop? (prop)
; ````````````````````````````
; Checks whether a proposition is an after relation, i.e. after.p.
;
  (and (listp prop) (>= (length prop) 2) (equal (second prop) 'after.p))
) ; END after-prop?


(defun before-prop? (prop)
; ````````````````````````````
; Checks whether a proposition is an before relation, i.e. before.p.
;
  (and (listp prop) (>= (length prop) 2) (equal (second prop) 'before.p))
) ; END before-prop?


(defun loc-record? (list)
; `````````````````````````
; Checks whether a list is a location record of form ($ loc ?x ?y ?z)
;
  (and (listp list) (= (length list) 5) (equal '$ (first list)) (equal 'loc (second list))
    (every #'numberp (cddr list)))
) ; END loc-record?


(defun at-loc-prop? (prop)
; ```````````````````````````
; Checks whether a proposition is an at-loc.p formula.
; i.e. (|Twitter| at-loc.p ($ loc ?x ?y ?z))
;
  (and (listp prop) (= (length prop) 3) (equal (second prop) 'at-loc.p) (loc-record? (third prop)))
) ; END at-loc-prop?


(defun move-prop? (prop)
; `````````````````````````
; Checks whether a proposition is a move.v formula.
; i.e. (|Toyota| ((past move.v) (from.p-arg ($ loc ?x1 ?y1 ?z1)) (to.p-arg ($ loc ?x2 ?y2 ?z2))))
;
  (and (listp prop) (= (length prop) 2) (listp (second prop)) (= (length (second prop)) 3)
    (equal (first (second prop)) '(past move.v)) (listp (second (second prop))) (listp (third (second prop)))
    (loc-record? (second (second (second prop)))) (loc-record? (second (third (second prop)))))
) ; END move-prop?


(defun same-sentence? (de1 de2 ulf)
; ``````````````````````````````````
; Checks whether de1 and de2 are in the same ulf sentence.
;
  (labels ((find-sk (de ulf-part)
    (cond
      ((null ulf-part) nil)
      ((equal ulf-part de) t)
      ((discourse-entity? ulf-part)
        (find-sk de (get ulf-part 'ulf)))
      ((atom ulf-part) nil)
      (t (some (lambda (x) (find-sk de x)) ulf-part)))))
  (and (find-sk de1 ulf) (find-sk de2 ulf)))
) ; END same-sentence?


(defun precise-construct? (de1 de2 ulf)
; ```````````````````````````````````````
; Checks whether de2 is related to de1 through some precise construct, e.g. appositive, relative pronoun, etc.
;
  (or
    ; Appositive
    (ttt:match-expr `(_!1 (n+preds _!2 _*1 (= ,de2) _*2)) (get de1 'ulf))
    (ttt:match-expr `(^* (np+preds ,de1 _*1 (= ,de2) _*2)) ulf)
    ; Predicate nominative
    (ttt:match-expr `(^* (,de1 ((pres copulative?) (= ,de2) _*))) ulf)
    ; Relative pronoun
    ; NOTE: What if we have nested relative pronouns (e.g. the block that is on top of the block that is to the left of ...)?
    ; I anticipate this being a problem...
    ; NOTE: Add it-clefts? e.g. "it was to Rome that he travelled"
    (and (equal 'relative (get de2 'cat)) (or
      (ttt:match-expr `(_!1 (n+preds _!2 _*1 (^* ,de2) _*2)) (get de1 'ulf))
      (ttt:match-expr `(^*1 (np+preds ,de1 _*1 (^*2 ,de2) _*2)) ulf))))
) ; END precise-construct?


(defun local? (phrase1 phrase2 ulf)
; ``````````````````````````````````
; Checks whether phrase1 is a local ancestor to phrase2; i.e. if there is no other discourse entity standing
; between (blocking) phrase1 and phrase2, and phrase1 and phrase2 are both in the same sentence/clause.
;
; NOTE: This is a rather tricky matter in general, since sentences like "The woman told Martha about herself"
; can have both readings, one in which 'herself' refers to 'the woman' (even though 'Martha' stands between the
; two) and one in which 'herself' refers to Martha. It seems that the 'blocking' criterion applies strictly in
; cases with 'to ...', but not necessarily predicates in general, so this functon is implemented correspondingly.
;
  (let (blocker-found)
    (labels
      ; Finds the sub-ulf directly following phrase1
      ((find-list (ulf-part)
        (cond
          ((atom ulf-part) nil)
          ((member phrase1 ulf-part :test #'equal) (cdr (member phrase1 ulf-part :test #'equal)))
          (t (some (lambda (x) (find-list x)) ulf-part))))
      ; Check if phrase2 is local to phrase1
      (local-recur (ulf-part)
        (cond
          ; If the current ulf-part matches phrase2, we have a match
          ((equal ulf-part phrase2) t)
          ; If a clause-forming operator is found (n+preds/np+preds due to relative clauses), do not search any deeper
          ((and (listp ulf-part) (or (sentential-preposition? (first ulf-part)) (member (first ulf-part) '(n+preds np+preds that tht ans-to))))
            nil)
          ; If an action/event reifer is found, return true only if no blocker has been found
          ((and (listp ulf-part) (member (first ulf-part) '(to ka ke)))
            (if (some (lambda (x) (local-recur x)) ulf-part) (if blocker-found nil t) nil))
          ; If some other individual is found, tentatively set the 'blocker-found' tag to true and return no match
          ((indiv? ulf-part) (setq blocker-found t) nil)
          ; If any other atom is found, return no match
          ((atom ulf-part) nil)
          ; Otherwise, recursively check if we have a match anywhere
          (t (if (some (lambda (x) (local-recur x)) ulf-part) t nil)))))
  (local-recur (find-list ulf))))
) ; END local?


(defun c-command? (phrase1 phrase2 ulf)
; ``````````````````````````````````````
; Checks whether phrase1 c-commands phrase2 in a given ulf.
;
  (ttt:match-expr `(^* (_*1 ,phrase1 _*2 (^* ,phrase2) _*3)) ulf)
) ; END c-command?


(defun sym-split (sym n &key front)
; ```````````````````````````````````
; Splits a symbol into two symbols at index n from the end.
; (or if :front t is given, n from the front)
;
  (if (and (atom sym) (> (length (string sym)) n))
    (let ((lex (string sym)))
      (if front
        (list (intern (subseq lex 0 n))
          (intern (subseq lex n (length lex))))
        (list (intern (subseq lex 0 (- (length lex) n)))
          (intern (subseq lex (- (length lex) n) (length lex)))))))
) ; END sym-split


(defun sym-contains (sym char)
; ``````````````````````````````
; Returns true if a symbol contains the character given by char.
;
  (if (member char (explode sym) :test #'char-equal) t)
) ; END sym-contains


(defun remove-type (s)
;```````````````````````
; Removes the type extension of a symbol, i.e. (remove-type man.n) => man
;
  (let ((has-dot (member #\. (reverse (coerce (string s) 'list)))))
    (if has-dot (intern (coerce (reverse (cdr has-dot)) 'string)) s))
) ; END remove-type