# Backend Hydratation (FastAPI)

Ce backend gère l'authentification des utilisateurs, la gestion des profils et l'enregistrement de la consommation d'eau.

## Prérequis

1.  **Python 3.8+**
2.  **MySQL Server**
3.  **Pip**

## Installation

1.  Allez dans le dossier backend :
    ```bash
    cd backend
    ```
2.  Installez les dépendances :
    ```bash
    pip install -r requirements.txt
    ```

## Configuration de la Base de Données

1.  Créez une base de données MySQL nommée `hydratation` :
    ```sql
    CREATE DATABASE hydratation;
    ```
2.  Assurez-vous que l'utilisateur `root` sans mot de passe est configuré ou modifiez la chaîne de connexion dans `main.py` :
    ```python
    db_url="mysql://root:password@localhost:3306/hydratation"
    ```

## Lancer le Serveur

Démarrez le serveur avec Uvicorn :
```bash
uvicorn main:app --reload
```

Le serveur sera accessible à l'adresse `http://localhost:8000`, ce qui correspond à la configuration de l'application Flutter.

## Intégration Flutter

L'application Flutter utilise déjà les endpoints suivants définis dans ce backend :
- `POST /users/create` : Inscription
- `GET /users/signin` : Connexion (supporte le corps JSON via Dio)
- `PUT /users/updatemail` : Mise à jour de l'email
- `PUT /users/updatename` : Mise à jour du nom
- `PUT /users/updatepassword` : Mise à jour du mot de passe
- `POST /compte/score` : Ajout d'un score d'hydratation
