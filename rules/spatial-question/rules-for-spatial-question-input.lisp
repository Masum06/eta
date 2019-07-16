;; Gist clause extraction
;; simple nested rules + features + wildcards
;;
;; "How did you get here today?"

(eval-when (load eval)
  (MAPC 'ATTACHFEAT
  '(
    (spatial-beginning-pair spatial-beginning there)
    (spatial-beginning spatial-verb between prep)
    (spatial-verb be modal wh_ do)
    (spatial-ending noun adj there directions pron prep)
    (spatial-word noun pron supporting corp adj
      uppermost under close touching farthest rotated)
    (spatial-word-potential spatial-word be wh_ prep)
    (kinds types sorts kind type sort formats format)
    (question questions)
    (answer understand hear interpret parse)
    (here here\'s heres)
    (directions left right top bottom back front)

    (corp Burger_King McDonalds Mercedes NVidia SRI SRI_International
      Starbucks Texaco Target Toyota Twitter Shell Adidas)
    (block blocks cube cubes book books black blacks glock glocks
      blog blogs bach blood bloods glass box look looks); often misrecognized
    (name corp)
    (prep of on to under in behind near touching abutting between from
                below above next next_to visible on_top_of to_the_left_of
                to_the_right_of in_front_of)     ; currently "next" needs to have
                                                 ; the 'prep' feature, to allow
                                                 ; merging into 'next_to.p'; it's
                                                 ; risky, & prior word-joining 
                                                 ; by '_' would be safer.
    (rel-adj near close touching adjacent flush)
    (qual-adj purple blue green yellow orange red pink gray grey
      black white brown clear visible nearby)
    (num-adj two three four five six seven eight nine ten eleven twelve many)
                   ; (But note: we assume numerals can also be determiners)
    (sup-adj leftmost rightmost furthest farthest nearest closest highest
      tallest nearest topmost uppermost smallest lowest largest
      centermost shortest backmost longest fewest frontmost)
    (ord-adj first second third fourth fifth sixthe seventh eighth ninth
      tenth eleventh twelfth thirteenth fourteenth fifteenth sixteenth
      seventeens eighteenth nineteenth twentieth)
    (diff-adj other different same distinct separate unique)
    (adj qual-adj rel-adj num-adj sup-adj ord-adj diff-adj)
    (mod-n adj corp)
    (noun block table stack row edge face plane line circle pile object
      color structure left right back front other); NB: "each other"
                                                         ; can also be adj, det
    (under underneath supporting support)
    (close next)
    (touching face-to-face abutting against flush) 
    (be is are was were)
    (verb touch touches support supports connect connects consist_of
      consists_of sit sits adjoin adjoins flank flanks)
    (farthest furthest)
    (rotated angled swivelled turned)
  ))

  ; This is the top level choice tree for processing spatial question inputs.
  ; First, we want to check whether the response _is_ a spatial question, which
  ; we can do pretty generally by checking if it has any spatial keyword in it. If so,
  ; we sent it to further subtrees to do some simple preprocessing. Otherwise, we can check
  ; for any number of "small talk" patterns, which we should also be able to handle.
  (READRULES '*specific-answer-from-spatial-question-input*
  '(
    ;; ----------------------------------------
    ;; If spatial question, start preprocessing
    ;; ----------------------------------------
    1 (0 spatial-word 0)
      2 (*asr-fix-tree* (1 2 3)) (0 :subtree+clause)
    ;; ---------------------
    ;; "Small talk" patterns
    ;; ---------------------
    1 (0 wh_ 1 your name 0)
      2 ((What is your name ?)) (0 :gist)
    1 (0 aux you 1 answer 3 question 0)
      2 ((Can you answer my question ?)) (0 :gist)
    1 (0 aux you 0)
      2 ((Can you do something ?)) (0 :gist)
    1 (0 wh_ 1 kinds 2 question 1 aux you 1 answer 0)
      2 ((What questions can you answer ?)) (0 :gist)
    1 (0)
      2 ((NIL Gist \: Eta could not understand my question \.)) (0 :gist)
  ))

  ; The first stage of preprocessing. Here we want to check for common ASR mistakes, and
  ; map those to the (most plausibly) correct input.
  (READRULES '*asr-fix-tree*
  '(
    1 (0 mcdonald\'s 0)
      2 (*asr-fix-tree* (1 mcdonalds 3)) (0 :subtree+clause)
    1 (0 mcdonalds black 0)
      2 (*asr-fix-tree* (1 mcdonalds block 4)) (0 :subtree+clause)
    1 (0 sra 0)
      2 (*asr-fix-tree* (1 SRI 3)) (0 :subtree+clause)
    1 (0 s or i 0)
      2 (*asr-fix-tree* (1 SRI 5)) (0 :subtree+clause)
    1 (0 meats are i 0)
      2 (*asr-fix-tree* (1 SRI 5)) (0 :subtree+clause)
    1 (0 meats? are i 0)
      2 (*asr-fix-tree* (1 SRI 5)) (0 :subtree+clause)
    1 (0 meats ? are i 0)
      2 (*asr-fix-tree* (1 SRI 6)) (0 :subtree+clause)
    1 (0 bsri 0)
      2 (*asr-fix-tree* (1 the SRI 3)) (0 :subtree+clause)
    1 (0 bsr i 0)
      2 (*asr-fix-tree* (1 the SRI 4)) (0 :subtree+clause)
    1 (0 psri 0)
      2 (*asr-fix-tree* (1 the SRI 3)) (0 :subtree+clause)
    1 (0 psr i 0)
      2 (*asr-fix-tree* (1 the SRI 4)) (0 :subtree+clause)
    1 (0 dsri 0)
      2 (*asr-fix-tree* (1 the SRI 3)) (0 :subtree+clause)
    1 (0 dsr i 0)
      2 (*asr-fix-tree* (1 the SRI 4)) (0 :subtree+clause)
    1 (0 esri 0)
      2 (*asr-fix-tree* (1 the SRI 3)) (0 :subtree+clause)
    1 (0 esr i 0)
      2 (*asr-fix-tree* (1 the SRI 4)) (0 :subtree+clause)
    1 (0 ssri block 0)
      2 (*asr-fix-tree* (1 SRI block 4)) (0 :subtree+clause)
    1 (0 sr. i block 0)
      2 (*asr-fix-tree* (1 SRI block 5)) (0 :subtree+clause)
    1 (0 sr \. i block 0)
      2 (*asr-fix-tree* (1 SRI block 6)) (0 :subtree+clause)
    1 (0 psr i block 0)
      2 (*asr-fix-tree* (1 the SRI block 5)) (0 :subtree+clause)
    1 (0 they survived look 0)
      2 (*asr-fix-tree* (1 the SRI block 5)) (0 :subtree+clause)
    1 (0 in their survival 0)
      2 (*asr-fix-tree* (1 and the SRI block 5)) (0 :subtree+clause)
    1 (0 novita 0)
      2 (*asr-fix-tree* (1 NVidia 3)) (0 :subtree+clause)
    1 (0 univita 0)
      2 (*asr-fix-tree* (1 NVidia 3)) (0 :subtree+clause)
    1 (0 aveda 0)
      2 (*asr-fix-tree* (1 NVidia 3)) (0 :subtree+clause)
    1 (0 play media 0)
      2 (*asr-fix-tree* (1 the NVidia 4)) (0 :subtree+clause)
    1 (0 play video 0)
      2 (*asr-fix-tree* (1 the NVidia 4)) (0 :subtree+clause)
    1 (0 visiting aveda block 0)
      2 (*asr-fix-tree* (1 is the NVidia block 5)) (0 :subtree+clause)
    1 (0 ultra 0)
      2 (*asr-fix-tree* (1 Toyota 3)) (0 :subtree+clause)
    1 (0 yoda 0)
      2 (*asr-fix-tree* (1 Toyota 3)) (0 :subtree+clause)
    1 (0 traffic 0)
      2 (*asr-fix-tree* (1 Target 3)) (0 :subtree+clause)
    1 (0 chopping 0)
      2 (*asr-fix-tree* (1 Target 3)) (0 :subtree+clause)
    1 (0 pocket 0)
      2 (*asr-fix-tree* (1 Target 3)) (0 :subtree+clause)
    1 (0 texican 0)
      2 (*asr-fix-tree* (1 Texaco 3)) (0 :subtree+clause)
    1 (0 Mexico 0)
      2 (*asr-fix-tree* (1 Texaco 3)) (0 :subtree+clause)
    1 (0 texas call 0)
      2 (*asr-fix-tree* (1 Texaco 4)) (0 :subtree+clause)
    1 (0 mass of the 0)
      2 (*asr-fix-tree* (1 Mercedes 5)) (0 :subtree+clause)
    1 (0 varsity sports 0)
      2 (*asr-fix-tree* (1 Mercedes 4)) (0 :subtree+clause)
    1 (0 above to 0)
      2 (*asr-fix-tree* (1 above the 4)) (0 :subtree+clause)
    1 (0 a mirror to 0)
      2 (*asr-fix-tree* (1 nearer to 5)) (0 :subtree+clause)
    1 (0 lymph nodes look 0)
      2 (*asr-fix-tree* (1 leftmost block 5)) (0 :subtree+clause)
    1 (0 rifles 0)
      2 (*asr-fix-tree* (1 rightmost 3)) (0 :subtree+clause)
    1 (0 metal 0)
      2 (*asr-fix-tree* (1 middle 3)) (0 :subtree+clause)
    1 (0 punches 0)
      2 (*asr-fix-tree* (1 touches 3)) (0 :subtree+clause)
    1 (0 punching 0)
      2 (*asr-fix-tree* (1 touching 3)) (0 :subtree+clause)
    1 (0 catching 0)
      2 (*asr-fix-tree* (1 touching 3)) (0 :subtree+clause)
    1 (0 stock 0)
      2 (*asr-fix-tree* (1 stack 3)) (0 :subtree+clause)
    1 (0 hour 0)
      2 (*asr-fix-tree* (1 tower 3)) (0 :subtree+clause)
    1 (0 power 0)
      2 (*asr-fix-tree* (1 tower 3)) (0 :subtree+clause)
    1 (0 boxer 0)
      2 (*asr-fix-tree* (1 blocks are 3)) (0 :subtree+clause)
    1 (0 blockus 0)
      2 (*asr-fix-tree* (1 blocks 3)) (0 :subtree+clause)
    1 (0 blokus 0)
      2 (*asr-fix-tree* (1 blocks 3)) (0 :subtree+clause)
    1 (0 lover 0)
      2 (*asr-fix-tree* (1 block 3)) (0 :subtree+clause)
    1 (0 rose 0)
      2 (*asr-fix-tree* (1 rows 3)) (0 :subtree+clause)
    1 (0 brett 0)
      2 (*asr-fix-tree* (1 red 3)) (0 :subtree+clause)
    1 (0)
      2 (*detect-references-tree* (1)) (0 :subtree+clause)
  ))


  ; The second stage of preprocessing. We want to detect any references/pronouns (for now)
  ; so we can preempt them and tell the user that they aren't currently supported.
  (READRULES '*detect-references-tree*
  '(
    ;; 1 (0 spatial-word-potential 0 ANA-PRON 0)
    ;;   2 ((Can you answer my question referring to a past question ?)) (0 :gist)
    ;; 1 (0 spatial-word-potential 0 that block 0)
    ;;   2 ((Can you answer my question referring to a past question ?)) (0 :gist)
    ;; 1 (0 spatial-word-potential 0 that one 0)
    ;;   2 ((Can you answer my question referring to a past question ?)) (0 :gist)
    1 (0)
      2 (*combine-prepositions-tree* (1)) (0 :subtree+clause)
  ))

  ; The third stage of preprocessing. We want to combine complex prepositions (e.g. "on top of")
  ; into one token simplify ulf parsing a bit.
  (READRULES '*combine-prepositions-tree*
  '(
    1 (0 on top of 0)
      2 (*combine-prepositions-tree* (1 on_top_of 5)) (0 :subtree+clause)
    1 (0 to the left of 0)
      2 (*combine-prepositions-tree* (1 to_the_left_of 6)) (0 :subtree+clause)
    1 (0 to the right of 0)
      2 (*combine-prepositions-tree* (1 to_the_right_of 6)) (0 :subtree+clause)
    1 (0 next to 0)
      2 (*combine-prepositions-tree* (1 next_to 4)) (0 :subtree+clause)
    1 (0 in front of 0)
      2 (*combine-prepositions-tree* (1 in_front_of 5)) (0 :subtree+clause)
    1 (0)
      2 (*trim-suffix-tree* (1)) (0 :subtree+clause)
  ))

  ; The fourth stage of preprocessing. We want to remove any "suffix" that the user might
  ; throw after the query, such as tag questions. We do this by trimming off everything at
  ; the end that isn't a spatial-ending (noun or adj). Right now this is being done in a rather
  ; unwieldy way, due to the problem of recursion (i.e. an input can theoretically have any number
  ; of spatial-ending words).
  (READRULES '*trim-suffix-tree*
  '(
    1 (0 spatial-ending ?)
      2 (*trim-prefix-tree* (1 2 ?)) (0 :subtree+clause)
    1 (0 spatial-ending)
      2 (*trim-prefix-tree* (1 2 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0
         spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0
         spatial-ending 0 spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 7 8 9 10 11 12 13 14 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0
         spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 7 8 9 10 11 12 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0
         spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 7 8 9 10 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 7 8 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 5 6 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 3 4 ?)) (0 :subtree+clause)
    1 (0 spatial-ending 0)
      2 (*trim-prefix-tree* (1 2 ?)) (0 :subtree+clause)
    1 (0 spatial-word 0)
      2 (*trim-prefix-tree* (1 2 ?)) (0 :subtree+clause)
  ))

  ; The fifth stage of preprocessing. We want to remove any "prefix" that the user might
  ; use as an opening, e.g. "my question is ...".
  (READRULES '*trim-prefix-tree*
  '(
    1 (yes I do \, 0)
      2 (*trim-prefix-tree* (5)) (0 :subtree+clause)
    1 (yes I do 0)
      2 (*trim-prefix-tree* (4)) (0 :subtree+clause)
    1 (yes \, 0)
      2 (*trim-prefix-tree* (3)) (0 :subtree+clause)
    1 (yes 0)
      2 (*trim-prefix-tree* (2)) (0 :subtree+clause)
    1 (0 here 1 my 1 question 0)
      2 (*trim-prefix-tree* (7)) (0 :subtree+clause)
    1 (0 my 1 question 2 be this 0)
      2 (*trim-prefix-tree* (8)) (0 :subtree+clause)
    1 (0 my 1 question 2 be 0)
      2 (*trim-prefix-tree* (7)) (0 :subtree+clause)
    1 (0 aux you 1 know if 0)
      2 (*multi-token-word-tree* (7)) (0 :subtree+clause)
    1 (0 aux you 1 know 0)
      2 (*multi-token-word-tree* (6)) (0 :subtree+clause)
    1 (0 aux you 1 see if 0)
      2 (*multi-token-word-tree* (7)) (0 :subtree+clause)
    1 (0 aux you 1 see 0)
      2 (*multi-token-word-tree* (6)) (0 :subtree+clause)
    1 (0 aux you 1 tell 1 if 0)
      2 (*multi-token-word-tree* (8)) (0 :subtree+clause)
    1 (0 aux you 1 tell me 0)
      2 (*multi-token-word-tree* (7)) (0 :subtree+clause)
    1 (0 aux you 1 tell 0)
      2 (*multi-token-word-tree* (6)) (0 :subtree+clause)
    1 (0 spatial-beginning-pair spatial-beginning-pair spatial-beginning-pair ; meant to match something
        spatial-beginning-pair 0)                                             ; like "is there...what is next
                                                                              ; to the red block?"
      2 (*multi-token-word-tree* (4 5 6)) (0 :subtree+clause)
    1 (between spatial-beginning 0)
      2 (*multi-token-word-tree* (1 2 3)) (0 :subtree+clause)
    1 (wh_ spatial-beginning 0)
      2 (*multi-token-word-tree* (1 2 3)) (0 :subtree+clause)
    1 (prep spatial-beginning 0)
      2 (*multi-token-word-tree* (1 2 3)) (0 :subtree+clause)
    1 (NIL so spatial-beginning 0)
      2 (*multi-token-word-tree* (3 4)) (0 :subtree+clause)
    1 (NIL \, spatial-beginning 0)
      2 (*multi-token-word-tree* (3 4)) (0 :subtree+clause)
    1 (NIL spatial-beginning 0)
      2 (*multi-token-word-tree* (2 3)) (0 :subtree+clause)
    1 (0)
      2 (*multi-token-word-tree* (1)) (0 :subtree+clause) 
  ))

  ; The sixth stage of preprocessing. Here we combine any words that have multiple tokens,
  ; e.g. "burger king" into a single word, joined by an underscore.
  (READRULES '*multi-token-word-tree*
  '(
    1 (0 burger king 0)
      2 (*multi-token-word-tree* (1 burger_king 4)) (0 :subtree+clause)
    1 (0 sri international 0)
      2 (*multi-token-word-tree* (1 sri_international 4)) (0 :subtree+clause)
    1 (0 next to 0)
      2 (*multi-token-word-tree* (1 next_to 4)) (0 :subtree+clause)
    1 (0)
      2 ((spatial-question 1)) (0 :gist)
  ))
		
  (READRULES '*question-from-spatial-question-input*
  '(
  ))

); end of eval-when
