NIVEAU FACILE :
###CREATION DE LA DATABASE
CREATE DATABASE MUSIQUE;

USE DATABASE MUSIQUE;

CREATE TABLE concert
(
    nom VARCHAR(255) PRIMARY KEY,
    nomOrchestre VARCHAR(255),
    date_ DATE,
    lieu VARCHAR(255),
    prix FLOAT (4)
);

CREATE TABLE musicien
(
    nom VARCHAR(255),
    instrument VARCHAR(255),
    anneeExperience INT(2),
    nomOrchestre VARCHAR(255),
    PRIMARY KEY (nom)
);

CREATE TABLE orchestre
(
    nom VARCHAR(255),
    style VARCHAR(255),
    chef VARCHAR (255),
    PRIMARY KEY (nom)
);

###INSERER LES VALEURS DANS LA DATABASE
INSERT INTO concert (nom, nomOrchestre, date_, lieu, prix)
VALUES ('Ultrall', 'orchestre1', '2021-06-15', 'Stade de France', 500),
('Die rich or trie dying', 'orchestre2', '2004-09-03', 'Zenith', 100),
('Ultral', 'orchestre1', '2014-09-05', 'NY', 600),
('Life', 'orchestre3', '2020-11-22', 'Dubai', 400),
('Fiestea', 'orchestre3', '2010-07-12', 'Miami', 50),
('Power', 'orchestre2', '1997-08-16', 'Douala', 1000),
('Mozart', 'orchestre5', '2019-04-20', 'Opéra Bastille', 10),
('Zen', 'orchestre7', '2015-02-22', 'LA', 50),
('Relax', 'orchestre6', '2016-01-01', 'PARIS', 200);

INSERT INTO musicien (nom, instrument, anneeExperience, nomOrchestre)
VALUES ('Yannick', 'guitare', 10, 'orchestre1'),
('Patrick', 'piano', 10, 'orchestre1'),
('Cedric', 'violon', 10, 'orchestre1'),
('Jordan', 'batterie', 2, 'orchestre2'),
('Gaelle', 'saxophone', 4, 'orchestre3'),
('Georges', 'harmonica', 20, 'orchestre6');

INSERT INTO orchestre (nom, style, chef)
VALUES ('orchestre1', 'jazz', 'leonardo'),
('orchestre2', 'pop', 'michaelgelo'),
('orchestre3', 'rnb', 'raphael'),
('orchestre4', 'house', 'donatello'),
('orchestre5', 'classic', 'Smith'),
('orchestre6', 'classic', 'Smith'),
('orchestre7', 'blues', 'Ray');


-Donner la liste des noms des jeunes musiciens et leurs instruments ; où jeune si moins de 5 ans d'expérience :
SELECT musicien.nom, musicien.instrument FROM musicien WHERE musicien.anneeExperience <= 5

-Donner la liste des différents instruments de l'orchestre :
SELECT DISTINCT musicien.instrument FROM musicien

-Donner toutes les informations sur les musiciens jouant du violon :
SELECT DISTINCT musicien.instrument FROM musicien INNER JOIN orchestre ON musicien.nomOrchestre = orchestre.nom WHERE orchestre.nom = 'Jazz92'

-Donner la liste des instruments dont les musiciens ont plus de 20 ans d'expérience :
SELECT DISTINCT musicien.instrument FROM musicien WHERE musicien.anneeExperience >= 20

-Donner la liste des noms des musiciens ayant entre 5 et 10 ans d'expérience (bornes incluses) :
SELECT DISTINCT musicien.nom FROM musicien WHERE musicien.anneeExperience BETWEEN 5 AND 10

-Donner la liste des instruments commençants par « vio » (e.g. violon, violoncelle, ...) :
SELECT musicien.instrument FROM musicien WHERE UPPER(instrument) LIKE 'VIO%' 

-Donner la liste des noms d'orchestre de style jazz :
SELECT orchestre.nom FROM orchestre WHERE orchestre.style = 'jazz' 

-Donner la liste des noms d'orchestre dont le chef est John Smith :
SELECT orchestre.nom FROM orchestre WHERE orchestre.chef = 'SMITH'

-Donner la liste des concert triés par ordre alphabétique :
SELECT concert.nom FROM concert ORDER BY concert.nom ASC

