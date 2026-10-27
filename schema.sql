CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    ville VARCHAR(80),
    date_inscription DATE DEFAULT CURRENT_DATE
);

CREATE TABLE produits (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    categorie VARCHAR(80),
    prix NUMERIC(10,2) NOT NULL CHECK (prix >= 0),
    stock INT DEFAULT 0
);

CREATE TABLE commandes (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(30) DEFAULT 'en_attente'
);

CREATE TABLE commande_details (
    id SERIAL PRIMARY KEY,
    commande_id INT REFERENCES commandes(id),
    produit_id INT REFERENCES produits(id),
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire NUMERIC(10,2) NOT NULL
);
