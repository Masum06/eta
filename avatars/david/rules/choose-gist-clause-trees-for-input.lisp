(READRULES '*gist-clause-trees-for-input*
   '(
      1 (2 what 1 your name 1)
         2 (*specific-answer-from-name-input*
            *question-from-name-input*
            nil
            nil) (0 :subtrees)
      1 (2 do 1 have 2 spatial question 1) 
         2 (*specific-answer-from-spatial-question-input*
            *question-answer-from-spatial-question-input*
            nil
            nil) (0 :subtrees)
      1 (0 do 1 want 2 resume 1)
         2 (*specific-answer-from-request-input*
            nil
            nil
            nil) (0 :subtrees)
))
