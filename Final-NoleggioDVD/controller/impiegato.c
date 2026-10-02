//
// Created by giuelino on 04/07/22.
//

#include <stdio.h>
#include <string.h>
#include "impiegato.h"
#include "../model/db.h"
#include "../view/Impiegato.h"
#include "../utils/io.h"



static bool effettuare_noleggio(void){
    struct noleggio noleggio;
    memset(&noleggio, 0, sizeof(noleggio));
    get_impiegato_register_noleggio_information(&noleggio);
    do_effettuare_noleggio(&noleggio);
    return false;
}



static bool controllare_data_restituizione(void){
    struct noleggio noleggio;
    MYSQL_TIME data;
    memset(&noleggio, 0, sizeof(noleggio));
    get_impiegato_register_noleggio_id(&noleggio);
    data=do_check_data_restituzione(&noleggio);
    print_data_restituzione(&data);
    return false;

}



static bool restituire_noleggio(void){
    struct noleggio noleggio;
    memset(&noleggio, 0, sizeof(noleggio));
    get_impiegato_register_noleggio_id(&noleggio);
    do_restituire_noleggio(&noleggio);
    return false; //TODO sistemare questa stored procedure
}

static bool aggiungere_cliente(void){
    struct cliente cliente;
    memset(&cliente,0,sizeof(cliente));
    get_impiegato_register_cliente_information(&cliente);
    do_aggiungere_cliente(&cliente);
    return false;
}


static bool controllare_disponibilita(void){
    struct film film;
    int codiceFilm;
    memset(&film,0,sizeof(film));
    get_impiegato_register_film_information(&film);
    codiceFilm=do_controllare_disponibilita(&film);
    view_disponibilita_film(&codiceFilm);
    return false;
}

static bool report_ordini_del_giorno(void) {
    char data_turno[DATE_LEN];
    get_impiegato_check_info_ordini(&data_turno);
    struct report_noleggi *noleggio = do_vedere_ordini_del_giorno(data_turno);
    if (noleggio != NULL) {
        print_report_noleggi(noleggio);
        dispose_report_noleggi(noleggio);
    }
    return false;
}

static bool controllare_turni_mensili(void){
    char data_turno[DATE_LEN];
    char cf_Imp[CF_IMP];
    get_impiegato_check_info_turni(cf_Imp, data_turno);
    struct turni_mensili *turni=do_controllare_turni_mensili(cf_Imp, data_turno);
    if (turni != NULL){
        print_turni_mensili(turni);
        dispose_turni_mensili(turni);
    }
    return false;
}

static bool verifica_posizione_film(void){
    int idFilm;
    int idCentro;
    get_impiegato_input_film_info_for_localization(&idFilm, &idCentro);
    struct posizione_film posizione=*do_verifica_posizione_film(&idFilm, &idCentro);
    view_posizione_film(&posizione);
    return false;
}

static bool check_copie_residue(void){
    int idFilm;
    int idCentro;
    get_impiegato_film_info_for_copie_residue(&idFilm,&idCentro);
    int copieResidue=do_check_copie_residue(&idFilm,&idCentro);
    print_copie_residue(&copieResidue);
    return false;
}


static bool verifica_remake(void){
    int idFilm;
    get_impiegato_input_film_remake_info(&idFilm);
    struct film_remake_list *films=do_verifica_film_remakes(&idFilm);
    view_film_remake_list(films);
    return false;
}

static bool quit(void)
{
    return true;
}

static bool verifica_costo_noleggio(){
    int idFilm;
    get_impiegato_film_id_for_costo(&idFilm);
    int costo= do_verifica_costo_noleggio(&idFilm);
    view_costo_noleggio(&costo);
    return false;
}
static struct {
    enum actions action;
    bool (*control)(void);
} controls[END_OF_ACTIONS] = {
        {.action = EFFETTUARE_NOLEGGIO, .control = effettuare_noleggio},
        {.action = CONTROLLARE_DATA_RESTITUZIONE, .control = controllare_data_restituizione},
        {.action = RESTITUIRE_NOLEGGIO, .control = restituire_noleggio},
        {.action = AGGIUNGERE_CLIENTE, .control = aggiungere_cliente},
        {.action = CONTROLLARE_DISPONIBILITA, .control = controllare_disponibilita},
        {.action = REPORT_ORDINI_DEL_GIORNO, .control = report_ordini_del_giorno},
        {.action = CONTROLLARE_TURNI_MENSILI, .control = controllare_turni_mensili},
        {.action = VERIFICA_POSIZIONE_FILM, .control = verifica_posizione_film},
        {.action = CHECK_COPIE_RESIDUE, .control = check_copie_residue},
        {.action = VERIFICA_REMAKE, .control = verifica_remake},
        {.action = VERIFICA_COSTO_NOLEGGIO, .control = verifica_costo_noleggio},
        {.action = QUIT, .control = quit}
};


void impiegato_controller(void) {
    db_switch_to_impiegato();
    while (true) {
        int action;
        action = get_impiegato_action();

        if (action >= END_OF_ACTIONS) {
            fprintf(stderr, "Error: unknown action\n");
            continue;
        }
        if (controls[action].control())
            break;

        press_anykey();
    }
}