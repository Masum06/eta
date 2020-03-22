; Ben's version of "rules-for-between-questions.lisp" -- July 22/19
; This is the file for "between" rules. These are a bit tricky, because 
; the complement of "between" either can be a plural ("between two red
; blocks") or a full NP conjunction ("between a red block and a blue
; block"), or a conjunction with ellipsis ("between a red and a blue
; block"; "between the Toyota and the SRI block"; "between the Toyota
; and SRI blocks").
;
; ====================================================================

; The following rules are only reached by questions containing "between"


; TBC -- assuming we're unlikely to get postmod examples like "the block between 
; two red blocks? Otherwise, we'd need an *np-between-ulf-tree* and  
; *n1-between-ulf-tree* to allow for this

(READRULES '*pp-between-ulf-tree*
; ````````````````````````````````````
; Parses prepositional phrases with between in them.
;
'(
    ; Recursive if there's some premodifier or other item preceding preposition
    1 (there between 9 noun); e.g., there between the Esso and NVidia blocks
       2 (((*pp-between-ulf-tree* 2 3 4)) 1) (0 :ulf-recur)
    1 (deg-adv between 9 noun); e.g., directly between the Esso and NVidia blocks
       2 (((lex-ulf! adv-a 1) (*pp-between-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
    1 (deg-adv adv-history between 9 noun); e.g., just recently between the Esso and NVidia blocks
       2 (((lex-ulf! mod-a 1) (*adv-ulf-tree* 2) (*pp-between-ulf-tree* 3 4 5)) (1 (2 3))) (0 :ulf-recur)
    1 (adv-history between 9 noun); e.g., ever between the Esso and NVidia blocks
       2 (((*adv-ulf-tree* 1) (*pp-between-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
    1 (nil between 9 noun); ignore non-adverb preceding "between"
       2 (((*pp-between-ulf-tree* 2 3 4)) 1) (0 :ulf-recur)

    ; Simple between prepositions
    1 (between det 2 noun); e.g., between two red blocks; between what blocks
       2 ((between.p (*np-ulf-tree* 2 3 4)) (1 2)) (0 :ulf-recur)
    1 (between det 2 noun and det 2 noun); e.g., between a red block and a blue block
       2 ((between.p (*np-ulf-tree* 2 3 4) and.cc (*np-ulf-tree* 6 7 8)) 
          (1 (2 and.cc 4))) (0 :ulf-recur)
    1 (between det adj and det adj noun); e.g., between a red and a blue block
       2 ((between.p (lex-ulf! det 2) (lex-ulf! adj 3) and.cc (lex-ulf! det 5)
          (lex-ulf! adj 6) (lex-ulf! noun 7)) (1 ((2 (3 7)) 4 (5 (6 7))))) (0 :ulf-recur)
    1 (between det name and det name block); e.g., between the NVidia and the Mercedes blocks
       2 ((between.p (lex-ulf! det 2) (lex-ulf! name 3) and.cc (lex-ulf! det 5)
          (lex-ulf! name 6) block.n) (1 ((2 (3 7)) 4 (5 (6 7))))) (0 :ulf-recur)
    1 (between det name and name block); e.g., between the NVidia and Mercedes blocks
       2 ((between.p (lex-ulf! det 2) (lex-ulf! name 3) and.cc (lex-ulf! name 5) block.n)
          (1 ((2 (3 6)) 4 (the.d (5 6))))) (0 :ulf-recur)
    1 (between det name block and name block); e.g., between the SRI block and NVidia block
       2 ((between.p (lex-ulf! det 2) (lex-ulf! name 3) block.n and.cc (lex-ulf! name 6) block.n)
          (1 ((2 (3 4)) 5 (the.d (6 7))))) (0 :ulf-recur)

)) ; END *pp-between-ulf-tree*



(READRULES '*yn-between-question-ulf-tree*
; ``````````````````````````````````````````````
; Parses yes-no questions involving between (including existential there questions)
;
'(
    ; Historical
    1 (be 0 between 0 block 0)
       2 (be det 2 block 1 between 7 noun adv-hist-word 0 ?); e.g., was the NVidia block between two red blocks previously ?
          3 (((lex-ulf! v 1) (*np-ulf-tree* 2 3 4) (*pp-between-ulf-tree* 5 6 7 8) (*adv-ulf-tree* 9 10) ?)
             ((1 2 3 4) ?)) (0 :ulf-recur) 
    1 (be there 1 adv-history 3 noun 1 between 7 noun ?); e.g., was there ever any red block between the SRI and NVidia blocks ?
       2 (((lex-ulf! v 1) there.pro (*adv-ulf-tree* 3 4) (*np-ulf-tree* 5 6 7 8 9 10) ?) 
          ((1 2 3 4) ?)) (0 :ulf-recur)
    1 (be there 3 noun 1 between 7 noun adv-hist-word 0 ?); e.g., were there any red blocks between a blue and a green block before this ?
       2 (((lex-ulf! v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8) (*adv-ulf-tree* 9 10) ?) 
          ((1 2 3 4) ?)) (0 :ulf-recur)

    ; Standard
    1 (be 0 between 0 block 0)
       2 (be det 2 block 1 between 7 noun ?); e.g., is the NVidia block (directly) between two red blocks ?
          3 (((lex-ulf! v 1) (*np-ulf-tree* 2 3 4) (*pp-between-ulf-tree* 5 6 7 8) ?)
             ((1 2 3) ?)) (0 :ulf-recur) 
    1 (be there 3 noun 1 between 7 noun ?); e.g., is there a red block between a blue and a green block ?
       2 (((lex-ulf! v 1) there.pro (*np-ulf-tree* 3 4 5 6 7 8) ?) 
          ((1 2 3) ?)) (0 :ulf-recur)

)) ; END *yn-between-question-ulf-tree*



(READRULES '*wh-between-question-ulf-tree*
; ``````````````````````````````````````````````
; Parses wh questions involving between
;
'(
    ; Historical
    1 (wh-det noun be 2 between 7 noun adv-hist-word 0 ?); e.g., what/which block was there between the Nvidia block and a red block before ?
       2 (((lex-ulf! det 1) (lex-ulf! noun 2) (lex-ulf! v 3) (*pp-between-ulf-tree* 4 5 6 7)
          (*adv-ulf-tree* 8 9) ?) (((1 2) (3 4 5)) ?)) (0 :ulf-recur)
    1 (what be 2 between 7 noun adv-hist-word 0 ?); what was between the two red blocks previously ?
       2 ((what.pro (lex-ulf! v 2) (*pp-between-ulf-tree* 3 4 5 6) (*adv-ulf-tree* 7 8) ?) 
          ((1 (2 3 4)) ?)) (0 :ulf-recur)
    1 (wh-det 1 noun be 1 between 7 noun adv-hist-word 0 ?); what red blocks were (there) between the Nvidia and Mercedes blocks initially ?
       2 (((lex-ulf! det 1) (*n1-ulf-tree* 2 3) (lex-ulf! v 4) (*pp-between-ulf-tree* 5 6 7 8)
          (*adv-ulf-tree* 9 10) ?) (((1 2) (3 4 5)) ?)) (0 :ulf-recur)
    1 (what color noun be 2 between 7 noun adv-hist-word 0 ?); e.g., what color block was between a red and a blue block on the first turn ?
       2 (((lex-ulf! det 1) (lex-ulf! adj 2) (lex-ulf! noun 3) (lex-ulf! v 4) (*pp-between-ulf-tree* 5 6 7 8)
          (*adv-ulf-tree* 9 10) ?) (((1 (2 3)) (4 5 6)) ?)) (0 :ulf-recur)
    1 (what color be the noun 1 between the 6 noun adv-hist-word 0 ?); what color was the block between the NVidia and Mercedes blocks initially ?
       2 (((lex-ulf! det 1) (lex-ulf! noun 2) (lex-ulf! v 3) the.d (lex-ulf! noun 5) (*pp-between-ulf-tree* 6 7 8 9 10)
          (*adv-ulf-tree* 11 12) ?) ((sub ({of}.p (1 2)) (3 (the.d (n+preds 5 6)) *h 7)) ?)) (0 :ulf-recur)
    1 (wh-pron be the 2 noun 1 between 7 noun adv-hist-word 0 ?); e.g., what was the block between the NVidia block and the SRI block before I moved it ?
       2 (((lex-ulf! pro 1) (lex-ulf! v 2) the.d (*n1-ulf-tree* 4 5) 
          (*pp-between-ulf-tree* 6 7 8 9) (*adv-ulf-tree* 10 11) ?) ((1 (2 (= (the.d (n+preds 4 5))) 6)) ?)) (0 :ulf-recur)
    1 (how many 1 block be 2 between 7 noun adv-hist-word 0 ?); e.g., how many blocks were (there) between a red block and a blue block previously ?
       2 (((*n1-ulf-tree* 3 4) (lex-ulf! v 5) (*pp-between-ulf-tree* 6 7 8 9) (*adv-ulf-tree* 10 11) ?)
          ((((nquan (how.mod-a many.a)) 1) (2 3 4)) ?)) (0 :ulf-recur)

    ; Standard
    1 (wh-det noun be 2 between 7 noun ?); e.g., what/which block is there directly between the Nvidia block and a red block ?
       2 (((lex-ulf! det 1) (lex-ulf! noun 2) (lex-ulf! v 3) 
          (*pp-between-ulf-tree* 4 5 6 7) ?) (((1 2) (3 4)) ?)) (0 :ulf-recur)
    1 (what be 2 between 7 noun ?); what is between the two red blocks ?
       2 ((what.pro (lex-ulf! v 2) (*pp-between-ulf-tree* 3 4 5 6) ?) 
          ((1 (2 3)) ?)) (0 :ulf-recur)
    1 (wh-det 1 noun be 1 between 7 noun ?); what red blocks are (there) between the Nvidia and Mercedes blocks ?
       2 (((lex-ulf! det 1) (*n1-ulf-tree* 2 3) (lex-ulf! v 4) 
          (*pp-between-ulf-tree* 5 6 7 8) ?) (((1 2) (3 4)) ?)) (0 :ulf-recur)
    1 (what color noun be 2 between 7 noun ?); e.g., what color block is between a red and a blue block ? [unusual subj NP!]
       2 (((lex-ulf! det 1) (lex-ulf! adj 2) (lex-ulf! noun 3) (lex-ulf! v 4) 
          (*pp-between-ulf-tree* 5 6 7 8) ?) (((1 (2 3)) (4 5)) ?)) (0 :ulf-recur)
    1 (what color be the noun 1 between the 6 noun ?); what color is the block between the NVidia and Mercedes blocks ?
       2 (((lex-ulf! det 1) (lex-ulf! noun 2) (lex-ulf! v 3) the.d (lex-ulf! noun 5)
          (*pp-between-ulf-tree* 6 7 8 9 10) ?) ((sub ({of}.p (1 2)) (3 (the.d (n+preds 5 6)) *h)) ?)) (0 :ulf-recur)
    1 (wh-pron be the 2 noun 1 between 7 noun ?); e.g., what is the block between a red block and a blue block ?
       2 (((lex-ulf! pro 1) (lex-ulf! v 2) the.d (*n1-ulf-tree* 4 5) 
          (*pp-between-ulf-tree* 6 7 8 9) ?) ((1 (2 (= (the.d (n+preds 4 5))))) ?)) (0 :ulf-recur)
    1 (how many 1 block be 2 between 7 noun ?); e.g., how many blocks are (there) between a red block and a blue block ?
       2 (((*n1-ulf-tree* 3 4) (lex-ulf! v 5) (*pp-between-ulf-tree* 6 7 8 9) ?)
          ((((nquan (how.mod-a many.a)) 1) (2 3)) ?)) (0 :ulf-recur)

)) ; END *wh-between-question-ulf-tree*



(READRULES '*fallback-between-spatial-question-ulf-tree*
; ``````````````````````````````````````````````
; These rules should be accessed as last resort by *spatial-question-ulf-tree*
; For the most part, these rules just allow for ignoring some words here and
; there, but there are also some reformulations (e,g., "support" relations)
;
'(
    1 (4 wh-det 2 noun be 2 between 8 noun 2 ?); what block is between a red and a blue block?
       2 (((*wh-beteen-question-ulf-tree* 2 3 4 5 7 8 9 ?)) (poss-ques 1)) (0 :ulf-recur)
    1 (4 wh-det 1 color 1 block be 1 between 3 noun 4); what color block is between ...
       2 (((*wh-between-question-ulf-tree* what color block is 9 10 11 ?)) 
          (poss-ques 1)) (0 :ulf-recur)
    1 (4 wh-pron be the 2 noun 1 between 7 noun 4); what is the block between ...
       2 ((what.pro (lex-ulf! v 3) the.d (*n1-ulf-tree* 5 6) (*pp-between-ulf-tree* 8 9 10) ?)
          (poss-ques ((1 (2 (= (the.d (n+preds 3 4))))) ?))) (0 :ulf-recur)
    1 (4 wh-det 2 noun be 1 between 7 noun 4); what red block is between ...
       2 (((*wh-between-question-ulf-tree* which 3 4 5 7 8 9 ?))
          (poss-ques 1)) (0 :ulf-recur)
    1 (2 be 1 det 2 noun 2 between 7 noun 4); are (there) some red blocks between ...
       2 (((*yn-between-question-ulf-tree* 2 4 5 6 8 9 10 ?)) (poss-ques 1)) (0 :ulf-recur)
    1 (2 be 1 pron 2 between 7 noun 4); is (there) anything ..between ...
       2 (((*yn-between-question-ulf-tree* 2 4 6 7 8 ?)) (poss-ques 1)) (0 :ulf-recur)
    1 (2 be 1 det 2 noun 2 between 7 noun 4); so\, is n\'t the NVidia block between the two of them ?
       2 (((*yn-between-question-ulf-tree* 2 4 5 6 8 9 10 ?)) (poss-ques 1)) (0 :ulf-recur)
    1 (0 det 1 block 0 between 0)
       2 (Sorry\, I am asking about some 3 4 being between objects \, but you didn\'t 
          really catch what it was\.) (0 :out)
    1 (0 between 0 det table 0)
       2 (Hmm\, you think I asked about a between-relation on the table\, but you 
          didn\'t really catch what I said\.) (0 :out)

    ; variants of begging-off responses should be added, with non-zero latency,
    ; so that the user will see a variety of such responses
)) ; END *fallback-between-spatial-question-ulf-tree*
 

;  ; borrowed stuff, for reference:
;   2 *yn-question-ulf-tree* (0 :subtree)
;  1 (modal 0)      ; e.g., "Can you see the NVidia block ?
;   2 *modal-question-ulf-tree* (0 :subtree)
;  1 (wh_ 0)
;   2 *wh-question-ulf-tree* (0 :subtree)
;  1 (prep 2 wh_ 0) ; e.g., "On top of which block is the NVidia block ?"
;   2 *ppwh-question-ulf-tree* (0 :subtree)


