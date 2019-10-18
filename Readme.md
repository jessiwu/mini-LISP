
# mini-LISP Interpreter
### - an interpreter can process a subset of LISP.
### - the interpreter is build with Flex & Bison.

# Environment
### this project was tested and executed under 
#### Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-38-generic x86_64)
#### Flex 2.6.4
#### Bison (GNU Bison) 3.0.4
#### g++ (Ubuntu 5.5.0-12ubuntu1) 5.5.0

### Compile Command:
+ compile the mini.y yacc file: 
> user@ubuntu: yacc -d mini.y
>
+ compile the mini.l lex file:
> user@ubuntu: flex mini.l
>
+ list the ouput files:
> user@ubuntu: ls
>
> mini.l  y.tab.c  y.tab.h  mini.y
>
+ compile the executable file with c++ language:
> user@ubuntu: g++ lex.yy.c y.tab.c -o MINI

### Output Example:
> user@ubuntu: cat 06_2.lsp 
>
> (define a (* 1 2 3 4))
>
> (define b (+ 10 -5 -2 -1))
> 
> (print-num (+ a b))
>
> user@ubuntu:~/final/define$ ./MINI < 06_2.lsp 
>
> 26

# Files
#### 1. mini.l: Flex scanner
#### 2. mini.y: Bison parser

# Features:
+ 1. Syntax Validation
> (+ (* 5 2) -) → syntax error
+ 2. Print Implementaion
> (print-num 456) → 456
+ 3. Numerical Operations Implementation
>  (+ 1 2 3 4) → 10
>
>  (< 1 2) → #t
>
>  (= (+ 1 1) 2 (/6 3)) → #t
+ 4. Logical Operations Implementation
>  (and #t (> 2 1)) → #t
>
>  (or (> 1 2) #f) → #f
>
>  (not (> 1 2)) → #t
+ 5. If Expression Implementation
>  (if (= 1 0) 1 2) → 2
>
>  (if #t 1 2) → 1
+ 6. Variable Definition Implementation
>  (define x 5)


