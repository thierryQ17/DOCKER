# Lien "Changer mon mot de passe"

## Fonctionnalité implémentée

✅ **Page créée** : `changePassword.php`
✅ **API créée** : `api.php?action=changePassword`
✅ **Authentification requise** : Oui (via `auth_middleware.php`)

## Comment ajouter le lien dans votre application

### Option 1 : Lien direct dans le menu

Ajoutez ce lien HTML dans votre menu de navigation :

```html
<a href="changePassword.php">
    <i class="bi bi-shield-lock"></i> Changer mon mot de passe
</a>
```

### Option 2 : Menu déroulant utilisateur

Si vous avez un menu déroulant avec le nom de l'utilisateur, ajoutez :

```html
<li>
    <a href="changePassword.php">
        <i class="bi bi-shield-lock"></i> Changer mon mot de passe
    </a>
</li>
```

### Option 3 : Page "Mon profil"

Ajoutez un bouton dans une page de profil utilisateur :

```html
<a href="changePassword.php" class="btn btn-primary">
    <i class="bi bi-shield-lock"></i> Changer mon mot de passe
</a>
```

## Accès direct

L'URL directe est : `http://localhost:8080/annuaire/changePassword.php`

## Fonctionnalités de la page

- ✅ **Sécurisée** : Nécessite d'être connecté
- ✅ **Validation** : Ancien mot de passe requis
- ✅ **Confirmation** : Double saisie du nouveau mot de passe
- ✅ **Visibilité** : Boutons pour afficher/masquer les mots de passe
- ✅ **Design** : Interface moderne et responsive
- ✅ **Feedback** : Messages d'erreur et de succès
- ✅ **Sécurité** :
  - Vérification de l'ancien mot de passe
  - Nouveau mot de passe différent de l'ancien
  - Minimum 6 caractères
  - Hachage bcrypt
