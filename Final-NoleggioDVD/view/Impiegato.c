#include <stdio.h>
#include <mariadb/mysql.h>

#include "../utils/io.h"
#include "../utils/validation.h"
#include "../model/db.h"
#include "../utils/db.h"

int get_impiegato_action(void)
{
    char options[12] = {'a','b', 'c', 'd','e','f','g','h','i','l','m','n'};
    char op;
    int op_int;
    clear_screen();
    puts("*********************************");
    puts("*    IMPIEGATO DASHBOARD    *");
    puts("*********************************\n");
    puts("*** What should I do for you? ***\n");
    puts("a) Registrare Noleggio");
    puts("b) Controllare data restituzione di un noleggio");
    puts("c) Restituire noleggio");
    puts("d) Aggiungere cliente");
    puts("e) Controllare diponibilità di un film");
    puts("f) Report ordini del giorno specificato");
    puts("g) Controllare turni mensili");
    puts("h) Verifica la posizione di un film nel centro");
    puts("i) Controlla copie residue di un film");
    puts("l) Verifica i remake di un film");
    puts("m) Verifica il costo di noleggio di un film");
    puts("n) Quit");

    op = multi_choice("Select an option", options, 11);

    if(op=='a') op_int=0;
    if(op=='b') op_int=1;
    if(op=='c') op_int=2;
    if(op=='d') op_int=3;
    if(op=='e') op_int=4;
    if(op=='f') op_int=5;
    if(op=='g') op_int=6;
    if(op=='h') op_int=7;
    if(op=='i') op_int=8;
    if(op=='l') op_int=9;
    if(op=='m') op_int=10;
    if(op=='n') op_int=11;
    return op_int;
}


void get_impiegato_register_noleggio_information(struct noleggio *noleggio){
    clear_screen();
    printf("** Benvenuto nella procedura di registrazione di un noleggio\n\n");

    printf("Inserisci cliente\n");
    int numeroTessera;
    fflush(stdin);
    scanf("%d",&numeroTessera);
    noleggio->idCliente=numeroTessera;
    printf("Inserisci Copia\n");
    int idCopia;
    fflush(stdin);
    scanf("%d",&idCopia);
    noleggio->idCopia=idCopia;
    int idFilm;
    fflush_unlocked(stdin);
    printf("Inserisci Film\n");
    scanf("%d",&idFilm);
    noleggio->idFilm=idFilm;
    int idInventario;
    fflush(stdin);
    printf("Inserisci Inventario\n");
    scanf("%d",&idInventario);
    noleggio->idInventario=idInventario;
    int idCentro;
    fflush(stdin);
    printf("Inserisci il centro\n");
    scanf("%d",&idCentro);
    noleggio->idCentro=idCentro;
    fflush(stdin);
    while(true) {
        fflush(stdin);
        if(validate_date(get_input("Inserisci la data Noleggio [YYYY-MM-DD]: ", DATE_LEN, noleggio->dataNoleggio, false)))
            break;
        fprintf(stderr, "Invalid date!\n");
    }
}

void get_impiegato_register_noleggio_id(struct noleggio *noleggio){
    clear_screen();
    printf("Benvenuto nella procedura di restituizione o di controllo data Restituzione\n\n");
    printf("Inserisci il numero del noleggio\n");
    int numeroNoleggio;
    scanf("%d", &numeroNoleggio);
    noleggio->idNoleggio=numeroNoleggio;
}


void get_impiegato_register_cliente_information(struct cliente *cliente){
    clear_screen();
    printf("Benvenuto nella procedura di iscrizione cliente\n\n");
    get_input("Inserisci il nome", NAME_LEN, cliente->nome, false);
    get_input("Inserisci il cognome", NAME_SURNAME_LEN, cliente->cognome, false);
    get_input("Inserisci il recapito", TEL_LEN, cliente->recapito, false);
}


void get_impiegato_register_film_information(struct film *film){
    clear_screen();
    printf("Benvenuto alla procedura di controllo se un film è disponibile nella nostra catena\n\n");
    get_input("Inserisci il titolo!\n\n", TITOLO_LEN, film->titolo, false);
    get_input("Inserisci il regista\n\n", REGISTA_LEN, film->regista, false);

}


void get_impiegato_check_info_ordini(char *data){
    clear_screen();
    printf("Benvenuto nella procedura di controllo ordini\n\n");
    while(true) {
        if(validate_date(get_input("Inserisci la data [YYYY-MM-DD]: ", DATE_LEN, data, false)))
            break;
        fprintf(stderr, "Invalid date!\n");
    }
}


void get_impiegato_check_info_turni(char *cf, char *data){

    clear_screen();
    printf("Benvenuto nella procedura di controllo turni\n\n");
    get_input("Inserisci il tuo codice fiscale.\n", CF_IMP, cf,false );
    while(true) {
        if(validate_date(get_input("Inserisci la data [YYYY-MM-DD]: ", DATE_LEN, data, false)))
            break;
        fprintf(stderr, "Invalid date!\n");
    }
    printf("Hai inserito: %s come Impiegato e %s come data\n\n", cf, data);
}



