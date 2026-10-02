#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <mariadb/mysql.h>
#include <assert.h>

#include "db.h"
#include "../utils/db.h"

static MYSQL *conn;

static MYSQL_STMT *login_procedure;
static MYSQL_STMT *aggiungere_film;
static MYSQL_STMT *check_copie_residue;
static MYSQL_STMT *controllare_disponibilita;
static MYSQL_STMT *effettuare_noleggio;
static MYSQL_STMT *modificare_carica_o_sede_impiegato;
static MYSQL_STMT *report_ordini_del_giorno;
static MYSQL_STMT *verifica_costo_noleggio;
static MYSQL_STMT *verifica_remake;
static MYSQL_STMT *aggiungere_cliente;
static MYSQL_STMT *aggiungere_impiegato;
static MYSQL_STMT *controllare_dataRestituzione;
static MYSQL_STMT *controllare_turni_mensili;
static MYSQL_STMT *eliminare_film;
static MYSQL_STMT *modificare_turni;
static MYSQL_STMT *restituire_noleggio;
static MYSQL_STMT *verifica_posizione_film;

static void close_prepared_stmts(void)
{
	if(login_procedure) {
		mysql_stmt_close(login_procedure);
		login_procedure = NULL;
	}
	if(aggiungere_film) {
		mysql_stmt_close(aggiungere_film);
		aggiungere_film = NULL;
	}
	if(check_copie_residue) {
		mysql_stmt_close(check_copie_residue);
		check_copie_residue = NULL;
	}
	if(controllare_disponibilita) {
		mysql_stmt_close(controllare_disponibilita);
		controllare_disponibilita = NULL;
	}
	if(effettuare_noleggio) {
		mysql_stmt_close(effettuare_noleggio);
		effettuare_noleggio = NULL;
	}
    if(modificare_carica_o_sede_impiegato) {
        mysql_stmt_close(modificare_carica_o_sede_impiegato);
        modificare_carica_o_sede_impiegato = NULL;
    }
    if(report_ordini_del_giorno) {
        mysql_stmt_close(report_ordini_del_giorno);
        report_ordini_del_giorno = NULL;
    }
    if(verifica_costo_noleggio) {
        mysql_stmt_close(verifica_costo_noleggio);
        verifica_costo_noleggio = NULL;
    }
    if(verifica_remake) {
        mysql_stmt_close(verifica_remake);
        verifica_remake = NULL;
    }
    if(aggiungere_cliente) {
        mysql_stmt_close(aggiungere_cliente);
        aggiungere_cliente = NULL;
    }
    if(aggiungere_impiegato) {
        mysql_stmt_close(aggiungere_impiegato);
        aggiungere_impiegato = NULL;
    }
    if(controllare_dataRestituzione) {
        mysql_stmt_close(controllare_dataRestituzione);
        controllare_dataRestituzione = NULL;
    }
    if(controllare_turni_mensili) {
        mysql_stmt_close(controllare_turni_mensili);
        controllare_turni_mensili = NULL;
    }
    if(eliminare_film) {
        mysql_stmt_close(eliminare_film);
        eliminare_film = NULL;
    }
    if(modificare_turni) {
        mysql_stmt_close(modificare_turni);
        modificare_turni = NULL;
    }
    if(restituire_noleggio) {
        mysql_stmt_close(restituire_noleggio);
        restituire_noleggio = NULL;
    }
    if(verifica_posizione_film) {
        mysql_stmt_close(verifica_posizione_film);
        verifica_posizione_film = NULL;
    }


}

