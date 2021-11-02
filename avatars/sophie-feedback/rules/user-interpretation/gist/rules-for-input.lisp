;

(READRULES '*feedback-input*
; TBC
'(
  1 (bye)
    2 ((Goodbye \.)) (0 :gist)

  ;; 1 (0 [SEP] 0)
  ;;   2 ((An input was found \: 1 and 3 \.)) (0 :gist)

  ; Top-level nodes match SOPHIE's responses where we previously had opportunity tags
  1 (WH_ does this mean for my future [SEP] 0)
    ; Second-level nodes detect whether user asked an open-ended question or not
    2 (0 [SEP] 0 WH_ worries you the most 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    ; If doctor did not ask an open-ended question, gist-clause stores suggestion
    2 ((Question-Suggestion \: what worries you the most ?)) (0 :gist)
  
  1 (What is 1 prognosis [SEP] 0)
    2 (0 [SEP] 0 Do you understand your prognosis 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How much information do you want 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 What scares you about your prognosis 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How do you feel about your prognosis 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    ; TODO:
    ; "How much information do you want about your prognosis?"
    ; "What concerns you most about the future"
    2 ((Question-Suggestion \: Do you understand your prognosis ? How much information do you want about your prognosis ? What concerns you the most for your future ?)) (0 :gist)

  1 (Can I trust your prognosis [SEP] 0) 
    2 (0 [SEP] 0 Do you understand your prognosis 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How do you feel about your prognosis 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    ; TODO:
    ; "How much information do you want about your prognosis?"
    ; "What concerns you most about the future"
    2 ((Question-Suggestion \: Do you understand your prognosis ? What concerns you the most for your future ?)) (0 :gist)

  1 (What are my options for treatment [SEP] 0)
    2 (0 [SEP] 0 What scares you about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How are you feeling about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 What are your treatment goals 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 ((Question-Suggestion \: What concerns you the most for your future ? What are your treatment goals ?)) (0 :gist)
  

  ; DEFUNCT -- QUESTIONS BETTER SUITED FOR EMPATHY
  ; 1 (I feel mildly depressed [SEP] 0)
  ;   2 (0 [SEP] 0 What scares you about your condition 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 (0 [SEP] 0 How are you feeling about your condition 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 (0 [SEP] 0 Were you nervous for this appointment 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;   2 ((Question-Suggestion \: What concerns you the most for your future ? What scares you about your condition ? Were you nervous about this meeting ?)) (0 :gist)
  ; 1 (Why have I not been sleeping well [SEP] 0)
  ;  2 (0 [SEP] 0 Were you nervous for this appointment 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 (0 [SEP] 0 What happens when you try to sleep 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 ((Question-Suggestion \: Were you nervous about this meeting ? Can you elaborate on your sleeping problems ?)) (0 :gist)
  ; 1 (I feel nervous about my future [SEP] 0)
  ;   2 (0 [SEP] 0 What scares you about your condition 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 (0 [SEP] 0 How are you feeling about your condition 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 (0 [SEP] 0 Were you nervous for this appointment 0)
  ;    3 ((The doctor asked an open ended question \.)) (0 :gist)
  ;  2 ((Question-Suggestion \: What concerns you the most for your future ? What scares you about your condition ? Were you nervous about this meeting ?)) (0 :gist)
  
  1 (I am sleeping poorly because of my mental health [SEP] 0) 
    2 (0 [SEP] 0 What scares you about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How are you feeling about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 Were you nervous for this appointment 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 ((Question-Suggestion \: What concerns you the most for your future ? What scares you about your condition ? Were you nervous about this meeting ?)) (0 :gist)


  ; Tentative - How does chemotherapy work? What should I tell my family? (Can I outlive your prognosis if I have healthy habits?) (Can I outlive your prognosis if I am healthy now?) (Can I outlive your prognosis until the graduation of my grandson?) 
  1 (What are my treatment options if I do not do chemotherapy [SEP] 0)
    2 (0 [SEP] 0 What scares you about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 How are you feeling about your condition 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 (0 [SEP] 0 What are your treatment goals 0)
      3 ((The doctor asked an open ended question \.)) (0 :gist)
    2 ((Question-Suggestion \: What concerns you the most for your future ? What are your treatment goals ?)) (0 :gist)
  
  ; EMPATHY OPPORTUNITIES
  1 (What should I tell my family [SEP] 0)
    2 (0 [SEP] 0 Do you want me to be present when you tell your family about the prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 You should reassure your family about the prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 You should tell your family the full truth about the prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 You will be available to help me and my family during my cancer treatment 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 ((Empathy-Suggestion \: Do you want me to be present when you tell your family about the prognosis ? I\'ll be there for you throughout the whole process \.)) (0 :gist)

  1 (I know that my cancer has gotten worse\, but I\'m not sure how bad it is [SEP] 0)
    2 (0 [SEP] 0 How do you feel about your prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 What scares you about your prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 How much do you want to know about your prognosis 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Were you nervous about this meeting 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 ((Empathy-Suggestion \: How much do you want to know about your prognosis ? Were you nervous about this meeting ?)) (0 :gist)

  1 (Why have I not been sleeping well [SEP] 0)
    2 (0 [SEP] 0 Is your mental health keeping you awake 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 What is on your mind when you try to sleep 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Can you tell me about your pain 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 How do you rate your pain 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 I am sorry that you are sleeping poorly 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 ((Empathy-Suggestion \: What goes through your mind when you try to sleep ? Do you feel pain at night ? I\'m sorry that you\'ve been sleeping poorly \.)) (0 :gist)

  1 (My pain has recently been getting worse [SEP] 0)
    2 (0 [SEP] 0 I am sorry that you are in pain 0) 
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Can you tell me about your pain 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 How do you rate your pain 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Do you want a stronger pain medication 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Is your pain medication working 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Has the pain become worse 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Do you have the pain frequently 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 ((Empathy-Suggestion \: I am sorry that you are in pain \. Can you tell me about your pain ? Has the pain become worse ?)) (0 :gist)

  1 (I feel mildly depressed [SEP] 0)
    2 (0 [SEP] 0 How is your mental health 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Is something harming your mental health 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 What scares you about your condition 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 How are you feeling about your condition 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Were you nervous for this appointment 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (Empathy-Suggestion \: How have you been recently? Were you nervous for this appointment ?) (0 :gist)

  1 (I feel anxious about my future [SEP] 0)
    2 (0 [SEP] 0 How is your mental health 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Is something harming your mental health 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 What scares you about your condition 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 How are you feeling about your condition 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Were you nervous for this appointment 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 You should see a therapist 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 You should take an antidepressant 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (Empathy-Suggestion \: How is your mental health? Were you nervous for this appointment ?) (0 :gist)
    
  1 (Why do I have cancer [SEP] 0)
    2 (0 [SEP] 0 I wish that you do not have cancer 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 I am sorry that you have cancer 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Cancer can affect anyone 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (0 [SEP] 0 Cancer can affect the human body suddenly 0)
      3 ((The doctor gave an empathetic response \.)) (0 :gist)
    2 (Empathy-Suggestion \: I\'m so sorry that this happened to you\. I wish that there was no such thing as cancer at all \.) (0 :gist)

  ; Empathy Opportunities:
  ; Can I trust my prognosis ?
  ; Can I outlive your prognosis if/until ... ?
  

  1 (0)
    2 ((NIL Gist \: nothing found for input \.)) (0 :gist)

)) ; END *feedback-input*