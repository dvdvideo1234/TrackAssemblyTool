#include "main.h"

using namespace sstack;
using namespace smatch;

FILE *I, *D, *DA, *AD, *R;

int mainExit(int errID, const char * const errFormat)
{
  if(errID != 0){ printf(errFormat,sstack::getErrorMessage(errID)); }
  fclose(I);
  fclose(D);
  fclose(DA);
  fclose(AD);
  return errID;
}

char *swapSlash(char *strData)
{
  char ch;
  unsigned int i = 0;
  while(strData[i] != '\0')
  {
    ch = strData[i];
    if  (ch == '\\'){ strData[i] = '/'; }
    i++;
  }
  return strData;
}

char *lowerPath(char *strData)
{
  char ch;
  unsigned int i = 0;
  while(strData[i] != '\0')
  {
    ch = strData[i];
    if(ch >= 'A' && ch <= 'Z'){ strData[i] |= ' '; }
    i++;
  }
  return strData;
}

char *getModelAddon(char *strPath, char *strModel, char *strName)
{
  char *cS, *cE, *cM;
  cM = strstr(strPath,MATCH_MODEL_DIR);
  if(cM != NULL)
  {
    memset(strName ,0,PATH_LEN);
    memset(strModel,0,PATH_LEN);
    cS = cM; cS -= 2; cE = cS;
    while(*cS != '/'){ cS--; } cS++;
    strncpy(strName ,cS,(int)(cE-cS)+1);
    strncpy(strModel,cM, strlen(cM) +1); lowerPath(strModel);
  }else{
    printf("getModelAddon: Path not a valid model!\n");
    return NULL;
  }
  return strName;
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
//int main(void)
{
/*
  int argc = 4;
  char argv[4][500];
  strcpy(argv[0], "chewpath.exe");
  strcpy(argv[1], "O:\\Documents\\CodeBlocks-Projs\\chewpath\\bin\\Debug\\");
  strcpy(argv[2], "models_list.txt");
  strcpy(argv[3], "F:\\Games\\Steam\\steamapps\\common\\GarrysMod\\garrysmod\\addons\\TrackAssemblyTool_GIT\\lua\\autorun\\trackassembly_init.lua");
  strcpy(argv[4], "F:\\Games\\Steam\\steamapps\\common\\GarrysMod\\garrysmod\\addons\\TrackAssemblyTool_GIT\\data\\peaces_manager\\models_ignored.txt");
*/
  sstack::cStringStack  Ignored;
  smatch::cMatchStack   Matches;
  smatch::stMatch      *Match;
  unsigned char F;
  int Cnt, Len, Err;
  char *S, *E, *F1, *F2, *F3;
  char resPath [PATH_LEN]  = {0};
  char dbsPath [PATH_LEN]  = {0};
  char addName [PATH_LEN]  = {0};
  char addModel[PATH_LEN]  = {0};
  char fName   [PATH_LEN]  = {0};

  printf("argc: <%d>\n",argc);
  for(Cnt = 0; Cnt < argc; Cnt++)
  {
    trimAll(argv[Cnt]);
    printf("argv[%d]=\"%s\"\n",Cnt, argv[Cnt]);
  }

  if(argc < 4)
  {
    printf("\nToo few parameters.\n");
    printf("Call with /base_path/, /model_list/, /db_file/ ! \n");
    return mainExit(0,"");
  }

  if(argc > 4)
  {
    strcpy(fName,argv[4]);
    if((R = fopen(fName ,"rt")) != NULL)
    {
      printf("Ignored models given <%s>\n",fName);

      while(fgets(resPath,PATH_LEN,R))
      {
        lowerPath(trimAll(resPath));
        if((Ignored.findStringID(0,resPath) == SSTACK_NOT_FOUND) && (resPath[0] != '#') && !strncmp(resPath,MATCH_MODEL_DIR,6))
        {
          Err = Ignored.putString(resPath);
          if(Err < 0){ return mainExit(Err,"main(R): putString: <%s>"); }
          printf("Ignore: <%s>\n",resPath);
        }
      }
      strcpy(resPath, ""); fclose(R);
    }
  }

  strcpy(fName,argv[1]);
  strcat(fName,argv[2]);

  I = fopen(fName  ,"rt");
  D = fopen(argv[3],"rt");

  strcpy(fName,argv[1]);
  strcat(fName,"db-addon.txt");
  DA = fopen(fName,"wt");

  strcpy(fName,argv[1]);
  strcat(fName,"addon-db.txt");
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

  // Add-ons model paths
  while(fgets(resPath,PATH_LEN,I))
  {
    swapSlash(trimAll(resPath));
    if(NULL == getModelAddon(resPath,addModel,addName))
      { return printf("main(getModelAddon): Path invalid <%s>\n", resPath); }
    Match = Matches.registerMatch(addName);
    // printf("Addon name registered: <%s>\n",addName);
    if(Match != NULL)
    { // A match has been registered on the database rows
      rewind(D); // Reset the stream to search for data
      while(fgets(dbsPath,PATH_LEN,D))
      {
        swapSlash(trimAll(dbsPath));
        Cnt = strlen(dbsPath);
        F1 = strstr(dbsPath,MATCH_START_NEW_TYPE);
        F2 = strstr(dbsPath,Match->Name);
        F3 = strstr(dbsPath,"end"); // Closing the IF statement in LUA
        if(!F &&  F1 != NULL &&  F2 != NULL){ F = 1; }
        if( F && (F1 != NULL || (F3 != NULL && Cnt == 3)) &&  F2 == NULL ){ F = 0; }
        if(F)
        { // printf("\n DB Read: <%s>",dbsPath);
          S = strstr(dbsPath,MATCH_MODEL_DIR);
          if(S != NULL)
          {
            E = strstr(S,MATCH_MODEL_END);
            if(E != NULL)
            {
              E[4] = '\0'; // ".mdl\0"
              // printf(DA,"DB Model <%s>\n",dbsPath);
              if((Match->Dbase).findStringID(0,S) == SSTACK_NOT_FOUND)
              {
                // printf("\nDba Count: %d",(Match->Dbase).getCount());
                // printf("\nAdd Count: %d",(Match->Addon).getCount());
                Err = (Match->Dbase).putString(S);
                if(Err < 0){ return mainExit(Err,"main(D): putString: <%s>"); }
              }
            }
          }
        }
      }
    }

    // printf("Addon path {%s}<%s>\n",addName,addModel);

    if(Ignored.findStringID(0,addModel) == SSTACK_NOT_FOUND)
    {
      Matches.addModelAddon(addName,addModel);
    }
  }

  // Matches.printAddons();
  // Matches.printDbases();

  Len = Matches.getCount();

  // printf("Matches count #%d\n",Len);

  Cnt = 0;
  fprintf(AD,"These models were removed by the extension creator/owner.\n");
  while(Cnt < Len)
  {
    Match = Matches.navigateMatchID(Cnt);
    if(Match != NULL)
    {
      Err = (Match->Addon).printMismatch(&(Match->Dbase),Cnt,Match->Name,AD);
      if(Err < 0){ return mainExit(Err,"main(AD): printMismatch: <%s>"); }
    }
    Cnt++;
  }

  Cnt = 0;
  fprintf(DA,"These models are missing in the database. Insert them.\n");
  while(Cnt < Len)
  {
    Match = Matches.navigateMatchID(Cnt);
    if(Match != NULL)
    {
      Err = (Match->Dbase).printMismatch(&(Match->Addon),Cnt,Match->Name,DA);
      if(Err < 0){ return mainExit(Err,"main(DA): printMismatch: <%s>"); }
    }
    Cnt++;
  }

  return mainExit(0,"");
}