static bool initialize_prepared_stmts(role_t for_role)
{
	switch(for_role) {

		case LOGIN_ROLE:
			if(!setup_prepared_stmt(&login_procedure, "call login(?, ?, ?)", conn)) {
				print_stmt_error(login_procedure, "Unable to initialize login statement\n");
				return false;
			}
			break;

		case IMPIEGATO: //PREPARO TUTTE LE STORE PROCEDURE CHE PUÒ EFFETTUARE UN IMPIEGATO.
			if(!setup_prepared_stmt(&effettuare_noleggio, "call effettuare_noleggio(?, ?, ?, ?, ?, ?, ?)", conn)) {
				print_stmt_error(effettuare_noleggio, "Unable to initialize effettuare_noleggio statement\n");
				return false;
			}
			if(!setup_prepared_stmt(&controllare_dataRestituzione, "call controllare_dataRestituzione(?)", conn)) {
				print_stmt_error(controllare_dataRestituzione, "Unable to initialize dataRestituzione report statement\n");
				return false;
			}
            if(!setup_prepared_stmt(&restituire_noleggio, "call restituire_noleggio(?)", conn)) {
                print_stmt_error(restituire_noleggio, "Unable to initialize restituire_noleggio statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&aggiungere_cliente, "call aggiungere_cliente(?,?,?)", conn)) {
                print_stmt_error(aggiungere_cliente, "Unable to initialize aggiungere_cliente statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&controllare_disponibilita, "call controllare_disponibilita(?,?)", conn)) {
                print_stmt_error(controllare_disponibilita, "Unable to initialize disponibilità statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&report_ordini_del_giorno, "call report_ordini_del_giorno(?)", conn)) {
                print_stmt_error(report_ordini_del_giorno, "Unable to initialize report_ordini_del_giorno statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&controllare_turni_mensili, "call controllare_turni_mensili(?,?)", conn)) {
                print_stmt_error(controllare_turni_mensili, "Unable to check controllare_turni_mensili  statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&verifica_posizione_film, "call verifica_posizione_film(?,?)", conn)) {
                print_stmt_error(verifica_posizione_film, "Unable to initizialize verifica_posizione_film statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&check_copie_residue, "call check_copie_residue(?,?)", conn)) {
                print_stmt_error(check_copie_residue, "Unable to initialize check_copie_residue report statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&verifica_costo_noleggio, "call verifica_costo_noleggio(?)", conn)) {
                print_stmt_error(verifica_costo_noleggio, "Unable to initialize verifica_costo_noleggio report statement\n");
                return false;
            }
            if(!setup_prepared_stmt(&verifica_remake, "call verifica_remake(?)", conn)) {
                print_stmt_error(verifica_remake, "Unable to initialize verifica_remake statement\n");
                return false;
            }
			break;
        case MANAGER: //PREPARO TUTTE LE STORE PROCEDURE CHE PUÒ EFFETTUARE UN MANAGER.
        if(!setup_prepared_stmt(&aggiungere_impiegato, "call aggiungere_impiegato(?,?,?,?,?)",conn)) {
            print_stmt_error(aggiungere_impiegato, "Unable to initialize aggiungere_impiegato statement\n");
            return false;
        }
        if(!setup_prepared_stmt(&modificare_carica_o_sede_impiegato, "call modificare_carica_o_sede_impiegato(?,?,?)",conn)) {
            print_stmt_error(modificare_carica_o_sede_impiegato, "Unable to initialize modificare_carica_o_sede_impiegato statement\n");
            return false;
        }
        if(!setup_prepared_stmt(&aggiungere_film, "call aggiungere_film(?,?,?,?)",conn)) {
            print_stmt_error(aggiungere_film, "Unable to initialize aggiungere_film statement\n");
            return false;
        }
        if(!setup_prepared_stmt(&eliminare_film, "call eliminare_film(?)",conn)) {
        print_stmt_error(eliminare_film, "Unable to initialize eliminare_film statement\n");
        return false;
        }
        if(!setup_prepared_stmt(&modificare_turni, "call modificare_turni(?,?,?)",conn)) {
                print_stmt_error(modificare_turni, "Unable to initialize modificare_turni statement\n");
                return false;
            }
        break;
    default:
			fprintf(stderr, "[FATAL] Unexpected role to prepare statements.\n");
			exit(EXIT_FAILURE);
	}

	return true;
}

bool init_db(void)
{
	unsigned int timeout = 300;
	bool reconnect = true;

	conn = mysql_init(NULL);
	if(conn == NULL) {
		finish_with_error(conn, "mysql_init() failed (probably out of memory)\n");
	}

	if(mysql_real_connect(conn, getenv("HOST"), getenv("LOGIN_USER"), getenv("LOGIN_PASS"), getenv("DB"),
			      atoi(getenv("PORT")), NULL,
			      CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS | CLIENT_COMPRESS | CLIENT_INTERACTIVE | CLIENT_REMEMBER_OPTIONS) == NULL) {
		finish_with_error(conn, "mysql_real_connect() failed\n");
	}

	if (mysql_options(conn, MYSQL_OPT_CONNECT_TIMEOUT, &timeout)) {
		print_error(conn, "[mysql_options] failed.");
	}
	if(mysql_options(conn, MYSQL_OPT_RECONNECT, &reconnect)) {
		print_error(conn, "[mysql_options] failed.");
	}
#ifndef NDEBUG
	mysql_debug("d:t:O,/tmp/client.trace");
	if(mysql_dump_debug_info(conn)) {
		print_error(conn, "[debug_info] failed.");
	}
#endif

	return initialize_prepared_stmts(LOGIN_ROLE);
}


void fini_db(void)
{
	close_prepared_stmts();

	mysql_close(conn);
}


role_t attempt_login(struct credentials *cred)
{
	MYSQL_BIND param[3]; // Used both for input and output
	int role = 0;

	// Prepare parameters
	set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, cred->username, strlen(cred->username));
	set_binding_param(&param[1], MYSQL_TYPE_VAR_STRING, cred->password, strlen(cred->password));
	set_binding_param(&param[2], MYSQL_TYPE_LONG, &role, sizeof(role));

	if(mysql_stmt_bind_param(login_procedure, param) != 0) { // Note _param
		print_stmt_error(login_procedure, "Could not bind parameters for login");
		role = FAILED_LOGIN;
		goto out;
	}

	// Run procedure
	if(mysql_stmt_execute(login_procedure) != 0) {
		print_stmt_error(login_procedure, "Could not execute login procedure");
		role = FAILED_LOGIN;
		goto out;
	}

	// Prepare output parameters
	set_binding_param(&param[0], MYSQL_TYPE_LONG, &role, sizeof(role));

	if(mysql_stmt_bind_result(login_procedure, param)) {
		print_stmt_error(login_procedure, "Could not retrieve output parameter");
		role = FAILED_LOGIN;
		goto out;
	}

	// Retrieve output parameter
	if(mysql_stmt_fetch(login_procedure)) {
		print_stmt_error(login_procedure, "Could not buffer results");
		role = FAILED_LOGIN;
		goto out;
	}

    out:
	// Consume the possibly-returned table for the output parameter
	while(mysql_stmt_next_result(login_procedure) != -1) {}

	mysql_stmt_free_result(login_procedure);
	mysql_stmt_reset(login_procedure);
	return role;
}


void db_switch_to_login(void)
{
	close_prepared_stmts();
	if(mysql_change_user(conn, getenv("LOGIN_USER"), getenv("LOGIN_PASS"), getenv("DB"))) {
		fprintf(stderr, "mysql_change_user() failed: %s\n", mysql_error(conn));
		exit(EXIT_FAILURE);
	}
	if(!initialize_prepared_stmts(LOGIN_ROLE)) {
		fprintf(stderr, "[FATAL] Cannot initialize prepared statements.\n");
		exit(EXIT_FAILURE);
	}
}


void db_switch_to_manager(void)
{
	close_prepared_stmts();
	if(mysql_change_user(conn, getenv("MANAGER_USER"), getenv("MANAGER_PASS"), getenv("DB"))) {
		fprintf(stderr, "mysql_change_user() failed: %s\n", mysql_error(conn));
		exit(EXIT_FAILURE);
	}
	if(!initialize_prepared_stmts(MANAGER)) {
		fprintf(stderr, "[FATAL] Cannot initialize prepared statements.\n");
		exit(EXIT_FAILURE);
	}
}


void do_aggiungere_film(struct film *film)
{
	MYSQL_BIND param[4];
    MYSQL_TIME anno;

	// Make proper type conversion
    date_to_mysql_time(film->anno, &anno);

	// Bind parameters
	set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, film->titolo, strlen(film->titolo));
	set_binding_param(&param[1], MYSQL_TYPE_VAR_STRING, film->regista, strlen(film->regista));
	set_binding_param(&param[2], MYSQL_TYPE_DATE, &anno, sizeof(anno));
	set_binding_param(&param[3], MYSQL_TYPE_VAR_STRING, film->tipo, strlen(film->tipo));

	if(mysql_stmt_bind_param(aggiungere_film, param) != 0) {
		print_stmt_error(aggiungere_film, "Could not bind parameters for do_aggiungere_film");
		return;
	}

	// Run procedure
	if(mysql_stmt_execute(aggiungere_film) != 0) {
		print_stmt_error(aggiungere_film, "Could not execute aggiungere_film procedure");
		return;
	}

	mysql_stmt_free_result(aggiungere_film);
	mysql_stmt_reset(aggiungere_film);
}

void do_aggiungere_impiegato(struct impiegato *imp){
    MYSQL_BIND param[6];

    //Bind Parameters
    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, imp->cf_Imp, strlen(imp->cf_Imp));
    set_binding_param(&param[1],MYSQL_TYPE_VAR_STRING, imp->nome, strlen(imp->nome));
    set_binding_param(&param[2], MYSQL_TYPE_VAR_STRING, imp->cognome,strlen(imp->cognome));
    set_binding_param(&param[3],MYSQL_TYPE_VAR_STRING,imp->titoloDiStudio, strlen(imp->titoloDiStudio));
    set_binding_param(&param[4],MYSQL_TYPE_VAR_STRING, imp->telefono, strlen(imp->telefono));
    set_binding_param(&param[5],MYSQL_TYPE_VAR_STRING,imp->username, strlen(imp->username));

    if(mysql_stmt_bind_param(aggiungere_impiegato,param)!=0){
        print_stmt_error(aggiungere_impiegato, "Could not bind parameters for aggiungere_impiegato procedure");
        return;
    }

    //Run procedure
    if(mysql_stmt_execute(aggiungere_impiegato) != 0) {
        print_stmt_error(aggiungere_impiegato, "Could not execute aggiungere_film procedure");
        return;
    }
    mysql_stmt_free_result(aggiungere_impiegato);
    mysql_stmt_reset(aggiungere_impiegato);

}

void do_update_role_or_site (struct management *management){
    MYSQL_BIND param[3];
    int carica;
    int centro;
    carica=management->carica;
    centro=management->centro;

    //BIND PARAMETERS
    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, management->cf_Imp, strlen(management->cf_Imp));
    set_binding_param(&param[1],MYSQL_TYPE_LONG, &centro, sizeof(centro));
    set_binding_param(&param[2], MYSQL_TYPE_LONG, &carica, sizeof(carica));

    if(mysql_stmt_bind_param(modificare_carica_o_sede_impiegato, param)!=0){
        print_stmt_error(modificare_carica_o_sede_impiegato,"Could not bind modificare_carica_o_sede_impiegato param");
        return;
    }

    if(mysql_stmt_execute(modificare_carica_o_sede_impiegato) != 0) {
        print_stmt_error(modificare_carica_o_sede_impiegato, "Could not execute modificare_carica_o_sede_impiegato procedure");
        return;
    }
    mysql_stmt_free_result(modificare_carica_o_sede_impiegato);
    mysql_stmt_reset(modificare_carica_o_sede_impiegato);

}

void do_eliminare_film(int *idFilm){
    MYSQL_BIND param[1];

    //BIND PARAMETER
    set_binding_param(&param[0],MYSQL_TYPE_LONG,idFilm, sizeof(idFilm));
    if(mysql_stmt_bind_param(eliminare_film,param)!=0){
        print_stmt_error(eliminare_film, "Could not bind eliminare-film param");
        return;
    }
    if(mysql_stmt_execute(eliminare_film) != 0) {
        print_stmt_error(eliminare_film, "Could not execute eliminare_film procedure");
        return;
    }

    mysql_stmt_free_result(eliminare_film);
    mysql_stmt_reset(eliminare_film);
}



void do_modifica_turni(struct turno *turno){

    MYSQL_BIND param[3];
    MYSQL_TIME data;
    date_to_mysql_time(turno->data, &data);


    //BIND PARAMETERS

    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, turno->cf_Imp,strlen(turno->cf_Imp)); //in
    set_binding_param(&param[1],MYSQL_TYPE_DATE, &data, sizeof(data)); //IN
    set_binding_param(&param[2], MYSQL_TYPE_VAR_STRING, turno->fascia, strlen(turno->fascia)); //IN



    if(mysql_stmt_bind_param(modificare_turni,param)!=0){
        print_stmt_error(modificare_turni, "Could not bind modificare_turni param");
        goto OUT;
    }
    if(mysql_stmt_execute(modificare_turni) != 0) {
        print_stmt_error(modificare_turni, "Could not execute aggiungere_film procedure");
        goto OUT;
    }

    OUT:
    mysql_stmt_free_result(modificare_turni);
    mysql_stmt_reset(modificare_turni);
    return;

}
//FINITI I BINDING DELLE STORE PROCEDURES DEL MANAGER

void do_effettuare_noleggio(struct noleggio *noleggio){

    MYSQL_BIND param[7];
    int Copia;
    int Film;
    int Inventario;
    int Centro;
    int Cliente;
    MYSQL_TIME dataNoleggio;
    MYSQL_TIME dataRestituzione;
    Copia=noleggio->idCopia;
    Film=noleggio->idFilm;
    Inventario=noleggio->idInventario;
    Centro=noleggio->idCentro;
    date_to_mysql_time(noleggio->dataNoleggio,&dataNoleggio);
    date_to_mysql_time(noleggio->dataNoleggio, &dataRestituzione);
    Cliente= noleggio->idCliente;

    //BIND of PARAMETERS
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &Cliente, sizeof(Cliente));
    set_binding_param(&param[1], MYSQL_TYPE_LONG, &Copia, sizeof(Copia));
    set_binding_param(&param[2], MYSQL_TYPE_DATE, &dataNoleggio, sizeof(dataNoleggio));
    set_binding_param(&param[3],MYSQL_TYPE_DATE,&dataRestituzione,sizeof(dataRestituzione));
    set_binding_param(&param[4], MYSQL_TYPE_LONG, &Centro, sizeof(Centro));
    set_binding_param(&param[5],MYSQL_TYPE_LONG,&Inventario, sizeof(Inventario));
    set_binding_param(&param[6], MYSQL_TYPE_LONG, &Film , sizeof(Film));

    if(mysql_stmt_bind_param(effettuare_noleggio,param)!=0) {
        print_stmt_error(effettuare_noleggio, "Could not bind eseguire noleggio param");
        return;
    }
    if(mysql_stmt_execute(effettuare_noleggio) != 0) {
        print_stmt_error(effettuare_noleggio, "Could not execute effettuare_noleggio procedure");
        return;
    }

    mysql_stmt_free_result(effettuare_noleggio);
    mysql_stmt_reset(effettuare_noleggio);

}

MYSQL_TIME do_check_data_restituzione(struct noleggio *noleggio){
    MYSQL_BIND param[1];
    MYSQL_TIME dataRestituzione;
    init_mysql_date(&dataRestituzione);
    int codiceTransazione;
    codiceTransazione= noleggio ->idNoleggio;
    //BIND OF PARAMETERS
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &codiceTransazione , sizeof(codiceTransazione)); //IN
    if(mysql_stmt_bind_param(controllare_dataRestituzione,param)!=0){
        print_stmt_error(controllare_dataRestituzione,"Could not bind controllare-data restituzione input");
        goto OUT;
    }
    if(mysql_stmt_execute(controllare_dataRestituzione) != 0) {
        print_stmt_error(controllare_dataRestituzione, "Could not execute controllare_data procedure");
        goto OUT;
    }



    //BIND OUTPUT
    set_binding_param(&param[0], MYSQL_TYPE_DATE, &dataRestituzione, sizeof(dataRestituzione));

    if(mysql_stmt_bind_result(controllare_dataRestituzione,param)!=0) {
        print_stmt_error(controllare_dataRestituzione, "Impossibile boundare i risultati in uscita");
    }

    // store_results should be called *after* binding and *before* fetching rows.
    if (mysql_stmt_store_result(controllare_dataRestituzione)) {
        print_stmt_error(controllare_dataRestituzione, "Impossible store result for controllare_data_restituzione");
        goto OUT;
    }

    if(mysql_stmt_fetch(controllare_dataRestituzione)) {
        print_stmt_error(controllare_dataRestituzione, "Could not buffer results");
        goto OUT;
    }

    OUT:
    mysql_stmt_free_result(controllare_dataRestituzione);
    mysql_stmt_reset(controllare_dataRestituzione);
    return dataRestituzione;
}


