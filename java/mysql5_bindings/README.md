## Composant ballerina mysql5 bindings

Cette librairie a été créé pour le ticket EA-444, afin de gérer les accès à la vieille DB FO mysql5 car le client mysql standard ne fonctionne pas avec une aussi vieille version mysql:

* elle intègre en java la librairie client mysql5 via une class java "wrapper" gérée dans le projet java mysql5_wrapper_java,
* le main contient un exemple d'utilisation de son API [CRUD](https://fr.wikipedia.org/wiki/CRUD).

### Déploiement et configuration

* Pré-requis: avoir installé Ballerina,  
* cloner ce repo et se mettre sur la branche correspondant à l'environnement,
* pour utiliser le script main, remplacer les REPLACEME dans le block Config.toml ci-dessous (NB: pour une bdd dans un docker local, sauf si on sait vraiment ce qu'on fait, mettre 127.0.0.1 et pas localhost);
```
[conf]
host = "REPLACEME"
user = "REPLACEME"
password = "REPLACEME"
database = "REPLACEME"    
```
* pour l'utiliser dans un autre composant, créer une conf avec un nom approprié genre [fo_db_conf] et avec les mêmes champs et les bonnes valeur, et passer cette conf à la fonction connect:
```
import cosmobilis/mysql5_bindings as j_mysql5;
...
configurable j_mysql5:Conf fo_db_conf = ?;
...
j_mysql5:Client 'client = check j_mysql5:connect(fo_db_conf);

# et dans le Config.toml du composant:

[fo_db_conf]
host = "REPLACEME"
user = "REPLACEME"
password = "REPLACEME"
database = "REPLACEME"    
```

Pour générer une nouvelle version de ce client:
* dans le projet mysql5_wrapper_java, modifier la classe wrapper src/main/java/cosmobilis/mysql5/DatabaseWrapper.java,
* la compiler en lançant dans ce projet build.sh,
* recopier l'archive mysql5_wrapper_java.jar générée par ce build à la racine du projet, dans mysql5_bindings/lib,
* recopier également tous les .jar présent dans mysql5_wrapper_java/lib, dans mysql5_bindings/lib,
* dans ce module, lancer la (re-) génération de la class wrapper ballerina:
```
bal bindgen --classpath ./lib/mysql5_wrapper_java.jar cosmobilis.mysql5.DatabaseWrapper
## appliquer ce patch à bindgen qui rajoute "isolated" au fonction qui doivent l'être
bin/patch_bindgen.sh
## NB: si on des erreur genre "cannot execute non-isolated function in isolated function" avec cette nouvelle version: rajouter dans ce script l'ajout de "isolated" aux function qui doivent l'être
```
* configurer si besoin la connexion à la db pour test dans Config.toml,
* modifier si besoin main.bal pour tester les changement de cette nouvelles version, puis exécuter ce main:
```
bal run
```