void get_impiegato_input_film_info_for_localization(int *idFilm, int *idCentro){
    clear_screen();
    printf("Benvenuto alla procedura di ricerca posizione di un film\n\n");
    printf("Inserisci il codice del film di interesse\n");
    scanf("%d", idFilm);
    printf("Inserisci il codice del centro\n");
    scanf("%d", idCentro);
}


void get_impiegato_film_info_for_copie_residue(int *idFilm, int * idCentro){
    clear_screen();
    printf("Benvenuto alla procedura per controllare le copie resiude di un film\n\n");
    printf("Inserisci il codice del film di interesse\n");
    fflush(stdin);
    scanf("%d", idFilm);
    printf("Inserisci il codice del centro\n");
    scanf("%d", idCentro);

}

void get_impiegato_input_film_remake_info(int *idFilm){
    clear_screen();
    printf("Benvenuto alla procedura per verificare i remake di un film!\n\n");
    printf("Inserisci il codice del film da verificare\n");
    fflush(stdin);
    scanf("%d", idFilm);
}


void print_data_restituzione(MYSQL_TIME *dataRestituzione){
    char data[DATE_LEN];
    clear_screen();
    mysql_date_to_string(dataRestituzione, data );
    printf("La data di restituizione di questo articolo è: %s", data);
    press_anykey();
}

void print_copie_residue(int *copieResidue){
    clear_screen();
    if(*copieResidue == -1){
        printf("C'è stato un errore nel recuperare il numero di copie \n\n");
        return;
    }
    else {
        printf("Le copie residue rimanenti sono : %d", *copieResidue);
        press_anykey();
    }
}


void print_report_noleggi(struct report_noleggi *noleggi){
    clear_screen();
    printf("Ordini del giorno: \n");
    for (size_t i = 0; i < noleggi->num_noleggi; i++){
        printf("Ordine n° %d: cliente %d copia %d inventario %d film %d centro %d ", noleggi->noleggio[i].idNoleggio,
               noleggi->noleggio[i].idCliente,
               noleggi->noleggio[i].idCopia,
               noleggi->noleggio[i].idInventario,
               noleggi->noleggio[i].idFilm,
               noleggi->noleggio[i].idCentro);



    }
    clear_screen();
}


void print_turni_mensili(struct turni_mensili *turni){
    clear_screen();
    printf("I tuoi turni mensili sono: \n");
    printf("Num entries: %d\n", turni->num_turni);
    if(turni->num_turni == 0){
        printf("\n ** Nessun turno questo mese, buona vacanza! ** \n");
        return;
    }
    for(size_t i =0; i < turni->num_turni; i++){
        char data[11];
        printf("Turno del giorno %s , Fascia : %s \n\n" , turni->turni[i].data, turni->turni[i].fascia);
    }

    press_anykey();
    clear_screen();
}

void view_disponibilita_film(int * codiceFilm){
    if(*codiceFilm == 0) {
        printf("Mi spiace, non abbiamo il titolo disponibile per il noleggio nella nostra catena, provi da BlockBuster\n\n");
        return;
    }
    else{
        printf("Il film da lei cercato è disponibile con il codice %d", *codiceFilm);
    }
}

void view_posizione_film(struct posizione_film *posizione){
    clear_screen();
    printf("Il film è posizionato: Scaffale %d, nel settore %d", posizione->scaffale, posizione->settore);
    press_anykey();
}


void view_film_remake_list(struct film_remake_list *film){
    clear_screen();
    printf("Ecco la lista dei remake del film:\n\n");
    for(size_t i=0; i < film->remakes; i++){
        printf("Film %d Titolo %s  Regista %s  Anno: %.4s ", film->film[i].idFilm, film->film[i].titolo, film->film[i].regista, film->film[i].anno);
    }
    press_anykey();
}

void get_impiegato_film_id_for_costo(int * film){
    clear_screen();
    printf("Inserisci il codice del film di cui vuoi vedere il costo\n");
    fflush(stdin);
    scanf("%d",film);

}


void view_costo_noleggio(int *costo){
    clear_screen();
    printf("Il costo di noleggio del film è: %d €", *costo);
}
/*void print_occupancy(struct occupancy *occupancy)
{
    clear_screen();
    printf("** Current Flight Occupancy **\n\n");

    for(size_t i = 0; i < occupancy->num_entries; i++) {
        printf("%s: %s (%s) -> %s (%s): booked %d/%d (%f%%)\n",
               occupancy->occupancy[i].idVolo,
               occupancy->occupancy[i].cittaPart,
               occupancy->occupancy[i].partenza,
               occupancy->occupancy[i].cittaArr,
               occupancy->occupancy[i].arrivo,
               occupancy->occupancy[i].prenotati,
               occupancy->occupancy[i].disponibili,
               occupancy->occupancy[i].occupazione);
    }
}
*/