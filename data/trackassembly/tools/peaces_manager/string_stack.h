#ifndef __STRING_STACK_H_
  #define __STRING_STACK_H_

  #define SSTACK_STRLN 500
  #define SSTACK_DEPTH 50000
  #define SSTACK_SUCCESS      0
  #define SSTACK_INVALID_ID  -1
  #define SSTACK_MALLOC_FAIL -2
  #define SSTACK_NOT_FOUND   -3
  #define SSTACK_INVALID_OP  -4
  #define SSTACK_INV_POINTER NULL

  namespace sstack
  {
    typedef struct st_string
    {
       int  Len;
       int  Cnt;
      char *Data;
    } stString;

    typedef class string_stack
    {
      private:
            int  Count;
       stString *Stack[SSTACK_DEPTH];
      public:
            int  getCount(void){ return Count; }
            int  putString(const char *strData);
       stString *getString(int iID);
            int  findStringID(int iID, const char * strData);
            int  printMismatch(struct string_stack *Other, int AdID, const char *AdName, FILE *File);
           void  print(int iID);
           void  initStack(void){ Count = 0; };
                 string_stack(void){ Count = 0; };
                ~string_stack(void);

    } cStringStack;

    string_stack::~string_stack(void)
    {
      int Item = 0;
      while(Item < Count)
      {
        free(Stack[Item]->Data);
        free(Stack[Item]);
        Item++;
      }
    }

    int string_stack::putString(const char *strData)
    {
      if(!(Count >= 0 || Count < SSTACK_DEPTH))
      {
        printf("putString: Stack overflow with %d\n",Count);
        return SSTACK_INVALID_ID;
      }
      stString *pItem = (stString*)malloc(sizeof(stString));
      if(SSTACK_INV_POINTER == pItem)
      {
        printf("putString: Failed to allocate memory for a string structure\n");
        return SSTACK_MALLOC_FAIL;
      }
      pItem->Len  = strlen(strData);
      pItem->Data = (char*)malloc(SSTACK_STRLN * sizeof(char));
      if(SSTACK_INV_POINTER == pItem->Data)
      {
        printf("putString: Failed to allocate memory for a string\n");
        return SSTACK_MALLOC_FAIL;
      }
      strcpy(pItem->Data,strData);
      Stack[Count++] = pItem;
      return (Count-1);
    }

    stString *string_stack::getString(int iID)
    {
      if(iID >= 0 || iID < Count){ return Stack[iID]; }
      printf("getString: No such ID #%d\n",iID ); return SSTACK_INV_POINTER;
    }

    void string_stack::print(int iID)
    {
      if(!(iID >= 0 || iID < Count))
        { printf("print: No such ID #%d\n",iID ); return; }
      printf("[%u]=(%u)<%s>\n",iID, strlen(Stack[iID]->Data), Stack[iID]->Data);
      return;
    }

    int string_stack::findStringID(int iID, const char * const strData)
    {
      if(SSTACK_INV_POINTER == strData)
        { printf("findStringID: No data\n"); return SSTACK_INVALID_ID; }
      if(!(iID >= 0 || iID < Count))
        { printf("findStringID: No such ID #%d\n",iID ); return SSTACK_INVALID_ID; }
      while(iID < Count)
      {
        if(SSTACK_INV_POINTER != strstr(Stack[iID]->Data,strData))
          { return iID; }
        iID++;
      }
      return SSTACK_NOT_FOUND;
    }

    int string_stack::printMismatch(struct string_stack *Other, int AdID, const char *AdName, FILE *File)
    {
      if(SSTACK_INV_POINTER == Other)
        { printf("printMismatch: Other stack missing\n"); return SSTACK_INVALID_OP; }
      if(SSTACK_INV_POINTER == File){ File = stdout; }
      int oCount = Other->getCount();
      int oItem  = 0, iStatus = 0;
      stString *strOther;
      fprintf(File,"\nGenerating report for #%d <%s>:\n\n",AdID,AdName);
      while(oItem < oCount)
      {
        strOther = Other->getString(oItem);
        if(NULL != strOther)
        {
          // fprintf(File,"Try: #%d <%s> --> <%s>\n",AdID,AdName,strOther->Data);
          iStatus = findStringID(0,strOther->Data);
          if(SSTACK_NOT_FOUND == iStatus)
          {
            fprintf(File,"%s\n",strOther->Data);
          }
        }
        oItem++;
      }
      return SSTACK_SUCCESS;
    }

    const char * const getErrorMessage(int iErr)
    {
      switch(iErr)
      {
        case SSTACK_INVALID_ID : { return "Invalid stack ID"; }
        case SSTACK_MALLOC_FAIL: { return "Memory allocation fail"; }
        case SSTACK_NOT_FOUND  : { return "Item not found"; }
        case SSTACK_INVALID_OP : { return "Invalid internal operation"; }
      }
      return "Success";
    }
  }

#endif
