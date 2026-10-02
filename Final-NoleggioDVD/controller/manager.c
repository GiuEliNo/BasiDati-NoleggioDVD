
#include "manager.h"
#include <stdio.h>
#include <string.h>
#include "../model/db.h"
#include "../utils/io.h"
#include "../view/manager.h"





static bool aggiungere_impiegato(void){
    struct impiegato impiegato;
    memset(&impiegato, 0, sizeof(impiegato));
    get_manager_register_impiegato_information(&impiegato);
    do_aggiungere_impiegato(&impiegato);
    return false;
}




static bool modificare_carica_o_sede(void){
    struct management management;
    memset(&management,0,sizeof(management));
    get_manager_input_new_site_or_role(&management);
    do_update_role_or_site (&management);
    return false;
}


static bool aggiungere_film(void){
    struct film film;
    memset(&film,0,sizeof(film));
    get_manager_input_new_film_info(&film);
    do_aggiungere_film(&film);
    return false;
}

static bool eliminare_film(void){
    int idFilm;
    get_manager_input_film_to_remove(&idFilm);
    do_eliminare_film(&idFilm);
    return false;
}

static bool modifica_turni(void){
    struct turno turno;
    memset(&turno,0,sizeof(turno));
    get_manager_input_turno_information(&turno);
    do_modifica_turni(&turno);
    return false;
}

static bool quit(void)
{
    return true;
}




static struct {
    enum actions action;
    bool (*control)(void);
} controls[END_OF_ACTIONS] = {
        {.action = AGGIUNGERE_IMPIEGATO, .control = aggiungere_impiegato},
        {.action = MODIFICARE_CARICA_O_SEDE, .control = modificare_carica_o_sede},
        {.action = AGGIUNGERE_FILM, .control = aggiungere_film},
        {.action = ELIMINARE_FILM, .control = eliminare_film},
        {.action = MODIFICARE_TURNI, .control = modifica_turni},
        {.action = QUIT, .control = quit}
};






void manager_controller(void) {
    db_switch_to_manager();
    while (true) {
        int action;
        action = get_manager_action();

        if (action >= END_OF_ACTIONS) {
            fprintf(stderr, "Error: unknown action\n");
            continue;
        }
        if (controls[action].control())
            break;

        press_anykey();
    }
}