%{
    #include <iostream>
    #include <vector>
    #include <string>
    using namespace std;
    int yylex(void);
    void yyerror(const char *);
    void print_number(int );
    void print_bool(bool );
    void variable_define(char*, int );
    int variable(const char *);
    typedef struct{
        string idname;
        int val;
    } typeID;
    vector<typeID> idstack;
%}

%define parse.error verbose

%code requires{
    typedef struct {
        int nval;
        bool bval;
        int type;
    }EXPRESSION;
}

%union tag{
    int num;
    bool b;
    char* ch;
    EXPRESSION expr;
}

%start PROGRAM
%token END
%type <expr> EXP
%type <expr> VARIABLE
%type <expr> NUM_OP
%type <expr> LOGICAL_OP
%type <expr> IF_EXP
%type <expr> E_PLUS
%type <expr> E_MINUS
%type <expr> E_MUL
%type <expr> E_DIV
%type <expr> E_MOD
%type <expr> E_GREATER
%type <expr> E_SMALLER
%type <expr> E_EQUAL
%type <expr> E_AND
%type <expr> E_OR
%type <expr> E_NOT
%type <expr> EXPX
%type <expr> EXPY
%type <expr> EXPZ
%type <expr> EXP_AND
%type <expr> EXP_OR
%type <expr> TEST_EXP
%type <expr> THEN_EXP
%type <expr> ELSE_EXP
%token<b> BOOL_val
%token<num> NUM
%token<ch> ID
%token DEFINE
%token OP_PAREN
%token CL_PAREN
%token PRT_NUM
%token PRT_BOOL
%token PLUS
%token MINUS
%token MUL
%token DIV
%token MOD
%token GREATER
%token SMALLER
%token EQUAL
%token AND
%token OR
%token NOT
%token IF

%%
/* Grammar Rules for mini-LISP */

PROGRAM     : STMT STMTS            { ; }
            ;
        
STMT        :  EXP                  { ; }
            |  PRINT_STMT           { ; }
            |  DEF_STMT             { ; }    
            ;
            
STMTS       : STMT                  { ; }
            | STMT STMTS            { ; }
            ;
        
PRINT_STMT  : OP_PAREN PRT_NUM EXP CL_PAREN            { print_number($3.nval); }
                                            
            | OP_PAREN PRT_BOOL EXP CL_PAREN           { print_bool($3.bval); }
            ;

EXP         : BOOL_val                { $$.bval = $1; }
            | NUM                     { $$.nval = $1; }
            | NUM_OP                  { $$ = $1; }
            | LOGICAL_OP              { $$ = $1; }
            | VARIABLE                { $$ = $1; }
            | IF_EXP                  { $$ = $1; }
            /*| FUN-EXP */
            /*| FUN-CALL */
            ;
           
DEF_STMT    : OP_PAREN DEFINE ID EXP CL_PAREN     { variable_define($3, $4.nval); }
            ;
            
VARIABLE    : ID                                  { $$.nval = variable($1); }
            ;
            
IF_EXP      : OP_PAREN IF TEST_EXP THEN_EXP ELSE_EXP CL_PAREN   { 
                                                                    if($3.bval){
                                                                        $$.nval = $4.nval;
                                                                    }
                                                                    else{
                                                                        $$.nval = $5.nval;
                                                                    }
                                                                }
            ;
NUM_OP      : E_PLUS                { $$ = $1; }
            | E_MINUS               { $$ = $1; }
            | E_MUL                 { $$ = $1; }
            | E_DIV                 { $$ = $1; }
            | E_MOD                 { $$ = $1; }
            | E_GREATER             { $$ = $1; }
            | E_SMALLER             { $$ = $1; }
            | E_EQUAL               { $$ = $1; }
            ;
            
LOGICAL_OP  : E_AND                 { $$ = $1; }
            | E_OR                  { $$ = $1; }
            | E_NOT                 { $$ = $1; }

E_PLUS      : OP_PAREN PLUS EXP EXPX CL_PAREN           { $$.nval = $3.nval + $4.nval; $$.type = 1; }
            ;

E_MINUS     : OP_PAREN MINUS EXP EXP CL_PAREN           { $$.nval = $3.nval - $4.nval; $$.type = 1; }
            ;
          
E_MUL       : OP_PAREN MUL EXP EXPY CL_PAREN            { $$.nval = $3.nval * $4.nval; $$.type = 1; }
            ;
            
E_DIV       : OP_PAREN DIV EXP EXP CL_PAREN             { $$.nval = $3.nval / $4.nval; $$.type = 1; }
            ;
            
E_MOD       : OP_PAREN MOD EXP EXP CL_PAREN             { $$.nval = $3.nval % $4.nval; $$.type = 1; }
            ;
            
