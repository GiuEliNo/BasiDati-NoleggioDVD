#pragma once
#include "../model/db.h"

enum actions {
    EFFETTUARE_NOLEGGIO,
    CONTROLLARE_DATA_RESTITUZIONE,
    RESTITUIRE_NOLEGGIO,
    AGGIUNGERE_CLIENTE,
    CONTROLLARE_DISPONIBILITA,
    REPORT_ORDINI_DEL_GIORNO,
    CONTROLLARE_TURNI_MENSILI,
    VERIFICA_POSIZIONE_FILM,
    CHECK_COPIE_RESIDUE,
    VERIFICA_REMAKE,
    VERIFICA_COSTO_NOLEGGIO,
    QUIT,
    END_OF_ACTIONS
};

extern int get_impiegato_action(void);
extern void get_impiegato_register_noleggio_id(struct noleggio *noleggio);
extern void get_impiegato_register_cliente_information(struct cliente *cliente);
extern void get_impiegato_register_film_information(struct film *film);
extern void get_impiegato_check_info_ordini(char *s);
extern void get_impiegato_check_info_turni(char *cf, char *data);
extern void get_impiegato_input_film_info_for_localization(int * film, int * centro);
extern void get_impiegato_film_info_for_copie_residue(int *film, int * centro);
extern void get_impiegato_input_film_remake_info(int *film);
extern void get_impiegato_register_noleggio_information(struct noleggio *noleggio);
extern void print_data_restituzione(MYSQL_TIME *dataRestituzione0);
extern void print_report_noleggi(struct report_noleggi *noleggi);
extern void print_copie_residue(int * copie);
extern void view_posizione_film(struct posizione_film *posizione);
extern void print_turni_mensili(struct turni_mensili *turni);
extern void view_disponibilita_film(int * codiceFilm);
extern void view_film_remake_list(struct film_remake_list *film);
extern void get_impiegato_film_id_for_costo(int * codicefilm);
extern void view_costo_noleggio(int *costoNoleggio);