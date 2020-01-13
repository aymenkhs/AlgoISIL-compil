%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    typedef struct Unite Unite;
    typedef struct Unite{
      int line;
      char nom[100];
      char type[100];
      Unite *next;
    };

    typedef struct Table_Symb{
      Unite * first;
      Unite * last;
    }Table_Symb;


    Table_Symb * InitListe ();
    void add_Unite(char * type, int line);
    void aficherTable();
    int exist(char * nom);

    // Variables pour determiner la position (ligne...)
    int nb_unite_lexical = 0;
    int nb_ligne = 1; // les lignes commencent a 1
    int nb_unite_ligne = 0;

    Table_Symb *head;

    int erreur = 0;


%}

KEYWORD (ALGORITHME)|(VAR)|(FONCTION)|(DEBUT)|(FIN)|(Return)|(entier)|(reel)|(chaine)|($$include)
DECBIBL <{BIBLIOTHEQUES}>
BIBLIOTHEQUES (InOut)|(Arithme)
OPERATEUR_ART [+-/]|'*'|(:=)
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
SPACE [ \t]+

%%

<<EOF>> {yyterminate();}
{KEYWORD} {add_Unite("mots clee", nb_ligne);}
{DECBIBL} {add_Unite("bibiliotheque", nb_ligne);}
{OPERATEUR_ART} {add_Unite("operateur arithmetique", nb_ligne);}
{OPERATEUR_COMP} {add_Unite("operateur de comparaison", nb_ligne);}
{ENTIER} {add_Unite("entier", nb_ligne);}
{REEL} {add_Unite("reel", nb_ligne);}
{CHAINE} {add_Unite("chaine", nb_ligne);}
{IDF} {add_Unite("identificateur", nb_ligne);}
{COMMENTAIRE};
{SPACE};
\n {nb_ligne++;}
. {add_Unite("erreur Lexiqual", nb_ligne);}

%%

Table_Symb * InitListe (){
  Table_Symb *head = malloc (sizeof(Table_Symb));
	head->first = NULL;
  head->last = NULL;
	return head;
}

void add_Unite(char type[], int line){
  char *ch;
  strcpy(ch, yytext);
  if(!exist(ch)){

    Unite *P;

    P = malloc(sizeof(Unite));
    if(head->first == NULL){
        head->first = P;
    }else{
      Unite *Q = head->last;
      Q->next = P;
    }
    head->last = P;

    if(!strcmp(type,"ENTIER")){
        int a;
        if(!str_to_long(ch, &a)){
            if(a<-32768 || a>32767){
                P->type = "ERREUR Entier trop grand ou petit"
            }
        }
    }else{
        strcpy(P->type, type);
    }

    strcpy(P->nom, ch);
    P->line = line;
    P->next = NULL;
  }
}

int exist(char * nom){
    Unite * P = head->first;
    while(P != NULL){
      if(nb_ligne >16){
      }
      if(!strcmp(P->nom, nom)){
        printf("trv %s\n",nom);
        return 1;
      }
      P = P->next;
    }
    printf("ajout %s\n",nom);
    return 0;
}

int str_to_long(const char *s, long *p)
{
    int ret = 0; /* code d'erreur 0 : succès. */
    if (*s == '\0')
        ret = 1; /* code d'erreur 1 : la chaine à convertir est vide. */
    else
    {
        char *end;
        *p = strtol(s, &end, 10);

        if (errno != 0)
            ret = 2; /* code d'erreur 2 : la fonction strtol a rencontré une erreur. */
        else if (*end != '\0')
            ret = 3; /* code d'erreur 3 : la conversion a échoué car un caractère invalide a été détecté. */
    }

    return ret;
}

void aficherTable(){
    printf("\n/***************Table des Symboles***************/\n");
    printf("_____________________________________\n");
    printf("\t|nom Entite | code Entite | Ligne\n");
    printf("_____________________________________\n");

    Unite *p = head->first;
    while(p != NULL){
        printf("\t|%s | %s | %d\n",p->nom, p->type, p->line);
        p = p->next;
    }
    printf("_____________________________________\n");
}


void main(){
    head = InitListe ();
    yylex();
    aficherTable(head);
}
