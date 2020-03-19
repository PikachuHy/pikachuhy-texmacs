(use-modules (convert markdown init-markdown))
(kbd-map 
  ("` ` ` s h e l l return" (make 'shell-code))
  ("` ` ` c p p return" (make 'cpp-code))
  ("` ` ` f o r t r a n return" (make 'fortran-code))
  ("` ` ` p y t h o n return" (make 'python-code))
  ("` ` ` s c h e m e return" (make 'scm-code))
  ("` ` ` s c i l a b return" (make 'scilab-code))
  ("` ` ` j a v a return" (make 'java-code))
  ("s c m tab" (make-session "scheme" "default"))
  ("p y tab" (make-session "python" "default"))
  ("g r a p h tab" (make-session "graph" "default"))
  ("C-V" (clipboard-paste-import "verbatim" "primary")) ;;; Ctrl+Shift+V
  ("A-L" (clipboard-paste-import "latex" "primary"))    ;;; Alt+Shift+L
  )

