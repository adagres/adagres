with Adagres.FFI_Types;
with Adagres.FFI_Types;
with Adagres.Memory_Context; use Adagres.Memory_Context;
with Interfaces;
with Interfaces.C.Strings;   use Interfaces.C.Strings;

package body Adagres.Error with
  Preelaborate
is

   procedure Raise_Postgres_Error
     (Context : Adagres.FFI_Types.Memory_Context := Adagres.Memory_Context.Current_Memory_Context)
   is
      function Copy_Of_Error_Data return Adagres.FFI_Types.Error_Data_Access with
        Import, Convention => C, External_Name => "CopyErrorData";
      procedure Flush_Error_State with
        Import, Convention => C, External_Name => "FlushErrorState";
   begin
      Current_Memory_Context := Context;
      Last_Postgres_Error    := Copy_Of_Error_Data;
      Flush_Error_State;
      raise Postgres_Error with Value (Last_Postgres_Error.Message);
   end Raise_Postgres_Error;

end Adagres.Error;
