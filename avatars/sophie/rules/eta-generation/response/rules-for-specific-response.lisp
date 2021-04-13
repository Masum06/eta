; The rules defined in this file are used to generate a specific response for a topic, in the context of the
; user's previous gist-clause (the specific rule tree is initially chosen based on the gist-clause of Eta's response).
;
; All trees defined in this file should be named using format *response-tree-<topic>*.


(READRULES '*response-tree-treatment-options*
; (What are my options for treatment 1)
'(
  1 (0 Maintaining good quality of life is a treatment option 0)
    2 (Keeping a high quality of life for the rest of my time is the most important thing to me right now \.
       What\'s the best option for making sure this is possible ?) (0 :out)

  1 (0 Do I want to try to fight the cancer 0)
    2 (My main priority is just to be comfortable for the time I have left\, but I\'m willing
       to try to fight the cancer if you think it will help \.) (100 :out)
    2 (I want to try to fight it if you think it would be best\, but my main priority is just
       being comfortable \.) (0 :out)
      
  1 (0 What are my treatment goals 0)
    2 (I think my priority is to be comfortable for the time I have left\, and to be able to enjoy my remaining
       years with my family \. However\, I\'m open to try fighting the cancer if you think I have a chance \.) (100 :out)
    2 (I really just want to be as comfortable as possible for the time I have left \.) (0 :out)

  1 (0 You need more tests before talking about treatment options 0)
    2 (I understand that some more tests might be necessary before deciding on treatment \. I still want to hear
       about my potential options\, though \.) (0 :out)

  1 (0 NIL GIST 0 treatment option 0)
    2 (Sorry\, I didn\'t really understand \. Could you please repeat my treatment options one more time ?) (0 :out)

  1 (0)
    2 (I want to talk a bit about my treatment options now \. What are my choices at this point ?) (0 :out)

)) ; END *response-tree-treatment-options*



(READRULES '*response-tree-comfort-care*
; (How does comfort care work 1)
'(
  
  1 (0 You do not think I need chemotherapy because I should get comfort care instead 0)
    2 (I think holding off on chemotherapy for now makes sense\, given that my priority is just to be comfortable \.
       So you think I should get comfort care\, then ?) (0 :out)

  1 (0 Comfort care is a treatment option 0)
    2 (Comfort care sounds good to me \. What I want is to try to get my life back to normal as much as possible \.
       You know\, spend time with my family\. What do I have to do for that ?) (0 :out)
  1 (0 Have I considered comfort care 0)
    2 (I haven\'t thought about it\, but it sounds like what I really need \. A way to maintain quality of life
       during the time I have left \. Can you tell me about it ?) (0 :out)

  1 (0)
    2 (You know\, my main priority is to be comfortable at this point \. Do you think I should
       start considering comfort care ?) (0 :out)

)) ; END *response-tree-comfort-care*



(READRULES '*response-tree-pain-medication-not-working*
; (Why isn\'t the pain medication working anymore 1)
'(
  1 (0 How is the pain medication working 0)
    2 (My pain is a little better under the lortab\, but it\'s not really helping as much as it used to \.) (0 :out)
  1 (0 Is the pain medication working at all 0)
    2 (The lortab is working a little bit\, but not much \.) (0 :out)
  1 (0 Is the pain medication working 0)
    2 (No\, it\'s not really working anymore \. So I have been taking the pills every three hours instead of every four \.) (0 :out)

  1 (0)
    2 (Could you tell me why the pain medication isn\'t working anymore ?) (0 :out)

)) ; END *response-tree-pain-medication-not-working*



(READRULES '*response-tree-lortab-frequency*
; (I am taking Lortab every three hours 1)
'(
  1 (0 How often am I taking medication 0)
    2 (I am taking two pills of lortab every three hours now for the past couple of weeks\, since this pain has come back \.) (0 :out)
  1 (0 Does taking medication more frequently help 0)
    2 (Taking the lortab more often seems to help a little \. I am already taking it every three hours \.) (0 :out)

)) ; END *response-tree-lortab-frequency*



(READRULES '*response-tree-sleep*
; (I have not been sleeping well 1)
'(
  1 (0 Have I been sleeping okay 0)
    2 (I have been having a bit of trouble \. I keep waking up at night \. Most nights I have to take my pain medication
       before falling back to sleep again \.) (0 :out)
  1 (0 How often am I waking up at night 0)
    2 (I haven\'t really been keeping track \. Maybe about four or five times in a night \.) (0 :out)

  1 (0 What is on my mind when I try to sleep 0)
    2 (When I actually sleep\, I don\'t really have anything on my mind \. When I have trouble sleeping I usually can\'t think
       of anything except for the pain \.) (0 :out)
  1 (0 What happens when I try to sleep 0)
    2 (I usually have trouble staying asleep \. Sometimes I wake up in the middle of the night and notice an ache in my
       back and near my chest \. That\'s when I have to take pain medication to fall back asleep \.) (0 :out)
  1 (0 Is your mental health keeping you awake 0)
    2 (I have been feeling a bit of anxiety\, which can sometimes make it difficult to fall asleep\, but usually it\'s
       my pain that keeps me awake \.) (0 :out)

)) ; END *response-tree-sleep*



(READRULES '*response-tree-test-results*
; (What do my test results mean 1)
'(
  1 (0 What test results am I referring to 0)
    2 (Oh\, sorry\, I assumed you were sent the results \. I had a second CT scan a couple weeks after radiation \.
       I was told that the tumor is still there\, but I wasn\'t sure how to interpret that \. They mentioned something
       about possible metastasis \.) (0 :out)

  1 (0 Do I know what the tests say 0)
    2 (I don\'t really understand the test results \. Can you explain them ?) (0 :out)

  1 (0 You are not sure what my test results mean 0)
    2 (Oh\, sorry\, I assumed you were sent the test results\, from when I had my second CT scan a couple weeks after radiation \.
       I was told that the tumor is still there\, but I wasn\'t sure how to interpret that \. They mentioned something
       about possible metastasis \. Could you explain what that means in simple terms ?) (100 :out)
    2 (Could you try your best to explain the test results to me ?) (0 :out)

  1 (0)
    2 (Let\'s talk about my test results\. I received my test results yesterday\, but I didn\'t really understand them \.
       Could you explain to me what my test results mean ?) (100 :out)
    2 (I still don\'t quite understand the test results\. Could you please explain in simple terms ?) (0 :out)

)) ; END *response-tree-test-results*



(READRULES '*response-tree-weight*
; (I have lost weight 1)
'(
  1 (0 Have I changed weight 0)
    2 (I have lost some weight \.) (0 :out)
  1 (0 How much weight have I lost 0)
    2 (I have lost about twenty five pounds since they started \. I gained seven back in radiation\, but I am still down a bit \.) (0 :out)

)) ; END *response-tree-weight*



(READRULES '*response-tree-pain*
; (My pain has recently been getting worse 1)
'(
  1 (0 Can I tell you about my pain 0)
    2 (The pain was pretty much under control for a while\, but in the past week it has been more difficult \.
       it used to be in my back and left side of my chest\, but now it\'s in my shoulder blade too\, and on
       the other side from where it started \.) (2 :out)
    2 (The pain doesn\'t really go into other areas \. It\'s dull and constant\, and aches a lot \. It usually
       hurts to take deep breathes \.) (0 :out)

  1 (0 How do I rate my pain 0)
    2 (The pain is about a seven out of ten \. With medication\, it goes down to about a five \.) (0 :out)
  1 (0 Where is the pain located 0)
    2 (The pain is primarily in the left side of my chest\, and in the middle of my back \. Recently\,
       it also moved to the right side of my chest \.) (0 :out)

  1 (0 Does it hurt to 0)
    2 (It hurts whenever I take a deep breath \. It used to hurt to swallow during radiation\, but that isn\'t as bad now \.) (0 :out)
  1 (0 Did my pain come back 0)
    2 (My pain came back a couple weeks after I finished radiation \. It\'s been getting worse recently \.) (0 :out)

  1 (0 Has the pain become worse 0)
    2 (The pain seems to have become worse recently \.) (0 :out)

)) ; END *response-tree-pain*



(READRULES '*response-tree-medication*
; (What are the side effects of stronger pain medication 1)
; (I am only taking Lortab to treat my pain 1)
'(
  1 (0 a stronger pain medication will help me sleep 0)
    2 (It would be nice to be able to sleep soundly again \. What would the side effects of a stronger pain medication be\, though ?) (0 :out)

  1 (0 I should take stronger pain medication 0)
    2 (Yeah\, I think I should take a stronger pain medication \. The current one isn\'t working well \. What are the side effects ?) (100 :out)
    2 (Yeah \, a stronger pain medication would be good \. What would the side effects be ?) (0 :out)

  1 (0 Do I want stronger pain medication 0)
    2 (I think I could use a stronger pain medication \. Something to help make me more comfortable \. What are the side effects ?) (100 :out)
    2 (I think having the stronger pain medication would help \.) (0 :out)

  1 (0 I should take something different 0)
    2 (I think something stronger for the pain would be good \. What would the side effects be for a different pain medication ?) (0 :out)
  1 (0 What medicine am I taking 0)
    2 (I am just taking the lortab for pain right now \.) (0 :out)
  1 (0 How were you prescribed your current pain medication 0)
    2 (I was prescribed the Lortab by my previous doctor\, a couple weeks after radiation \.) (0 :out)

  1 (0 What dosage of pain medication am I taking 0)
    2 (I\'ve been taking a pill of the lortab every three hours \. About five pills each day \. I\'m not sure what the exact dosage is \.) (0 :out)

  1 (0 Am I taking pain-med 0)
    2 (I think so \. I am taking lortab for pain right now \.) (0 :out)
  1 (0 Am I taking pain-med-other 0)
    2 (No\, I am not taking any of those \. Just the lortab \.) (0 :out)

  1 (0 What is my history with med-narcotic 0)
    2 (I took some pain medication for a fractured ankle about fifteen or so years ago\, but I don\'t believe it was a narcotic \. 
       besides that\, my doctor prescribed me lortab about three weeks ago \.) (0 :out)
  1 (0 Am I taking med-narcotic 0)
    2 (No\, I am not taking any of those \. Just the lortab \.) (0 :out)

)) ; END *response-tree-medication*



(READRULES '*response-tree-medication-stronger-request*
; (Can I have a stronger pain medication 1)
'(
  1 (0 Addiction is not a side effect of the medication 0)
    2 (It\'s good to know that stronger pain medication is an option without risking addiction \. Would you be
       able to prescribe me some stronger medication\, then ?) (0 :out)
  1 (0 A side effect of the medication be 2 side-effects-moderate 2 \. 0)
    2 (I think I should try the medicine and see if I have problems with 9 10 11 \. Could you prescribe me some ?) (0 :out)
  1 (0 A side effect of the medication be 2 side-effects-insignificant 2 \. 0)
    2 (I already have 9 10 11 \, so I think the new medicine is worth a try \. Could you prescribe me some ?) (0 :out)

  1 (0 NIL GIST 0 side effects 3 medication 0)
    2 (I think it\'s worth giving it a try \. Could you prescribe me some stronger pain medication ?) (0 :out)

  1 (0)
    2 (You know\, I\'m in a lot of pain\, and the Lortab just isn\'t working \. I think maybe I need something
       stronger for my pain \.) (0 :out)

)) ; END *response-tree-medication-stronger-request*



(READRULES '*response-tree-treatment-chemotherapy*
'(
  1 (0 Chemotherapy is a treatment option 0)
    2 (Do you think chemotherapy is really going to help ?) (0 :out)

  1 (0)
    2 (What about chemotherapy ?) (0 :out)

)) ; END *response-tree-treatment-chemotherapy*



(READRULES '*response-tree-chemotherapy-explanation*
; (How does chemotherapy work 1)
'(
  1 (0 A side effect of chemotherapy is 0)
    2 (0 low blood 0)
      3 (I think I will have to do some more research on those side effects before choosing \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 neuropathy 0)
      3 (I think I will have to do some more research on those side effects before choosing \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 hair loss 0)
      3 (Hair loss sounds unpleasant\, but I would be willing to put up with it if it gives me a chance of improving \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 diarrhea 0)
      3 (Diarrhea sounds unpleasant\, but I would be willing to put up with it if it gives me a chance of improving \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 nausea 0)
      3 (I already have nausea\, so I think chemotherapy might be worth it if it helps improve my condition \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 fatigue 0)
      3 (I already have fatigue\, so I think chemotherapy might be worth it if it helps improve my condition \.
         How does chemotherapy usually work ?) (0 :out)
    2 (0 loss of appetite 0)
      3 (My appetite is already pretty poor\, so I think chemotherapy might be worth it if it helps improve my condition \.
         How does chemotherapy usually work ?) (0 :out)
    2 (Okay \. How does chemotherapy usually work ?) (0 :out)

  1 (0 What chemotherapy details are you asking about 0)
    2 (I\'m just wondering how the process of chemotherapy works\, and what I\'d have to do for it \.) (0 :out)

  1 (0)
    2 (How does chemotherapy usually work ?) (0 :out)

)) ; END *response-tree-chemotherapy-explanation*



(READRULES '*response-tree-chemotherapy*
; (How does chemotherapy work 1)
; (Do I need chemotherapy 1)
'(
  1 (0 Did my doctor mention chemotherapy 0)
    2 (My doctor mentioned something about chemotherapy\, but said that I should wait to see how
       things go after the radiation is done \. Why? Do you think I need chemotherapy ?) (0 :out)

  1 (0)
    2 (My previous doctor mentioned something about chemotherapy\, but he said to wait to see how
       things go after the radiation \. Do you think I need chemotherapy ?) (100 :out)
    2 (Thanks\, though I\'m still a bit confused at this point \. Should I get chemotherapy ?) (100 :out)
    2 (Do you think I need chemotherapy ?) (0 :out)

)) ; END *response-tree-chemotherapy*



(READRULES '*response-tree-chemotherapy-side-effects*
; (What are the side effects of chemotherapy 1)
'(
  1 (0 You think we should talk to my oncologist about chemotherapy 0)
    2 (I agree it would be best to revisit chemotherapy after talking to my oncologist \. However\, I still want
       to learn a bit more about it \. What are some of the side effects ?) (0 :out)

  1 (0)
    2 (I hear about people getting sick and losing hair during chemotherapy \. What are some of the side effects ?) (100 :out)
    2 (What are some of the side effects of chemotherapy ?) (0 :out)

)) ; END *response-tree-chemotherapy-side-effects*



(READRULES '*response-tree-tell-family*
; (What should I tell my family 1)
'(
  1 (0 Do my family know about my cancer 0)
    2 (My family know about my cancer already\, but they don\'t really know how bad it is\, or what it
       means for me \. How should I discuss these with them ?) (0 :out)

  1 (0)
    2 (I haven\'t told my family everything yet \. I wanted to wait to talk to you first \.
       What should I say to them ?) (0 :out)

)) ; END *response-tree-tell-family*



(READRULES '*response-tree-prognosis*
; (what is 1 prognosis 1)
'(
  1 (0 My cancer has gotten worse 0)
    2 (What does that mean for me ?) (0 :out)
  1 (0 The prognosis is that I cannot be cured 0)
    2 (I feared as much \, though it\'s still pretty upsetting \. How long do you think I have ?) (0 :out)

  1 (0 The prognosis is that my cancer should be treated with chemotherapy 0)
    2 (I want to talk about my options in a minute\, but first I just want to know how bad it really is \.
       How long do you think I have ?) (0 :out)

  1 (0 The prognosis is hard to predict 0)
    2 (My last doctor also just said it would be hard to predict \. I think I am ready to hear though \. Could you
       please just tell me what the worst case looks like ?) (0 :out)

  1 (0 The test results show that the cancer hasn\'t spread 0)
    2 (My previous doctor didn\'t seem very optimistic \. So what do you think this all means for me ?) (0 :out)

  1 (0 The test results show that me cannot be cured 0)
    2 (That\'s distressing \. I was fearing the worst\, but in the back of my mind I didn\'t think it would all
       happen so quickly \. My family will be distraught \. What I am wondering at this point is\, how much time
       do I have left ?) (0 :out)

  1 (0 The test results show that my cancer has spread 0)
    2 (Those are not the words I wanted to hear \. I mean\, I was bracing for the worst\, since I could tell by the
       pain that it\'s bad \. But to hear that the cancer has spread is quite depressing \. What does
       it all mean for me ?) (0 :out)

  1 (0 The prognosis is that I may live for several elapsed-time 0)
    2 (I\'m not sure whether that\'s a good thing or bad thing \. Could you be more specific about how long
       you think I have left ?) (0 :out)

  1 (0)
    2 (What do you think this means for me in the future ?) (100 :out)
    2 (How long do you think I have left at this point ?) (100 :out)
    2 (I want you to be honest with me \. How long do you think I have ?) (0 :out)

)) ; END *response-tree-prognosis*



(READRULES '*response-tree-rephrase*
; (can 1 rephrase 1 question 1)
'(
  1 (0)
    2 (I am sorry\, I didn\'t quite understand\. Can you say it again ?) (3 :out)
    2 (Would you mind rephrasing ?) (3 :out)
    2 (Could you repeat that one more time using a different phrasing ?) (0 :out)

)) ; END *response-tree-rephrase*