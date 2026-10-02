#include <stdbool.h>

#include "login.h"
#include "../view/login.h"
#include "../model/db.h"
#include "impiegato.h"
#include "manager.h"


bool login(void)
{
	struct credentials cred;
	view_login(&cred);
	role_t role = attempt_login(&cred);

	switch(role) {
		case IMPIEGATO:
			impiegato_controller();
			break;
		case MANAGER:
			manager_controller();
			break;
		default:
			return false;
	}

	return true;
}
