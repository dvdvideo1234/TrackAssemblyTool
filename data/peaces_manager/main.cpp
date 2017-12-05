#include "main.h"

using namespace stentry;
using namespace stmatch;
using namespace common;

FILE *I = NULL, *D = NULL, *DA = NULL, *AD = NULL, *R = NULL, *L = NULL;

int onExit(int errID, const char * const errFormat)
{
  switch(errID)
  {
    case SSTACK_SUCCESS    : { common::logSystem(L,errFormat,"OK"); break; }
    case SSTACK_INVALID_ID : { common::logSystem(L,errFormat,"Indexing mismatch !"); break; }
    case SSTACK_MALLOC_FAIL: { common::logSystem(L,errFormat,"Memory allocation fail !"); break; }
    case SSTACK_NOT_FOUND  : { common::logSystem(L,errFormat,"Not found in the stack !"); break; }
    case SSTACK_INVALID_OP : { common::logSystem(L,errFormat,"Invalid operation call !"); break; }
    default                : { common::logSystem(L,errFormat,"What the hell did you break ?"); break; }
  }
  if(I  != NULL){ fclose(I);  }
  if(D  != NULL){ fclose(D);  }
  if(DA != NULL){ fclose(DA); }
  if(AD != NULL){ fclose(AD); }
  if(L  != NULL){ fclose(L);  }
  if(R  != NULL){ fclose(R);  }
  return errID;
}

