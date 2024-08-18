with Interfaces.C;      use Interfaces.C;
with Ada.Exceptions;    use Ada.Exceptions;
with Adagres.Constants; use Adagres.Constants;
with Adagres.SetJmp;    use Adagres.SetJmp;
with Adagres.FFI_Types; use Adagres.FFI_Types;
with Adagres.Error;     use Adagres.Error;

package body Adagres.Fun is

   function Native_Function (FCI : Function_Call_Info) return Any_Datum is
      function errstart (level : int; domain : char_array) return int with
        Import, Convention => C, External_Name => "errstart";

      procedure errmsg (format : char_array) with
        Import, Convention => C_Variadic_1, External_Name => "errmsg";

      function errcode (code : int) return int with
        Import, Convention => C, External_Name => "errcode";

      procedure errfinish (filename : char_array; lineno : int; funcname : char_array) with
        Import, Convention => C, External_Name => "errfinish";

      procedure Unreachable with
        Import, Convention => C, External_Name => "abort", No_Return;

      procedure Rethrow_Error (Error : Error_Data_Access) with
        Import, Convention => C, External_Name => "ReThrowError", No_Return;

      procedure Re_Throw with
        Import, Convention => C, External_Name => "pg_re_throw", No_Return;

      Old_JB            : access Sig_Jmp_Buf;
      CB                : access Error_Context_Callback;
      Result            : Any_Datum;
      Local_Sig_Jmp_Buf : aliased Sig_Jmp_Buf;
   begin
      if sigsetjmp (Local_Sig_Jmp_Buf'Access, 1) = 1 then
         Adagres.Error.PG_exception_stack  := Old_JB;
         Adagres.Error.Error_Context_Stack := CB;
         Re_Throw;
      else
         Old_JB                            := Adagres.Error.PG_exception_stack;
         CB                                := Adagres.Error.Error_Context_Stack;
         Adagres.Error.PG_exception_stack  := Local_Sig_Jmp_Buf'Unchecked_Access;
         Result                            := Fun (FCI);
         Adagres.Error.PG_exception_stack  := Old_JB;
         Adagres.Error.Error_Context_Stack := CB;
         return Result;
      end if;
   exception
      when Postgres_Error =>
         Adagres.Error.PG_exception_stack  := Old_JB;
         Adagres.Error.Error_Context_Stack := CB;
         Rethrow_Error (Last_Postgres_Error);
      when Error : others =>
         declare
            Unused : int;
         begin
            Adagres.Error.PG_exception_stack  := Old_JB;
            Adagres.Error.Error_Context_Stack := CB;

            Unused := errstart (Adagres.Constants.ERROR, To_C ("test"));
            Unused := errcode (ERRCODE_INTERNAL_ERROR);
            errmsg (To_C (Exception_Message (Error)));
            errfinish (To_C ("aaa"), 10, To_C ("bbb"));
            Unreachable;
         end;
   end Native_Function;

end Adagres.Fun;
