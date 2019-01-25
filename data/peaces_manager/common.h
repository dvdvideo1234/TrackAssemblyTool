#ifndef __COMMON_H_
  #define __COMMON_H_
  // Available symbols "!@#$%^&()_+[]{}"
  // General comment symbol
  #define LINE_COMMENT "#"
  // This string is used to explode the string given
  #define EXPLODE_DELIMITER "$"
  // The maximum number of pointer pieces for the exploded string
  #define MAX_NODES_ADDON 30
  // The maximum length of the delimiter enabled
  #define MAX_DELIMIT_LEN 10
  // Maximum path length when reading from the model processing list
  #define MAX_PATH_LENGTH 500
  // For example <"models/props/something.mdl">
  // <models> OR what the model in the line starts with
  #define MATCH_MODEL_DIR "models"
  // <.mdl> OR what the model in the line ends with
  #define MATCH_MODEL_END ".mdl"
  // <asmlib.GetCategory("PHX Metal")>
  // A new track type starts from this line ( e.g. "PHX Metal" )
  #define MATCH_START_NEW_TYPE "asmlib.GetCategory(\""
  // The log buffer result string length
  #define MAX_BUFFER_LOG 2000

  namespace common
  {
    static char logBuffer[MAX_BUFFER_LOG];
    static char *arrNodes[MAX_NODES_ADDON];
    static FILE *fLog = stdout;

    void setLog(FILE *log){ if(log != NULL){fLog = log;}else{fLog = stdout;}}

    void logSystem(FILE *log, const char *form, ...)
    {
      va_list args;
      va_start(args, form);
      vsnprintf(logBuffer, MAX_BUFFER_LOG, form, args);
      va_end(args);
      if(log==NULL){ printf(logBuffer); printf("\n"); }
      else{ fprintf(log, logBuffer); fprintf(log,"\n"); }
    }

    char **strExplode(char *strIn)
    {
      const char *expDelim = EXPLODE_DELIMITER;
      arrNodes[0] = NULL;
      if(expDelim != NULL && strIn != NULL && strncmp(expDelim,"",MAX_DELIMIT_LEN))
      {
        char *strE, *strB = strIn; unsigned int id, di;
        if((strE = strstr(strB,expDelim)) != NULL)
        { id = 0; /// This is where the compiler enters most of the time
          while(strE != NULL)
          { di = 0; /// Find all the delimiters present in the string
            arrNodes[id] = strB; /// Save the pointer in the node array
            logSystem(fLog,"strExplode: CUT[%d] = <%s> @ %p",id,strB,strB);
            while(expDelim[di]){ strE[di++] = '\0'; } strB = &(strE[di]);
            strE = strstr(strB,expDelim); id++; /// Replace the delimiter and go to the next
          } /// Make sure that the rest of the string is also saved in a node
          logSystem(fLog,"strExplode: RST[%d] = <%s> @ %p",id,strB,strB);
          arrNodes[id++] = strB;
          arrNodes[id] = NULL; /// Terminate the node array
        }else{
          logSystem(fLog,"strExplode: No delimiter found");
          arrNodes[0] = strB;
          arrNodes[1] = NULL;
        }
      }else{
        logSystem(fLog,"strExplode: Skip <%s><%s>",((strIn==NULL) ? "(null)" : strIn),((expDelim==NULL) ? "(null)" : expDelim));
        arrNodes[0] = strIn;
        arrNodes[1] = NULL;
      }
      return arrNodes;
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

    char *getConsistency(char *strPath, char *strModel, char *strName)
    {
      char *cS, *cE, *cM;
      cM = strstr(strPath,MATCH_MODEL_DIR);
      if(cM != NULL)
      {
        memset(strName ,0,MAX_PATH_LENGTH);
        memset(strModel,0,MAX_PATH_LENGTH);
        cS = cM; cS -= 2; cE = cS;
        while(*cS != '/'){ cS--; } cS++;
        strncpy(strName ,cS,(int)(cE-cS)+1);
        strncpy(strModel,cM, strlen(cM) +1); lowerPath(strModel);
        logSystem(fLog,"getConsistency: {%s}<%s>",strName,strModel);
      }else{
        logSystem(fLog,"getConsistency: Path not a valid model!");
        return NULL;
      }
      return strName;
    }

    char *trimAll(char *strData)
    {
      unsigned int L = strlen(strData);
      if(L == 0){ return strData; } // Nothing to trim
      unsigned int S = 0, E = L;
      while((!(strData[S] > ' ') || !(strData[E] > ' ')) && (S >= 0) && (S <= L) && (E >= 0) && (E <= L))
      {
        if(strData[S] <= ' '){ S++; }
        if(strData[E] <= ' '){ E--; }
      }
      if(S == 0 && E == L)
      {
        logSystem(fLog,"trimAll: Already trimmed");
        return strData;
      }
      if((S >= 0) && (S <= L) && (E >= 0) && (E <= L) && (S <= E)){
        L = E - S + 1; /// Memmove must be used because the pointers are overlapping
        memmove(strData,&strData[S],L); strData[L] = '\0';
        // logSystem(fLog,"trimAll: After trim <%s>",strData);
      }else{ strData[0] = '\0'; }
      return strData;
    }

  }

#endif
