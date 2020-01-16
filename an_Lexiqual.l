%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    typedef struct Unite Unite;
    typedef struct Unite{
      int line;
      char *nom;
      char *type;
      Unite *next;
    };

    typedef struct Table_Symb{
      Unite * first;
      Unite * last;
    }Table_Symb;


    Table_Symb * InitListe ();
    void add_Unite(char * type);
    void aficherTable();
    int exist(char * nom);
    int str_to_long(const char *s, long *p);
    void afficher_tirer();

    Table_Symb *head;

%}

%option yylineno

KEYWORD (ALGORITHME)|(VAR)|(FONCTION)|(DEBUT)|(FIN)|(Return)|(entier)|(reel)|(chaine)|($$include)
DECBIBL <{BIBLIOTHEQUES}>
BIBLIOTHEQUES (InOut)|(Arithme)
FONCTION_PRED (Lire)|(Ecrire)
OPERATEUR_ART [+-/]|"*"|(:=)
OPERATEUR_COMP [<>=]|(<=)|(>=)|(!=)
SEPARATEUR :|"("|")"|"."|"["|"]"
LETTRE [a-zA-Z]
CHIFRE [0-9]
NOMBRE {CHIFRE}+
ENTIER -?{NOMBRE}
REEL {ENTIER}\.{NOMBRE}
CHAINE \"[^\"]*\"
IDF {LETTRE}({LETTRE}|{CHIFRE}|_({LETTRE}|{CHIFRE}))*
COMMENTAIRE "/*"((("*"[^/])?)|[^*])*"*/"
SPACE [ \t]+

%%

<<EOF>> {yyterminate();}
{KEYWORD} {add_Unite("mots clee");}
{DECBIBL} {add_Unite("bibiliotheque");}
{FONCTION_PRED} {add_Unite("fonction predefinie");}
{OPERATEUR_COMP} {add_Unite("operateur de comparaison");}
{REEL} {add_Unite("reel");}
{ENTIER} {add_Unite("entier");}
{SEPARATEUR} {add_Unite("separateur");}
{OPERATEUR_ART} {add_Unite("operateur arithmetique");}
{CHAINE} {add_Unite("chaine");}
{IDF} {add_Unite("identificateur");}
{COMMENTAIRE} {printf("commentaire :\n%s\n\n",yytext);}
{SPACE}
\n
. {add_Unite("erreur Lexiqual");}

%%

Table_Symb * InitListe (){
  Table_Symb *head = malloc (sizeof(Table_Symb));
	head->first = NULL;
  head->last = NULL;
	return head;
}

void add_Unite(char type[]){
  if(!exist(yytext)){

    Unite *P;

    P = malloc(sizeof(Unite));
    if(head->first == NULL){
        head->first = P;
    }else{
      Unite *Q = head->last;
      Q->next = P;
    }
    head->last = P;

    if(!strcmp(type,"entier")){
        long a;
        if(!str_to_long(yytext, &a)){
            if(a<-32768 || a>32767){
                char *chaine = "ERREUR Entier trop grand ou petit";
                P->type = malloc((strlen(chaine)+1) * sizeof(char));
                strcpy(P->type, chaine);
            }else{
              char *chaine = "entier";
              P->type = malloc((strlen(chaine)+1) * sizeof(char));
              strcpy(P->type, chaine);
            }
        }
    }else if (!strcmp(type,"identificateur") && strlen(yytext)>8){
        char *chaine = "ERREUR Idf trop grand";
        P->type = malloc((strlen(chaine)+1) * sizeof(char));
        strcpy(P->type, chaine);
    }else{
        P->type = malloc((strlen(type)+1) * sizeof(char));
        strcpy(P->type, type);
    }


    P->nom = malloc((strlen(yytext)+1) * sizeof(char));
    strcpy(P->nom, yytext);
    P->line = yylineno;
    P->next = NULL;
  }
}

int exist(char * nom){
    Unite * P = head->first;
    while(P != NULL){
      if(!strcmp(P->nom, nom)){
        return 1;
      }
      P = P->next;
    }
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
    printf("\n\n\n/***************Table des Symboles***************/\n");
    afficher_tirer();
    printf("\t|\t\t  nom Entite  \t\t|\t\tcode Entite\t\t| Ligne\n");
    afficher_tirer();

    Unite *p = head->first;
    while(p != NULL){
        printf("\t|%40s | %35s | %d\n",p->nom, p->type, p->line);
        p = p->next;
    }
    afficher_tirer();
}

void afficher_tirer(){
  // une fonction qui affiche les tirer juste pour ne pas les ecrire a chaque fois
  // et avoir un meilleur affichage de la table
  for(int i=0;i<96;i++){
    printf("_");
  }
  printf("\n");
}

void main(){
    head = InitListe ();
    yylex();
    aficherTable(head);
}
