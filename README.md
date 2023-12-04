

### Inntroduction

Dans le contexte de ce projet, dont les spécifications sont disponibles  [ici](https://github.com/diranetafen/student-list.git "here"). 

J'ai conceptualisé une architecture AWS pour faciliter pour repondre a la problematique donnee.

L'infrastructure en question se compose de plusieurs module AWS:
 
1: Une EC2 : une machine virtuelle  ubuntu-bionic  
2: Un ei : une adresse ip publique 
3: Un ebs : un module de stockage amovible 
4: Un security group : un parfeu 

Un aperçu de l'architecture proposé est illustré ci-dessous.

![project](https://github.com/MousMaster/Terraform/blob/main/architecture.png)


------------

### Plan d'action
  

Adopter une procedure iterative pour creation des modules ainsi  : 
je vais commencer tout d'abord par creer le module ec2 qui est la brique de base de 'linfrastructure puis je vais creer 
le security group puis et ei (elastic ip ) puis enfin ebs pour le stockage.


### Structure des modules 
Le fichier "main.tf" comprend la configuration de chaque module respectivement. 
Le fichier "output.tf" comprend les variables du module qui seront exporte pour pouvoir etre utilise dans d'autre module.
Le fichier "variables.tf" comprend les parametres par defaut de chaque variable (type + valeur).


Fichier "output.tf"

```console
output "output_ec2_id" {
    value = aws_instance.myec2.id
  }
```
*La variable sera exporte sous le "nom output_ec2_id" elle comprendra l'id de l'ec2 en l'occurence celui de  "aws_instance.myec2"*

Fichier "variables.tf" 

```console
variable "maintainer" {
  type    = string
  default = "mous"
}
```
*La variable "maintainer" aura pour valeur par defaut "mous" et pour type "string" *




### Étape 1: Module "ec2module"

Il sera composé de trois fichier un "variables.tf" decrivant les variables (valeur par défaut, type de variable), le fichier output cotenant les varaibles du modules aux quelles on fait appel en dehors du module, et enfin le fichier "main.tf" contenant les instruction necessaire quand la creation de l'objet ec2.




```console
docker run -v ./student_age.json:/data/student_age.json -p 8082:5000 student-api 
```

*Cette commande déploie l'image sous forme de conteneur, en lui associant un volume et en exposant le port 8082. *


```console
 curl -u toto:python -X GET http://127.0.0.1:50000/pozos/api/v1.0/get_student_ages
 ```

 *Cette commande teste la connexion à l'API. Les identifiants "toto" et "python" sont utilisés pour l'authentification HTTP basique.*
 *

![project](https://github.com/MousMaster/Docker/blob/master/images/curl_ok.png)

On test a present si l'api repond et renvoie la liste des étudiants, confirmant ainsi le bon fonctionnement de l'API.





*On arrive a reccuperer la list des etudiants on en conclue que l'api est fonctionnelle*


### Étape 2: Mise en place du docker-compose



Après avoir généré le fichier docker-compose, on modifie la ligne :

```console
$url = 'http://<api_ip_or_name:port>/pozos/api/v1.0/get_student_ages';

```
par :
           
```console
$url = 'http://student-api:5000/pozos/api/v1.0/get_student_ages';
```

Cela permet au frontend de pointer vers le backend. Remplacez <api_ip_or_name> par le nom du conteneur (student-api) et <port> par 5000.

Puis on test si l'on arrive a reccuperer la liste des etudiants a partir du frontend :

![project](https://github.com/MousMaster/Docker/blob/master/images/we_site_ok.png)
  

### Étape 3: Déploiement d'un registre Docker local


Pour cette étape, j'ai opté pour une approche "Infrastructure as Code". Une fois le registre lancé,j'ai lancé les commandes suivantes : 

```console
docker image tag student-list-api localhost:51000/v2/student_api
```

* Cette commande tag l'image, étape nécessaire avant de la charger sur un registre Docker. *

```console
docker push localhost:51000/v2/student_api                      
```
* Cette commande charge l'image créée précédemment sur le registre Docker local.
 *



![project](https://github.com/MousMaster/Docker/blob/master/images/push_ok.png)

![project](https://github.com/MousMaster/Docker/blob/master/images/push_front_ok.png)

Les captures d'écran fournies montrent que les étapes se sont déroulées avec succès.
