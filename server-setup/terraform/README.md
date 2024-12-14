## Configuration de Terraform

## Setup

1. L'utilisateur doit avoir le droit "EC2FullAccess"

2. Ajouter les secrets en tant que variables d'environnement de la machine hôte

```sh
% export AWS_ACCESS_KEY_ID="anaccesskey"
% export AWS_SECRET_ACCESS_KEY="asecretkey"
```

3. Tester

```sh
% terraform plan
```
