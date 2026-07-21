# Guide de démarrage U-Skill Wiki (Pour Windows)

Ce document vous explique comment lancer le projet U-Skill Wiki sur votre ordinateur Windows. Aucune connaissance technique n'est requise!

---

## WinGet

Les deux méthodes d'installation requierent le logiciel WinGet (une sorte de magasin d'applications pour développeurs). Pour vérifier si vous l'avez déjà, suivez ces étapes:

1. Ouvrez l'application **Powershell** sur votre ordinateur **en tant qu'administrateur**.

2. Tapez "winget" puis appuyez sur <kbd>Return</kbd>. Si vous voyez un message rouge, cela indique que WinGet n'est pas installé. Pour installer WinGet, copiez-collez cette commande et appuyez sur <kbd>Return</kbd>:
   ```powershell
   Install-PackageProvider -Name NuGet -Force; Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery; Repair-WinGetPackageManager -AllUsers
   ```
   Une fois fini, vous pouvez vérifier que WinGet s'est bien installé en exécutant la commande "winget".

## Méthode 1 : L'installation automatique (Recommandée)

La manière la plus simple de lancer le projet est d'utiliser le script mis à votre disposition. Il s'occupera d'installer tous les outils nécessaires ainsi que de lancer le projet.

### Étape 1 : Télécharger le projet

1. Ouvrez l'application **Powershell** sur votre ordinateur (<kbd>Win</kbd> + <kbd>R</kbd>, tapez "powershell", <kbd>Return</kbd>).

2. Naviguez jusqu'à votre Bureau en exécutant cette commande:
   ```powershell
   cd "$env:USERPROFILE\Desktop"
   ```

3. Téléchargez le projet en tapant cette commande:
   ```powershell
   git clone https://github.com/Shuvlyy/uskill-wiki.git ; cd uskill-wiki
   ```

> [!NOTE]
> Si il s'agit de la première fois que vous utilisez la commande `git`, il se peut que vous deviez l'installer avec la commande suivante:
> ```powershell
> winget install --id Git.Git -e --source winget
> ```

### Étape 2 : Lancer le projet

Lancez le script d'installation en tapant cette commande:
```powershell
start setup_windows.bat
```

> [!CAUTION]
> **Redémarrage possible :** Le script vérifie si votre PC possède les fonctionnalités de virtualisation (WSL, nécessaires pour Docker). S'il doit les installer, il vous demandera de **redémarrer votre ordinateur**. Dans ce cas, après le redémarrage :
> 1. Rouvrez l'application Powershell (<kbd>Win</kbd> + <kbd>R</kbd>, tapez "powershell", <kbd>Return</kbd>).
> 2. Retournez dans le dossier du projet: `cd "$env:USERPROFILE\Desktop\uskill-wiki"`
> 3. Relancez le script (`start setup_windows.bat`) pour qu'il reprenne l'installation là où il s'était arrêté.

> [!IMPORTANT]
> Si le script vous indique *"Please fill up the .env file (admin email + password)."*, vous devez [configurer le projet](#configuration-du-projet) puis relancer le script avec la même commande.

Une fois lancé, laissez l'ordinateur travailler! Il prendra sûrement du temps pour tout mettre en place. Suivez bien les instructions affichées ! Il va peut-être vous demander votre autorisation pour installer certains outils. Une fois terminé, il affichera un message de succès.

L'application sera alors accessible sur votre navigateur internet via cette adresse : **http://localhost:8080**.

---

## Méthode 2 : L'installation manuelle

Si vous préférez comprendre chaque étape ou si le script ne marche pas, voici comment faire manuellement :

### Étape 1 : Télécharger le projet
Ouvrez le **Powershell** (<kbd>Win</kbd> + <kbd>R</kbd>, tapez "powershell", <kbd>Return</kbd>) et copiez-collez cette ligne, puis appuyez sur <kbd>Return</kbd> :
```powershell
git clone https://github.com/Shuvlyy/uskill-wiki.git ; cd uskill-wiki
```

> [!NOTE]
> Si il s'agit de la première fois que vous utilisez la commande `git`, il se peut que vous deviez l'installer avec la commande suivante:
> ```powershell
> winget install --id Git.Git -e --source winget
> ```

### Étape 2 : Installer Python
Ensuite, tapez :
```powershell
winget install -e --id Python.Python.3.11 --accept-package-agreements --accept-source-agreements
```

### Étape 3 : Installer Docker Desktop
Ensuite, tapez :
```powershell
winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
```

Une fois installé, ouvrez l'application **Docker Desktop** depuis le menu Démarrer de Windows.

### Étape 4 : Préparer la configuration

Avant de passer à l'étape suivante, assurez-vous de suivre les instructions de [configuration du projet](#configuration-du-projet).

### Étape 5 : Lancer le projet

Pour lancer le projet, dans le Powershell, toujours dans le dossier du projet, tapez :
```powershell
docker compose up --build -d
```

Cette commande s'occupera de démarrer tout ce qu'il faut. Quand c'est fini, le projet est prêt !
- L'application sera accessible via ce lien : **http://localhost:8080**
- Et pour les plus curieux, l'API sera accessible ici : **http://localhost:8000**

## Comment arrêter le projet ?
Quand vous avez fini de tester l'application, pour tout arrêter proprement, tapez dans le Powershell (toujours dans le dossier du projet) :
```cmd
docker compose down
```

## Configuration du projet

Avant de lancer le projet, il doit être correctement configuré. Pour ça, suivez ces étapes:

Vous devriez normalement être dans le Powershell, dans le dossier du projet. En exécutant la commande `dir -Force`, vous verrez un fichier nommé `.env.sample`.

> [!NOTE]
> Pour vérifier que vous êtes bien dans le dossier du projet, assurez-vous simplement qu'il est écrit à gauche de la ligne (il devrait y avoir écrit `uskill-wiki`).

1. Faites une copie de ce fichier et nommez la copie `.env` (avec un point au début, c'est important). Vous ne verrez peut-être pas ces fichiers dans votre explorateur de fichiers (à moins que vous ayez changé les paramètres de Windows), pas d'inquiétudes c'est normal. Vous devez donc faire ça depuis le Powershell. Toujours dans le dossier du projet, tapez cette commande:
   ```powershell
   copy .env.sample .env
   ```

2. Ouvrez ce fichier `.env` avec le logiciel `Bloc-notes` (un logiciel d'édition de texte) dans le Powershell:
   ```powershell
   notepad .env
   ```

3. Une fois dans le Bloc-notes, rendez-vous à la fin de la première ligne (avec écrit `USKILL_ADMIN_EMAIL=`) et renseignez l'email administrateur.\
Faites la même chose avec `USKILL_ADMIN_PASSWORD=` avec le mot de passe administrateur.\
Vous n'avez pas besoin de mettre de guillemets (`"`).\
Laissez les autres champs par défaut, à moins que vous ne sachiez ce que vous faites.

4. Une fois fini, vous pouvez enregistrer le fichier et quitter le logiciel. Pour vérifier que vos modifications ont bien été prises en compte, vous pouvez exécuter cette commande:
   ```powershell
   type .env
   ```
   Et vous devriez normalement voir l'email et le mot de passe administrateur que vous avez renseigné.

Une fois cette étape de configuration faite, vous pouvez continuer les étapes de la méthode d'installation que vous suiviez.
