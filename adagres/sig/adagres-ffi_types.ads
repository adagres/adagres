with Interfaces;

package Adagres.FFI_Types with
  Preelaborate
is

   type Command_Id is new Interfaces.Unsigned_32;

   type Memory_Context_Data is private;
   type Memory_Context is access Memory_Context_Data;

private

   type Memory_Context_Data is null record;

end Adagres.FFI_Types;
