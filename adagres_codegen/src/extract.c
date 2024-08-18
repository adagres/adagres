#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#include <postgres.h>
#include <fmgr.h>

// Deal with Postgres overriding printf family
#undef fprintf

void extract_types_and_constants()
{
        FILE *f;

#define member_layout(type, name) offsetof(type, name), sizeof(((type *)0)->name) * 8 - 1
        f = fopen("generated/adagres-ffi_layouts.ads", "w");
        fprintf(f,
                "package Adagres.FFI_Layouts with Preelaborate is\n"
                "flinfo_Offset : constant Integer := %d; flinfo_Bits : constant Integer := %d; \n"
                "context_Offset : constant Integer := %d; context_Bits : constant Integer := %d; \n"
                "resultinfo_Offset : constant Integer := %d; resultinfo_Bits : constant Integer := %d; \n"
                "fncollation_Offset : constant Integer := %d; fncollation_Bits : constant Integer := %d; \n"
                "Is_Null_Offset : constant Integer := %d; Is_Null_Bits : constant Integer := %d; \n"
                "Num_Args_Offset : constant Integer := %d; Num_Args_Bits : constant Integer := %d; \n"
                "Args_Offset : constant Integer := %d; \n",
                member_layout(FunctionCallInfoBaseData, flinfo),
                member_layout(FunctionCallInfoBaseData, context),
                member_layout(FunctionCallInfoBaseData, resultinfo),
                member_layout(FunctionCallInfoBaseData, fncollation),
                member_layout(FunctionCallInfoBaseData, isnull),
                member_layout(FunctionCallInfoBaseData, nargs),
                offsetof(FunctionCallInfoBaseData, args));

        fprintf(f,
                "Sig_Jmp_Buf_Size : constant Integer := %1$d;\n",
                sizeof(sigjmp_buf) * 8);

        fprintf(f, "end Adagres.FFI_Layouts;\n");
        fclose(f);
        system("gnatpp generated/adagres-ffi_layouts.ads");
        fprintf(stdout, "Wrote adagres-ffi_layout.ads");

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
