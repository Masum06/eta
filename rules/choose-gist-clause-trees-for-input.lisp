(eval-when (load eval)

   (READRULES '*gist-clause-trees-for-input*
   '(
      1 (2 what 1 your name 1)
         2 (*specific-answer-from-name-input*
            *unbidden-answer-from-name-input*
            *thematic-answer-from-name-input*
            *question-from-name-input*) (0 :subtrees)
      1 (2 do 1 have 2 spatial question 1) 
         2 (*specific-answer-from-spatial-question-input*
            *unbidden-answer-from-spatial-question-input*
            *thematic-answer-from-spatial-question-input*
            *question-answer-from-spatial-question-input*) (0 :subtrees)
   ))
); end of eval-when
