#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#include <postgres.h>
#include <fmgr.h>

// Deal with Postgres overriding printf family
#undef fprintf

void extract_types_and_constants()
{
#define member_layout(type, name) offsetof(type, name), sizeof(((type *)0)->name) * 8 - 1
    FILE *f = fopen("generated/adagres-codegen.ads", "w");
    fprintf(f,
            "with Interfaces.C; use Interfaces.C;\n"
            "with Interfaces.C.Extensions;  use Interfaces.C.Extensions;\n"
            "with Adagres.Datum; use Adagres.Datum;\n");
    fprintf(f,
            "package Adagres.Codegen with Preelaborate is\n"
            "type Function_Call_Info_Base_Data_Arguments is array (short range <>) of Nullable_Datum with Convention => C;"
            "type Function_Call_Info_Base_Data (Num_Args : short := 0) is record\n"
            "flinfo : access int;\n"
            "context : access int;\n"
            "resultinfo : access int;\n"
            "fncollation : unsigned;\n"
            "Is_Null : bool;\n"
            "Args : Function_Call_Info_Base_Data_Arguments(1..Num_Args);\n"
            "end record;\n"
            "for Function_Call_Info_Base_Data use record \n"
            "  flinfo at %d range 0 .. %d;\n"
            "  context at %d range 0 .. %d;\n"
            "  resultinfo at %d range 0 .. %d;\n"
            "  fncollation at %d range 0 .. %d;\n"
            "  Is_Null at %d range 0 .. %d;\n"
            "  Num_Args at %d range 0 .. %d;\n"
            " --  Args at %d range 0 .. ??;\n"
            "end record;\n",
            member_layout(FunctionCallInfoBaseData, flinfo),
            member_layout(FunctionCallInfoBaseData, context),
            member_layout(FunctionCallInfoBaseData, resultinfo),
            member_layout(FunctionCallInfoBaseData, fncollation),
            member_layout(FunctionCallInfoBaseData, isnull),
            member_layout(FunctionCallInfoBaseData, nargs),
            offsetof(FunctionCallInfoBaseData, args));

    fprintf(f,
            "pragma Warnings (Off, \"%1$d bits of \"\"Sig_Jmp_Buf\"\" unused\");\n"
            "type Sig_Jmp_Buf is limited null record;\n"
            "for Sig_Jmp_Buf'Size use %1$d;\n"
            "pragma Warnings (On, \"%1$d bits of \"\"Sig_Jmp_Buf\"\" unused\");\n",
            sizeof(sigjmp_buf));

    fprintf(f, "end Adagres.Codegen;\n");
    fclose(f);
    system("gnatpp generated/adagres-codegen.ads");
    fprintf(stdout, "Wrote adagres-codegen.ads");

    f = fopen("generated/adagres-constants.ads", "w");

    fprintf(f,
            "with Interfaces.C; use Interfaces.C;\n"
            "package Adagres.Constants with Preelaborate is\n");

    fprintf(f, "DEBUG5: constant int := %d;\n", DEBUG5);
    fprintf(f, "DEBUG4: constant int := %d;\n", DEBUG4);
    fprintf(f, "DEBUG3: constant int := %d;\n", DEBUG3);
    fprintf(f, "DEBUG2: constant int := %d;\n", DEBUG2);
    fprintf(f, "DEBUG1: constant int := %d;\n", DEBUG1);

    fprintf(f, "LOG: constant int := %d;\n", LOG);
    fprintf(f, "LOG_SERVER_ONLY: constant int := %d;\n", LOG_SERVER_ONLY);

    fprintf(f, "INFO: constant int := %d;\n", INFO);

    fprintf(f, "NOTICE: constant int := %d;\n", NOTICE);
    fprintf(f, "WARNING: constant int := %d;\n", WARNING);
    fprintf(f, "WARNING_CLIENT_ONLY: constant int := %d;\n", WARNING_CLIENT_ONLY);
    fprintf(f, "ERROR: constant int := %d;\n", ERROR);
    fprintf(f, "FATAL: constant int := %d;\n", FATAL);
    fprintf(f, "PANIC: constant int := %d;\n", PANIC);

    fprintf(f, "ERRCODE_SUCCESSFUL_COMPLETION: constant int := %d;\n", ERRCODE_SUCCESSFUL_COMPLETION);
    fprintf(f, "ERRCODE_WARNING: constant int := %d;\n", ERRCODE_WARNING);
    fprintf(f, "ERRCODE_DATA_EXCEPTION: constant int := %d;\n", ERRCODE_DATA_EXCEPTION);

    fprintf(f, "ERRCODE_INTERNAL_ERROR: constant int := %d;\n", ERRCODE_INTERNAL_ERROR);

    fprintf(f, "end Adagres.Constants;\n");
    fclose(f);
    system("gnatpp generated/adagres-constants.ads");
    fprintf(stdout, "Wrote adagres-constants.ads");
}
