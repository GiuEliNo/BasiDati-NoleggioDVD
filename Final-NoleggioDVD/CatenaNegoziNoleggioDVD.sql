-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CatenaNegoziNoleggioDVD
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CatenaNegoziNoleggioDVD
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CatenaNegoziNoleggioDVD` ;
USE `CatenaNegoziNoleggioDVD` ;

-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Centro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Centro` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Centro` (
  `codiceCentro` INT NOT NULL AUTO_INCREMENT,
  `Responsabile` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceCentro`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Telefoni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Telefoni` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Telefoni` (
  `Numero` VARCHAR(45) NOT NULL,
  `Centro` INT NOT NULL,
  PRIMARY KEY (`Numero`),
  INDEX `CodiceCentro_idx` (`Centro` ASC) VISIBLE,
  CONSTRAINT `CentroTelefoni`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Impiegati`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Impiegati` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Impiegati` (
  `CodiceFiscaleImpiegato` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `TitoloDiStudio` VARCHAR(45) NOT NULL,
  `Telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CodiceFiscaleImpiegato`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (
  `DataInizio` DATE NOT NULL,
  `Centro` INT NOT NULL,
  `Impiegato` VARCHAR(16) NOT NULL,
  `Carica` ENUM('Impiegato', 'Manager') NOT NULL,
  PRIMARY KEY (`DataInizio`, `Centro`, `Impiegato`),
  INDEX `CodiceCentro_idx` (`Centro` ASC) VISIBLE,
  INDEX `CodiceFiscaleImpiegato_idx` (`Impiegato` ASC) VISIBLE,
  CONSTRAINT `CentroPeriodiCorrenti`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ImpiegatoPeriodiCorrenti`
    FOREIGN KEY (`Impiegato`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`PeriodiPassati`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`PeriodiPassati` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`PeriodiPassati` (
  `DataInizio` DATE NOT NULL,
  `Centro` INT NOT NULL,
  `Impiegato` VARCHAR(45) NOT NULL,
  `DataFine` DATE NOT NULL,
  `Carica` ENUM('Impiegato', 'Manager') NOT NULL,
  PRIMARY KEY (`DataInizio`, `Impiegato`, `Centro`),
  INDEX `codiceCentro_idx` (`Centro` ASC) VISIBLE,
  INDEX `Impiegato_idx` (`Impiegato` ASC) VISIBLE,
  CONSTRAINT `CentroPeriodiPassati`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ImpiegatoPeriodiPassati`
    FOREIGN KEY (`Impiegato`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Turni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Turni` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Turni` (
  `Impiegato` VARCHAR(16) NOT NULL,
  `DataTurno` DATE NOT NULL,
  `Fascia Oraria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Impiegato`, `DataTurno`),
  CONSTRAINT `ImpiegatoTurni`
    FOREIGN KEY (`Impiegato`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Settori`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Settori` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Settori` (
  `codiceSettore` INT NOT NULL AUTO_INCREMENT,
  `Centro` INT NOT NULL,
  PRIMARY KEY (`codiceSettore`, `Centro`),
  INDEX `codiceCentro_idx` (`Centro` ASC) VISIBLE,
  CONSTRAINT `CentroSettori`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Scaffali`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Scaffali` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Scaffali` (
  `codiceScaffali` INT NOT NULL AUTO_INCREMENT,
  `Settore` INT NOT NULL,
  `Centro` INT NOT NULL,
  PRIMARY KEY (`codiceScaffali`, `Settore`, `Centro`),
  INDEX `CodiceCentro_idx` (`Centro` ASC) VISIBLE,
  INDEX `CodiceSettore_idx` (`Settore` ASC) VISIBLE,
  CONSTRAINT `CentroScaffali`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SettoriScaffali`
    FOREIGN KEY (`Settore`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Costi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Costi` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Costi` (
  `Tipo` VARCHAR(45) NOT NULL,
  `Costo` INT NOT NULL,
  PRIMARY KEY (`Tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Film`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Film` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Film` (
  `codiceFilm` INT NOT NULL AUTO_INCREMENT,
  `Titolo` VARCHAR(45) NOT NULL,
  `Regista` VARCHAR(45) NOT NULL,
  `Anno` YEAR(4) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceFilm`),
  INDEX `fk_FilmCosti_idx` (`Tipo` ASC) VISIBLE,
  CONSTRAINT `fk_FilmCosti`
    FOREIGN KEY (`Tipo`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Costi` (`Tipo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Inventari`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Inventari` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Inventari` (
  `codiceInventario` INT NOT NULL,
  `Film` INT NOT NULL,
  `Centro` INT NOT NULL,
  `CopieResidue` TINYINT(2) NOT NULL,
  PRIMARY KEY (`codiceInventario`, `Film`, `Centro`),
  INDEX `CodiceCentro_idx` (`Centro` ASC) VISIBLE,
  INDEX `CodiceFilm_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `CentroInventario`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FilmInventario`
    FOREIGN KEY (`Film`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Copie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Copie` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Copie` (
  `codiceCopie` INT NOT NULL AUTO_INCREMENT,
  `Inventario` INT NOT NULL,
  `Film` INT NOT NULL,
  `Centro` INT NOT NULL,
  `Scaffale` INT NOT NULL,
  `Settore` INT NOT NULL,
  `Stato` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceCopie`, `Centro`, `Film`, `Inventario`),
  INDEX `centroCopie_idx` (`Centro` ASC) VISIBLE,
  INDEX `filmCopie_idx` (`Film` ASC) VISIBLE,
  INDEX `inventarioCopie_idx` (`Inventario` ASC) VISIBLE,
  INDEX `settoriCopie_idx` (`Settore` ASC) VISIBLE,
  INDEX `scaffaliCopie_idx` (`Scaffale` ASC) VISIBLE,
  CONSTRAINT `centroCopie`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `filmCopie`
    FOREIGN KEY (`Film`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `inventarioCopie`
    FOREIGN KEY (`Inventario`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Inventari` (`codiceInventario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `settoriCopie`
    FOREIGN KEY (`Settore`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `scaffaliCopie`
    FOREIGN KEY (`Scaffale`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Remake`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Remake` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Remake` (
  `Film` INT NOT NULL,
  `FilmRemake` INT NOT NULL,
  PRIMARY KEY (`Film`, `FilmRemake`),
  INDEX `FilmFiglio_idx` (`FilmRemake` ASC) VISIBLE,
  CONSTRAINT `FilmPadre`
    FOREIGN KEY (`Film`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FilmFiglio`
    FOREIGN KEY (`FilmRemake`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Attori`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Attori` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Attori` (
  `CodiceAttore` INT NOT NULL AUTO_INCREMENT,
  `NomeAttore` VARCHAR(45) NOT NULL,
  `CognomeAttore` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CodiceAttore`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Partecipa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Partecipa` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Partecipa` (
  `Attore` INT NOT NULL,
  `Film` INT NOT NULL,
  PRIMARY KEY (`Attore`, `Film`),
  INDEX `CodiceFilm_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `AttorePartecipa`
    FOREIGN KEY (`Attore`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FilmPartecipa`
    FOREIGN KEY (`Film`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Clienti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Clienti` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Clienti` (
  `numTessera` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`numTessera`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Noleggi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Noleggi` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Noleggi` (
  `codiceTransazione` INT NOT NULL AUTO_INCREMENT,
  `Cliente` INT NOT NULL,
  `Copia` INT NOT NULL,
  `DataNoleggio` DATE NOT NULL COMMENT '			',
  `DataRestituzione` DATE NOT NULL,
  `Centro` INT NOT NULL,
  `Film` INT NOT NULL,
  `Inventario` INT NOT NULL,
  PRIMARY KEY (`codiceTransazione`),
  INDEX `Inventario_idx` (`Inventario` ASC) VISIBLE,
  INDEX `Film_idx` (`Film` ASC) VISIBLE,
  INDEX `Centro_idx` (`Centro` ASC) VISIBLE,
  INDEX `Cliente_idx` (`Cliente` ASC) VISIBLE,
  INDEX `CopiaNoleggi_idx` (`Copia` ASC) VISIBLE,
  CONSTRAINT `CopiaNoleggi`
    FOREIGN KEY (`Copia`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Copie` (`codiceCopie`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `InventarioNoleggi`
    FOREIGN KEY (`Inventario`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Inventari` (`codiceInventario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FilmNoleggi`
    FOREIGN KEY (`Film`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `CentroNoleggi`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ClienteNoleggi`
    FOREIGN KEY (`Cliente`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Clienti` (`numTessera`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Recapiti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Recapiti` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Recapiti` (
  `Numero` VARCHAR(45) NOT NULL,
  `Cliente` INT NOT NULL,
  PRIMARY KEY (`Numero`, `Cliente`),
  INDEX `Cliente_idx` (`Cliente` ASC) VISIBLE,
  CONSTRAINT `ClienteRecapiti`
    FOREIGN KEY (`Cliente`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Clienti` (`numTessera`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Indirizzi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Indirizzi` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Indirizzi` (
  `Centro` INT NOT NULL,
  `Città` VARCHAR(45) NOT NULL,
  `Via` VARCHAR(45) NOT NULL,
  `Civico` INT NOT NULL,
  `CAP` INT NOT NULL,
  PRIMARY KEY (`Centro`, `Città`, `Via`, `Civico`, `CAP`),
  CONSTRAINT `CentroIndirizzi`
    FOREIGN KEY (`Centro`)
    REFERENCES `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CatenaNegoziNoleggioDVD`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CatenaNegoziNoleggioDVD`.`Users` ;

CREATE TABLE IF NOT EXISTS `CatenaNegoziNoleggioDVD`.`Users` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` CHAR(32) NOT NULL,
  `Ruolo` ENUM('manager', 'impiegato') NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

USE `CatenaNegoziNoleggioDVD` ;

-- -----------------------------------------------------
-- procedure effettuare_noleggio
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`effettuare_noleggio`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `effettuare_noleggio`(in var_Cliente int, in var_Copia int, in var_DataNoleggio DATETIME,in var_DataRestituzione DATETIME, in var_Centro int, in var_Inventario int, in var_Film int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;
  set transaction isolation level repeatable read;
  start transaction;
	if(SELECT Stato from Copie WHERE codiceCopie=var_Copia and Inventario=var_Inventario and Centro=var_Centro and Film=var_Film)='Noleggiata' 
    then signal sqlstate '45001' set message_text= "La copia è già stata noleggiata";
    end if;
    INSERT INTO Noleggi(Cliente,Copia,DataNoleggio,DataRestituzione,Centro,Film,Inventario)
    VALUES(var_Cliente, var_Copia, var_DataNoleggio, date_add(var_DataRestituzione, INTERVAL 3 DAY),var_Centro,var_Film,var_Inventario); -- Aggiungiamo i 3 giorni a data Restituzione per la riconsegna.
    UPDATE Copie SET Stato = 'Noleggiata'
    WHERE codiceCopie=var_Copia and Inventario=var_Inventario and Centro=var_Centro and Film=var_Film;
    UPDATE Inventari set CopieResidue=CopieResidue - 1
    WHERE CodiceInventario=var_Inventario and Centro=var_Centro and Film=var_Film;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungere_cliente
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`aggiungere_cliente`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `aggiungere_cliente` (in var_Nome VARCHAR(45),in var_Cognome VARCHAR(45), in var_Recapito int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;
  set transaction isolation level read uncommitted;
  start transaction;
    INSERT into Clienti(Nome,Cognome)
    VALUES(var_Nome,var_Cognome);
    INSERT into Recapiti(Numero, Cliente)
    VALUES(var_Recapito,(SELECT NumTessera 
    from Clienti 
    WHERE Nome=var_Nome and Cognome=var_Cognome));
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungere_impiegato
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`aggiungere_impiegato`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `aggiungere_impiegato` (in var_CF VARCHAR(16), in var_Nome VARCHAR(45), in var_Cognome VARCHAR(45), in var_Titolo VARCHAR(45), in var_Telefono int )
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;
set transaction isolation level repeatable read;
start transaction;
begin
  INSERT into Impiegati(CodiceFiscaleImpiegato,Nome,Cognome,TitoloDiStudio,Telefono)
  VALUES(var_CF,var_Nome,var_Cognome,var_Titolo,var_Telefono);
  commit;
  end;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure controllare_disponibilita
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`controllare_disponibilita`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `controllare_disponibilita` (in var_Titolo VARCHAR(45), in var_Regista VARCHAR(45))
BEGIN
declare var_codiceFilm int;
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;
set transaction isolation level repeatable read;
set transaction read only;
start transaction;
    SELECT `CodiceFilm` into var_codiceFilm
    FROM Film
    WHERE `Titolo`=var_Titolo and `Regista`=var_Regista;
    if var_codiceFilm is null then signal sqlstate '45001' set message_text= "codice film non esistente";
    end if;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure controllare_dataRestituzione
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`controllare_dataRestituzione`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `controllare_dataRestituzione` (in var_CodiceTransazione int)
	BEGIN
	declare exit handler for sqlexception
	  begin
		rollback; -- rollback any changes made in the transaction
		resignal; -- raise again the sql exception handler 
	  end;
	set transaction isolation level read committed;
    set transaction read only;-- voglio essere sicuro di leggere solo cose che sono state committate
	start transaction; 

	  SELECT DataRestituzione
	  FROM Noleggi
	  WHERE CodiceTransazione=var_CodiceTransazione;
	  commit;
	END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungere_film
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`aggiungere_film`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `aggiungere_film` (in var_Titolo VARCHAR(45), in var_Regista VARCHAR(45), in var_Anno DATE, in var_Tipo VARCHAR(45))
BEGIN
declare exit handler for sqlexception
begin
  rollback; -- rollback any changes made in the transaction
  resignal; -- raise again the sql exception handler 
end;
set transaction isolation level read uncommitted; -- Aggiungo solo un film senza dover leggere nulla, non ho bisogno di isolamento maggiori.
start transaction;
  begin
    INSERT into Film(Titolo,Regista,Anno,Tipo)
    VALUES(var_Titolo,var_Regista,YEAR(var_Anno),var_Tipo);
    commit;
    end;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificare_turni
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`modificare_turni`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `modificare_turni` (in var_Impiegato VARCHAR(16), in var_DataTurno date, in var_Fascia VARCHAR(45))
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;
set transaction isolation level serializable;
start transaction;
  begin
  INSERT into Turni(Impiegato,DataTurno,`Fascia Oraria`)  
  VALUES(var_Impiegato, var_DataTurno, var_Fascia);
  commit;
  end;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure controllare_turni_mensili
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`controllare_turni_mensili`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `controllare_turni_mensili` (in var_Impiegato VARCHAR(16), in var_Data DATETIME)  
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;
set transaction isolation level read committed;
set transaction read only;
start transaction;
  Select * 
  from `Turni`
  WHERE `Turni`.`Impiegato`= var_Impiegato and MONTH(`Turni`.`DataTurno`)=MONTH(var_Data) and YEAR(`Turni`.`DataTurno`)=YEAR(var_Data);
  commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure check_copie_residue
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`check_copie_residue`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `check_copie_residue` (in var_Film int , in var_Centro int)
BEGIN
declare exit handler for sqlexception
begin
  rollback; -- rollback any changes made in the transaction
  resignal; -- raise again the sql exception handler 
end;
set transaction isolation level read committed;
start transaction;
begin
  SELECT CopieResidue 
  From Inventari
  WHERE Centro=var_Centro and Film=var_Film;
  commit;
  end;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verifica_remake
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`verifica_remake`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `verifica_remake` (in var_Film int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;
set transaction isolation level read uncommitted;
set transaction read only;
start transaction;
	SELECT `F2`.`codiceFilm`,`F2`.`titolo`,`F2`.`anno`, `F2`.`regista`
    from `Film` as `F1` 
    join `Remake` on `F1`.`codiceFilm`=`Film` 
    join `Film` as `F2` on `F2`.`codiceFilm`=`FilmRemake`
    WHERE `F1`.`codiceFilm` = var_Film;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_ordini_del_giorno
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`report_ordini_del_giorno`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `report_ordini_del_giorno` (in var_Data DATETIME)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;
set transaction isolation level repeatable read;
start transaction;
begin
	SELECT *
    FROM Noleggi
    WHERE DataNoleggio=var_Data;
    commit;
    end;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminare_film
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`eliminare_film`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `eliminare_film` (in var_Film int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;

set transaction isolation level serializable;
start transaction;
begin
	-- TODO logica di controllo che non fa esplodere tutto 
    
    DELETE
    FROM Film
    WHERE CodiceFilm=var_Film;				-- WARNING DA gestire con cautela, tutte le foreign key sono settate on DELETE CASCADE
    commit;
    end;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verifica_posizione_film
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`verifica_posizione_film`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `verifica_posizione_film` (in var_Film int,in var_Centro int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;

set transaction isolation level repeatable read;
set transaction read only;
start transaction;

	SELECT Scaffale, Settore
    FROM Copie
    WHERE Film=var_Film and Centro=var_Centro;
    commit;
END;$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verifica_costo_noleggio
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`verifica_costo_noleggio`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `verifica_costo_noleggio` (in var_Film int)
BEGIN
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;

set transaction isolation level read committed;	
start transaction;
	SELECT Costo
    From Film join Costi on `Film`.`Tipo`=`Costi`.`Tipo`
    WHERE `Film`.`codiceFilm` = var_Film;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure restituire_noleggio
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`restituire_noleggio`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `restituire_noleggio` (in var_Transazione int)
BEGIN

declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
end;
set transaction isolation level repeatable read;
start transaction;
    UPDATE Copie inner join Noleggi on `Noleggi`.`Copia`=`Copie`.`codiceCopie` and `Noleggi`.`Film`=`Copie`.`Film` and `Noleggi`.`Inventario`=`Copie`.`Inventario` and `Noleggi`.`Centro`=`Copie`.`Centro` 
    set Stato = 'Disponibile'
    WHERE Noleggi.codiceTransazione=var_Transazione;
    UPDATE Inventari inner join Noleggi on `Noleggi`.`Film`=`Inventari`.`Film`and `Noleggi`.`Centro`=`Inventari`.`Centro` 
    set Inventari.CopieResidue = Inventari.CopieResidue +1
    WHERE Noleggi.codiceTransazione=var_Transazione;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`login`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `login` (in var_username VARCHAR(45), in var_password VARCHAR(45), out var_role int)
BEGIN
	declare var_user_role ENUM('manager', 'impiegato');
	select `Ruolo` 
	from  `Users` 
    WHERE `Username` = var_username 
	and `Password` = var_password
	into var_user_role;

-- see the correspinding enum in the client

    if var_user_role= 'manager' then set var_role=1;
    elseif var_user_role= 'impiegato' then set var_role=2;
    else
		set var_role=3;
	end if;
 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificare_carica_o_sede_impiegato
-- -----------------------------------------------------

USE `CatenaNegoziNoleggioDVD`;
DROP procedure IF EXISTS `CatenaNegoziNoleggioDVD`.`modificare_carica_o_sede_impiegato`;

DELIMITER $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE PROCEDURE `modificare_carica_o_sede_impiegato` (in var_Impiegato VARCHAR(16),in var_Centro int, in var_nuovaCarica VARCHAR(45))
BEGIN
declare var_controllo varchar(16);
declare exit handler for sqlexception
  begin
	rollback; -- rollback any changes made in the transaction
    resignal; -- raise again the sql exception handler 
  end;

set transaction isolation level repeatable read;

start transaction;
	select `Impiegato` from `PeriodiCorrenti` where `Impiegato`=var_Impiegato into var_controllo;
    if var_controllo is null then signal sqlstate '45002' set message_text="Errore, l'impiegato non lavora in nessuna sede";
    end if;
    UPDATE `PeriodiCorrenti` set `DataInizio`= current_date() , `Centro`=var_Centro, `Carica`=var_NuovaCarica
    WHERE `Impiegato` = var_Impiegato;
    commit;

END$$

DELIMITER ;
USE `CatenaNegoziNoleggioDVD`;

DELIMITER $$

USE `CatenaNegoziNoleggioDVD`$$
DROP TRIGGER IF EXISTS `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti_AFTER_UPDATE` $$
USE `CatenaNegoziNoleggioDVD`$$
CREATE DEFINER = CURRENT_USER TRIGGER `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti_AFTER_UPDATE` AFTER UPDATE ON `PeriodiCorrenti` FOR EACH ROW
	BEGIN
		insert into `PeriodiPassati`
		values(OLD.DataInizio, OLD.Centro,OLD.Impiegato, current_date(), OLD.Carica);
	END$$


DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'login' IDENTIFIED BY 'login';

GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`login` TO 'login';
SET SQL_MODE = '';
DROP USER IF EXISTS impiegato;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'impiegato' IDENTIFIED BY 'impiegato';

GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`effettuare_noleggio` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`controllare_dataRestituzione` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`restituire_noleggio` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`aggiungere_cliente` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`controllare_disponibilita` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`report_ordini_del_giorno` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`controllare_turni_mensili` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`verifica_posizione_film` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`check_copie_residue` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`verifica_remake` TO 'impiegato';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`verifica_costo_noleggio` TO 'impiegato';
SET SQL_MODE = '';
DROP USER IF EXISTS manager;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'manager' IDENTIFIED BY 'manager';

GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`aggiungere_impiegato` TO 'manager';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`modificare_carica_o_sede_impiegato` TO 'manager';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`aggiungere_film` TO 'manager';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`eliminare_film` TO 'manager';
GRANT EXECUTE ON procedure `CatenaNegoziNoleggioDVD`.`modificare_turni` TO 'manager';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Centro`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`, `Responsabile`, `email`) VALUES (01, 'Lino Amati', 'centro01@catena.net');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`, `Responsabile`, `email`) VALUES (02, 'Leopoldo Sole', 'centro02@catena.net');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`, `Responsabile`, `email`) VALUES (03, 'Federico Livorno', 'centro03@catena.net');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`, `Responsabile`, `email`) VALUES (04, 'Francesco Berardi', 'centro04@catena.net');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Centro` (`codiceCentro`, `Responsabile`, `email`) VALUES (05, 'Luisa Apicuori', 'centro05@catena.net');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Telefoni`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Telefoni` (`Numero`, `Centro`) VALUES ('3333333', 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Telefoni` (`Numero`, `Centro`) VALUES ('4444444', 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Telefoni` (`Numero`, `Centro`) VALUES ('5555555', 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Telefoni` (`Numero`, `Centro`) VALUES ('44343244', 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Telefoni` (`Numero`, `Centro`) VALUES ('1181981', 05);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Impiegati`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('FRLZPL48B51F274R', 'Franco', 'Leppi', 'DIploma', '331323219');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('RYHCDC78A22A225J', 'Rhyorn', 'Codice', 'Diploma', '332239981');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('CSPJDN97C61F293Q', 'Cesare', 'Cuio', 'Laurea', '338978612');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('MTZCQA47B60F849K', 'Montezemolo', 'Aquilata', 'Diploma', '330139212');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('XCRNFT60D03M032A', 'Xecira', 'Cercis', 'Laurea', '330212238');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Impiegati` (`CodiceFiscaleImpiegato`, `Nome`, `Cognome`, `TitoloDiStudio`, `Telefono`) VALUES ('RSTGLI97E11H501M', 'Giulio', 'Rustia', 'Laurea', '3495192490');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (`DataInizio`, `Centro`, `Impiegato`, `Carica`) VALUES ('2022/07/01', 01, 'FRLZPL48B51F274R', 'Impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (`DataInizio`, `Centro`, `Impiegato`, `Carica`) VALUES ('2022/07/01', 01, 'RYHCDC78A22A225J', 'Impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (`DataInizio`, `Centro`, `Impiegato`, `Carica`) VALUES ('2022/07/01', 01, 'CSPJDN97C61F293Q', 'Impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (`DataInizio`, `Centro`, `Impiegato`, `Carica`) VALUES ('2022/07/01', 02, 'MTZCQA47B60F849K', 'Manager');
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiCorrenti` (`DataInizio`, `Centro`, `Impiegato`, `Carica`) VALUES ('2022/07/01', 01, 'XCRNFT60D03M032A', 'Manager');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`PeriodiPassati`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`PeriodiPassati` (`DataInizio`, `Centro`, `Impiegato`, `DataFine`, `Carica`) VALUES ('2021/12/25', 02, 'FRLZPL48B51F274R', '2022/07/01', 'Impiegato');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Turni`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('FRLZPL48B51F274R', '2020-12-12', 'mattino');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-12', 'pomeriggio');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-13', 'mattina');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-14', 'pomeriggio');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-15', 'mattina');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-16', 'mattina');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Turni` (`Impiegato`, `DataTurno`, `Fascia Oraria`) VALUES ('RSTGLI97E11H501M', '2020-12-17', 'mattina');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Settori`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (01, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (02, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (03, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (04, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (01, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (02, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (03, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (04, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (05, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (01, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (02, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (03, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (04, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (05, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (01, 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (02, 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (03, 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (04, 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Settori` (`codiceSettore`, `Centro`) VALUES (01, 05);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Scaffali`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 01, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (02, 01, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 02, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (02, 02, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (03, 02, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (04, 02, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 01, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 02, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 03, 02);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (01, 01, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Scaffali` (`codiceScaffali`, `Settore`, `Centro`) VALUES (02, 02, 03);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Costi`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Costi` (`Tipo`, `Costo`) VALUES ('Classici', 5);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Costi` (`Tipo`, `Costo`) VALUES ('Nuove Uscite', 7);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Film`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`, `Titolo`, `Regista`, `Anno`, `Tipo`) VALUES (01, 'Viva la gioia', 'Franco carlo', 1987, 'Classici');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`, `Titolo`, `Regista`, `Anno`, `Tipo`) VALUES (02, 'Francesco l\'eremita', 'gigi la trottola', 1999, 'Classici');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`, `Titolo`, `Regista`, `Anno`, `Tipo`) VALUES (03, 'Corolla', 'gina lipoppi', 2022, 'Nuove Uscite');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Film` (`codiceFilm`, `Titolo`, `Regista`, `Anno`, `Tipo`) VALUES (04, 'Corinzio', 'franco lino', 2021, 'Nuove Uscite');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Inventari`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Inventari` (`codiceInventario`, `Film`, `Centro`, `CopieResidue`) VALUES (01, 01, 01, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Copie`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Copie` (`codiceCopie`, `Inventario`, `Film`, `Centro`, `Scaffale`, `Settore`, `Stato`) VALUES (01, 01, 01, 01, 01, 01, 'Disponibile');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Copie` (`codiceCopie`, `Inventario`, `Film`, `Centro`, `Scaffale`, `Settore`, `Stato`) VALUES (02, 01, 01, 01, 01, 01, 'Noleggiata');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Remake`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Remake` (`Film`, `FilmRemake`) VALUES (1, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Attori`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (01, 'Francesca', 'Sole');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (02, 'Lippiri', 'Montie');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (03, 'Eleonora', 'Zappirichi');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (04, 'Lisandra', 'Elel');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (05, 'Giulio', 'Mortieri');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Attori` (`CodiceAttore`, `NomeAttore`, `CognomeAttore`) VALUES (06, 'Sedicente', 'Appariscente');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Partecipa`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Partecipa` (`Attore`, `Film`) VALUES (01, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Partecipa` (`Attore`, `Film`) VALUES (01, 03);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Partecipa` (`Attore`, `Film`) VALUES (02, 04);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Partecipa` (`Attore`, `Film`) VALUES (04, 01);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Partecipa` (`Attore`, `Film`) VALUES (06, 03);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Clienti`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Clienti` (`numTessera`, `Nome`, `Cognome`) VALUES (01, 'Gino', 'Pippo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Noleggi`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Noleggi` (`codiceTransazione`, `Cliente`, `Copia`, `DataNoleggio`, `DataRestituzione`, `Centro`, `Film`, `Inventario`) VALUES (01, 01, 02, '2022-07-02', '2022-07-05', 01, 01, 01);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Indirizzi`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Indirizzi` (`Centro`, `Città`, `Via`, `Civico`, `CAP`) VALUES (01, 'Roma', 'Via dell\'amaradam', 12, 00126);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Indirizzi` (`Centro`, `Città`, `Via`, `Civico`, `CAP`) VALUES (02, 'Roma', 'Via della piazza morta', 17, 00172);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Indirizzi` (`Centro`, `Città`, `Via`, `Civico`, `CAP`) VALUES (03, 'Milano', 'Via la storta', 1, 18182);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Indirizzi` (`Centro`, `Città`, `Via`, `Civico`, `CAP`) VALUES (04, 'Firenze', 'Via della margherita', 98, 14299);
INSERT INTO `CatenaNegoziNoleggioDVD`.`Indirizzi` (`Centro`, `Città`, `Via`, `Civico`, `CAP`) VALUES (05, 'Bologna', 'Via delle vecchie', 12, 11223);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CatenaNegoziNoleggioDVD`.`Users`
-- -----------------------------------------------------
START TRANSACTION;
USE `CatenaNegoziNoleggioDVD`;
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('franco', 'pippo', 'impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('rhyorn.codice', 'pippo', 'impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('cesare.cuio', 'pippo', 'impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('montezemolo.aquilata', 'pippo', 'manager');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('xecira.cercis', 'pippo', 'impiegato');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('pino', 'pippo', 'manager');
INSERT INTO `CatenaNegoziNoleggioDVD`.`Users` (`Username`, `Password`, `Ruolo`) VALUES ('giulio', 'pippo', 'manager');

COMMIT;

