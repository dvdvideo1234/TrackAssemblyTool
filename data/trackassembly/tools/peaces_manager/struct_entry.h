#ifndef __STRING_STACK_H_
  #define __STRING_STACK_H_
  // The maximum string length for a item
  #define SSTACK_STRLN 300
  // String creator name length
  #define SSTACK_STRLN 300
  // How deep is the stack
  #define SSTACK_DEPTH 5000
  // Type used for storing booleans
  // 0 -> Ignored by cross-add from the same creator
  #define SSTACK_TYPE_FLAGS unsigned char
  // Type used for indexing
  #define SSTACK_TYPE_INDEX unsigned int
  // General error type and error codes
  #define SSTACK_TYPE_ERROR   unsigned char
  #define SSTACK_INV_POINTER  NULL
  #define SSTACK_SUCCESS      0
  #define SSTACK_INVALID_ID   1
  #define SSTACK_MALLOC_FAIL  2
  #define SSTACK_NOT_FOUND    3
  #define SSTACK_INVALID_OP   4
  #define SSTACK_EMPTY_ID     5

  namespace stentry
  {
    static FILE *fLog = stdout;

    void setLog(FILE *log){ if(log != NULL){fLog = log;}}

    typedef struct st_string
    {
      SSTACK_TYPE_INDEX Len;
      SSTACK_TYPE_INDEX Cnt;
      char *Data; /// The actual string data
    } stEntry;

    typedef class entry_stack
    {
      private:
       SSTACK_TYPE_INDEX Count;
       stEntry *Stack[SSTACK_DEPTH];
      public:
       SSTACK_TYPE_INDEX getCount(void){ return Count; }
       SSTACK_TYPE_ERROR putEntry(const char *strData);
       SSTACK_TYPE_ERROR remEntry(SSTACK_TYPE_INDEX iID);
       stEntry *getEntry(SSTACK_TYPE_INDEX iID);
       SSTACK_TYPE_FLAGS cmpEntryID(SSTACK_TYPE_INDEX iID, stEntry *oEntry);
       SSTACK_TYPE_ERROR findEntryID(SSTACK_TYPE_INDEX iID, const char *strData, SSTACK_TYPE_INDEX *oID);
       SSTACK_TYPE_ERROR printMismatch(struct entry_stack *Other, SSTACK_TYPE_INDEX AdID, const char *AdName, FILE *File);
                    void print(SSTACK_TYPE_INDEX iID);
                    void initStack(void){ Count = 0; };
                         entry_stack(void){ Count = 0; };
                        ~entry_stack(void);

    } cEntryStack;

    entry_stack::~entry_stack(void)
    {
      stEntry *enRem;
      SSTACK_TYPE_INDEX Cnt = 0;
      while(Cnt < Count)
      {
        enRem = Stack[Cnt];
        if(SSTACK_INV_POINTER != enRem)
          { free(enRem->Data); free(Stack[Cnt]); }
        Cnt++;
      }
    }

    SSTACK_TYPE_FLAGS entry_stack::cmpEntryID(SSTACK_TYPE_INDEX iID, stEntry *oEntry)
    { /// Return true on difference
      if(oEntry == SSTACK_INV_POINTER)
        { common::logSystem(fLog,"cmpEntry: Other invalid"); return (1==0); }
      if(!(iID >= 0 || iID < Count))
        { common::logSystem(fLog,"cmpEntry: Invalid ID <%u>",iID ); return(1==0); }
      if(Stack[iID] == SSTACK_INV_POINTER)
        { common::logSystem(fLog,"cmpEntry: No data ID <%u>",iID); return (1==0); }
      return strcmp(Stack[iID]->Data, oEntry->Data);
    }

    SSTACK_TYPE_ERROR entry_stack::putEntry(const char *strData)
    {
      if(!(Count >= 0 || Count < SSTACK_DEPTH))
      {
        common::logSystem(fLog,"putEntry: Stack overflow with %d",Count);
        return SSTACK_INVALID_ID;
      }
      stEntry *pItem = SSTACK_INV_POINTER;
      if(SSTACK_INV_POINTER == (pItem = (stEntry*)malloc(sizeof(stEntry))))
      {
        common::logSystem(fLog,"putEntry: Failed to allocate memory for a string structure");
        return SSTACK_MALLOC_FAIL;
      }
      pItem->Len = strlen(strData);
      if(SSTACK_INV_POINTER == (pItem->Data = (char*)malloc(SSTACK_STRLN * sizeof(char))))
      {
        common::logSystem(fLog,"putEntry: Failed to allocate memory for a string");
        return SSTACK_MALLOC_FAIL;
      }
      strcpy(pItem->Data,strData);
      Stack[Count++] = pItem; return SSTACK_SUCCESS;
    }

    SSTACK_TYPE_ERROR entry_stack::remEntry(SSTACK_TYPE_INDEX iID)
    {
      if(iID >= 0 || iID < Count)
      {
        stEntry *enRem = Stack[iID];
        if(SSTACK_INV_POINTER == enRem)
          { common::logSystem(fLog,"remEntry: Missing <%u>",iID ); return SSTACK_EMPTY_ID; }
        free(enRem->Data); free(Stack[iID]);
        Stack[iID] = SSTACK_INV_POINTER;
        return SSTACK_SUCCESS;
      }
      common::logSystem(fLog,"remEntry: No such ID <%d>",iID ); return SSTACK_INVALID_ID;
    }

    stEntry *entry_stack::getEntry(SSTACK_TYPE_INDEX iID)
    {
      if(iID >= 0 || iID < Count){ return Stack[iID]; }
      common::logSystem(fLog,"getEntry: No such ID <%d>",iID ); return SSTACK_INV_POINTER;
    }

    void entry_stack::print(SSTACK_TYPE_INDEX iID)
    {
      if(!(iID >= 0 || iID < Count))
        { common::logSystem(fLog,"print: No such ID <%d>",iID ); return; }
      if(Stack[iID] == SSTACK_INV_POINTER)
        { common::logSystem(fLog,"print: Data ID <%d>",iID ); return; }
      common::logSystem(fLog,"[%u]=(%u)<%s>",iID, strlen(Stack[iID]->Data), Stack[iID]->Data);
      return;
    }

    SSTACK_TYPE_ERROR entry_stack::findEntryID(SSTACK_TYPE_INDEX sID, const char * const strData, SSTACK_TYPE_INDEX *oID)
    {
      if(SSTACK_INV_POINTER == strData)
        { common::logSystem(fLog,"findStringID: No data"); return SSTACK_INVALID_OP; }
      if(!(sID >= 0 || sID < Count))
        { common::logSystem(fLog,"findStringID: No such ID <%d>",sID ); return SSTACK_INVALID_ID; }
      stEntry *enCur = NULL;
      while(sID < Count)
      {
        enCur = Stack[sID];
        if(SSTACK_INV_POINTER == enCur)
          { common::logSystem(fLog,"findStringID: No data ID <%d>",sID ); return SSTACK_EMPTY_ID; }
        if(SSTACK_INV_POINTER != strstr(enCur->Data,strData))
          { *oID = sID; return SSTACK_SUCCESS; }
        sID++;
      }
      return SSTACK_NOT_FOUND;
    }

    SSTACK_TYPE_ERROR entry_stack::printMismatch(struct entry_stack *Other, SSTACK_TYPE_INDEX AdID, const char *AdName, FILE *fRep)
    {
      if(SSTACK_INV_POINTER == Other)
        { common::logSystem(fLog,"printMismatch: Other stack missing"); return SSTACK_INVALID_OP; }
      if(SSTACK_INV_POINTER == fRep){ fRep = stdout; }
      SSTACK_TYPE_INDEX oCount = Other->getCount();
      SSTACK_TYPE_INDEX oItem  = 0, gItem;
      SSTACK_TYPE_ERROR stErr  = 0;
      stEntry *enOther;
      common::logSystem(fRep,"\nGenerating report for #%d <%s>:\n",AdID,AdName);
      while(oItem < oCount)
      {
        enOther = Other->getEntry(oItem);
        if(SSTACK_INV_POINTER != enOther)
        {
          common::logSystem(fLog,"printMismatch: Found #%d <%s> # <%s>",AdID,AdName,enOther->Data);
          stErr = findEntryID(0,enOther->Data,&gItem);
          if(SSTACK_NOT_FOUND == stErr)
          {
            common::logSystem(fRep,"%s",enOther->Data);
          }
        }
        oItem++;
      }
      return SSTACK_SUCCESS;
    }
  }

#endif
