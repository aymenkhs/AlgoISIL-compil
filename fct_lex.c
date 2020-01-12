#include <stdio.h>
#include <stdlib.h>

#include "fct_lex.h"

Table_Symb * InitListe (){
	Table_Symb *head = malloc (sizeof(Table_Symb));
	head->first = NULL;
    head->last = NULL;
	return head;
}

Unite * add_Unite(Table_Symb * head, char * type, char * nomUnite, int line){
	Unite *P;

	P = malloc(sizeof(Unite));
	P->type = type;
    P->nom = nomUnite;
    P->line = line;
    P->next = NULL;

    Unite Q = head->last;
	Q->next = P;
    head->last = P;
	return P;
}

void aficherTable(Table_Symb * head){
    printf("\n/***************Table des Symboles***************/\n");
    printf("_____________________________________\n");
    printf("\t|nom Entite | code Entite | Ligne\n");
    printf("_____________________________________\n");

    Unite *P = Table_Symb->first;
    while(P != NULL){
        printf("\t|%s | %s | %d",p->nom, p->type, p->line);
    }
    printf("_____________________________________\n");
}
