; The rules defined in this file contain reactions to specific gist clause questions from the user, in the form of either
; subschemas to instantiate or direct templatic outputs. Note that, in general, GPT-3 generation will be able to
; handle response generation in cases where a specific reaction is not selected here, so these rules are mainly
; used for subschema selection.
;
; The rules are grouped into various subtopics corresponding to topics that
; appear in schemas:
;
; - cancer-worse
; - medical-history
; - medicine-side-effects
; - appointment
; - chemotherapy-details
; - diagnosis-details
; - energy
; - medicine
; - pain
; - radiation
; - sleep
; - chemotherapy
; - comfort-care
; - medicine-request
; - medicine-working
; - prognosis
; - sleep-poorly
; - tell-family
; - test-results
; - treatment-option
; - treatment-goals
; - open-ended-question
;

; Define any useful predicates here:
(defpred !not-non-alcoholic x (not (isa x 'non-alcoholic)))
(defpred !not-medicine-gen x (not isa x 'medicine-gen))


(READRULES '*reaction-to-question*
'(
; ````````````````````     cancer-worse      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````    medical-history    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` medicine-side-effects ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      appointment      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ```````````````````` chemotherapy-details  ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   diagnosis-details   ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````        energy         ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````       medicine        ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````         pain          ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````       radiation       ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````         sleep         ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     chemotherapy      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     comfort-care      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   medicine-request    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   medicine-working    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````       prognosis       ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     sleep-poorly      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````      tell-family      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````     test-results      ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````   treatment-option    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````    treatment-goals    ```````````````````````
; ``````````````````````````````````````````````````````````````````



; ````````````````````  open-ended-question  ```````````````````````
; ``````````````````````````````````````````````````````````````````



)) ; END *reaction-to-question*