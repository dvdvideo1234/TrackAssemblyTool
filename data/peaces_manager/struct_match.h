#ifndef __STRUCT_MATCH_H_
  #define __STRUCT_MATCH_H_
  #include "struct_entry.h"
  // The maximum name for add-on name
  #define MSTACK_ADLEN       500
  // How deep the match item stack goes
  #define MSTACK_DEPTH       50
  // Invalid pointer to return on fail
  #define MSTACK_INV_POINTER NULL
  // Type used for indexing
  #define MSTACK_TYPE_INDEX  unsigned int

  namespace stmatch
  {
    static FILE *fLog = stdout;

    void setLog(FILE *log){ if(log != NULL){fLog = log;}}

    typedef struct st_match
    {
      char *Name;
      char *Sors;
      stentry::cEntryStack Addon;
      stentry::cEntryStack Dbase;
    } stMatch;

    typedef class match_stack
    {
      private:
        MSTACK_TYPE_INDEX Count;
        stMatch *Stack[MSTACK_DEPTH];
      public:
        MSTACK_TYPE_INDEX getCount(void){return Count;};
        stMatch *registerMatch(const char *strAddon, const char *strSource);
        stMatch *navigateMatch(const char *strAddon);
        stMatch *navigateMatchID(MSTACK_TYPE_INDEX iID);
        stMatch *addModelAddon(const char *strAddon, const char *strModel);
        stMatch *addModelDbase(const char *strAddon, const char *strModel);
        void     printAddons(void);
        void     printDbases(void);
        match_stack(void){Count = 0;};
       ~match_stack(void);
    } cMatchStack;

    match_stack::~match_stack(void)
    {
      stMatch *enRem;
      MSTACK_TYPE_INDEX Cnt = 0;
      while(Cnt < Count)
      {
        enRem = Stack[Cnt];
        if(SSTACK_INV_POINTER != enRem)
          { free(enRem->Name); free(enRem->Sors); }
        Cnt++;
      }
    }

    stMatch *match_stack::navigateMatchID(MSTACK_TYPE_INDEX iID)
    {
      if(iID >= 0 || iID < Count){ return Stack[iID]; }
      common::logSystem(fLog,"navigateMatchID: Invalid ID <%u>",iID);
      return MSTACK_INV_POINTER;
    }

    stMatch *match_stack::navigateMatch(const char *strAddon)
    {
      if(strAddon == NULL){ return MSTACK_INV_POINTER; }
      MSTACK_TYPE_INDEX Cnt = 0;
      while(Cnt < Count)
      { // common::logSystem(fLog,"navigateMatch: <%s>=<%s> <%d>",Stack[Cnt]->Name,strAddon,Cnt);
        if(!strcmp(Stack[Cnt]->Name,strAddon))
        { common::logSystem(fLog,"navigateMatch: Addon <%s> exists under ID #%d!",strAddon,Cnt);
          return Stack[Cnt];
        }
        Cnt++;
      }
      return MSTACK_INV_POINTER;
    }

    stMatch *match_stack::registerMatch(const char *strAddon, const char * strSource)
    {
      common::logSystem(fLog,"registerMatch: <%s>", strAddon);
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem != MSTACK_INV_POINTER){ return MSTACK_INV_POINTER; }
      if(MSTACK_INV_POINTER == (pItem = (stMatch*)malloc(sizeof(stMatch))))
      {
        common::logSystem(fLog,"registerMatch: Allocate match failed <%s>!",strAddon);
        return MSTACK_INV_POINTER;
      }
      pItem->Addon.initStack();
      pItem->Dbase.initStack();
      if(MSTACK_INV_POINTER == (pItem->Name = (char*)malloc(MSTACK_ADLEN * sizeof(char))))
      {
        common::logSystem(fLog,"registerMatch: Allocate add-on failed <%s>!",strAddon);
        return MSTACK_INV_POINTER;
      }
      strcpy(pItem->Name,strAddon);
      common::logSystem(fLog,"registerMatch: Addon [%d] <%s>",Count,pItem->Name);
      if(strSource != NULL and strcmp(strSource,""))
      {
        if(MSTACK_INV_POINTER == (pItem->Sors = (char*)malloc(MSTACK_ADLEN * sizeof(char))))
        {
          common::logSystem(fLog,"registerMatch: Allocate source failed <%s>!",strAddon);
          return MSTACK_INV_POINTER;
        }
        strcpy(pItem->Sors,strSource);
        common::logSystem(fLog,"registerMatch: Source [%d] <%s>",Count,pItem->Sors);
      }
      Stack[Count++] = pItem;
      return pItem;
    }

    stMatch *match_stack::addModelAddon(const char *strAddon, const char *strModel)
    {
      common::logSystem(fLog,"addModelAddon(<%s>, <%s>)",strAddon,strModel);
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem == MSTACK_INV_POINTER)
      {
        common::logSystem(fLog,"addModelAddon: Failed to locate addon <%s> !",strAddon);
        return MSTACK_INV_POINTER;
      }
      pItem->Addon.putEntry(strModel);
      common::logSystem(fLog,"addModelAddon: Count {%u}",pItem->Addon.getCount());
      return pItem;
    }

    stMatch *match_stack::addModelDbase(const char *strAddon, const char *strModel)
    {
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem == MSTACK_INV_POINTER)
      {
        common::logSystem(fLog,"addModelDbase: Failed to locate an add-on <%s> !",strAddon);
        return MSTACK_INV_POINTER;
      }
      pItem->Dbase.putEntry(strModel);
      return pItem;
    }

    void match_stack::printAddons(void)
    {
      MSTACK_TYPE_INDEX Cnt = 0, CntItems = 0, Item = 0;
      common::logSystem(fLog,"printAddons: Folders report");
      while(Cnt < Count)
      {
        common::logSystem(fLog,"printAddons: Name: <%s>",Stack[Cnt]->Name);
        CntItems = Stack[Cnt]->Addon.getCount(); Item = 0;
        while(Item < CntItems)
        {
          if(Stack[Cnt]->Addon.getEntry(Item) != MSTACK_INV_POINTER)
          {
            common::logSystem(fLog,"printAddons: Found [%d]<%s>",Item,Stack[Cnt]->Addon.getEntry(Item)->Data);
          }
          Item++;
        }
        Cnt++;
      }
    }

    void match_stack::printDbases(void)
    {
      MSTACK_TYPE_INDEX Cnt = 0, CntItems = 0, Item;
      common::logSystem(fLog,"printDbases: Folders report");
      while(Cnt < Count)
      {
        common::logSystem(fLog,"printDbases: Name: <%s>",Stack[Cnt]->Name);
        CntItems = Stack[Cnt]->Dbase.getCount(); Item = 0;
        while(Item < CntItems)
        {
          if(Stack[Cnt]->Dbase.getEntry(Item) != MSTACK_INV_POINTER)
          {
            common::logSystem(fLog,"printDbases: Found [%d]<%s>",Item,Stack[Cnt]->Dbase.getEntry(Item)->Data);
          }
          Item++;
        }
        Cnt++;
      }
    }
  }

#endif
