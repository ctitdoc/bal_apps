## Composant ballerina sync_fo_quotations

Ce composant a été créé pour le ticket EA-437: il transmet les nouveaux devis créés via le site au BO:
* Récupère tous les devis enregistrés dans la bdd du site en statut de transmission "TODO",  à partir du 10 juillet 2025 (date à partir de laquelle l'erreur http 503 de l'ancien code était systématique),
* les soumet par API au BO,
* sur retour OK du BO les passe en statut de transmission "DONE",
* sur retour non OK, envoi une alerte (loguée) dans le channel teams des alertes EliteAuto, et les passe en statut de transmission "ERREUR".


### Déploiement et configuration

* Pré-requis: avoir installé Ballerina,
* cloner ce repo et se mettre sur la branche correspondant à l'environnement,
* copier/coller le template de configuration ci-dessous dans un fichier Config.toml à la racine du module et remplacer les valeur REPLACEME par les bonnes valeur (voir les README des composant intégrés et/ou demander aux "bonnes personnes" ces valeur si besoin),

```
\# reco: comment this line in prod environnement<br>
ballerina.log.level = "DEBUG"

[conf]
# in dev and preprod the url should be equal the one of a running /modules/mock service and the secret : "unused:unused"
boApiUrl = "REPLACEME"
boApiSecret = "REPLACEME"
```

* ajouter dans le fichier ~/.profile du compte bal_apps (= fichier exécuté à chaque ouverture de session du compte linux qui exécute une app ou un module bal_apps):
```
# set PATH of sync_fo_quotations if it is there
if [ -d "$HOME/<path to bal_apps>/modules/sync_fo_quotations/bin" ] ; then
    PATH="$HOME/<path to bal_apps>/modules/sync_fo_quotations/bin:$PATH"
fi
```
* puis exécuter dans une console:
```
source ~/.profile
```
* exécuter les procédures de déploiement des README des composant intègrés (ces composant sont  indiqués dans les section dependency du fichier Ballerina.toml),

* lancer "bal build" à la racine de ce module pour vérifier que le projet compile bien,
* pour lancer le job: bal run



