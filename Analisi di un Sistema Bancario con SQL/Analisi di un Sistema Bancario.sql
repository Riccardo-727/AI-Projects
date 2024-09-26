/* 
Creare una tabella denormalizzata che contenga indicatori comportamentali sul cliente, 
calcolati sulla base delle transazioni e del possesso prodotti. 
Lo scopo è creare le feature per un possibile modello di machine learning supervisionato.
*/

-- CREO LA TABELLA FINALE

CREATE TABLE IF NOT EXISTS features_client LIKE banca.cliente;

INSERT INTO features_client SELECT * FROM banca.cliente;


-- CREO ALCUNE VISTE CHE SARANNO UTILI NELLE FASI SUCCESSIVE


-- 1

create view info_cliente_conto as
select tab_cliente.id_cliente, tab_cliente.nome, tab_cliente.cognome, tab_cliente.data_nascita, tab_conto.id_conto, tab_tipo_conto.id_tipo_conto, tab_tipo_conto.desc_tipo_conto
from cliente tab_cliente
LEFT JOIN conto tab_conto ON tab_cliente.id_cliente = tab_conto.id_cliente
LEFT JOIN tipo_conto tab_tipo_conto ON tab_conto.id_tipo_conto = tab_tipo_conto.id_tipo_conto
order by tab_cliente.id_cliente
;

-- CHECK 

select count(distinct id_cliente)
from cliente
;

select count(distinct id_cliente)
from info_cliente_conto
;

select count(distinct id_tipo_conto)
from conto
;

select count(distinct id_tipo_conto)
from info_cliente_conto
;


-- 2

create view info_transazioni as
select tab_transazioni.data as data_transazione, tab_tipo_transazione.id_tipo_transazione, tab_transazioni.importo, tab_transazioni.id_conto, tab_tipo_transazione.desc_tipo_trans, tab_tipo_transazione.segno
from tipo_transazione tab_tipo_transazione
LEFT JOIN transazioni tab_transazioni ON tab_tipo_transazione.id_tipo_transazione = tab_transazioni.id_tipo_trans
order by tab_tipo_transazione.id_tipo_transazione
;

select count(distinct id_tipo_transazione)
from tipo_transazione
;

select count(distinct id_tipo_transazione)
from info_transazioni
;


-- Indicatore Età

ALTER TABLE features_client ADD età INTEGER;

UPDATE features_client
SET età = YEAR(CURDATE()) - YEAR(data_nascita);


-- Numero di transazioni in uscita su tutti i conti

ALTER TABLE features_client ADD numero_transazioni_uscita INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita = (
   
    SELECT count(*)
    FROM info_transazioni it
    INNER JOIN info_cliente_conto ic ON ic.id_conto = it.id_conto
    WHERE it.segno = '-' AND ic.id_cliente = fc.id_cliente
);



-- Numero di transazioni in entrata su tutti i conti

ALTER TABLE features_client ADD numero_transazioni_entrata INTEGER;

UPDATE features_client fc
SET numero_transazioni_entrata = (
   
    SELECT count(*)
    FROM info_transazioni it
    INNER JOIN info_cliente_conto ic ON ic.id_conto = it.id_conto
    WHERE it.segno = '+' AND ic.id_cliente = fc.id_cliente
);



-- Importo transato in uscita su tutti i conti

ALTER TABLE features_client ADD importo_transazioni_uscita FLOAT;

UPDATE features_client fc
SET importo_transazioni_uscita = (
   
    SELECT sum(it.importo)
    FROM info_transazioni it
    INNER JOIN info_cliente_conto ic ON ic.id_conto = it.id_conto
    WHERE it.segno = '-' AND ic.id_cliente = fc.id_cliente
);


-- Importo transato in entrata su tutti i conti

ALTER TABLE features_client ADD importo_transazioni_entrata FLOAT;

UPDATE features_client fc
SET importo_transazioni_entrata = (
   
    SELECT sum(it.importo)
    FROM info_transazioni it
    INNER JOIN info_cliente_conto ic ON ic.id_conto = it.id_conto
    WHERE it.segno = '+' AND ic.id_cliente = fc.id_cliente
);



-- Numero totale di conti posseduti

ALTER TABLE features_client ADD numero_totale_conti INTEGER;

UPDATE features_client fc
SET numero_totale_conti = (
   
    SELECT count(*)
    FROM info_cliente_conto as ic
    WHERE ic.id_cliente = fc.id_cliente
);



-- Numero di conti posseduti per tipologia (Conto Base)

ALTER TABLE features_client ADD conto_base INTEGER;

UPDATE features_client fc
SET conto_base = (
   
    SELECT count(*)
    FROM info_cliente_conto as ic
    WHERE ic.id_cliente = fc.id_cliente AND ic.desc_tipo_conto = 'Conto Base'
);



-- Numero di conti posseduti per tipologia (Conto Business)

ALTER TABLE features_client ADD conto_business INTEGER;

UPDATE features_client fc
SET conto_business = (
   
    SELECT count(*)
    FROM info_cliente_conto as ic
    WHERE ic.id_cliente = fc.id_cliente AND ic.desc_tipo_conto = 'Conto Business'
);


-- Numero di conti posseduti per tipologia (Conto Privato)

ALTER TABLE features_client ADD conto_privato INTEGER;

UPDATE features_client fc
SET conto_privato = (
   
    SELECT count(*)
    FROM info_cliente_conto as ic
    WHERE ic.id_cliente = fc.id_cliente AND ic.desc_tipo_conto = 'Conto Privato'
);


