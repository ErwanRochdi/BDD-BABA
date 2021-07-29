###CREATION DE LA BASE DE DONNEE
CREATE DATABASE vignoble;

USE vignoble;

CREATE TABLE producteur
(
    numProd INT(2),
    nom VARCHAR(255),
    domaine VARCHAR(255),
    region VARCHAR(255),
    PRIMARY KEY (numProd)
);

CREATE TABLE vin
(
    numVin INT(2),
    appellation VARCHAR(255),
    couleur VARCHAR(255),
    annee YEAR(4),
    degre INT(2),
    PRIMARY KEY (numVin)
);

CREATE TABLE recolte
(
    nProd INT(2),
    nVin INT(2),
    quantite INT(3),
    PRIMARY KEY (nProd, nVin),
    FOREIGN KEY (nProd) REFERENCES producteur(numProd),
    FOREIGN KEY (nVin) REFERENCES vin(numVin)
);

#INSERER LES VALEURS DANS LA DATABASE
INSERT INTO producteur (numProd, nom, domaine, region) VALUES
(1, 'Producteur1', 'Graves', 'Bordeaux'),
(2, 'Producteur2', 'Domaine Roblet-Monnot', 'Bourgogne'),
(3, 'Producteur3', 'Domaine des Rouges', 'Bordeaux'),
(4, 'Dupont', 'Domaine Marcel Richaud', 'Côte Du Rhône'),
(5, 'Producteur5', 'La Grande Oncle', 'Alsace'),
(6, 'Producteur6', 'Domaine Pierre Labet', 'Bourgogne'),
(7, 'Dupond', 'Domaine Mikulski', 'Bourgogne'),
(8, 'Producteur8', 'Domaine Tissot', 'Jura'),
(9, 'Producteur9', 'Domaine Peyre Rose', 'Languedoc Roussillon'),
(10, 'Producteur10', 'Domaine Chapelas', 'Côte Du Rhône'),
(11, 'Producteur11', 'Domaine Pierre Labet', 'Côte Du Rhône');

INSERT INTO vin (numVin, appellation, couleur, annee, degre) VALUES
(1, 'Château Villa Bel-Air', 'Rouge', 2014, 13),
(2, 'Domaine Roblet-Monnot', 'Rouge', 2017, 13),
(3, 'La Fussière', 'Rouge', 2017, 13),
(4, 'Mistral AOC', 'Rouge', 2004, 15),
(5, 'La Grange Oncle Charles', 'Blanc', 2018, 13),
(6, 'Vieilles Vignes', 'Blanc', 2017, 13),
(7, 'Genevrière', 'Blanc', 1999, 13),
(8, 'Cremant du Jura Blanc', 'Blanc', 2015, 15),
(9, 'Syrah Leone', 'Rosé', 1995, 15),
(10, 'Domaine Chapelas Rosé', 'Rosé', 2004, 14),
(11, 'Vieilles Vignes', 'Blanc', 2000, 15);

INSERT INTO recolte VALUES
(1, 1, 20),
(2, 2, 40),
(3, 3, 50),
(4, 4, 100),
(5, 5, 70),
(6, 6, 90),
(7, 7, 200),
(8, 8, 5),
(9, 9, 25),
(10, 10, 100),
(11, 20, 70);

NIVEAU FACILE:
-Donner la liste des appellations des vins de 1995 :
SELECT vin.appellation FROM vin WHERE annee ='1995'

-Donner toutes les informations, hors identifiants, sur les vins après 2000 :
SELECT vin.appellation, vin.couleur, vin.annee, vin.degre FROM vin WHERE annee > '2000' 

-Donner la liste des vins dont l'année est entre 2000 et 2009 (bornes incluses) :
SELECT * FROM vin WHERE annee BETWEEN '2000' AND '2009'

-Donner la liste des vins blancs de degré supérieur à 14 :
SELECT * FROM vin WHERE couleur = 'Blanc' AND degre > 14

-Donner la liste des vins dont l'appellation contient le sigle « AOC » :
SELECT * FROM vin WHERE UPPER(vin.appellation) LIKE '%AOC%'

-Donner la liste des domaines de production de vins de la région Bordeaux :
SELECT producteur.domaine FROM producteur WHERE region = 'Bordeaux'

-Quels sont les noms et la région des producteurs du vin numéro 5 ?
SELECT producteur.nom, producteur.region FROM producteur INNER JOIN recolte ON producteur.numProd = recolte.nProd WHERE nVin = '5'