E_GREATER  : OP_PAREN GREATER EXP EXP CL_PAREN        { 
                                                          if($3.nval-$4.nval>0){ 
                                                                $$.bval = true;
                                                                $$.type = 2;
                                                          }
                                                          else{
                                                                $$.bval = false;
                                                                $$.type = 2;
                                                          }
                                                      }
            ;

E_SMALLER   : OP_PAREN SMALLER EXP EXP CL_PAREN        { 
                                                          if($3.nval-$4.nval<0){ 
                                                                $$.bval = true;
                                                                $$.type = 2;
                                                          }
                                                          else{
                                                                $$.bval = false;
                                                                $$.type = 2;
                                                          }
                                                     }
            ;
            
E_EQUAL     : OP_PAREN EQUAL EXP EXPZ CL_PAREN      { 
                                                          if($3.nval-$4.nval==0){ 
                                                                $$.bval = true;
                                                                $$.type = 2;
                                                          }
                                                          else{
                                                                $$.bval = false;
                                                                $$.type = 2;
                                                          }
                                                    }
            ;

E_AND       : OP_PAREN AND EXP EXP_AND CL_PAREN         {
                                                            if($3.bval&&$4.bval){ 
                                                                $$.bval = true;
                                                                $$.type = 2;
                                                            }
                                                            else{
                                                                $$.bval = false;
                                                                $$.type = 2;
                                                            }
                                                        }
            ;
            
E_OR        : OP_PAREN OR EXP EXP_OR CL_PAREN           {
                                                            if($3.bval||$4.bval){ 
                                                                $$.bval = true;
                                                                $$.type = 2;
                                                            }
                                                            else{
                                                                $$.bval = false;
                                                                $$.type = 2;
                                                            }
                                                        }
            ;

E_NOT       : OP_PAREN NOT EXP CL_PAREN                 { $$.bval = !($3.bval); }
            ;

EXPX        : EXP                { $$.nval = $1.nval; }
            | EXP EXPX           { $$.nval = $1.nval + $2.nval; }
            ;
            
EXPY        : EXP                { $$.nval = $1.nval; }
            | EXP EXPY           { $$.nval = $1.nval * $2.nval; }
            ;
            
EXPZ        : EXP                { $$.nval = $1.nval; }
            | EXP EXPZ           {
                                    if($1.nval - $2.nval == 0){
                                        $$.bval = true;
                                    }
                                    else{
                                        $$.bval = false;
                                    }
                                 }
            ;
            
EXP_AND     : EXP                { $$.bval = $1.bval; }
            | EXP EXP_AND        {
                                    if($1.bval&&$2.bval){ 
                                        $$.bval = true;
                                        $$.type = 2;
                                    }
                                    else{
                                        $$.bval = false;
                                        $$.type = 2;
                                    }
                                 }
            ;
            
EXP_OR      : EXP               { $$.bval = $1.bval; }
            | EXP EXP_OR        {
                                    if($1.bval||$2.bval){ 
                                        $$.bval = true;
                                        $$.type = 2;
                                    }
                                    else{
                                        $$.bval = false;
                                        $$.type = 2;
                                    }
                                 }
            ;
            
TEST_EXP    : EXP               { $$ = $1; }
            ;

            
THEN_EXP    : EXP               { $$ = $1; }
            ;
            
ELSE_EXP    : EXP               { $$ = $1; }
            ;

%%
/* C++ code */

int main(void)
{   
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    cout << s << endl;
    exit(0);
}

void print_number(int num)
{
    cout << num << endl;
    return;
}

void print_bool(bool b)
{
    if(b){
        cout << "#t" << endl;
    }
    else{
        cout << "#f" << endl;
    }
    return;
}

void variable_define(char* ch, int n)
{
    string str(ch);
    typeID tmp;
    tmp.idname = str;
    tmp.val = n;
    
    if( idstack.size()==0 ){
        idstack.push_back(tmp);
        return;
    }
    else{
        for( int i=0; i< idstack.size(); i++){
            if( idstack[i].idname.compare(str) == 0){
                yyerror("syntax error");
                return;
            }
        }
        idstack.push_back(tmp);
    }
    return;
}

int variable(const char* ch)
{
    string str(ch);
    typeID tmp;
    tmp.idname = str;
    tmp.val = 0;
    
    /*check*/
    if( idstack.size()==0 ){
        yyerror("syntax error");
    }
    else{
        for( int i=0; i < idstack.size(); i++){
            /*find the coresponding variable*/
            if( str.compare(idstack[i].idname) == 0){
                return idstack[i].val;
            }
        }
        yyerror("syntax error");
    }
}
