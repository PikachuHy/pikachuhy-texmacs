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

       
(define (num-join l)
  (cond ((== (car l) 0) (num-join (cdr l)))
        (else (num-join-sub l)))
  )

(define (num-join-sub l)
  (cond ((== (length l) 1) (number->string (car l)))
        (else (string-append (number->string (car l)) "." (num-join-sub (cdr l)))))
  
  )

(define (get-ch-title title ch)
  (string-append "Chapter " (number->string ch) " " title)
  )

(define (get-1-title title ch s1)
  (string-append (num-join (list ch s1)) " " title)
  )
(define (get-2-title title ch s1 s2)
  (string-append "    " (num-join (list ch s1 s2)) " " title)
  )
(define (get-3-title title ch s1 s2 s3)
  (string-append "        " (num-join (list ch s1 s2 s3)) " " title)
  )

(define (sections->tree-data sections)
  (let ((index -1) (ch 0) (s1 0) (s2 0) (s3 0) (title ""))
    (map (lambda (s) 
      (begin
      (set! index (+ index 1))
      (set! title (tm/section-get-title-string s))
      (cond  ((== (tm-car s) 'chapter)
              (begin  (set! ch (+ ch 1))
                      (set! s1 0)
                      (set! s2 0)
                      (set! s3 0)
                      (set! title (get-ch-title title ch))  
              
              ))

             ((== (tm-car s) 'section) 
               (begin (set! s1 (+ s1 1))
                      (set! s2 0)
                      (set! s3 0)
                      (set! title (get-1-title title ch s1))
               ))
             ((== (tm-car s) 'subsection)
               (begin (set! s2 (+ s2 1))
                      (set! s3 0)
                      (set! title (get-2-title title ch s1 s2))
               ))
             ((== (tm-car s) 'subsubsection)
               (begin (set! s3 (+ s3 1))
                      (set! title (get-3-title title ch s1 s2 s3))
               ))
             (else (set! title (string-append "            " title))))
            )
      
      `(item ,title ,index))
    
    sections
  )))

(tm-widget (widget-outline)
  (resize ("150px" "400px" "9000px") ("300px" "600px" "9000px")
  (tree-view
   (lambda (clicked cmd-role . user-roles)
  (tree-go-to (list-ref (tree-search-sections (buffer-tree)) (string->number cmd-role)) 0 :end)
  )
   (stree->tree (cons 'root (sections->tree-data (tree-search-sections (buffer-tree)))))
   (stree->tree '(list (item DisplayRole CommandRole))))))
;;; don't work
(tm-menu (focus-extra-icons t)
  (:require (section-context? t))
  (mini #t
    //
    (=> (eval (tm/section-get-title-string t))
        (link focus-section-menu))
    ("Go to section" (top-window widget-outline "Outline"))
    ))