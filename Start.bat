call .\env\Scripts\activate
echo (setq *user-name* %1) > io/sessionInfo.lisp
sbcl --load "start.lisp"