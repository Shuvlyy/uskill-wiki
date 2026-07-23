# Guide de démarrage U-Skill Wiki (Pour Mac)

Ce document vous explique comment lancer le projet U-Skill Wiki sur votre Mac. Aucune connaissance technique n'est requise!

---

## Méthode 1 : L'installation automatique (Recommandée)

La manière la plus simple de lancer le projet est d'utiliser le script mis à votre disposition. Il s'occupera d'installer tous les outils nécessaires ainsi que de lancer le projet.

### Étape 1 : Télécharger le projet
Ouvrez l'application **Terminal** sur votre Mac (<kbd>Cmd</kbd> + <kbd>Space</kbd>, tapez "Terminal", <kbd>Return</kbd>), puis téléchargez le projet en tapant cette commande:
```bash
git clone https://github.com/Shuvlyy/uskill-wiki.git && cd uskill-wiki/
```

> [!NOTE]
> Si il s'agit de la première fois que vous utilisez la commande `git`, macOS vous demandera votre mot de passe pour installer le logiciel.

### Étape 2 : Lancer le projet
Lancez le script d'installation en tapant cette commande puis en appuyant sur <kbd>Return</kbd>:
```bash
bash setup_mac.sh
bash setup_mac.sh --filldata # Prenez cette commande si vous voulez ajouter les ressources de base.
```

> [!IMPORTANT]
> Lorsqu'OrbStack se lancera automatiquement, vous devrez suivre le programme d'installation et bien choisir Docker lorsque ce sera demandé.

> [!IMPORTANT]
> Si le script vous indique *"Please fill up the .env file (admin email + password)."*, vous devez [configurer le projet](#configuration-du-projet) puis relancer le script avec la même commande.

Une fois fait, laissez l'ordinateur travailler! Il va peut-être vous demander votre mot de passe pour installer certains outils. Une fois terminé, il affichera un message de succès.

L'application sera alors accessible sur votre navigateur internet via cette adresse : **http://localhost:8080**.

---

## Méthode 2 : L'installation manuelle

Si vous préférez comprendre chaque étape ou si le script ne marche pas, voici comment faire manuellement :

### Étape 1 : Télécharger le projet
Ouvrez le **Terminal** (<kbd>Cmd</kbd> + <kbd>Space</kbd>, tapez "Terminal", <kbd>Return</kbd>) et copiez-collez cette ligne, puis appuyez sur <kbd>Return</kbd> :
```bash
git clone https://github.com/Shuvlyy/uskill-wiki.git && cd uskill-wiki/
```

> [!NOTE]
> Si il s'agit de la première fois que vous utilisez la commande `git`, macOS vous demandera votre mot de passe pour installer le logiciel.

### Étape 2 : Installer Homebrew
Toujours dans le Terminal, tapez :
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


### Étape 3 : Installer OrbStack (Docker)
Ensuite, tapez :
```bash
brew install --cask orbstack
```

Une fois installé, ouvrez l'application **OrbStack** (<kbd>Cmd</kbd> + <kbd>Space</kbd>, tapez "OrbStack", <kbd>Return</kbd>).
Si vous préférez, vous pouvez l'ouvrir depuis le Terminal:
```bash
open /Applications/OrbStack.app/
```

Suivez le programme de configuration, et sélectionnez bien Docker quand il vous sera demandé de choisir.

### Étape 4 : Préparer la configuration

Avant de passer à l'étape suivante, assurez-vous de suivre les instructions de [configuration du projet](#configuration-du-projet).

### Étape 5 : Lancer le projet

Pour lancer le projet, dans le Terminal, toujours dans le dossier du projet, tapez :
```bash
docker compose up --build -d
```

Cette commande s'occupera de démarrer tout ce qu'il faut. Quand c'est fini, le projet est prêt !
- L'application sera accessible via ce lien : **http://localhost:8080**
- La page administrateur sera accessible ici : **http://localhost:8080/#/admin**
- Et pour les plus curieux, l'API sera accessible ici : **http://localhost:8000**

### Étape 6 : Populer la base de données

Si vous voulez ajouter les ressources déjà fournies, exécutez cette commande :
```bash
docker compose exec api python -m seeder.seeder seeder/data.json
```

## Comment arrêter le projet ?
Quand vous avez fini de tester l'application, pour tout arrêter proprement, tapez dans le Terminal (toujours dans le dossier du projet) :
```bash
docker compose down
```

## Configuration du projet

Avant de lancer le projet, il doit être correctement configuré. Pour ça, suivez ces étapes:

Vous devriez normalement être dans le Terminal, dans le dossier du projet. En exécutant la commande `ls -a`, vous verrez un fichier nommé `.env.sample`.

> [!NOTE]
> Pour vérifier que vous êtes bien dans le dossier du projet, assurez-vous simplement qu'il est écrit à gauche de la ligne (il devrait y avoir écrit `uskill-wiki`).

1. Faites une copie de ce fichier et nommez la copie `.env` (avec un point au début, c'est important). Vous ne verrez pas ces fichiers dans votre Finder (à moins que vous ayez changé les paramètres de votre Mac), pas d'inquiétudes c'est normal. Vous devez donc faire ça depuis le Terminal. Toujours dans le dossier du projet, tapez cette commande:
   ```bash
   cp .env.sample .env
   ```

2. Ouvrez ce fichier `.env` avec le logiciel TextEdit (un logiciel d'édition de texte) dans le Terminal:
   ```bash
   open -a TextEdit .env
   ```

3. Une fois dans TextEdit, rendez-vous à la fin de la première ligne (avec écrit `USKILL_ADMIN_EMAIL=`) et renseignez l'email qui aura accès à la page administrateur de l'application.\
Faites la même chose avec `USKILL_ADMIN_PASSWORD=` avec le mot de passe qui permettra d'accéder à la page administrateur.\
Vous pouvez mettre l'email et le mot de passe que vous souhaitez.\
Vous n'avez pas besoin de mettre de guillemets (`"`).\
Laissez les autres champs par défaut, à moins que vous ne sachiez ce que vous faites.

4. Une fois fini, vous pouvez enregistrer le fichier et quitter le logiciel. Pour vérifier que vos modifications ont bien été prises en compte, vous pouvez exécuter cette commande:
   ```bash
   cat .env
   ```
   Et vous devriez normalement voir l'email et le mot de passe administrateur que vous avez renseigné.

Une fois cette étape de configuration faite, vous pouvez continuer les étapes de la méthode d'installation que vous suiviez.
