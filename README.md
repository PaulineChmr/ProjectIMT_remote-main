# ProjectIMT_remote

Application SwiftUI permettant la prise de deux photos d'un même visage à deux instants différents, pour montrer son évolution dans le temps.

## MODELS

* **Customer**  
Un Customer a un identifiant unique, nom, prénom, date de naissance, ainsi qu'un tableau de Transformation (défini dans la partie relationships de la classe).  
Il est obligatoire de fournir au moins le prénom lors de l'initialisation d'une instance de Customer.  
            
* **Transformation**     
Une Transformation a un identifiant unique, un nom, une photo et une date d'avant et d'après transformation, et une dose de produit injecté sur un endroit du visage avant et après transformation. Il est important de préciser que les photos sont enregistrées directement dans les fichiers du téléphone, les attributs before_picture et after_picture n'enregistrent donc que le chemin permettant d'y accéder. Les transformations ont également un tableau d'Additional Photo (défini dans la partie relationships de la classe), afin d'enregistrer des expressions faciales différentes pour une même transformation.
Une transformation peut être initialisée avec tous ses champs vides.  

* **Additional Photo**  
Une Additional Photo a un identifiant unique, une photo et une date d'avant et d'après transformation, et un nombre indiquant sa position dans la liste d'Additional Photo de la Transformation mère. 

* **Persistance des données**  
Ces trois classes sont générées par le framework Core Data. Celui-ci permet également de gérer les relations entre les deux classes, mais il permet surtout de stocker les données de l'application. Il utilise pour cela :  
Un contexte de données (on le retrouve souvent comme attribut nommé viewContext) afin de les sauvegarder ou de les récupérer depuis la persistance des données.  
Un magasin de données qui gère la persistance des données (fichier Persistence.swift).
Ainsi, lorsque l'on modifie la valeur d'un des attributs des classes générées par Core Data, il est nécessaire de faire appel à la fonction viewContext.save(), et lorsque l'on souhaite supprimer une instance de ces classes, on applique la fonction viewContext.delete(element). 



## VIEWS

* **CustomerListView**  
Vue principale de l'application.  
Affiche les différents patients enregistrés, chacun possédant sa liste de transformations (les listes étant dépliables pour plus d'érgonomie).  
Deux boutons sont présents en haut de l'écran : l'un permet d'ajouter de nouveaux patients en faisant appel à AddCustomerSheet, l'autre permet de générer un fichier csv contenant la liste des patients, les transformations associées ainsi que la liste des quantités de produits injectées dans les différents sites en utilisant le fichier GenerateCSV.  
Des boutons permettent de modifier les infos des patients, de les supprimer, ou de leur ajouter de nouvelles transformations. Chaque transformation peut également posséder différents couples de photos en y ajoutant des Additional Photo.  
L'affichage des transformations et des boutons correspondants se fait avec TransformationItemRow. L'affichage des photos supplémentaires se fait avec PhotoItemRow.

* **AddCustomerSheet**  
Affiche un formulaire permettant de rentrer un nom, prénom, et date de naissance.  
Le prénom est obligatoire.  

* **EditCustomerSheet**  
Affiche un formulaire permettant de modifier le nom, prénom, et date de naissance d'un patient existant.  

* **TransformationItemRow**   
Présente deux ImagePicker() ainsi qu'un bouton permettant d'afficher ShowTransformationView() dès lors que deux photos ont été prises. 
Un autre bouton permet d'associer à la transformation une liste de sites d'injection avec les quantités correspondantes.

* **ImagePicker**  
Bouton custom permettant de selectionner/prendre une photo, et de l'afficher dans un cercle.  
Pour prendre une photo avec la caméra, on appelle CameraView().  

* **CameraView**  
Utilise le framework AVFoundation pour créer une vue de caméra custom.  
Utilise UIKit : nécessité d'utiliser un ControllerRepresentable et un ViewCoordinator pour intégrer la vue à SwiftUI.  
Contient un bouton pour prendre la photo, un bouton pour accepter la photo, un autre pour la reprendre.  
Si la photo est la première de la transformation, une ellipse apparait en transparence pour positionner/centrer le visage.  
Si la photo est la deuxième de la transformation, la première photo apparait en transparence pour positionner au mieux le visage.  
Afin d'enregistrer les photos dans les fichiers du téléphone, on utilise la classe définie dans le fichier LocalFileManager.

* **LcoalFileManager**
Utilise la classe FileManager disponible dans la bibliothèque Foundation afin d'enregistrer les photos dans un répertoire particulier des fichiers du téléphone. Ce répertoire est indiqué dans la fonction getPathForImage.

* **ShowTransformationView**  
Affiche la transformation en montrant l'évolution entre la photo "avant" et la photo "après".  
Un slider permet de passer d'une photo à l'autre en "fondu" en modifiant linéairement la transparence des photos. 

* **TextFieldAlert**  
Alerte custom affichant une zone de saisie de text, chose impossible avec une alerte classique.

* **PhotoItemRow**  
Similaire au fichier TransformationItemRow, mais on modifie les attributs d'une Additional Photo au lieu d'une Transformation.

* **MultiImagePicker**  
Similaire au fichier TransformationItemRow, mais on modifie les attributs d'une Additional Photo au lieu d'une Transformation.

* **MultCameraView**  
Similaire au fichier TransformationItemRow, mais on modifie les attributs d'une Additional Photo au lieu d'une Transformation.

* **MultLocalFileManager**  
Similaire au fichier TransformationItemRow, mais on modifie les attributs d'une Additional Photo au lieu d'une Transformation.



## AXES D'AMÉLIORATION

* **Suppression manuelle des fichiers**  
L'application ne prend pas en compte la possibilité que l'utilisateur supprime manuellement les fichiers photo enregistrés dans ses dossiers. Dans ce cas, elle considère que les fichiers existent et risque de crash si l'on cherche à afficher la photo. Il faudrait donc ajouter une condition pour inclure ce cas.

* **Ergonomie de la view AddMuscleSheet**  
Afficher une image d'un visage afin que l'utilisateur clique sur les zones d'injection, puis choisisse la dose de produit injectée.
