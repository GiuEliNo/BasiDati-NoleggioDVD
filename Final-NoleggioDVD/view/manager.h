#pragma once
#include "../model/db.h"


enum actions {
    AGGIUNGERE_IMPIEGATO,
    MODIFICARE_CARICA_O_SEDE,
    AGGIUNGERE_FILM,
    ELIMINARE_FILM,
    MODIFICARE_TURNI,
    QUIT,
    END_OF_ACTIONS
};



extern int get_manager_action();
extern void get_manager_register_impiegato_information(struct impiegato *impiegato);
extern void get_manager_input_new_site_or_role(struct management *management);
extern void get_manager_input_new_film_info(struct film *film);
extern void get_manager_input_film_to_remove(int * idFilm);
extern void get_manager_input_turno_information(struct turno *turno);