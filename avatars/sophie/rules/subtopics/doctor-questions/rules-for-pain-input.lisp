(MAPC 'ATTACHFEAT
'(
  (more-info learn hear tell say more additional elaborate)
  (elaborate continue describe)
  (can could)
  (scale rate rating)
  (part parts section sections area areas)
  (pain-bad bad much strongly intensely badly)
  (take taking)
  (pain-return come back return)
))


(READRULES '*pain-input*
'(
  ; If doctor inquires for more information
  1 (0 more-info 2 more-info 0)
    2 (*pain-question* (can you tell me about your pain ?)) (0 :subtree+clause)
  1 (0 go on 0)
    2 (*pain-question* (can you tell me about your pain ?)) (0 :subtree+clause)
  1 (0 elaborate 0)
    2 (*pain-question* (can you tell me about your pain ?)) (0 :subtree+clause)
  ; If doctor specifically wants you to rate your pain
  1 (0 how pain-bad 2 pain 0)
    2 (*pain-question* (how do you rate your pain ?)) (0 :subtree+clause)
  1 (0 scale 0)
    2 (*pain-question* (how do you rate your pain ?)) (0 :subtree+clause)
  ; If doctor asks about what lead up to this
  1 (0 what 2 happened 3 before 0)
    2 (*diagnosis-details-question* (what lead to your diagnosis ?)) (0 :subtree+clause)
  1 (0 how do 3 know 0)
    2 (*diagnosis-details-question* (what lead to your diagnosis ?)) (0 :subtree+clause)
  1 (0 how 0 find out 0)
    2 (*diagnosis-details-question* (what lead to your diagnosis ?)) (0 :subtree+clause)
  ; If doctor asks what you're taking for the pain
  1 (0 wh_ 1 medicine-gen 0)
    2 (*medicine-question* (what are you taking for the pain ?)) (0 :subtree+clause)
  1 (0 wh_ 2 med-take 0)
    2 (*medicine-question* (what medicine are you taking ?)) (0 :subtree+clause)
  ; When you take it does it take care of the pain?
  1 (0 be-aux 3 med-help 3 pain 0)
    2 (*medicine-question* (does your pain medicine help with the pain ?)) (0 :subtree+clause)
  1 (0 be-aux 3 med-help 1 at all 0)
    2 (*medicine-question* (does your pain medicine help with the pain ?)) (0 :subtree+clause)
  1 (0 be-aux 3 med-help 1 little 0)
    2 (*medicine-question* (does your pain medicine help with the pain ?)) (0 :subtree+clause)
  1 (0 be-aux 1 it 3 do anything 0)
    2 (*medicine-question* (does your pain medicine help with the pain ?)) (0 :subtree+clause)

  1 (0 SELF 2 sorry 0)
    2 ((You are sorry that I am in pain \.)) (0 :gist)

  1 (0 medicine-gen 0)
    2 *medicine-working-input* (0 :subtree)
  1 (0 something 1 med-better 0)
    2 *medicine-working-input* (0 :subtree)

  1 (0)
    2 *general-input* (0 :subtree)
  1 (0)
    2 ((NIL Gist \: nothing found for pain \.)) (0 :gist)
))


(READRULES '*pain-question*
'(
  ; Did the pain come back?
  1 (0 do 1 pain 1 pain-return 0)
    2 ((Did my pain come back ?) (Pain-return)) (0 :gist)
  ; How do you rate your pain?
  1 (0 scale 0)
    2 ((How do I rate my pain ?) (Pain-description)) (0 :gist)
  1 (0 how pain-bad 0)
    2 ((How do I rate my pain ?) (Pain-description)) (0 :gist)
  ; Can you tell me about your pain?
  1 (0 how be 2 pain 0)
    2 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
  1 (0 more-info 1 about 2 pain 0)
    2 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
  1 (0 what 2 medicine-gen 0)
    2 (*medicine-question* (what medication are you taking ?)) (0 :subtree+clause)
  1 (0 what pain 1 be you 0)
    2 ((Can I tell you about my pain ?) (Pain-description)) (0 :gist)
  ; Where does it hurt?
  1 (0 where it 3 pain 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 where do 3 pain 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 where be 3 pain 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  1 (0 what part 3 pain 0)
    2 ((Where is the pain located ?) (Pain-description)) (0 :gist)
  ; Does it hurt to [...]
  1 (0 do 2 pain to 0)
    2 (0 breath 0)
      3 ((Does it hurt to breath ?) (Pain-description)) (0 :gist)
    2 (0)
      3 ((Does it hurt to do anything ?) (Pain-description)) (0 :gist)
))


(READRULES '*pain-reaction*
'(
  1 (You are sorry that I am in pain 1)
    2 (Thanks\, I just hope the pain can be treated \.) (0 :out)
))