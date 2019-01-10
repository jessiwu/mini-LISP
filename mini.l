%{
    #include "y.tab.h"
    void yyerror(const char *);
%}

letter [a-z]
digit [0-9]
separator (\t|\r)

number   (0|[-]?[1-9][0-9]*)
id       {letter}({letter}|{digit}|'-')*
boolval  (#t|#f)

def_stat    define
op_paren    [\(]
cl_paren    [\)]
plus        [\+]
minus       [\-]
multiply    [\*]
divide      [\/]
modulus     mod
greater     [\>]
smaller     [\<]
equal       =
logic_and   and
logic_or    or
logic_not   not
if_stat     if
printnum    print-num
printbool   print-bool

%%
\n              { ; }
<<EOF>>         { return 0; }
{printnum}      { return PRT_NUM; }
{printbool}     { return PRT_BOOL; }
{def_stat}      { return DEFINE; }
{op_paren}      { return OP_PAREN; }
{cl_paren}      { return CL_PAREN; }
{number}        { yylval.num = atoi(yytext); return NUM; }
{boolval}       { if(yytext[1]=='t'){ yylval.b = true; return BOOL_val; } else { yylval.b = false; return BOOL_val; } }
{plus}          { return PLUS; }
{minus}         { return MINUS; }
{multiply}      { return MUL; }
{divide}        { return DIV; }
{modulus}       { return MOD; }
{greater}       { return GREATER; }
{smaller}       { return SMALLER; }
{equal}         { return EQUAL; }
{logic_and}     { return AND; }
{logic_or}      { return OR; }
{logic_not}     { return NOT; }
{if_stat}            { return IF; }
{id}            { yylval.ch = strndup(yytext, yyleng); return ID; }
{separator}     { ; }
[ ]		        { ; }
.               { yyerror("syntax error"); }

%%
int yywrap (void) { return 1; }
