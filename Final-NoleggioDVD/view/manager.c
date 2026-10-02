
#include <stdio.h>
#include <mariadb/mysql.h>

#include "../utils/io.h"
#include "../utils/validation.h"
#include "../model/db.h"
#include "manager.h"




int get_manager_action(void) {
    char options[6] = {'1','2','3','4','5','6'};
    char op;
    clear_screen();
    puts("*********************************");
    puts("*    MANAGER DASHBOARD    *");
    puts("*********************************\n");
    puts("*** What should I do for you? ***\n");
    puts("1) Aggiungere Impiegato");
    puts("2) Modificare carica o sede di un impiegato");
    puts("3) Aggiungere film");
    puts("4) Eliminare film");
    puts("5) Modificare turni");
    puts("6) Quit");

    op = multi_choice("Select an option", options, 11);
    return op - '1';
}

void get_manager_register_impiegato_information(struct impiegato *impiegato){
    clear_screen();
    printf("Benvenuto nella procedura di registrazione di un nuovo impiegato\n\n");
    get_input("Codice Fiscale?",  CF_IMP, impiegato->cf_Imp,false);
    get_input("Nome?", NAME_LEN, impiegato->nome, false);
    get_input("Cognome?", NAME_LEN, impiegato->cognome, false);
    get_input("titolo di studio?", TITOLO_LEN, impiegato->titoloDiStudio, false);
    get_input("Telefono?", TEL_LEN, impiegato->telefono, false);
}

void get_manager_input_new_site_or_role(struct management *management){
    clear_screen();
    printf("Benvenuto nella gestione degli impiegati per modificare sede o carica\n\n");
    get_input("Inserisci codice fiscale", CF_IMP, management->cf_Imp, false);
    printf("Inserisci il codice del centro");
    int centro;
    scanf("%d", &centro);
    management->centro=centro;
    printf("Inserisci il ruolo, 1 per impiegato, 2 per manager");
    int carica;
    scanf("%d", &carica);
    management->carica=carica;
}



void get_manager_input_new_film_info(struct film *film){
    clear_screen();
    printf("Benvenuto alla procedura di registrazione di un nuovo film\n\n");
    get_input("Inserisci il titolo", TITOLO_LEN, film->titolo, false);
    while(true) {
        if(validate_date(get_input("Inserisci la data  [YYYY-MM-DD]: ", DATE_LEN, film->anno, false)))
            break;
        fprintf(stderr, "Invalid date!\n");
    }
    get_input("Inserisci il regista", REGISTA_LEN, film->regista, false);
    get_input("Inserisci il tipo Classici| Nuove uscite", TIPO_LEN, film->tipo, false);
}


void get_manager_input_film_to_remove(int *idFilm){
    clear_screen();
    printf("Benvenuto alla procedura per rimuovere un film\n\n");
    printf("Inserisci il codice del film da rimuovere");
    scanf("%d", idFilm);
}

void get_manager_input_turno_information(struct turno *turno){
    clear_screen();
    printf("Benvenuto alla procedura di modifica turni");
    get_input("Inserisci l'impiegato: ", CF_IMP, turno->cf_Imp,false);
    while(true) {
        if (validate_date(get_input("inserisci la data del turno[YYYY-MM-DD]: ", DATE_LEN, turno->data, false)))
            break;
        fprintf(stderr, "Invalid date!\n");
    }

    get_input("Inserisci la fascia? [Mattina|Pomeriggio]\n",NAME_LEN, turno->fascia, false);

}