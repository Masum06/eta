cd eta
call .\env\Scripts\activate
echo (setq *user-name* "Dr. Tom Carroll") > io/sessionInfo.lisp
sbcl --load "start.lisp"