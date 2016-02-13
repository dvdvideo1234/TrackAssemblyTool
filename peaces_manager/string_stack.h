#define SSTACK_DEPTH 10000
#define SSTACK_SUCCESS      0
#define SSTACK_INVALID_ID  -1
#define SSTACK_MALLOC_FAIL -2
#define SSTACK_NOT_FOUND   -3
#define SSTACK_INVALID_OP  -4
#define SSTACK_INV_POINTER NULL

typedef struct st_string
{
  int   Len;
  char *Data;
} stString;

typedef class string_stack
{
    private:
      int Count;
      int Log;
stString *Stack[SSTACK_DEPTH];
    public:
        int getCount(void){ return Count; }
        int putString(const char *strData);
  stString *getString(int iID);
        int findStringID(int iID, const char * strData);
        int updateStack(struct string_stack *Other, FILE *File);
      void      print(int iID);
             string_stack(void);
            ~string_stack(void);

} cstrStack;

string_stack::string_stack(void)
{
  Count = 0;
}

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
  if(Count >= SSTACK_DEPTH)
  {
    printf("putString: Stack overflow\n");
    return SSTACK_INVALID_ID;
  }
  stString *String = (struct st_string*)malloc(sizeof(struct st_string));
  if(SSTACK_INV_POINTER == String)
  {
    printf("putString: Failed to allocate memory for a string structure\n");
    return SSTACK_MALLOC_FAIL;
  }
  String->Len  = strlen(strData);
  String->Data = (char*)malloc((String->Len + 1) * sizeof(char));
  if(SSTACK_INV_POINTER == String->Data)
  {
    printf("putString: Failed to allocate memory for a string\n");
    return SSTACK_MALLOC_FAIL;
  }
  strcpy(String->Data,strData);
  Stack[Count++] = String;
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
  printf("[%u]<%s>\n",Stack[iID]->Len, Stack[iID]->Data);
  return;
}

int string_stack::findStringID(int iID, const char *strData)
{
  if(SSTACK_INV_POINTER == strData)
    { printf("findString: No data\n"); return -1; }
  if(!(iID >= 0 || iID < Count))
    { printf("findString: No such ID #%d\n",iID ); return SSTACK_INVALID_ID; }
  while(iID < Count)
  {
    if(SSTACK_INV_POINTER != strstr(Stack[iID]->Data,strData))
      { return iID; }
    iID++;
  }
  return SSTACK_NOT_FOUND;
}

int string_stack::updateStack(struct string_stack *Other, FILE *File)
{
  if(SSTACK_INV_POINTER == Other){ printf("findString: No other stack\n"); return SSTACK_INVALID_OP; }
  if(SSTACK_INV_POINTER == File){ printf("findString: No file\n"); return SSTACK_INVALID_OP; }
  int oCount = Other->getCount();
  int oItem  = 0, iStatus = 0;
  stString *strOther;
  while(oItem < oCount)
  {
    strOther = Other->getString(oItem);
    if(NULL != strOther)
    {
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







