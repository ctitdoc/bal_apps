## Composant ballerina update_customer_dispo

Ce composant a été créé pour le ticket EA-432, et permet de mettre à jour le champ customerDispo dans l'index des offres algolia du site http://www.elite-auto.fr, via un job Ballerina exécuté toutes les minutes:

* Ce job test si l'index vient d'être reconstruit, en détectant, via une requete dans les log algolia, si une commande de move de l'index temporaire en index master plus récente que la dernière execution de ce cron, a eu lieu:



  
* si oui, le champ customerDispo est ajouté à toutes les offres de l'index via cette logique:

    * si le champ disponibiliteForFO vaut 'en stock' et que le champ nature ne vaut ni 1 ('Elite'), ni 5 ('Proxauto VO'), alors customerDispo vaut 'disponible', sinon customerDispo vaut la même valeur que disponibiliteForFO;



  






  
* ce traitement utilise les fonctionnalités algolia de traitement des données par lot de 1000; les test de perf donnent moins d'une minute pour traiter 5000 offres (la volumétrie actuelle de l'index étant de 4500 offres);



  
* D'autre part, les jobs ballerina supportent nativement les non concurrences d'exécution de leur tâche, c'est à dire que, contrairement à un cron classique, la tâche de la minute suivante n'est pas lancée tant que la tâche de la minute précédente n'est pas terminée (avec une logique paramétrable si cette dernière ne termine jamais).



  




### Déploiement et configuration

* Pré-requis: avoir installé Ballerina,



  
* cloner ce repo et se mettre sur la branche correspondant à l'environnement,



  
* copier/coller le template de configuration ci-dessous dans un fichier Config.toml à la racine du repo et remplacer les valeur REPLACEME par les bonnes valeur (pour les conf des composant intégrés: voir leur README, si besoin demander aux "bonnes personnes"),



  
* lancer "bal build" dedans pour vérifier que le projet compile bien,



  
* pour lancer le job depuis le repo: bal run



  
* NB:

    * si dryRun vaut true, aucune mis à jour de l'index n'est faite (c'est donc un mode de test de base de la logique d'accès en lecture à l'index),



  
    * si dryRun vaut true ET dryRunNotify vaut aussi true, une notification de test est envoyée dans le channel teams configuré (c'est donc un mode de test de base d'envoi de notif teams).



  






  




<<<<



    [algolia]
    appId = "REPLACEME"
    apiKey = "REPLACEME"
    indexName = "REPLACEME"
    
    [customerDispo]
    dryRun = true
    dryRunNotify = true
    
    [job_patch.conf]
    port = REPLACEME

    [teams]
    webhookUrl = "REPLACEME"
    channelId = "REPLACEME"
    apiKey = "REPLACEME"
    

>>>>
