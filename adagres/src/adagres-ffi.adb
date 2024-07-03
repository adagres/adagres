with Interfaces.C;    use Interfaces.C;
with Adagres.SetJmp;  use Adagres.SetJmp;
with Adagres.Codegen; use Adagres.Codegen;

package body Adagres.FFI is

   function Get_Current_Command_Id_Wrap (Used : Interfaces.C.Extensions.bool) return Command_Id is
      Ok     : int;
      Result : Command_Id;
      Old_JB : access Sig_Jmp_Buf;
   begin
      Old_JB := PG_exception_stack;
      Ok     := sigsetjmp (Local_Sig_Jmp_Buf'Access, 0);
      if Ok /= 0 then
         PG_exception_stack := Old_JB;
         Re_Throw;
      else
         Result := Get_Current_Command_Id (Used);
      end if;
      return Result;
   end Get_Current_Command_Id_Wrap;
end Adagres.FFI;