void do_restituire_noleggio(struct noleggio *noleggio) {
    MYSQL_BIND param[1];
    int codiceNoleggio;
    codiceNoleggio = noleggio->idNoleggio;


    //BIND OF PARAMETER
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &codiceNoleggio, sizeof(codiceNoleggio));
    if (mysql_stmt_bind_param(restituire_noleggio, param) != 0) {
        print_stmt_error(restituire_noleggio, "Could not bind restituire_noleggio params");
        return;
    }
    if(mysql_stmt_execute(restituire_noleggio) != 0) {
        print_stmt_error(restituire_noleggio, "Could not execute restituire_noleggio procedure");
        return;
    }

    mysql_stmt_free_result(restituire_noleggio);
    mysql_stmt_reset(restituire_noleggio);

}


void do_aggiungere_cliente(struct cliente *cliente){
    MYSQL_BIND param[3];


    //BIND OF PARAMETERS

    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, cliente->nome,strlen(cliente->nome));
    set_binding_param(&param[1], MYSQL_TYPE_VAR_STRING, cliente->cognome,strlen(cliente->cognome));
    set_binding_param(&param[2], MYSQL_TYPE_VAR_STRING, cliente->recapito,strlen(cliente->recapito));

    if(mysql_stmt_bind_param(aggiungere_cliente,param)!=0){
        print_stmt_error(aggiungere_cliente, "Could not bind aggiungere_cliente");
        return;


    }

    if(mysql_stmt_execute(aggiungere_cliente) != 0) {
        print_stmt_error(aggiungere_cliente, "Could not execute aggiungere_cliente procedure");
        return;
    }
    mysql_stmt_free_result(aggiungere_cliente);
    mysql_stmt_reset(aggiungere_cliente);

}

