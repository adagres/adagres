with Adagres.FFI_Types;

package Adagres.Memory_Context with
  Preelaborate
is

   package T renames Adagres.FFI_Types;

   Current_Memory_Context : T.Memory_Context with
     Import, Convention => C, External_Name => "CurrentMemoryContext";

   Error_Context : T.Memory_Context with
     Import, Convention => C, External_Name => "ErrorContext";

end Adagres.Memory_Context;
