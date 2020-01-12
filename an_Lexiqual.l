%{
    #include "fct_lex.h"

    // Variables pour determiner la position (ligne...)
    int nb_unite_lexical = 0;
    int nb_ligne = 1; // les lignes commencent a 1
    int nb_unite_ligne = 0;

    Table_Symb * head = InitListe ();

    int erreur = 0;
}%

KEYWORD (Algorithme)|(Var)|(Fonction)|(Debut)|(Fin)|(Return)|(entier)|(reel)|(chaine)
DECBIBL &&include<{BIBLIOTHEQUES}>
BIBLIOTHEQUES (InOut)|(Arithme)|{IDF}
OPERATEUR_ART [+-/]|'*'
OPERATEUR_COMP [<>=]|(<=)|(>=)|(!=)
SEPARATEUR :|'('|')'|'.'
LETTRE [a-zA-Z]
CHIFRE [0-9]
NOMBRE {CHIFRE}+
ENTIER -?{NOMBRE}
REEL {ENTIER}\.{NOMBRE}
CHAINE "[^\"]"
IDF {LETTRE}({LETTRE}|{CHIFRE}|_({LETTRE}|{CHIFRE}))*
COMMENTAIRE "/*"((("*"[^/])?)|[^*])*"*/"
SPACE [ \t]

%%
KEYWORD {add_Unite(head ,yytext, "mots clee", nb_ligne)}
DECBIBL {add_Unite(head ,yytext, "bibiliotheque", nb_ligne)}
OPERATEUR_ART {add_Unite(head ,yytext, "operateur arithmetique", nb_ligne)}
OPERATEUR_COMP {add_Unite(head ,yytext, "operateur de comparaison", nb_ligne)}
ENTIER {add_Unite(head ,yytext, "entier", nb_ligne)}
REEL {add_Unite(head ,yytext, "reel", nb_ligne)}
CHAINE {add_Unite(head ,yytext, "chaine", nb_ligne)}
IDF {add_Unite(head ,yytext, "identificateur", nb_ligne)}
COMMENTAIRE {add_Unite(head ,yytext, "commentaire", nb_ligne)}
SPACE {}
\n {nb_ligne++;}
. {printf("erreur a la ligne %d\n", nb_ligne);}

%%

int main() {
    yylex();
    return 0;
}
