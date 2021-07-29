PARTIE 2 : 
###CREATION DE LA DATABASE SC_MVC_BTP :
CREATE DATABASE S6_MVC_BTP;

USE S6_MVC_BTP;

CREATE TABLE Client
(
    id INT PRIMARY KEY,
    nom VARCHAR(255),
    anneeNaiss YEAR(4),
    ville VARCHAR(255)
);

CREATE TABLE Fournisseur
(
    id INT PRIMARY KEY,
    nom VARCHAR(255),
    age INT(2),
    ville VARCHAR(255)
);

CREATE TABLE Produit
(
    label VARCHAR(255),
    idF INT,
    prix FLOAT(4),
    PRIMARY KEY (label, idF),
    FOREIGN KEY (idF) REFERENCES Fournisseur(id)
);

CREATE TABLE Commande
(
    num INT(1),
    idC INT,
    labelP VARCHAR(255),
    quantité INT,
    PRIMARY KEY (num, labelP, idC),
    FOREIGN KEY (idC) REFERENCES Client(id),
    FOREIGN KEY (labelP) REFERENCES Produit(label)
);


###INSERER LES VALEURS DANS LES TABLES
INSERT INTO client (id, nom, anneeNaiss, ville)
VALUES (1, 'Jean', 1965, '75006 Paris'),
(2, 'Paul', 1958, '75003 Paris'),
(3, 'Vincent', 1954, '94200 Evry'),
(4, 'Pierre', 1950, '92400 Courbevoie'),
(5, 'Daniel', 1963, '44000 Nantes');

INSERT INTO fournisseur (id, nom, age, ville)
VALUES (1, 'Abounayan', 52, '92190 Meudon'),
(2, 'Cima', 37, '44150 Nantes'),
(3, 'Preblocs', 48, '92230 Gennevilliers'),
(4, 'Samaco', 61, '75018 Paris'),
(5, 'Damasco', 29, '49100 Angers');

INSERT INTO produit (label, idF, prix)
VALUES ('sable', 1, 300),
('briques', 1, 1500),
('parpaing', 1, 1150),
('sable', 2, 350),
('tuiles', 3, 1200),
('parpaing', 3, 1300),
('briques', 4, 1500),
('ciment', 4, 1300),
('parpaing', 4, 1450),
('briques', 5, 1450),
('tuiles', 5, 1100);

INSERT INTO commande (num, idC, labelP, quantité)
VALUES (1, 1, 'briques', 5),
(1, 1, 'ciment', 10),
(2, 2, 'briques', 12),
(2, 2, 'sable', 9),
(2, 2, 'parpaing', 15),
(3, 3, 'sable', 17),
(4, 4, 'briques', 8),
(4, 4, 'tuiles', 17),
(5, 5, 'parpaing', 10),
(5, 5, 'ciment', 14),
(6, 5, 'briques', 21),
(7, 2, 'ciment', 12),
(8, 4, 'parpaing', 8),
(9, 1, 'tuiles', 15);

###RECUPERER 
-Les informations sur les clients :
SELECT * FROM client;

-toutes les informations « utiles à l’utilisateur » sur les clients, i.e. sans l’identifiant (servant à lier les relations) :
SELECT nom, anneeNaiss, ville FROM client;

-le nom des clients dont l’âge est supérieur à 50 :
SELECT nom FROM client WHERE anneeNaiss < 1971;

-la liste des produits (leur label), sans doublon :
SELECT DISTINCT label FROM produit;
--Dans l'ordre alphabétique :
SELECT DISTINCT label FROM produit ORDER BY label ASC;

-Les commandes avec une quantité entre 8 et 18 inclus : 
SELECT * FROM commande WHERE quantité BETWEEN 8 AND 18;
--OU
SELECT * FROM commande WHERE quantité >= 8 AND quantité <= 18;

-le nom et la ville des clients dont le nom commence par ’P’ :
SELECT nom, ville FROM client WHERE UPPER(nom) LIKE 'P%';

-le nom des fournisseurs situés à PARIS :
SELECT nom FROM fournisseur WHERE UPPER(ville) LIKE '%PARIS';

