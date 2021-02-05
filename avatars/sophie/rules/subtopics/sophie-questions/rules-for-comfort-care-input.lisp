(MAPC 'ATTACHFEAT
  '(
    (thought think consider considered look looked)
    (comfort-care-word comfort palliative hospice care)
  ))


(READRULES '*comfort-care-verification-input*
'(
  1 (0 POS 0)
    2 ((I do not think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 I 1 think-gen so 0)
    2 ((I do not think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 no 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 NEG 1 think-gen 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
))


(READRULES '*comfort-care-input*
'(
  1 (0 palliative care 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 hospice 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
    
  1 (0 POS 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 I 1 think-gen so 0)
    2 ((I think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 no 0)
    2 ((I do not think you need comfort care \.) (comfort-care)) (0 :gist)
  1 (0 NEG 1 think-gen 0)
    2 ((I do not think you need comfort care \.) (comfort-care)) (0 :gist)

  1 (0)
    2 *general-input* (0 :subtree)
  1 (0)
    2 ((NIL Gist \: nothing found for comfort care \.)) (0 :gist)
))


(READRULES '*comfort-care-question*
'(
  1 (1 aux pron 4 thought 4 comfort-care-word 0)
    2 ((Have you considered comfort care ?) (comfort-care)) (0 :gist)
  1 (1 aux 4 mention 4 comfort-care-word 0)
    2 ((Have you considered comfort care ?) (comfort-care)) (0 :gist)
))


(READRULES '*comfort-care-reaction*
'(
  1 (I do not think you need comfort care \.)
    2 *confirm-no-comfort-care* (100 :schema)
    2 (Okay\, you see\. You will think about starting chemotherapy right away then\.) (0 :out)
  1 (0)
    2 (Comfort care sounds good\. If you\'re not going to make it\, you want to at least want to be comfortable
       and spend time with family for as long as possible\.) (0 :out)
))