int do_controllare_disponibilita(struct film *film){
    MYSQL_BIND param[2];
    int codiceFilm =0;
    //BIND params

    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, film->titolo, strlen(film->titolo)); //IN
    set_binding_param(&param[1], MYSQL_TYPE_VAR_STRING, film->regista, strlen(film->regista)); //IN


    if(mysql_stmt_bind_param(controllare_disponibilita,param)!=0){
        print_stmt_error(controllare_disponibilita, "Could not bind controllare-disponibilità");
        goto OUT;
    }
    if(mysql_stmt_execute(controllare_disponibilita) != 0) {
        print_stmt_error(controllare_disponibilita, "Could not execute controllare-disponibilità procedure");
        goto OUT;
    }
    mysql_stmt_store_result(controllare_disponibilita);

    //BIND output

    set_binding_param(&param[0], MYSQL_TYPE_LONG, &codiceFilm, sizeof(codiceFilm));  //OUT
    if(mysql_stmt_bind_result(controllare_disponibilita,param)!=0){
        print_stmt_error(controllare_disponibilita,"Could not bind result!");
        goto OUT;
    }
    if(mysql_stmt_fetch(controllare_disponibilita)!=0){
        print_stmt_error(controllare_disponibilita,"Could not retrieve code");
        goto OUT;
    }

    OUT:
    mysql_stmt_free_result(controllare_disponibilita);
    mysql_stmt_reset(controllare_disponibilita);
    return codiceFilm;
}