int main(int argc, char **argv)
// int main(void)
{
  /* Only for test !
    int argc = 5;
    char argv[6][500];
    strcpy(argv[0], "chewpath.exe");
    strcpy(argv[1], "E:\\Documents\\CodeBlocks-Projs\\chewpath\\bin\\Debug\\");
    strcpy(argv[2], "E:\\Documents\\Lua-Projs\\SVN\\TrackAssemblyTool_GIT_master\\lua\\autorun\\trackassembly_init.lua");
    strcpy(argv[3], "E:\\Documents\\Lua-Projs\\SVN\\TrackAssemblyTool_GIT_master\\data\\peaces_manager\\models_ignored.txt");
    strcpy(argv[4], "system_log");
  */
  stentry::cEntryStack  Ignored;
  stentry::cEntryStack *cuAdd, *cuDbs;
  stmatch::cMatchStack  Matches;
  stmatch::stMatch     *Match, *cuMch;
  stentry::stEntry     *enAd;
  unsigned char F;
  char *S, *E, *F1, *F2, *F3, *adNode;
  char resPath [MAX_PATH_LENGTH]  = {0};
  char dbsPath [MAX_PATH_LENGTH]  = {0};
  char addName [MAX_PATH_LENGTH]  = {0};
  char addModel[MAX_PATH_LENGTH]  = {0};
  char fName   [MAX_PATH_LENGTH]  = {0};
  char cpBoom  [MAX_PATH_LENGTH]  = {0};
  char **arList = NULL;
  SSTACK_TYPE_INDEX tiCnt  = 0, uLen = 0, ID, iDb, iAd;
  SSTACK_TYPE_ERROR teErr = 0; /// No error

  if(argc < 3)
  {
    common::logSystem(L,"Too few parameters <%d> !",argc);
    common::logSystem(L,"Call with /base_path/, /db_file/, /ignore_list/, /addon_delimiter/ !");
    return onExit(SSTACK_SUCCESS,"Finished status: %s");
  }

  if(argc > 4 && strcmp(argv[4],""))
  {
    strcpy(fName,argv[1]);
    strcat(fName,argv[4]);
    strcat(fName,".txt");
    L = fopen(fName,"wt");
    if(L != NULL)
    {
      stmatch::setLog(L);
      stentry::setLog(L);
      common::setLog(L);
      common::logSystem(L,"Log file given <%s>",fName);
    }
    else
    {
      common::logSystem(L,"Log invalid <%s>",fName);
    }
  }

  logSystem(L,"argc: <%d>",argc);
  for(tiCnt = 0; tiCnt < (SSTACK_TYPE_INDEX)argc; tiCnt++)
  {
    common::trimAll(argv[tiCnt]);
    common::logSystem(L,"argv[%u]=<%s>",tiCnt, argv[tiCnt]);
  }

  if(argc > 3)
  { /// Ignored models list
    strcpy(fName,argv[3]);
    if((R = fopen(fName ,"rt")) != NULL)
    {
      common::logSystem(L,"Ignored models given <%s>",fName);

      while(fgets(resPath,MAX_PATH_LENGTH,R))
      {
        common::lowerPath(common::trimAll(resPath));
        if((Ignored.findEntryID(0,resPath,&ID) == SSTACK_NOT_FOUND) &&
           strncmp(resPath,LINE_COMMENT,strlen(LINE_COMMENT)) && !strncmp(resPath,MATCH_MODEL_DIR,6))
        {
          teErr = Ignored.putEntry(resPath);
          if(teErr != SSTACK_SUCCESS){ return onExit(teErr,"main(Ignore): putString: <%s>"); }
          common::logSystem(L,"Ignore: <%s>",resPath);
        }
      }
      strcpy(resPath, "");
    }
  }

  strcpy(fName,argv[1]);
  strcat(fName,LIST_PROCESS);
  strcat(fName,".txt");
  I = fopen(fName,"rt");
  if(NULL == I)
  { /// The model list that we must process
    common::logSystem(L,"Cannot open input file <%s>",fName);
    return onExit(SSTACK_SUCCESS,"Finished status: %s");
  }

  D = fopen(argv[2],"rt");
  if(NULL == D)
  { /// The database which the model list must be compared with
    common::logSystem(L,"Cannot open database file <%s>",argv[2]);
    return onExit(SSTACK_SUCCESS,"Finished status: %s");
  }

  strcpy(fName,argv[1]);
  strcat(fName,"db-addon.txt");
  DA = fopen(fName,"wt");
  if(NULL == DA)
  { /// These models are missing in the database
    common::logSystem(L,"DB-Addon <%s>",fName);
    common::logSystem(L,"Cannot open db-addon, using console");
    DA = stdout;
  }

  strcpy(fName,argv[1]);
  strcat(fName,"addon-db.txt");
  AD = fopen(fName,"wt");
  if(NULL == AD)
  { /// These models were removed by the extension creator/owner
    common::logSystem(L,"Addon-DB <%s>",fName);
    common::logSystem(L,"Cannot open addon-db, using console");
    AD = stdout;
  }

  // Addons model paths
  while(fgets(resPath,MAX_PATH_LENGTH,I))
  { /// Process every line in the models list
    common::swapSlash(common::trimAll(resPath));
    if(strncmp(resPath,LINE_COMMENT,strlen(LINE_COMMENT)))
    { /// Process the line when it is not commented
      if(NULL == common::getConsistency(resPath,addModel,addName))
        { common::logSystem(L,"main(getConsistency): Path invalid <%s>", resPath); return onExit(SSTACK_SUCCESS,"Finished status: %s"); }
      strcpy(cpBoom, addName); arList = common::strExplode(cpBoom); tiCnt = 0;
      if(arList == NULL) /// Explode the string with replacing the delimiter with a null symbol
        { common::logSystem(L,"main(strExplode): Explosion invalid <%s><%s>",addName); return onExit(SSTACK_SUCCESS,"Finished status: %s"); }
      while(arList[tiCnt] != NULL)
      { /// For every explosion if exploded or not, the name is registered
        adNode = arList[tiCnt];
        Match = Matches.registerMatch(adNode,addName);
        common::logSystem(L,"Check match: {%s}<%s>",adNode,addModel);
        if(Match != NULL)
        { /// A match has been registered on the database rows
          common::logSystem(L,"Match created: <%s>",Match->Name);
          rewind(D); // Reset the stream to search for data
          while(fgets(dbsPath,MAX_PATH_LENGTH,D))
          { /// For every line in the DB
            common::swapSlash(common::trimAll(dbsPath));
            uLen = strlen(dbsPath);
            F1 = strstr(dbsPath,MATCH_START_NEW_TYPE);
            F2 = strstr(dbsPath,Match->Name);
            F3 = strstr(dbsPath,MATCH_CLOSE_LUA); /// Closing the IF statement in LUA
            if(!F &&  F1 != NULL &&  F2 != NULL){ F = 1; }
            if( F && (F1 != NULL || (F3 != NULL && uLen == 3)) &&  F2 == NULL ){ F = 0; }
            if(F)
            { common::logSystem(L,"DB Read: <%s>",dbsPath);
              S = strstr(dbsPath,MATCH_MODEL_DIR);
              if(S != NULL)
              {
                E = strstr(S,MATCH_MODEL_END);
                if(E != NULL)
                {
                  E[4] = '\0'; // ".mdl\0"
                  common::logSystem(L,"DB Model <%s>",S);
                  if((Match->Dbase).findEntryID(0,S,&ID) == SSTACK_NOT_FOUND)
                  {
                    teErr = (Match->Dbase).putEntry(S);
                    if(teErr != SSTACK_SUCCESS){ return onExit(teErr,"main(DB): putString: <%s>"); }
                    common::logSystem(L,"Dba Count: %d",(Match->Dbase).getCount());
                    common::logSystem(L,"Add Count: %d",(Match->Addon).getCount());
                  }
                }
              }
            }
          } /// Database is ready
        }
        if(Ignored.findEntryID(0,addModel,&ID) == SSTACK_NOT_FOUND)
        {
          Matches.addModelAddon(adNode,addModel);
        } common::logSystem(L,"Addon {%s}<%s> @ {%p}<%p>",adNode,addModel,adNode,addModel);
        tiCnt++;
      } /// The exploded list is processed for the current model
    }
  }

  common::logSystem(L,"\nPrinting processed:");
  Matches.printAddons();
  common::logSystem(L,"\nPrinting database:");
  Matches.printDbases();

  common::logSystem(L,"\nRemove all repeating paths:");
  uLen = Matches.getCount(); tiCnt = 0;
  while(tiCnt < uLen)
  {
    Match = Matches.navigateMatchID(tiCnt);
    memcpy(cpBoom, Match->Sors,sizeof(cpBoom));
    arList = strExplode(cpBoom); ID = 0;
    while(arList[ID] != NULL)
    {
      adNode = arList[ID++];
      if(strncmp(Match->Name,adNode,MSTACK_ADLEN))
      {
        cuAdd = &(Match->Addon); /// The repeated model path checked
        cuMch = Matches.navigateMatch(adNode);
        if(cuMch == MSTACK_INV_POINTER)
          { return onExit(SSTACK_NOT_FOUND,"main(Repeat): Navigation failed: %s"); }
        cuDbs = &(cuMch->Dbase); /// Database to use for checking
        for(iAd = 0; iAd < cuAdd->getCount(); iAd++)
        {
          for(iDb = 0; iDb < cuDbs->getCount(); iDb++)
          {
            if(!cuAdd->cmpEntryID(iAd, cuDbs->getEntry(iDb)))
            {
              enAd = cuAdd->getEntry(iAd);
              common::logSystem(L,"Same: <%s> repeats <%s>",adNode,Match->Name);
              common::logSystem(L,"Remove [AD][%u]: <%s>",iAd,(enAd == NULL) ? "NULL" : enAd->Data);
              cuAdd->remEntry(iAd);
            }
          }
        }
      }
    }
    tiCnt++;
  }


  /// Printout the differences
  uLen = Matches.getCount();
  common::logSystem(L,"\nMatches count #%d",uLen);
  tiCnt = 0; common::logSystem(L,"Addon-DB mismatch");
  fprintf(AD,"These models were removed by the extension creator/owner.\n");
  while(tiCnt < uLen)
  {
    Match = Matches.navigateMatchID(tiCnt);
    if(Match != NULL)
    {
      teErr = (Match->Addon).printMismatch(&(Match->Dbase),tiCnt,Match->Name,AD);
      if(teErr != SSTACK_SUCCESS){ return onExit(teErr,"main(AD): printMismatch: <%s>"); }
    }
    tiCnt++;
  }

  tiCnt = 0; common::logSystem(L,"DB-Addon mismatch");
  fprintf(DA,"These models are missing in the database. Insert them.\n");
  while(tiCnt < uLen)
  {
    Match = Matches.navigateMatchID(tiCnt);
    if(Match != NULL)
    {
      teErr = (Match->Dbase).printMismatch(&(Match->Addon),tiCnt,Match->Name,DA);
      if(teErr != SSTACK_SUCCESS){ return onExit(teErr,"main(DA): printMismatch: <%s>"); }
    }
    tiCnt++;
  }
  return onExit(SSTACK_SUCCESS,"Finished status: %s");
}
