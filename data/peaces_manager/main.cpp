#include <iostream>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "string_stack.h"
#define BUFF_LEN 100000
#define PATH_LEN 1000

// For example <"models/props/something.mdl">
// <"models/> OR what the model in the line starts with
#define MATCH_MODEL_STR "\"models/"
// <.mdl"> OR what the model in the line ends with
#define MATCH_MODEL_END ".mdl\""

// <asmlib.DefaultType("PHX Metal")>
// A new track type starts from this line ( e.g. "PHX Metal" )
#define MATCH_START_NEW_TYPE "asmlib.DefaultType(\""


using namespace sstack;

FILE *I, *D, *DA, *AD;

int mainExit(int errID, const char * const errFormat)
{
  if(errID < 0){ printf(errFormat,sstack::sstackErrMsg(errID)); }
  fclose(I);
  fclose(D);
  fclose(DA);
  fclose(AD);
  return 0;
}

char *pathToGmod(char *strData)
{
  char ch;
  unsigned int i = 0;
  while(strData[i] != '\0')
  {
    ch = strData[i];
    if  (ch == '\\'){ strData[i] = '/'; }
    else if(ch >= 'A' && ch <= 'Z'){ strData[i] |= ' '; }
    i++;
  }
  return strData;
}

char *trimAll(char *strData)
{
  unsigned int L = strlen(strData);
  if(L > 0){ L--; }else{ return strData; }
  unsigned int S = 0, E = L;
  while((!(strData[S] > ' ') || !(strData[E] > ' ')) && (S >= 0) && (S <= L) && (E >= 0) && (E <= L))
  {
    if(strData[S] <= ' '){ S++; }
    if(strData[E] <= ' '){ E--; }
  }
  if(S == 0 && E == L){ return strData; } // Nothing to be done
  if((S >= 0) && (S <= L) && (E >= 0) && (E <= L)){
    L = E - S + 1;
    strncpy(strData,&strData[S],L); strData[L] = '\0';
  }else{ strData[0] = '\0'; }
  return strData;
}

int main(int argc, char **argv)
{
  sstack::cstrStack Addon, DataBase;
  unsigned char F;
  int Cnt, Len, Err;
  char *S, *E, *F1, *F2, *F3;
  char resuPath[PATH_LEN]  = {0};
  char fName[PATH_LEN]     = {0};

  printf("\nargc: <%d>",argc);
  for(Cnt = 0; Cnt < argc; Cnt++)
  {
    trimAll(argv[Cnt]);
    printf("\nargv[%d] = <%s>",Cnt, argv[Cnt]);
  }

  if(argc < 5)
  {
    printf("\nToo few parameters.\n");
    printf("Call with /base_path/, /model_list/, /db_file/ /add-on_type/! \n");
    return mainExit(0,"");
  }

  strcpy(fName,argv[1]);
  strcat(fName,argv[2]);

  I = fopen(fName  ,"rt");
  D = fopen(argv[3],"rt");

  strcpy(fName,argv[1]);
  strcpy(fName,"db-addon.txt");
  DA = fopen(fName,"wt");

  strcpy(fName,argv[1]);
  strcpy(fName,"addon-db.txt");
  AD = fopen(fName,"wt");

  if(NULL == I)
  {
    printf("Cannot open input file");
    return mainExit(0,"");
  }

  if(NULL == D)
  {
    printf("Cannot open database file");
    return mainExit(0,"");
  }

  if(NULL == DA)
  {
    printf("Cannot open db-addon, using console");
    DA = stdout;
  }

  if(NULL == AD)
  {
    printf("Cannot open addon-db, using console");
    AD = stdout;
  }

  Cnt = strlen(argv[1]);
  while(fgets(resuPath,PATH_LEN,I))
  {
    trimAll(resuPath);
    strcpy(resuPath,&(resuPath[Cnt]));
    pathToGmod(resuPath);
    Err = Addon.putString(resuPath);
    if(Err < 0){ return mainExit(Err,"main(I): putString: <%s>"); }
  }

  while(fgets(resuPath,PATH_LEN,D))
  {
    trimAll(resuPath);
    Cnt = strlen(resuPath);
    F1 = strstr(resuPath,MATCH_START_NEW_TYPE);
    F2 = strstr(resuPath,argv[4]);
    F3 = strstr(resuPath,"end"); // Closing the IF statement in LUA
    if(!F &&  F1 != NULL &&  F2 != NULL){ F = 1; }
    if( F && (F1 != NULL || (F3 != NULL && Cnt == 3)) &&  F2 == NULL ){ F = 0; }
    if(F)
    {
      S = strstr(resuPath,MATCH_MODEL_STR);
      if(S != NULL)
      {
        S++;
        E = strstr(S,MATCH_MODEL_END);
        if(E != NULL)
        {
          Len = (E - S + 4);
          strncpy(resuPath,S,Len);
          resuPath[Len] = '\0';
          pathToGmod(resuPath);
          if(DataBase.findStringID(0,resuPath) == SSTACK_NOT_FOUND)
          {
            Err = DataBase.putString(resuPath);
            if(Err < 0){ return mainExit(Err,"main(D): putString: <%s>"); }
          }
        }
      }
    }
  }

  fprintf(AD,"%s\n\n","These models were removed by the extension creator/owner.");
  Err = Addon.printMismatch(&DataBase,AD);
  if(Err < 0){ return mainExit(Err,"main(AD): printMismatch: <%s>"); }

  fprintf(DA,"%s\n\n","These models are missing in the database. Insert them.");
  Err = DataBase.printMismatch(&Addon,DA);
  if(Err < 0){ return mainExit(Err,"main(DA): printMismatch: <%s>"); }

  return mainExit(0,"");
}