struct report_noleggi *do_vedere_ordini_del_giorno(char *data_check){

    MYSQL_BIND param[9];
    size_t row=0;
    int idNoleggio;
    int idCliente;
    int idCopia;
    int idInventario;
    int idFilm;
    int idCentro;
    MYSQL_TIME dataNoleggio;
    MYSQL_TIME dataRestituzione;
    MYSQL_TIME data;
    date_to_mysql_time(data_check, &data );
    int status;

    struct report_noleggi *noleggi;

    set_binding_param(&param[0], MYSQL_TYPE_DATE, &data, sizeof(data)); //

    if(mysql_stmt_bind_param(report_ordini_del_giorno,param)!=0){
        print_stmt_error(report_ordini_del_giorno, "Could not bind report ordini del giorno param");
        goto OUT;
    }

    if(mysql_stmt_execute(report_ordini_del_giorno)!=0){
        print_stmt_error(report_ordini_del_giorno, "Could not execute report ordini del giorno");
        goto OUT;
    }

    mysql_stmt_store_result(report_ordini_del_giorno);
    noleggi=malloc(sizeof(*noleggi) + sizeof(struct noleggio) * mysql_stmt_num_rows(report_ordini_del_giorno));
    if (noleggi==NULL){
        goto OUT;
    }
    memset(noleggi, 0, sizeof(*noleggi) + sizeof(struct noleggio)* mysql_stmt_num_rows(report_ordini_del_giorno));
    noleggi->num_noleggi= mysql_stmt_num_rows(report_ordini_del_giorno); //Imposto i numeri di noleggi da riportare al numero di righe del result set corrispondente
    mysql_stmt_store_result(report_ordini_del_giorno);

