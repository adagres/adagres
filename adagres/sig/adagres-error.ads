with Adagres.Memory_Context;
with Adagres.FFI_Types; use Adagres.FFI_Types;
with Adagres.SetJmp;    use Adagres.SetJmp;

package Adagres.Error with
  Preelaborate
is

   PG_exception_stack : access Sig_Jmp_Buf with
     Import, Convention => C, External_Name => "PG_exception_stack";

   Error_Context_Stack : access Error_Context_Callback with
     Import, Convention => C, External_Name => "error_context_stack";

   Last_Postgres_Error : Error_Data_Access;

   Postgres_Error : exception;

   procedure Raise_Postgres_Error
     (Context : Adagres.FFI_Types.Memory_Context :=
        Adagres.Memory_Context.Current_Memory_Context) with
     Inline_Always, No_Return;

end Adagres.Error;
