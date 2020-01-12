#ifndef Fct_Lex
#define Fct_Lex


typedef struct Unite{
  int line;
  int unite_line;
  int num_unite;
  char * nom;
  char * type;
  IDF * next;
}Unite;

typedef struct Table_Symb{
	Unite * first;
    Unite * last;
}Table_Symb;

Table_Symb * InitListe ();
Unite * add_Unite(Table_Symb * head, char * type, char * nomUnite, int line);


#endif //Fct_Lex
