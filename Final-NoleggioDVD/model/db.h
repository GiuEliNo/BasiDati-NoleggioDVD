#pragma once
#include <stdbool.h>
#include <stdlib.h>
#include <mariadb/mysql.h>
extern bool init_db(void);
extern void fini_db(void);

#define DATE_LEN 11
#define TIME_LEN 6
#define DATETIME_LEN (DATE_LEN + TIME_LEN)

#define USERNAME_LEN 45
#define PASSWORD_LEN 45
struct credentials {
	char username[USERNAME_LEN];
	char password[PASSWORD_LEN];
};

typedef enum {
	MANAGER = 1,
    IMPIEGATO,
    LOGIN_ROLE,
	FAILED_LOGIN
} role_t;

extern void db_switch_to_login(void);
extern role_t attempt_login(struct credentials *cred);
extern void db_switch_to_manager(void);
extern void db_switch_to_impiegato(void);

#define TIPO_LEN 45
#define TITOLO_LEN 45
#define REGISTA_LEN 45
#define TIPO_LEN 45
#define CF_IMP 17
#define TEL_LEN 45

struct film {
    int idFilm;
    char titolo[TITOLO_LEN];
    char regista[REGISTA_LEN];
    char anno[DATE_LEN];
    char tipo[TIPO_LEN];
};

struct noleggio{
    int idNoleggio;
    int idCliente;
    int idCopia;
    int idInventario;
    int idFilm;
    int idCentro;
    char dataNoleggio[DATE_LEN];
    char dataRestituzione[DATE_LEN];
};


struct report_noleggi{
    unsigned num_noleggi;
    struct noleggio noleggio[];
};











#define NAME_SURNAME_LEN 45










struct impiegato{
    char cf_Imp[CF_IMP];
    char nome[NAME_SURNAME_LEN];
    char cognome[NAME_SURNAME_LEN];
    char titoloDiStudio[TITOLO_LEN];
    char telefono[TEL_LEN];
    char username[USERNAME_LEN];
};

struct management{
    char cf_Imp[CF_IMP];
    int centro;
    int carica;
};


struct turno{
    char cf_Imp[CF_IMP];
    char data[DATE_LEN];
    char fascia[NAME_LEN];
};


struct cliente{
    char nome[NAME_LEN];
    char cognome[NAME_SURNAME_LEN];
    char recapito[TEL_LEN];
};

struct turni_mensili{
    unsigned num_turni;
    struct turno turni[];
};


struct posizione_film{
    int scaffale;
    int settore;
};

struct film_remake_list{
    unsigned remakes; //Numero dei film remake
    struct film film[];
};


extern void do_aggiungere_film(struct film *film);
extern void do_effettuare_noleggio(struct noleggio *noleggio);
extern MYSQL_TIME do_check_data_restituzione(struct noleggio *noleggio);
extern void do_restituire_noleggio(struct noleggio *noleggio);
extern void do_aggiungere_cliente(struct cliente *cliente);
extern int do_controllare_disponibilita(struct film *film);
extern struct report_noleggi *do_vedere_ordini_del_giorno(char *data);
extern struct turni_mensili *do_controllare_turni_mensili(char *Impiegato, char * data);
extern struct posizione_film *do_verifica_posizione_film(int *idFilm, int *idCentro);
extern int do_check_copie_residue(int * idFilm, int * idCentro);
extern struct film_remake_list *do_verifica_film_remakes( int * idFilm);
extern void do_aggiungere_impiegato(struct impiegato *impiegato);
extern void do_update_role_or_site(struct management *management);
extern void do_eliminare_film(int * idFilm);
extern void do_modifica_turni(struct turno *turno);
extern void dispose_report_noleggi(struct report_noleggi *noleggi);
extern void dispose_turni_mensili(struct turni_mensili *turni);
extern int do_verifica_costo_noleggio(int * codiceFilm);