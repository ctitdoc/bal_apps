## Composant java wrapper mysql5

Ce composant java a été créé pour le ticket EA-444, afin de gérer les accès à la vieille DB FO mysql5 car le client mysql standard de Ballerina ne fonctionne pas avec une aussi vieille version mysql.

Sauf de vraies bonnes raison, ce composant n'est intégré que dans le composant mysql5_bindings qui lui expose l'API du client ballerina mysql5 intégrable dans les autres composant.

Voir donc le composant mysql5_bindings pour plus de détail sur le rôle de ce wrapper et ses déploiement et configuration.