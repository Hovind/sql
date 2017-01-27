/*=============================================================================

  Name: TestDB.c
  		main

  Abs:  main function of the prototype

  Auth: 04-01-2011, Nicolas ANCIAUX (NA):
  Rev:  05-01-2011, Nicolas ANCIAUX (NA):

=============================================================================*/

#include <ocilib.h>			// OCILIB (to call Oracle OCI)
#include <stdio.h>			
#include <stdlib.h>
#include <string.h>			// inclue pour strchr()
 
int lire(char *chaine, int longueur)
{
    char *positionEntree = NULL;
    // On lit le texte saisi au clavier
    if (fgets(chaine, longueur, stdin) != NULL)  // Si la saisie se fait sans erreur
    {
        positionEntree = strchr(chaine, '\n'); // On recherche l'"Entr�e"
        if (positionEntree != NULL) // Si on a trouv� le retour � la ligne
            *positionEntree = '\0'; // On remplace ce caract�re par \0
        return 1; // On renvoie 1 si la fonction s'est d�roul�e sans erreur
    }
    else
        return 0; // On renvoie 0 s'il y a eu une erreur
}

int connect_dbms(OCI_Connection **cn) {

	char* login = "system";		// login SGBD
	char* mdp = "oracle";	// mot de passe SGBD
	char* sgbd = "XE";		// nom SGBD pour la connection ODBC (voir doc du SGBD)

	// V�rification de l'initialisation de la librairie OCILIB:
	if ( !OCI_Initialize(NULL, NULL, OCI_ENV_DEFAULT) )
		return EXIT_FAILURE;

	// Creation d'une connection vers le SGBD source:
	//    /!\ indiquez un login/mdp correct
	*cn = OCI_ConnectionCreate(sgbd, login, mdp, OCI_SESSION_DEFAULT);
	
	// Si la connection a �t� �tablie corectement, afficher ses propri�t�s:
	if(cn != NULL){
		printf(OCI_GetVersionServer(*cn));
		printf("Server major    version : %i\n", OCI_GetServerMajorVersion(*cn));
		printf("Server minor    version : %i\n", OCI_GetServerMinorVersion(*cn));
		printf("Server revision version : %i\n", OCI_GetServerRevisionVersion(*cn));
		printf("Connection      version : %i\n", OCI_GetVersionConnection(*cn));
	}
  
	return EXIT_SUCCESS;
}

int executeQuery(char* query, OCI_Connection* cn) {

    OCI_Statement* st;
    OCI_Resultset* rs;
	int nb_col;
	int i=0;
	OCI_Column *col;

	// Cr�ation d'une requ�te � partir de la connexion:
    st = OCI_StatementCreate(cn);

	// Execution de la requ�te:
	OCI_ExecuteStmt(st, query);
 
	// Stockage du r�sultat de la requete dans un resultset:
    rs = OCI_GetResultset(st);

	// R�cup�ration du nombre de colonnes du r�sultat:
	nb_col = OCI_GetColumnCount (rs);

	// affichage des noms de colonnes:
	for(i=0; i<nb_col; i++)
	{
		col = OCI_GetColumn (rs, i+1);
		printf("%s | ", OCI_ColumnGetName (col));
	}	printf("\n");


	// Parcours et affichage des lignes du r�sultat:
    while (OCI_FetchNext(rs))
    {
		// r�cup�ration de chaque valeur de colonne sous forme de chaine
		// et affichage des valeurs: 
		for(i=0; i<nb_col; i++)
			printf("%s | ", OCI_GetString(rs,i+1));
	    printf("\n");
    }

	// lib�ration des ressources de la librairie OCILIB:
    OCI_Cleanup();

	return EXIT_SUCCESS;
}

int main( int argc, char *argv[] )
{
	char* query = "select * from cli";	// requ�te � executer
	OCI_Connection* cn;
	int exit_code;		
	char login[50];
	char pwd[50];

	// se connecter � la base de donn�e:
	exit_code = connect_dbms(&cn);


	// Lecture du login/pwd
	printf("Login ? ");
	lire(login, 50);
	printf("Login = %s \n\n", login);
	printf("Pwd ? ");
	lire(pwd, 50);
	printf("pwd = %s \n\n", pwd);

	// executer la requ�te et afficher le r�sultat:
	exit_code = executeQuery(query, cn);

    return exit_code;
}

