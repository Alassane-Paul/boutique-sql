-- 1.   Lister tous les clients
SELECT * 
FROM clients;

-- 2.	Lister tous les produits par prix décroissant
SELECT *
FROM produits
ORDER BY prix DESC
LIMIT 5;

-- 3.	Afficher les clients de Lomé
SELECT *
FROM clients
WHERE ville = 'Lomé';

-- 4.	Compter le nombre total de clients
SELECT COUNT(*) AS nombre_clients
FROM clients;

-- 5.	Compter le nombre de commandes par statut
SELECT statut, 
        COUNT(*) AS nombre_commandes
FROM commandes
GROUP BY statut;

-- 6.	Afficher les produits dont le stock est inférieur à 60
SELECT nom , stock
FROM produits
WHERE stock < 60;

-- 7.	Calculer le prix moyen des produits
SELECT AVG(prix) AS prix_moyen
FROM produits;

-- 8.	Afficher le produit le plus cher
SELECT nom, prix
FROM produits
ORDER BY prix DESC
LIMIT 1;

-- 9.	Afficher le produit le moins cher
SELECT nom, prix
FROM produits
ORDER BY prix ASC
LIMIT 1;

-- 10.	Lister les commandes avec le nom du client
SELECT c.nom AS nom_client, 
co.id AS id_commande, co.date_commande, co.statut
FROM commandes co
JOIN clients c ON co.client_id = c.id;

--11.	Lister les clients qui n’ont jamais commandé
SELECT c.id AS id_client,
       c.nom AS nom_client
FROM clients c
LEFT JOIN commandes co ON co.client_id = c.id
WHERE co.id IS NULL;

-- 12.	Calculer le chiffre d’affaires total
SELECT SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires_total
FROM commande_details cd;

-- 13.	Calculer le chiffre d’affaires par produit
SELECT p.nom AS nom_produit, 
        SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires
FROM commande_details cd
JOIN produits p ON cd.produit_id = p.id
GROUP BY p.nom;

-- 14.	Calculer le chiffre d’affaires par client
SELECT c.nom AS nom_client, 
        SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires
FROM commande_details cd
JOIN commandes co ON cd.commande_id = co.id
JOIN clients c ON co.client_id = c.id
GROUP BY c.nom;

-- 15.	Afficher les clients ayant dépensé plus de 30 000 FCFA
SELECT c.nom AS nom_client, 
        SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires
FROM commande_details cd
JOIN commandes co ON cd.commande_id = co.id
JOIN clients c ON co.client_id = c.id
GROUP BY c.nom
HAVING SUM(cd.quantite * cd.prix_unitaire) > 30000;

-- 16.	Calculer le nombre de produits vendus par catégorie
SELECT p.categorie,
       COUNT(DISTINCT cd.produit_id) AS nombre_produits_vendus
FROM commande_details cd
JOIN produits p ON cd.produit_id = p.id
GROUP BY p.categorie;

-- 17.	Trouver la dernière commande de chaque client
SELECT c.nom AS nom_client, 
       MAX(co.date_commande) AS derniere_commande
FROM commandes co
JOIN clients c ON co.client_id = c.id
GROUP BY c.nom;

-- 18.	Classer les produits par chiffre d’affaires
SELECT p.nom AS nom_produit, 
       SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires
FROM commande_details cd
JOIN produits p ON cd.produit_id = p.id
GROUP BY p.nom
ORDER BY chiffre_affaires DESC;

-- 19.	Calculer le montant total de chaque commande
SELECT co.id AS id_commande, 
       SUM(cd.quantite * cd.prix_unitaire) AS montant_total
FROM commande_details cd
JOIN commandes co ON cd.commande_id = co.id
GROUP BY co.id;

-- 20.	Afficher les commandes contenant plus d’un produit
SELECT co.id AS id_commande,
       COUNT(DISTINCT cd.produit_id) AS nombre_produits_distincts
FROM commande_details cd
JOIN commandes co ON cd.commande_id = co.id
GROUP BY co.id
HAVING COUNT(DISTINCT cd.produit_id) > 1;

-- 21.	Numéroter les commandes de chaque client, de la plus récente à la plus ancienne
WITH commandes_classees AS (
    SELECT co.id,
           co.client_id,
           co.date_commande,
           co.statut,
           ROW_NUMBER() OVER (
               PARTITION BY co.client_id
               ORDER BY co.date_commande DESC, co.id DESC
           ) AS rang
    FROM commandes co
)
SELECT c.nom AS nom_client,
       cc.id AS id_commande,
       cc.date_commande AS derniere_commande,
       cc.statut
FROM commandes_classees cc
JOIN clients c ON c.id = cc.client_id
WHERE cc.rang = 1;

-- 22.	Classer les produits par chiffre d'affaires avec les ex aequo au même rang
SELECT p.nom AS nom_produit,
       SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires,
       RANK() OVER (
           ORDER BY SUM(cd.quantite * cd.prix_unitaire) DESC
       ) AS rang_chiffre_affaires
FROM commande_details cd
JOIN produits p ON cd.produit_id = p.id
GROUP BY p.id, p.nom;

-- 23.	Afficher le chiffre d'affaires calculé par client à l'aide d'une CTE
WITH chiffre_affaires_clients AS (
    SELECT c.id AS client_id,
           c.nom AS nom_client,
           SUM(cd.quantite * cd.prix_unitaire) AS chiffre_affaires
    FROM commande_details cd
    JOIN commandes co ON cd.commande_id = co.id
    JOIN clients c ON co.client_id = c.id
    GROUP BY c.id, c.nom
)
SELECT client_id, nom_client, chiffre_affaires
FROM chiffre_affaires_clients
ORDER BY chiffre_affaires DESC;