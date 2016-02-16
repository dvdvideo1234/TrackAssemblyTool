#include <iostream>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "string_stack.h"
#define BUFF_LEN 100000
#define PATH_LEN 1000

using namespace std;

char *pathToGmod(char *strData)
{
  int i = 0;
  char ch;
  while(strData[i] != '\0')
  {
    ch = strData[i];
    if  (ch == '\\'){ strData[i] = '/'; }
    else if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')){ strData[i] |= ' '; }
    i++;
  }
  return strData;
}

int main(int argc, char **argv)
{
  cstrStack Addon, DataBase;
  int Cnt, Len, F; char *S, *E, *F1, *F2;
  char basePath[PATH_LEN]  = {0};
  char resuPath[PATH_LEN]  = {0};
  char fName[PATH_LEN]     = {0};

  for(Cnt = 0; Cnt < argc; Cnt++)
  {
    printf("\nargv[%d] = <%s>",Cnt, argv[Cnt]);
  }

  if(argc < 3)
  {
    printf("\nToo few parameters.\n");
    printf("Call with /base_path/, /model_list/, /db_file/ /rail_type/! \n");
    return 0;
  }

  printf("\n");

  strcpy(basePath,argv[1]);

  printf("basePath: <%s>\n",basePath);

  strcpy(fName,basePath);
  strcat(fName,argv[2]);

  FILE *I = fopen(fName  ,"rt");
  FILE *D = fopen(argv[3],"rt");

  strcpy(fName,basePath);
  strcpy(fName,"db-addon.txt");
  FILE *DA = fopen(fName,"wt");

  strcpy(fName,basePath);
  strcpy(fName,"addon-db.txt");
  FILE *AD = fopen(fName,"wt");

  if(NULL == I)
  {
    printf("Cannot open input file");
    return 0;
  }

  if(NULL == D)
  {
    printf("Cannot open database file");
    return 0;
  }

  if(NULL == DA)
  {
    printf("Cannot open db-addon");
    return 0;
  }

  if(NULL == AD)
  {
    printf("Cannot open addon-db");
    return 0;
  }

  fprintf(AD,"%s\n\n","These models were removed by the extension creator/owner.");
  fprintf(DA,"%s\n\n","These models are missing in the database. Insert them.");

  Cnt = strlen(basePath);
  while(fgets(resuPath,PATH_LEN,I))
  {
    strcpy(resuPath,&(resuPath[Cnt]));
    pathToGmod(resuPath);
    resuPath[strlen(resuPath)-1] = '\0';
    Addon.putString(resuPath);
  }

  while(fgets(resuPath,PATH_LEN,D))
  {
    Cnt = strlen(resuPath);
    resuPath[Cnt-1] = '\0';
    F1 = strstr(resuPath,"asmlib.DefaultType(\"");
    F2 = strstr(resuPath,argv[4]);
    if(!F && F1 != NULL && F2 != NULL){ F = 1; }
    if( F && F1 != NULL && F2 == NULL){ F = 0; }
    if(F)
    {
      S = strstr(resuPath,"\"models/");
      if(S != NULL)
      {
        S++;
        E = strstr(S,".mdl\"");
        if(E != NULL)
        {
          Len = (E - S + 4);
          strncpy(resuPath,S,Len);
          resuPath[Len] = '\0';
          pathToGmod(resuPath);
          if(DataBase.findStringID(0,resuPath) == SSTACK_NOT_FOUND)
          {
            DataBase.putString(resuPath);
          }
        }
      }
    }
  }

  DataBase.updateStack(&Addon,DA);
  Addon.updateStack(&DataBase,AD);

  fclose(I);
  fclose(D);
  fclose(DA);
  fclose(AD);
  return 0;
}
