// http://www.nusphere.com/kb/css2manual/grammar.html
// http://www.w3.org/TR/CSS21/grammar.html
// http://flex.sourceforge.net/manual/Simple-Examples.html#Simple-Examples
// http://www.codeproject.com/Articles/20450/Simple-CSS-Parser
// http://souptonuts.sourceforge.net/readme_lemon_tutorial.html
// http://www.hwaci.com/sw/lemon/lemon.html
%include {
#include <stdio.h>
#include <assert.h>
}

%token_type {const char*}

%syntax_error
{
    fprintf(stderr, "Error parsing command\n");
}

start ::= css.
css ::= charset ruleset.
css ::= ruleset.

charset ::= CHARSET_SYM STRING SEMI.

ruleset ::= rule.
ruleset ::= rule ruleset.
rule    ::= selectorlist LBRACE decllist RBRACE.

selectorlist ::= selector.
selectorlist ::= selector COMMA selectorlist.

selector     ::= simple_selector.
selector     ::= simple_selector combinator selector.

simple_selector ::= element_name.
simple_selector ::= element_name selector_symbol.
simple_selector ::= selector_symlist.

selector_symbol ::= HASH.
selector_symbol ::= class.

selector_symlist ::= selector_symbol.
selector_symlist ::= selector_symbol selector_symlist.

element_name ::= IDENT.
element_name ::= STAR.

class ::= DOT IDENT.

combinator ::= PLUS.
combinator ::= GT.

decllist ::= declaration.
decllist ::= decllist SEMI declaration.

declaration ::= property COLON expr prio.

prio ::= IMPORTANT_SYM.

property ::= IDENT.

expr ::= term.
expr ::= term rtermlist.

rterm ::=  operator term.
rterm ::=  term.
rtermlist ::= rterm.
rtermlist ::= rterm rtermlist.

operator ::= SLASH.
operator ::= COMMA.

term ::= unary_operator measure.
term ::= measure.
term ::= STRING.
term ::= IDENT.
term ::= URI.
term ::= HEXCOLOR.

measure ::= NUMBER.
measure ::= PERCENTAGE.
measure ::= LENGTH.
measure ::= EMS.
measure ::= EXS.
measure ::= ANGLE.
measure ::= TIME.
measure ::= FREQ.
measure ::= DIMENSION.

unary_operator ::= PLUS.
unary_operator ::= MINUS.