    //BIND dei parametri di uscita

    set_binding_param(&param[1], MYSQL_TYPE_LONG, &idNoleggio, sizeof(idNoleggio));
    set_binding_param(&param[2], MYSQL_TYPE_LONG, &idCliente, sizeof(idCliente));
    set_binding_param(&param[3], MYSQL_TYPE_LONG,&idCopia,sizeof(idCopia));
    set_binding_param(&param[4],MYSQL_TYPE_LONG, &idInventario, sizeof(idInventario));
    set_binding_param(&param[5], MYSQL_TYPE_LONG, &idFilm, sizeof(idFilm));
    set_binding_param(&param[6], MYSQL_TYPE_LONG, &idCentro, sizeof(idCentro));
    set_binding_param(&param[7],MYSQL_TYPE_DATETIME, &dataNoleggio, sizeof(dataNoleggio));
    set_binding_param(&param[8],MYSQL_TYPE_DATE,&dataRestituzione,sizeof(dataRestituzione));

    if(mysql_stmt_bind_result(report_ordini_del_giorno,param)!=0){
        print_stmt_error(report_ordini_del_giorno, "Could not bind report ordini del giorno param");
        free(noleggi);
        noleggi=NULL;
        goto OUT;
    }

    while(1){
        status= mysql_stmt_fetch(report_ordini_del_giorno);
        if (status==1 || status == MYSQL_NO_DATA)
            break;

        noleggi->noleggio[row].idNoleggio= idNoleggio;
        noleggi->noleggio[row].idCopia= idCopia;
        noleggi->noleggio[row].idInventario= idInventario;
        noleggi->noleggio[row].idCliente= idCliente;
        noleggi->noleggio[row].idFilm= idFilm;
        noleggi->noleggio[row].idCentro= idCentro;
        mysql_timestamp_to_string(&dataNoleggio, noleggi->noleggio[row].dataNoleggio);
        mysql_timestamp_to_string(&dataRestituzione, noleggi->noleggio[row].dataRestituzione);

        row++;
    }

    OUT:
    mysql_stmt_free_result(report_ordini_del_giorno);
    mysql_stmt_reset(report_ordini_del_giorno);
    return noleggi;

}

void dispose_report_noleggi(struct report_noleggi *noleggi)
{
    free(noleggi);
}






struct turni_mensili *do_controllare_turni_mensili(char* Impiegato, char* data_check){
    int status;
    MYSQL_BIND param[3];
    char cf_Imp[CF_IMP];
    MYSQL_TIME dataTurno;
    MYSQL_TIME data;
    char fascia[NAME_LEN];
    date_to_mysql_time(data_check, &data );
    init_mysql_date(&dataTurno);

