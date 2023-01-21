# ProjectIMT_remote

Application SwiftUI permettant la prise de deux photos d'un même visage à deux instants différents, pour montrer son évolution dans le temps.

## MODELS

* **Customer**  
Un patient a un identifiant unique, nom, prénom, date de naissance, ainsi qu'une tableau contenenant une liste de transformation.  
Il est obligatoire de fournir au moins le prénom lors de l'initialisation d'une instance de Customer.  
            
* **Transformation**     
Une transformation a un identifiant unique, un nom, une photo et une date d'avant et d'après transformation.  
Une transformaiton peut être initialisée avec tous ses champs vides.  



## VIEWMODELS 

* **CustomerListManager**  
Sauvegarde les données de nos Patients et de leurs transformation.  
Fournit des fonctions pour ajouter, editer, supprimer... les patients et transformations.  
Les données ne sont pas persistantes, et se remettent à zéro après fermeture de l'application.  



## VIEWS

* **CameraView**  
Utilise le framework AVFoundation pour créer une vue de caméra custom.  
Utilise UIKit : nécessité d'utiliser un ControllerRepresentable et un ViewCoordinator pour intégrer la vue à SwiftUI.  
Contient un bouton pour prendre la photo, un bouton pour accepter la photo, un autre pour la reprendre.  
Si la photo est la première de la transformation, une ellipse apparait en transparence pour positionner/centrer le visage.  
Si la photo est la deuxième de la transformation, la première photo apparait en transparence pour positionner au mieux le visage.  

* **ImagePicker**  
Bouton custom permettant de selectionner/prendre une photo, et de l'afficher dans un cercle.  
Pour prendre une photo avec la caméra, on appelle CameraView().  
Sinon, on utilise UIImagePickerView() fournit par UIKit pour selectionner une photo de la galerie.  

* **TransformationItemRow**   
Présente deux ImagePicker() ainsi qu'un bouton permettant d'afficher ShowTransformationView() quand deux photos ont été prises.  

* **ShowTransformationView**  
Affiche la transformation en montrant l'évolution entre la photo "avant" et la photo "après".  
Un slider permet de passer d'une photo à l'autre en "fondu" en modifiant linéairement la transparence des photos.  

* **CustomerListView**  
Vue principale de l'application.  
Affiche les différents patients enregistrés, chacun possédant sa liste de transformations (les listes étant dépliables pour plus d'érgonomie).  
Un boutton permet d'ajouter de nouveaux patients.  
Des boutons permettent de modifier les infos des patients, de les supprimer, ou de leur ajouter de nouvelles transformations.  
Chaque Transformation est affichée en utilisant ShowTransformationView.  

* **AddCustomerSheet**  
Affiche un formulaire permettant de rentrer un nom, prénom, et date de naissance.  
Le prénom est obligatoire.  

* **EditCustomerSheet**  
Affiche un formulaire permettant de modifier le nom, prénom, et date de naissance, d'un patient existant.  

* **TextFieldAlert**  
Alerte custom affichant une zone de saisie de text, chose impossible avec une alerte classique.

## PERSISTENCE DES DONNEES 

* **Besoin**  
Dans l’application, les données sont des photos ou des spécifications sur les opérations et leur patient. Les données seront donc manipulées comme des objets. L’application pourrait être déployée durant plusieurs années sur tout un hôpital, voire sur un réseau d’hôpitaux. Il faut donc une base de données orientée objet qui peut contenir un très grande quantité de données.  

* **Core Data & Realm**  
Les meilleures solutions pour développer cela avec Swift sont la base de données mobile et multi-plateformes Realm, et la base de données locale (sur les appareils et applications), et munie d’une API orientée objet Core Data. Core Data est le pilier des développeurs iOS, mais l’API est encombrante et le coût de sa mise en oeuvre est élevé. Realm, plus récent, est en ascension grâce à sa facilité et son lot d’avantages.  
Realm, contrairement à SQLite (utilisé par Core Data), n’est pas basé sur l’ORM (Object-Relational Mapping). Il a un fonctionnement propre qui le rend facile à manier, et la gestion des données plus intuitive. Les requêtes sont aussi plus rapides. Core Data demande une sauvegarde à chaque changement de données. Realm enregistre les données automatiquement, donc même en cas de crash de l’application, ou de fermeture du simulateur, on peut toujours regarder le résultat de la base de données.  
Cependant, Realm a aussi des désavantages. CoreData permet une représentation visuelle du modèle dans Xcode, et utiliser l’éditeur de modèle de Xcode est plus simple que d’utiliser les fonctions qui lient les objets dans Realm. Aussi, travailler avec Realm augmente considérablement la taille de l’application alors que CoreData ne provoque que des changements minimes. 

* **Piste de choix**  
Ces deux bases de données sont adéquates pour l’application, mais le choix dépendra aussi de la suite du projet, et comment les organismes voudront traiter et sécuriser les données. D’un côté, Realm permet une circulation des données d’une plateforme à l’autre, et il est surtout plus simple d’utilisation. D’un autre côté, Core Data reste sûr, et si l’hôpital veut conserver les données sur des appareils MacOS ou des iOS, il fait largement l’affaire.  
