INSERT INTO clients (nom, email, ville) VALUES
('Awa', 'awa@example.com', 'Lomé'),
('Kofi', 'kofi@example.com', 'Lomé'),
('Fatou', 'fatou@example.com', ' Kara'),
('Yao', 'yao@example.com', 'Tsévié');

INSERT INTO produits (nom, categorie, prix, stock) VALUES
('Formation Python', 'Développement', 25000, 100),
('Formation React', 'Développement', 30000, 80),
('Formation IA', 'Intelligence artificielle', 45000, 50),
('Formation Flutter', 'Développement mobile', 35000, 70);

INSERT INTO commandes (client_id, statut) VALUES
(1, 'payee'),
(2, 'payee'),
(1, 'en_attente'),
(3, 'payee');

INSERT INTO commande_details (commande_id, produit_id, quantite, prix_unitaire) VALUES
(1, 1, 1, 25000),
(2, 2, 2, 30000),
(3, 3, 1, 45000),
(4, 4, 1, 35000);