    struct turni_mensili *turni;
    size_t row=0;
    //BIND parameters

    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, Impiegato, strlen(Impiegato)); //in
    set_binding_param(&param[1], MYSQL_TYPE_DATE, &data, sizeof(data)); //in


    if(mysql_stmt_bind_param(controllare_turni_mensili,param)!=0){
        print_stmt_error(controllare_turni_mensili, "Could not bind report controllare_turni_mensili input param");
        goto OUT;
    }

    if(mysql_stmt_execute(controllare_turni_mensili)!=0) {
        print_stmt_error(controllare_turni_mensili, "Could not execute controllare turni mensili");
        goto OUT;
    }

    mysql_stmt_store_result(controllare_turni_mensili);

    turni=malloc(sizeof(*turni) + sizeof(struct turno)* mysql_stmt_num_rows(controllare_turni_mensili));
    if(turni == NULL) {
        printf("Impossibile fare il malloc\n");
        goto OUT;
    }

    memset(turni, 0, sizeof(*turni)+ sizeof(struct turno)* mysql_stmt_num_rows(controllare_turni_mensili));
    turni->num_turni= mysql_stmt_num_rows(controllare_turni_mensili);
    mysql_stmt_store_result(controllare_turni_mensili);

    //bind parameters

    set_binding_param(&param[0], MYSQL_TYPE_VAR_STRING, cf_Imp, strlen(cf_Imp));
    set_binding_param(&param[1], MYSQL_TYPE_DATETIME, &dataTurno, sizeof(dataTurno));
    set_binding_param(&param[2], MYSQL_TYPE_VAR_STRING, fascia, strlen(fascia));


    if(mysql_stmt_bind_result(controllare_turni_mensili,param)!=0){
        print_stmt_error(controllare_turni_mensili, "Could not bind controllare turni mensili out param");
        free(turni);
        turni=NULL;
        goto OUT;
    }

    while(1) {
        status = mysql_stmt_fetch(controllare_turni_mensili);
        if (status == 1 || status == MYSQL_NO_DATA)
            break;

        strcpy(turni->turni[row].cf_Imp, cf_Imp);
        mysql_date_to_string(&dataTurno, turni->turni[row].data);
        strcpy(turni->turni[row].fascia, fascia);

        row++;
    }
    OUT:
    mysql_stmt_free_result(controllare_turni_mensili);
    mysql_stmt_reset(controllare_turni_mensili);
    return turni;
}


extern void dispose_turni_mensili(struct turni_mensili *turni){
    free(turni);
}

struct posizione_film *do_verifica_posizione_film(int* idFilm, int* idCentro){

    MYSQL_BIND param[2];

    int scaffale;
    int settore;
    struct posizione_film *posizione;

    set_binding_param(&param[0],MYSQL_TYPE_LONG, idFilm, sizeof(idFilm)); //in
    set_binding_param(&param[1],MYSQL_TYPE_LONG, idCentro, sizeof(idCentro)); //in

    if(mysql_stmt_bind_param(verifica_posizione_film,param)!=0){
        print_stmt_error(verifica_posizione_film, "Could not bind verifica_posizione_film param");
        goto OUT;
    }

    if(mysql_stmt_execute(verifica_posizione_film)!=0){
        print_stmt_error(verifica_posizione_film, "Could not execute, verifica-posizione-film param");
        goto OUT;
    }


    posizione=malloc(sizeof(*posizione));
    if(posizione == NULL)
        goto OUT;
    memset(posizione, 0, sizeof(*posizione));
    mysql_stmt_store_result(verifica_posizione_film);

    //bind parametri in uscita
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &scaffale, sizeof(scaffale));
    set_binding_param(&param[1],MYSQL_TYPE_LONG, &settore, sizeof(settore));

    if(mysql_stmt_bind_result(verifica_posizione_film,param)!=0){
        print_stmt_error(verifica_posizione_film, "Could not bind verifica_posizione_film param in out");
        goto OUT;
    }
    // Retrieve output parameter
    if(mysql_stmt_fetch(verifica_posizione_film)) {
        print_stmt_error(verifica_posizione_film, "Could not buffer results");
        goto OUT;
    }

    posizione->scaffale=scaffale;
    posizione->settore=settore;

    OUT:
    mysql_stmt_free_result(verifica_posizione_film);
    mysql_stmt_reset(verifica_posizione_film);
    return posizione;

}


int do_check_copie_residue(int *idFilm, int *idCentro){
    MYSQL_BIND param[3];
    int copieResidue=-1;


    //BINDING of PARAM
    set_binding_param(&param[0], MYSQL_TYPE_LONG, idFilm, sizeof(idFilm));  //IN
    set_binding_param(&param[1], MYSQL_TYPE_LONG, idCentro, sizeof(idCentro)); //IN


    if(mysql_stmt_bind_param(check_copie_residue, param)!=0){
        print_stmt_error(check_copie_residue, "Could not BIND check-copie-residue param in");
        goto OUT;
    }

    if(mysql_stmt_execute(check_copie_residue)!=0){
        print_stmt_error(check_copie_residue, "Could not execute copie residue stmt");
        goto OUT;
    }
    mysql_stmt_store_result(check_copie_residue);

    //BIND output

    set_binding_param(&param[0], MYSQL_TYPE_LONG, &copieResidue, sizeof(copieResidue)); //OUT
    if(mysql_stmt_bind_result(check_copie_residue, param)!=0){
        print_error(check_copie_residue, "Could not bind output");
    }
    mysql_stmt_store_result(check_copie_residue);
    mysql_stmt_fetch(check_copie_residue);


    OUT:
    mysql_stmt_free_result(check_copie_residue);
    mysql_stmt_reset(check_copie_residue);
    return copieResidue;

}