-l’identifiant Fournisseur et le prix associés des "briques" et des "parpaing" : 
SELECT idF, prix FROM produit WHERE label IN ('briques', 'parpaing');
--OU
SELECT idF, prix FROM produit WHERE label = 'briques' OR label = 'parpaing';

-la liste des noms des clients avec ce qu’ils ont commandé (label + quantité des produits) :
SELECT * FROM client INNER JOIN commande ON client.id = commande.idC;

-le produit cartésien entre les clients et les produits (i.e. toutes les combinaisons possibles d’un achat par un client), on affichera le nom des clients ainsi que le label produits :
SELECT client.nom, commande.labelP FROM client CROSS JOIN commande WHERE client.id = commande.idC;

###LE NOMBRE DE RESULTAT EST BEAUCOUP PLUS GRAND

-la liste, triée par ordre alphabétique, des noms des clients qui commandent le produit "briques" :
SELECT client.nom FROM client INNER JOIN commande ON client.id = commande.idC WHERE commande.labelP = 'briques' ORDER BY client.nom ASC;

-le nom des fournisseurs qui vendent des "briques" ou des "parpaing" :
SELECT DISTINCT fournisseur.nom FROM fournisseur INNER JOIN produit ON fournisseur.id = produit.idF WHERE produit.label = 'briques' OR produit.label = 'parpaing';
--OU
SELECT nom FROM fournisseur WHERE id IN ( SELECT idF FROM produit WHERE label = 'briques' OR label = 'parpaing' ); 

-le nom des produits fournis par des fournisseurs parisiens (intra muros uniquement) :
SELECT produit.label FROM produit INNER JOIN fournisseur ON produit.idF = fournisseur.id WHERE UPPER(ville) LIKE '%PARIS';
--OU
SELECT DISTINCT produit.label FROM fournisseur CROSS JOIN produit WHERE UPPER(ville) LIKE '%PARIS' AND idF = 4;
--OU
SELECT label FROM produit WHERE idf IN ( SELECT id FROM fournisseur WHERE UPPER(ville) LIKE '%PARIS' )

-les nom et adresse des clients ayant commandé des briques, tel que la quantité commandée soit comprise entre 10 et 15 :
SELECT client.nom, client.ville FROM client INNER JOIN commande ON client.id = commande.idC WHERE labelP = 'briques' AND quantité BETWEEN 10 AND 15

-le nom des fournisseurs, le nom des produits et leur coût, correspondant pour tous les fournisseurs proposant au moins un produit commandé par Jean : 
SELECT fournisseur.nom, produit.label, produit.prix
FROM client
INNER JOIN commande ON client.id = commande.idC
INNER JOIN produit ON commande.labelP = produit.label
INNER JOIN fournisseur ON produit.idF = fournisseur.id
WHERE client.nom = 'Jean'

-idem, mais on souhaite cette fois que le résultat affiche le nom des fournisseurs trié dans l’ordre alphabétique descendant et pour chaque fournisseur le nom des produits dans l’ordre ascendant :
SELECT fournisseur.nom, produit.label, produit.prix
FROM client
INNER JOIN commande ON client.id = commande.idC
INNER JOIN produit ON commande.labelP = produit.label
INNER JOIN fournisseur ON produit.idF = fournisseur.id
WHERE client.nom = 'Jean'
ORDER BY fournisseur.nom DESC, produit.label ASC

-le nom et le coût moyen des produits :
SELECT label, AVG(prix) FROM produit

-le nom des produits proposés et leur coût moyen lorsque celui-ci est supérieur à 1200 : 
SELECT label, AVG(prix) FROM produit WHERE prix > 1200 GROUP BY label

-le nom des produits dont le coût est inférieur au coût moyen de tous les produits :
SELECT label FROM produit WHERE prix < ( SELECT AVG(prix) FROM produit )

-le nom des produits proposés et leur coût moyen pour les produits fournis par au moins 3 fournisseurs :
SELECT label, AVG(prix) FROM produit GROUP BY label HAVING COUNT(idf) > 2
 











