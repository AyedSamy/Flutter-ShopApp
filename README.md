# Miaged

Miaged est une application mobile basée sur le style de Vinted, développée en Flutter et fonctionnelle sous Android.

## Lancement de l'application

Depuis une interface en ligne de commande, exécutez la commande : flutter run -d [android_phone_id]

## Interface de login

Au lancement de l'application, l'utilisateur peut se logger en renseignant son login (email) et son password.

Voici des identifiants disponibles pour se connecter à l'application :

**Login**: john@doe.fr

**Password**: doedoe

## Liste de vêtements & détail

La homepage contient une liste de vêtements dont les informations sont récupérées depuis la base de données Firebase. Les utilisateurs inscrits ont la possibilité de peupler cette base de données. Quelques différences se trouvent par rapport au critère d'acceptance de la BottomNavigationBar avec Acheter, Panier et Profil : j'ai finalement placé l'accès au profil sur l'AppBar, et mis en place un panel accessible sur la BottomNavigationBar pour observer le contenu du panier sans quitter la section Acheter, dans laquelle se trouve la liste des produits.

Le détail d'un produit est également disponible via un bouton See details, qui lance un panel permettant de voir toutes les informations du produit (titre, image, description, catégorie, taille, marque, prix) ainsi que de l'ajouter ou le supprimer du panier (la quantité est alors directement mise à jour). J'ai rajouté également la possibilité pour l'utilisateur de sélectionner plusieurs exemplaires du même produit.

## Le panier

Le panier accessible depuis un panel (modal bottom sheet) met en avant les informations des produits sélectionnés par l'utilisateur connecté (titre, quantité sélectionnée, prix unitaire). Un sous-total est alors indiqué en dessous de chaque article du panier. Le total global est visible sur le bas du panel. Une croix permet enfin de supprimer un article du panier.

## Profil utilisateur

L'ensemble des informations personnelles de l'utilisateur peuvent être modifiées lorsque l'utilisateur accède à cette page, la sauvegarde s'opérant sur la base de données.
Un bouton pour se déconnecter est également disponible sur le bas de la page (un autre bouton logout est disponible sur la page d'achat).

## Filtrer sur la liste des vêtements

Une liste déroulante a été mise en place pour filtrer les différentes catégories de vêtements ou accessoires. J'ai aussi rajouté la possiblité pour l'utilisateur de filtrer via le titre du produit dans une barre de recherche, et le filtre agit notamment selon la catégorie sélectionnée.

## Autres divers ajouts

L'utilisateur a la possibilité de s'inscrire sur l'application dans une section Register.

Il a la possibilité d'ajouter ses propres produits via un bouton Add item, et d'utiliser son appareil photo ou sa galerie pour fournir une image de son produit, stockée par la suite sur Firebase (une image par défaut est utilisée si aucune image n'est jointe).