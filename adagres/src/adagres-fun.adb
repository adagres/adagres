with Ada.Exceptions;    use Ada.Exceptions;
with Adagres.Constants; use Adagres.Constants;

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

      Ok     : int;
      Result : Any_Datum;
      Old_JB : access Sig_Jmp_Buf;
   begin
      Old_JB := Adagres.Fun.PG_exception_stack;
      Ok     := sigsetjmp (Local_Sig_Jmp_Buf'Access, 0);
      if Ok /= 0 then
         Adagres.Fun.PG_exception_stack := Old_JB;
         Re_Throw;
      else
         Result := Fun (FCI);
      end if;
      return Result;
   exception
      when Error : others =>
         Ok := errstart (Adagres.Constants.ERROR, To_C ("test"));
         Ok := errcode (ERRCODE_INTERNAL_ERROR);
         errmsg (To_C (Exception_Message (Error)));
         errfinish (To_C ("aaa"), 10, To_C ("bbb"));
         Unreachable;
   end Native_Function;

end Adagres.Fun;