-Quels sont les producteurs de la région Beaujolais ?
SELECT producteur.nom FROM producteur WHERE region = 'Beaujolais' 

-Donner la liste des producteurs dont le nom commence par « Dupon » :
SELECT * FROM producteur WHERE UPPER(producteur.nom) LIKE 'DUPON%'

-Donner la liste des noms des producteurs triée par ordre alphabétique :
SELECT producteur.nom FROM producteur ORDER BY producteur.nom ASC 

NIVEAU MOYEN:
-Donner la ou les années (par ordre décroissant) où les vins ont le plus fort degré, en les triant par couleur :
SELECT vin.annee, vin.couleur, vin.degre FROM vin ORDER BY vin.couleur, vin.degre DESC, vin.annee DESC 

-Donner toutes les informations sur les vins, ordonnés par couleur (ordre alphabétique) et degré (de plus fort au plus faible), dont le degré est supérieur au degré moyen de tous les vins :
SELECT * FROM vin WHERE vin.degre > ( SELECT AVG(degre) FROM vin ) ORDER BY vin.couleur ASC, vin.degre DESC 

-Donner le degré minimum et maximum des vins par appellation et par couleur :
SELECT vin.appellation, vin.couleur, MIN(vin.degre), MAX(vin.degre)
FROM vin
GROUP BY vin.appellation, vin.couleur

MULTI-TABLES AVEC JOINTURE :
-Donner les noms des producteurs qui produisent du vin numéro 20 en quantité supérieure à 50 :
SELECT producteur.nom FROM producteur INNER JOIN recolte ON producteur.numProd = recolte.nProd WHERE recolte.nVin = 20 AND recolte.quantite > 50

-Donner le nombre de récoltes de vin rouge en 2004 :
SELECT recolte.quantite FROM recolte INNER JOIN vin ON recolte.nVin = vin.numVin WHERE vin.couleur = 'Rouge' AND vin.annee = 2004

-Donner la quantité totale par année de vin blanc récolté :
SELECT recolte.quantite, vin.annee FROM recolte INNER JOIN vin ON recolte.nVin = vin.numVin WHERE vin.couleur = 'Blanc' GROUP BY vin.annee

-Donner le degré moyen par année de vin blanc récolté :
SELECT AVG(vin.degre), vin.annee FROM vin WHERE vin.couleur = 'Blanc' GROUP BY vin.annee 

-Donner la liste des noms et des domaines des producteurs de vin rouge :
SELECT producteur.nom, producteur.domaine
FROM producteur
INNER JOIN recolte ON producteur.numProd = recolte.nProd
INNER JOIN vin ON recolte.nVin = vin.numVin
WHERE vin.couleur = 'Rouge'

-Donner l’appellation, le numéro du producteur et la quantité produite pour les vins récoltés en 1999 avec une quantité de 200 :
SELECT vin.appellation, producteur.numProd, recolte.quantite
FROM vin
INNER JOIN recolte ON vin.numVin = recolte.nVin
INNER JOIN producteur ON recolte.nProd = producteur.numProd
WHERE vin.annee = '1999' AND recolte.quantite = '200'

MULTI TABLES AVEC SOUS REQUETE
-Donner les noms des producteurs qui produisent du vin numéro 20 en quantité supérieure à 50 :
SELECT producteur.nom FROM producteur WHERE producteur.numProd IN ( SELECT recolte.nProd FROM recolte WHERE recolte.nVin = 20 AND recolte.quantite > 50 )

-Donner le nombre de récoltes de vin rouge en 2004 :
SELECT recolte.quantite FROM recolte WHERE recolte.nVin IN ( SELECT vin.numVin FROM vin WHERE vin.couleur = 'Rouge' AND vin.annee = 2004 )

-Donner le degré moyen par année de vin blanc récolté :
SELECT AVG(vin.degre), vin.annee FROM vin WHERE vin.couleur = 'Blanc' GROUP BY vin.annee

-Donner la liste des noms et des domaines des producteurs de vin rouge
SELECT producteur.nom, producteur.domaine
FROM producteur
WHERE producteur.numProd IN (
    SELECT recolte.nProd
    FROM recolte
    WHERE recolte.nVin IN (
        SELECT vin.numVin
        FROM vin
        WHERE vin.couleur = 'Rouge'
        )
    )