-Donner la liste des concerts se déroulant le 31 décembre 2015 à Versailles :
SELECT concert.nom FROM concert WHERE concert.lieu = 'Versailles' AND concert.date_ = '2015-12-31'

-Donner les lieux de concerts où le prix est supérieur à 150 euros :
SELECT concert.lieu FROM concert WHERE concert.prix > 150

-Donner la liste des concerts se déroulant à Opéra Bastille pour moins de 50 euros :
SELECT concert.nom FROM concert WHERE concert.lieu = 'Opéra Bastille' AND concert.prix < 50

-Donner la liste des concert ayant eu lieu en 2014 : 
SELECT concert.nom FROM concert WHERE UPPER(date_) LIKE '2014%'

NIVEAU MOYEN :
-Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms :
SELECT musicien.nom, musicien.instrument FROM musicien INNER JOIN orchestre ON musicien.nomOrchestre = orchestre.nom WHERE musicien.anneeExperience > 3 AND orchestre.style = 'jazz' ORDER BY musicien.nom ASC

-Donner les différents lieux, triés par ordre alphabétique, de concerts où l'orchestre du chef Smith joue avec un prix inférieur à 20 :
SELECT concert.lieu FROM concert INNER JOIN orchestre ON concert.nomOrchestre = orchestre.nom WHERE orchestre.chef = 'Smith' AND concert.prix < 20 ORDER BY concert.lieu ASC

-Donner le nombre de concerts de style blues en 2015 :
SELECT COUNT(concert.lieu) FROM concert INNER JOIN orchestre ON concert.nomOrchestre = orchestre.nom WHERE orchestre.style = 'blues' AND UPPER(date_) = '2015%' 

-Donner le prix moyen des concerts de style jazz par lieu de production :
SELECT concert.lieu, AVG(prix) FROM concert INNER JOIN orchestre ON concert.nomOrchestre = orchestre.nom WHERE orchestre.style = 'jazz'

-Donner la liste des instruments participant aux concerts donnés par le chef Smith le 1er janvier 2016 :
SELECT musicien.instrument FROM musicien INNER JOIN orchestre ON musicien.nomOrchestre = orchestre.nom INNER JOIN concert ON orchestre.nom = concert.nomOrchestre WHERE orchestre.chef = 'Smith' AND concert.date_ = '2016-01-01'

-Donner le nombre moyen d'années d'expérience des joueurs de trompette par style d'orchestre :
SELECT DISTINCT orchestre.style, AVG(anneeExperience) FROM musicien INNER JOIN orchestre ON musicien.nomOrchestre = orchestre.nom WHERE musicien.instrument = 'trompette' 

NIVEAU DIFFICILE :
-Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms :
SELECT musicien.nom, musicien.instrument
FROM musicien
WHERE musicien.anneeExperience > 3 AND musicien.nomOrchestre IN (
    SELECT orchestre.nom
    FROM orchestre
    WHERE orchestre.style = 'jazz'
    )

-Donner les différents lieux, triés par ordre alphabétique, de concerts où l'orchestre du chef Smith joue avec un prix inférieur à 20 : 
SELECT concert.lieu
FROM concert
WHERE concert.prix < 20 AND concert.nomOrchestre IN (
    SELECT orchestre.nom
    FROM orchestre
    WHERE orchestre.chef = 'Smith'
    )
ORDER BY concert.lieu ASC

-Donner le nombre de concerts de blues en 2015 :
SELECT COUNT(concert.nom)
FROM concert
WHERE concert.date_ = '2015%' AND concert.nomOrchestre IN (
    SELECT orchestre.nom
    FROM orchestre
    WHERE orchestre.style = 'blues'
    )

-Donner le prix moyen des concerts de style jazz par lieu de production
SELECT AVG(concert.prix), concert.lieu
FROM concert
WHERE concert.nomOrchestre IN (
    SELECT orchestre.nom
    FROM orchestre
    WHERE orchestre.style = 'jazz'
    )

-Donner la liste des instruments participant aux concerts donnés par le chef Smith le 1er janvier 2016 :
SELECT musicien.instrument
FROM musicien
WHERE musicien.nomOrchestre IN (
    SELECT orchestre.nom
    FROM orchestre
    WHERE orchestre.chef = 'Smith' AND orchestre.nom IN (
        SELECT concert.nomOrchestre
        FROM concert
        WHERE concert.date_ = '2016-01-01'
        )
    )

