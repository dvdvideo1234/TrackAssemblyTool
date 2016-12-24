#ifndef __STRUCT_MATCH_H_
  #define __STRUCT_MATCH_H_
  #include "string_stack.h"
  #define MSTACK_ADLEN       500
  #define MSTACK_DEPTH       20000
  #define MSTACK_INV_POINTER NULL

  namespace smatch
  {

    typedef struct st_match
    {
      char    Name[MSTACK_ADLEN];
      sstack::cStringStack Addon;
      sstack::cStringStack Dbase;
    } stMatch;

    typedef class match_stack
    {
      private:
        int     Count;
        stMatch *Stack[MSTACK_DEPTH];
      public:
            int  getCount(void){return Count;};
        stMatch *registerMatch(const char *strAddon);
        stMatch *navigateMatch(const char *strAddon);
        stMatch *navigateMatchID(int iID);
        stMatch *addModelAddon(const char *strAddon, const char *strModel);
        stMatch *addModelDbase(const char *strAddon, const char *strModel);
        void     printAddons(void);
        void     printDbases(void);
        match_stack(void){Count = 0;};
       ~match_stack(void);
    } cMatchStack;

    match_stack::~match_stack(void)
    {
      int Cnt = 0;
      while(Cnt < Count)
      {
        free(Stack[Cnt]->Name);
        free(Stack[Cnt]);
        Cnt++;
      }
    }

    stMatch *match_stack::navigateMatchID(int iID)
    {
      if(iID >= 0 || iID < Count){ return Stack[iID]; }
      return MSTACK_INV_POINTER;
    }

    stMatch *match_stack::navigateMatch(const char *strAddon)
    {
      int Cnt = 0;
      while(Cnt < Count)
      { // printf("<%s>=<%s> <%d>\n",Stack[Cnt]->Name,strAddon,Cnt);
        if(!strcmp(Stack[Cnt]->Name,strAddon))
        { // printf("navigateMatch: Addon <%s> exists under ID #%d!\n",strAddon,Cnt);
          return Stack[Cnt];
        }
        Cnt++;
      }
      return MSTACK_INV_POINTER;
    }

    stMatch *match_stack::registerMatch(const char *strAddon)
    {
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem != MSTACK_INV_POINTER){ return MSTACK_INV_POINTER; }
      pItem = (stMatch*)malloc(sizeof(stMatch));
      if(MSTACK_INV_POINTER == pItem)
      {
        printf("registerMatch: Failed to allocate memory for an add-on <%s>!\n",strAddon);
        return MSTACK_INV_POINTER;
      }
      pItem->Addon.initStack();
      pItem->Dbase.initStack();
      strcpy(pItem->Name,strAddon);
      printf("registerMatch: Registered [%d] <%s>\n",Count,pItem->Name);
      Stack[Count++] = pItem;
      return pItem;
    }

    stMatch *match_stack::addModelAddon(const char *strAddon, const char *strModel)
    {
     // printf("addModelAddon(<%s>, <%s>)\n",strAddon,strModel);
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem == MSTACK_INV_POINTER)
      {
        printf("addModelAddon: Failed to locate addon <%s> !\n",strAddon);
        return MSTACK_INV_POINTER;
      }
     // printf("addModelAddon Before %d\n",pItem->Addon.getCount());
      pItem->Addon.putString(strModel);
     // printf("addModelAddon After  %d\n",pItem->Addon.getCount());
      return pItem;
    }

    stMatch *match_stack::addModelDbase(const char *strAddon, const char *strModel)
    {
      stMatch *pItem = navigateMatch(strAddon);
      if(pItem == MSTACK_INV_POINTER)
      {
        printf("addModelDbase: Failed to locate an add-on <%s> !\n",strAddon);
        return MSTACK_INV_POINTER;
      }
      pItem->Dbase.putString(strModel);
      return pItem;
    }

    void match_stack::printAddons(void)
    {
      int Cnt = 0, CntItems = 0, Item;
      printf("\n\nAddon folders report\n");
      while(Cnt < Count)
      {
        printf("\nAddon name: <%s>\n",Stack[Cnt]->Name);
        CntItems = Stack[Cnt]->Addon.getCount();
        Item = 0;
        while(Item < CntItems)
        {
          if(Stack[Cnt]->Addon.getString(Item) != MSTACK_INV_POINTER)
          {
            printf("[%d]<%s>\n",Item,Stack[Cnt]->Addon.getString(Item)->Data);
          }
          Item++;
        }
        Cnt++;
      }
    }

    void match_stack::printDbases(void)
    {
      int Cnt = 0, CntItems = 0, Item;
      printf("\n\nDatabases report\n");
      while(Cnt < Count)
      {
        printf("\nAddon name: <%s>\n",Stack[Cnt]->Name);
        CntItems = Stack[Cnt]->Dbase.getCount();
        Item = 0;
        while(Item < CntItems)
        {
          if(Stack[Cnt]->Dbase.getString(Item) != MSTACK_INV_POINTER)
          {
            printf("[%d]<%s>\n",Item,Stack[Cnt]->Dbase.getString(Item)->Data);
          }
          Item++;
        }
        Cnt++;
      }
    }
  }

#endif
