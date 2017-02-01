Lancement:
- Se connecter au server Oracle
- Lancer le script parties-2-3.sql dans sqlplus
- Compiler le programme c parties-4-5.c avec la commande 'make'
- Lancer le programme c parties-4-5

Connexion avec un bon login/pwd:
- Taper n'importe quoi comme reponse a la question de securité
- Taper un des logins valides (admin/admin, oystein/hovind ou gabriel/petry)
- Choisir un fournisseur

Connexion avec un mauvais login/pwd:
- Taper n'importe quoi comme reponse a la question de securité
- Taper un login invalide
- Taper 'n' pour sortir

Connexion par injection 1:
- Taper 'n' comme reponse a la question de securité
- Taper <' or 'y'='y> comme login et mot de passe
- Choisir un fournisseur

Affichage par injection 2:
- Taper 'n' comme reponse a la question de securité
- Taper <' or 'y'='y> comme login et mot de passe
- Taper <' union select * from logins where 'y'='y> comme choix de fournisseur

Protection contre les injections:
- Taper 'y' comme reponse a la question de securité
- Essayer de faires les injections décrites au dessus