-- Numero di conti posseduti per tipologia (Conto Famiglia)

ALTER TABLE features_client ADD conto_famiglia INTEGER;

UPDATE features_client fc
SET conto_famiglia = (
   
    SELECT count(*)
    FROM info_cliente_conto as ic
    WHERE ic.id_cliente = fc.id_cliente AND ic.desc_tipo_conto = 'Conto Famiglia'
);



-- Numero di transazioni in uscita per tipologia (transazione acquisto su amazon)

ALTER TABLE features_client ADD numero_transazioni_uscita_acquisti_amazon INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita_acquisti_amazon = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND it.desc_tipo_trans = 'Acquisto su Amazon'
);



-- Numero di transazioni in uscita per tipologia (transazione Acquisto su Rata Mutuo)

ALTER TABLE features_client ADD numero_transazioni_uscita_rata_mutuo INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita_rata_mutuo = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND it.desc_tipo_trans = 'Rata Mutuo'
);




-- Numero di transazioni in uscita per tipologia (transazione Acquisto su Hotel)

ALTER TABLE features_client ADD numero_transazioni_uscita_hotel INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita_hotel = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND it.desc_tipo_trans = 'Hotel'
);



-- Numero di transazioni in uscita per tipologia (transazione Biglietto Aereo)

ALTER TABLE features_client ADD numero_transazioni_uscita_biglietto_aereo INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita_biglietto_aereo = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND it.desc_tipo_trans = 'Biglietto Aereo'
);




-- Numero di transazioni in uscita per tipologia (transazione Supermercato)

ALTER TABLE features_client ADD numero_transazioni_uscita_supermercato INTEGER;

UPDATE features_client fc
SET numero_transazioni_uscita_supermercato = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND it.desc_tipo_trans = 'Supermercato'
);



-- Numero di transazioni in entrata per tipologia (transazione Stipendio)

ALTER TABLE features_client ADD numero_transazioni_entrata_stipendio INTEGER;

UPDATE features_client fc
SET numero_transazioni_entrata_stipendio = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND it.desc_tipo_trans = 'Stipendio'
);



-- Numero di transazioni in entrata per tipologia (transazione Pensione)

ALTER TABLE features_client ADD numero_transazioni_entrata_pensione INTEGER;

UPDATE features_client fc
SET numero_transazioni_entrata_pensione = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND it.desc_tipo_trans = 'Pensione'
);



-- Numero di transazioni in entrata per tipologia (transazione Dividendi)

ALTER TABLE features_client ADD numero_transazioni_entrata_dividendi INTEGER;

UPDATE features_client fc
SET numero_transazioni_entrata_dividendi = (
   
    SELECT count(*)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND it.desc_tipo_trans = 'Dividendi'
);



-- Importo transato in uscita per tipologia di conto (Conto Base)

ALTER TABLE features_client ADD totale_importo_uscita_conto_base FLOAT;

UPDATE features_client fc
SET totale_importo_uscita_conto_base = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND ic.desc_tipo_conto = 'Conto Base'
);



-- Importo transato in uscita per tipologia di conto (Conto Business)

ALTER TABLE features_client ADD totale_importo_uscita_conto_business FLOAT;

UPDATE features_client fc
SET totale_importo_uscita_conto_business = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND ic.desc_tipo_conto = 'Conto Business'
);



-- Importo transato in uscita per tipologia di conto (Conto Privato)

ALTER TABLE features_client ADD totale_importo_uscita_conto_privato FLOAT;

UPDATE features_client fc
SET totale_importo_uscita_conto_privato = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND ic.desc_tipo_conto = 'Conto Privati'
);



-- Importo transato in uscita per tipologia di conto (Conto Famiglia)

ALTER TABLE features_client ADD totale_importo_uscita_conto_famiglia FLOAT;

UPDATE features_client fc
SET totale_importo_uscita_conto_famiglia = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '-' AND ic.desc_tipo_conto = 'Conto Famiglia'
);



-- Importo transato in entrata per tipologia di conto (Conto Base)

ALTER TABLE features_client ADD totale_importo_entrata_conto_base FLOAT;

UPDATE features_client fc
SET totale_importo_entrata_conto_base = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND ic.desc_tipo_conto = 'Conto Base'
);


-- Importo transato in entrata per tipologia di conto (Conto Business)

ALTER TABLE features_client ADD totale_importo_entrata_conto_business FLOAT;

UPDATE features_client fc
SET totale_importo_entrata_conto_business = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND ic.desc_tipo_conto = 'Conto Business'
);




-- Importo transato in entrata per tipologia di conto (Conto Privato)

ALTER TABLE features_client ADD totale_importo_entrata_conto_privato FLOAT;

UPDATE features_client fc
SET totale_importo_entrata_conto_privato = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND ic.desc_tipo_conto = 'Conto Privati'
);



-- Importo transato in entrata per tipologia di conto (Conto Famiglia)

ALTER TABLE features_client ADD totale_importo_entrata_conto_famiglia FLOAT;

UPDATE features_client fc
SET totale_importo_entrata_conto_famiglia = (
   
    SELECT sum(it.importo)
    FROM info_cliente_conto ic
    INNER JOIN info_transazioni it ON ic.id_conto = it.id_conto
    WHERE ic.id_cliente = fc.id_cliente AND it.segno = '+' AND ic.desc_tipo_conto = 'Conto Famiglia'
);



select *
from features_client as fc
;



#ALTER TABLE features_client DROP COLUMN totale_importo_uscita_conto_business;
