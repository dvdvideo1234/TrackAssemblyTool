#include <iostream>
#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "string_stack.h"
#include "struct_match.h"

#define PATH_LEN SSTACK_STRLN

// For example <"models/props/something.mdl">
// <models> OR what the model in the line starts with
#define MATCH_MODEL_DIR "models"

// <.mdl"> OR what the model in the line ends with
#define MATCH_MODEL_END ".mdl"

// <asmlib.DefaultType("PHX Metal")>
// A new track type starts from this line ( e.g. "PHX Metal" )
#define MATCH_START_NEW_TYPE "asmlib.DefaultType(\""
