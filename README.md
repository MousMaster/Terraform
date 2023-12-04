

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

Il sera composé de trois fichier un "variables.tf" , le fichier "output.tf" , et enfin le fichier "main.tf".

Le fichier "main.tf"

Ce code Terraform récupère la dernière image AMI d'Ubuntu Bionic 18.04 pour une instance EC2 via la ressource data "aws_ami". La ressource aws_instance crée une instance EC2 en utilisant cette AMI, spécifiant le type d'instance, la clé SSH, les tags, le groupe de sécurité, et la zone de disponibilité à partir de variables. De plus, elle définit des paramètres du volume racine, et utilise des provisioners local-exec pour écrire l'adresse IP publique dans un fichier et remote-exec pour installer et démarrer Nginx via SSH. 


### Étape 2: Module "sgmodule"


Le code fourni configure un groupe de sécurité AWS (aws_security_group) qui autorise le trafic entrant sur les ports HTTP (80), HTTPS (443) et SSH (22). Il crée un groupe de sécurité nommé d'après le mainteneur spécifié dans les variables Terraform. Les règles ingress définissent des autorisations pour le trafic entrant, permettant à tout le monde (0.0.0.0/0) d'accéder aux ports HTTP et HTTPS, ainsi qu'au port SSH pour une connexion sécurisée.

La règle egress autorise tout le trafic sortant vers toutes les destinations et tous les ports. L'ajout de la règle pour le protocole SSH, bien que non spécifié dans les consignes initiales, semble être une adaptation pour faciliter l'utilisation du provisioner remote-exec via SSH pour des opérations de configuration à distance sur l'instance EC2. Cependant, l'ouverture de l'accès SSH à toutes les adresses IP (0.0.0.0/0) présente un risque de sécurité, et il est recommandé de limiter cet accès à des adresses IP spécifiques pour renforcer la sécurité de l'infrastructure.


### Étape 3: Module "ippublique"

Le code présent utilise Terraform pour définir une ressource AWS EIP (Elastic IP). Dans cet exemple, la ressource EIP est configurée avec l'option vpc = true, ce qui spécifie que l'Elastic IP doit être associée à une instance dans un Virtual Private Cloud (VPC). L'utilisation de vpc = true permet de créer une adresse IP élastique pour une utilisation dans un environnement VPC spécifique, ce qui est souvent nécessaire pour des instances EC2 exécutées dans un VPC. Cela permet à cette adresse IP de fonctionner dans un contexte de réseau VPC, offrant ainsi une isolation réseau et des fonctionnalités de sécurité améliorées pour les ressources AWS.

### Étape 4: Module "ebsmodule"


Le code fourni utilise Terraform pour définir une ressource AWS EBS Volume (Elastic Block Store). Dans cet extrait, la ressource EBS Volume est configurée pour être créée dans la zone de disponibilité "us-east-1b" spécifiée. La taille du volume est définie à l'aide d'une variable Terraform nommée ebssize.

De plus, des tags sont associés à ce volume EBS via la clé "Name", qui utilise la valeur "ebs-${var.maintainer}". Cela permet de faciliter l'identification et la gestion des ressources en attribuant des étiquettes (tags) pour une meilleure organisation et traçabilité au sein de votre environnement AWS.


### Étape 5 : Module principal "dev"

Dans ce code Terraform, le module principal joue un rôle central en orchestrant différents modules spécialisés pour construire l'infrastructure complète sur AWS.


Ce fichier agit comme un orchestrateur principal, appelant et intégrant les fonctionnalités spécifiques offertes par d'autres modules.
Il utilise les modules spécialisés (sg, ebs, ip_public, ec2) pour gérer des aspects spécifiques de l'infrastructure.
Utilisation des Modules :

Chaque module est dédié à une tâche particulière :
module.sg gère la création du groupe de sécurité.
module.ebs est responsable de la gestion des volumes EBS.
module.ip_public gère l'attribution et la configuration des adresses IP publiques.
module.ec2 déploie et configure des instances EC2.
Intégration des Ressources :

Le module principal utilise les sorties générées par chaque module spécialisé (output_sg_name, output_eip, etc.) comme entrées pour d'autres modules ou ressources AWS (aws_eip_association, aws_volume_attachment).
Par exemple, module.ec2 utilise les valeurs de sortie de module.ip_public et module.sg pour configurer correctement l'instance EC2 avec une adresse IP publique et un groupe de sécurité approprié.
Organisation Modulaire :

Cette approche modulaire permet de découper l'infrastructure en composants indépendants, simplifiant la gestion et la maintenance.
Chaque module se concentre sur une fonction spécifique, favorisant la réutilisation et la facilité de mise à jour.


### Conclusion : 

L'ensemble de l'infrastructure créée avec Terraform vise à déployer et à gérer des ressources AWS pour former une architecture complète. Cette infrastructure se compose d'une instance EC2, d'un groupe de sécurité, d'une adresse IP publique, et d'un volume EBS, orchestrés à l'aide de modules Terraform.

Résumé de l'infrastructure :

Instance EC2 : Déploiement d'une instance EC2 de type "t2.micro" dans la région AWS "us-east-1".
Groupe de Sécurité : Création d'un groupe de sécurité configuré pour autoriser le trafic sur les ports 80 (HTTP), 443 (HTTPS), et 22 (SSH) depuis toutes les adresses IP.
Adresse IP Publique : Attribution d'une adresse IP élastique à l'instance EC2.
Volume EBS : Création d'un volume EBS dans la zone de disponibilité "us-east-1b".
Ce que j'ai appris :

Modularité avec Terraform : L'utilisation de modules Terraform permet de découper l'infrastructure en composants indépendants, simplifiant ainsi la gestion et la maintenance.
Interconnexion des Ressources : Les modules interagissent les uns avec les autres à travers les sorties (outputs) et les entrées (inputs) pour créer une infrastructure interconnectée.
Orchestration d'Infrastructures AWS : La mise en place d'une infrastructure sur AWS avec Terraform nécessite la gestion fine des ressources et de leurs dépendances.

## Conclusion :

Cette expérience avec Terraform m'a permis de comprendre comment organiser et déployer une infrastructure sur AWS de manière modulaire et reproductible. J'ai appris à utiliser des modules Terraform pour décrire différents aspects de l'infrastructure AWS, en les reliant de manière cohérente pour créer un environnement complet. Cela a renforcé ma compréhension des bonnes pratiques en matière de gestion des ressources cloud et d'orchestration d'infrastructures complexes à l'aide d'outils d'automatisation comme Terraform.