struct film_remake_list *do_verifica_film_remakes(int *idFilm){
    int status;
    size_t row=0;
    MYSQL_BIND param[4];
    char titolo[TITOLO_LEN];
    char anno[TIME_LEN];
    MYSQL_TIME year;
    struct film_remake_list *filmList;
    char regista[REGISTA_LEN];
    int idFilmRemake;
    //BIND param

    set_binding_param(&param[0], MYSQL_TYPE_LONG, idFilm, sizeof(idFilm));

    if(mysql_stmt_bind_param(verifica_remake,param)!=0){
        print_stmt_error(verifica_remake,"Could not bind param for verifica_remake");
        goto OUT;
    }

    if(mysql_stmt_execute(verifica_remake)!=0){
        print_stmt_error(verifica_remake, "Could not execute verifica remake");
        goto OUT;
    }

    if(mysql_stmt_store_result(verifica_remake)!=0){
        print_stmt_error(verifica_remake, "could not store result for verifica_remake");
        goto OUT;
    }

    filmList=malloc(sizeof(*filmList) + sizeof(struct film) * mysql_stmt_num_rows(verifica_remake));
    if(filmList==NULL) {
        goto OUT;
    }
    memset(filmList,0,sizeof(*filmList)+sizeof(struct film)*mysql_stmt_num_rows(verifica_remake));
    filmList->remakes= mysql_stmt_num_rows(verifica_remake);

    //BIND PARAM
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &idFilmRemake, sizeof(idFilmRemake));
    set_binding_param(&param[1], MYSQL_TYPE_VAR_STRING, &titolo, strlen(titolo));
    set_binding_param(&param[2], MYSQL_TYPE_YEAR, &year, sizeof(year));
    set_binding_param(&param[3], MYSQL_TYPE_VAR_STRING,&regista, strlen(regista));

    if(mysql_stmt_bind_result(verifica_remake,param)!=0){
        print_stmt_error(verifica_remake,"Could not bind verifica-remake-out-param");
        free(filmList);
        filmList=NULL;
        goto OUT;
    }



    printf("%s %s \n\n",titolo, regista);
    while(true) {
        status = mysql_stmt_fetch(verifica_remake);

        if (status == 1 || status == MYSQL_NO_DATA) {
            break;
        }
        filmList->film[row].idFilm = idFilmRemake;
        strcpy(filmList->film[row].titolo, titolo);
        mysql_date_to_string(&year, anno);
        strcpy(filmList->film[row].anno, anno);
        strcpy(filmList->film[row].regista, regista);

        row++;


    }


    OUT:
    mysql_stmt_free_result(verifica_remake);
    mysql_stmt_reset(verifica_remake);
    return filmList;

}


void db_switch_to_impiegato(void)
{
    close_prepared_stmts();
    if(mysql_change_user(conn, getenv("IMPIEGATO_USER"), getenv("IMPIEGATO_PASS"), getenv("DB"))) {
        fprintf(stderr, "mysql_change_user() failed: %s\n", mysql_error(conn));
        exit(EXIT_FAILURE);
    }
    if(!initialize_prepared_stmts(IMPIEGATO)) {
        fprintf(stderr, "[FATAL] Cannot initialize prepared statements.\n");
        exit(EXIT_FAILURE);
    }
}


int do_verifica_costo_noleggio(int * codiceFilm){
    MYSQL_BIND param[1];
    int Film;
    Film=*codiceFilm;
    int Costo;
    set_binding_param(&param[0], MYSQL_TYPE_LONG,&Film, sizeof(Film));

    if(mysql_stmt_bind_param(verifica_costo_noleggio,param)!=0){
        print_stmt_error(verifica_costo_noleggio,"Could not bind input param");
        goto OUT;
    }
    if(mysql_stmt_execute(verifica_costo_noleggio)!=0){
        print_stmt_error(verifica_costo_noleggio, "could not execute verifica costo noleggio");
        goto OUT;
    }
    //OUT
    set_binding_param(&param[0], MYSQL_TYPE_LONG, &Costo, sizeof(Costo));
    if(mysql_stmt_bind_result(verifica_costo_noleggio,param)!=0){
        print_stmt_error(verifica_costo_noleggio, "Could not bind output param");
        goto OUT;
    }

    mysql_stmt_store_result(verifica_costo_noleggio);
    mysql_stmt_fetch(verifica_costo_noleggio);

    OUT:
    mysql_stmt_free_result(verifica_costo_noleggio);
    mysql_stmt_reset(verifica_costo_noleggio);
    return Costo;


}