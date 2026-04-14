# TP Terraform - Guide de prise en main (clone Git)

Ce projet contient une infra AWS avec :
- VPC + subnets + Internet Gateway + route table
- Security Group web
- Instance EC2 Ubuntu + nginx
- Backend Terraform S3 (state distant)
- Import d'un Security Group existant
- Bonus : module local réseau

Le projet est prévu pour tourner en us-east-1.

## 1) Prérequis

Installer :
- Terraform >= 1.7
- AWS CLI v2
- Git

Vérifier :
- terraform version
- aws --version
- git --version

## 2) Cloner le repo

- git clone <URL_DU_REPO>
- cd TP2

## 3) Credentials AWS (OBLIGATOIRE)

Chaque personne doit utiliser ses propres credentials AWS.
Ne jamais réutiliser ceux d'un autre et ne jamais les committer.

Option A (fichier credentials) :
- ~/.aws/credentials
- profil default avec :
  - aws_access_key_id
  - aws_secret_access_key
  - aws_session_token (si session temporaire)

Option B (variables d'environnement) :
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- AWS_REGION=us-east-1

Vérifier l'identité active :
- aws sts get-caller-identity

## 4) Personnaliser les valeurs du projet

Les valeurs à adapter selon votre user :
- student_name
- promo_name
- key_name (nom de votre key pair AWS)

Le plus simple : créer un fichier local non committé dev.tfvars (déjà ignoré par .gitignore) :

Exemple :
student_name = "votre-prenom"
promo_name   = "VOTRE_PROMO"
key_name     = "tf-votre-prenom-dev-key"
region       = "us-east-1"

Puis utiliser :
- terraform plan -var-file="dev.tfvars"
- terraform apply -var-file="dev.tfvars"

## 5) Backend S3 du state

Le backend est configuré dans terraform.tf.
Important : ne pas écraser le state d'un autre utilisateur.

Vérifier/adapter :
- bucket : bucket S3 accessible avec VOS droits
- key : chemin unique (ex : votre-prenom/project.tfstate)
- region : us-east-1

Si vous changez backend :
- terraform init -migrate-state

## 6) Initialisation et vérification

Dans le dossier TP2 :
- terraform init
- terraform fmt
- terraform validate -no-color
- terraform plan -no-color -var-file="dev.tfvars"

Attendu :
- validate : success
- plan : pas de recréation inattendue

## 7) Commandes utiles

Sorties Terraform :
- terraform output
- terraform output -raw web_instance_public_ip

SSH instance (user Ubuntu) :
- ssh -i ~/.ssh/id_rsa_tp2 ubuntu@<IP_PUBLIQUE>

Test nginx :
- curl http://<IP_PUBLIQUE>

## 8) Import Security Group (phase import)

Si vous faites l'exercice import :
- créer le SG manuellement en console/AWS CLI
- recopier son ID (sg-xxxxxxxx)
- mettre cet ID dans le bloc import du code
- terraform plan
- terraform apply
- terraform state list
- terraform state show aws_security_group.imported

## 9) SFTP VS Code (si vous utilisez .vscode/sftp.json)

Le fichier .vscode/sftp.json est un exemple local.
Chaque collègue doit adapter :
- host
- username
- remotePath

Exemple :
- host : IP de sa VM
- username : son user (pas forcément user29)
- remotePath : /home/son-user

Important :
- le SFTP synchronise les fichiers, mais pas l'historique Git
- pour garder l'historique propre : utiliser git push / git pull

## 10) Règles de sécurité

- Ne jamais committer :
  - credentials AWS
  - fichiers tfvars sensibles
  - state Terraform
- Garder .terraform.lock.hcl versionné

## 11) Séquence rapide pour un nouveau collègue

1. Configurer ses credentials AWS
2. Cloner le repo
3. Créer dev.tfvars avec ses valeurs
4. Vérifier le backend S3 (bucket + key perso)
5. terraform init
6. terraform validate
7. terraform plan -var-file="dev.tfvars"
8. terraform apply -var-file="dev.tfvars" (si besoin)

Si erreur de droits AWS (403) :
- vérifier l'identité active avec aws sts get-caller-identity
- vérifier que les permissions du rôle/session couvrent EC2 + S3
