/*============================================================================

  Name: TestDB.c
  		main

  Abs:  main function of the prototype

  Auth: 04-01-2011, Nicolas ANCIAUX (NA):
  Rev:  05-01-2011, Nicolas ANCIAUX (NA):

  Mod: 01-02-2017, Gabriel PETRY, Øystein HOVIND

=============================================================================*/

#include <ocilib.h>			// OCILIB (to call Oracle OCI)
#include <stdio.h>			
#include <stdlib.h>
#include <string.h>			// inclue pour strchr()

void nettoyer(char *chaine, char c) // élimine le caractère c dans la string donnée
{
	char *src;
	for (src = chaine; *src != '\0'; src++) {
		if (*src != c) {
            		*chaine++ = *src;
		}
	}
	*chaine = '\0';
}

char lirechar()
{
	char c = getchar();
	getchar(); /* Prendre newline de STDIN */
	return c;
}

int lire(char *chaine, int longueur, int secure)
{
	char *positionEntree = NULL;
	// On lit le querye saisi au clavier
	if (fgets(chaine, longueur, stdin) != NULL)  // Si la saisie se fait sans erreur
	{
		positionEntree = strchr(chaine, '\n'); // On recherche l'"Entrée"
		if (positionEntree != NULL) // Si on a trouvé le retour à la ligne
			*positionEntree = '\0'; // On remplace ce caractère par \0
	
		if (secure)
			nettoyer(chaine, '\'');
	
		return 1; // On renvoie 1 si la fonction s'est déroulée sans erreur
	}
	else
		return 0; // On renvoie 0 s'il y a eu une erreur
}

int connect_dbms(OCI_Connection **cn) {

	char* login = "system";		// login SGBD
	char* mdp = "oracle"; 		// mot de passe SGBD
	char* sgbd = "XE";		// nom SGBD pour la connection ODBC (voir doc du SGBD)

	// Vérification de l'initialisation de la librairie OCILIB:
	if ( !OCI_Initialize(NULL, NULL, OCI_ENV_DEFAULT) )
		return EXIT_FAILURE;

	// Creation d'une connection vers le SGBD source:
	//    /!\ indiquez un login/mdp correct
	*cn = OCI_ConnectionCreate(sgbd, login, mdp, OCI_SESSION_DEFAULT);
	
	// Si la connection a été établie corectement, afficher ses propriétés:
	if(cn != NULL){
		printf(OCI_GetVersionServer(*cn));
		printf("Server major    version : %i\n", OCI_GetServerMajorVersion(*cn));
		printf("Server minor    version : %i\n", OCI_GetServerMinorVersion(*cn));
		printf("Server revision version : %i\n", OCI_GetServerRevisionVersion(*cn));
		printf("Connection      version : %i\n", OCI_GetVersionConnection(*cn));
	}
  
	return EXIT_SUCCESS;
}

/* Exécute la requête et retourne le nombre des lignes de son résultat
   Si ce nombre est > 0 le login donnée est bien présent dans la BD */
int verifyQuery(char* query, OCI_Connection* cn) {
	OCI_Statement* st;
	OCI_Resultset* rs;

	// Création d'une requête à partir de la connexion:
   	st = OCI_StatementCreate(cn);

	// Execution de la requête:
	OCI_ExecuteStmt(st, query);
 
	// Stockage du résultat de la requete dans un resultset:
	rs = OCI_GetResultset(st);

	// Récupèration du résultat:
        return OCI_FetchNext(rs);
}

/* Exécute la requête et imprime son résultat */
int executeQuery(char* query, OCI_Connection* cn) { 

	OCI_Statement* st;
	OCI_Resultset* rs;
	int nb_col;
	int i=0;
	OCI_Column *col;

	// Création d'une requête à partir de la connexion:
	st = OCI_StatementCreate(cn);

	// Execution de la requête:
	OCI_ExecuteStmt(st, query);
 
	// Stockage du résultat de la requete dans un resultset:
	rs = OCI_GetResultset(st);

	// Récupèration du nombre de colonnes du résultat:
	nb_col = OCI_GetColumnCount (rs);

	// affichage des noms de colonnes:
	for(i=0; i<nb_col; i++)
	{
		col = OCI_GetColumn (rs, i+1);
		printf("%s | ", OCI_ColumnGetName (col));
	}	printf("\n");


	// Parcours et affichage des lignes du résultat:
	while (OCI_FetchNext(rs))
	{
		// récupération de chaque valeur de colonne sous forme de chaine
		// et affichage des valeurs: 
		for(i=0; i<nb_col; i++)
			printf("%s | ", OCI_GetString(rs,i+1));
	    printf("\n");
	}

	// libération des ressources de la librairie OCILIB:
	//OCI_Cleanup();

	return EXIT_SUCCESS;
}

int main( int argc, char *argv[] )
{
	char* supplier_query[2] = { "SELECT distinct nom_med, type_med FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = '",
				    "'" };	// requête à executer
	char* login_query[3] = { "select * from logins where login = '",
				 "' and password = '",
				 "'" };
	OCI_Connection* cn;
	int exit_code;		
	char login[50];
	char pwd[50];
	char* query;
	char supplier[100];
	size_t size;
	int val; // indique si la validation a été completée
	char secure; // indique si l'utilisateur veut activer la securité

	printf("Activer la securite [y/n] ? ");
	secure = lirechar() == 'y';

	// se connecter à la base de donnée:
	exit_code = connect_dbms(&cn);

	do {
		// Lecture du login/pwd
		printf("Login ? ");
		lire(login, 50, secure);
		printf("Login = %s \n\n", login);
		printf("Pwd ? ");
		lire(pwd, 50, secure);
		printf("pwd = %s \n\n", pwd);
		
		// concatene les informations tapées avec le modèle de requête
		size = strlen(login_query[0]) + strlen(login_query[1]) + strlen(login_query[2]) + strlen(login) + strlen(pwd) + 1;

		query = malloc(size);
		bzero(query, size);

		strncat(query, login_query[0], size);
		strncat(query, login, size);
		strncat(query, login_query[1], size);
		strncat(query, pwd, size);
		strncat(query, login_query[2], size);
				
		val = verifyQuery(query, cn);
		free(query);

		if(!val){ //si toujours pas validee, demande si l'utilisateur veut reesayer
			printf("Login non valide\n");
			printf("Continuer [y/n] ? ");

			if(lirechar() == 'n')
				return exit_code;
		}
		
	} while (!val);

	printf("Login valide\n");
	//demande du fourniv
	printf("Fournisseur ? ");
	lire(supplier, 100, secure);
	printf("Fournisseur = %s \n\n", supplier);

	// concatene les informations tapées avec le modèle de requête
	size = strlen(supplier_query[0]) + strlen(supplier_query[1]) + strlen(supplier) + 1;
	query = malloc(size);
	bzero(query, size);	

	strncat(query, supplier_query[0], size);
	strncat(query, supplier, size);
	strncat(query, supplier_query[1], size);
	


	// execute la requête et affiche le résultat:
	exit_code = executeQuery(query, cn);
	free(query);

	return exit_code;
}

