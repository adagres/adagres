with Interfaces;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;
with System;

with Adagres.FFI_Types;

package Adagres.FFI with
  Preelaborate
is

   function Get_Current_Command_Id
     (Used : Interfaces.C.Extensions.bool) return Adagres.FFI_Types.Command_Id with
     Import, Convention => C, External_Name => "GetCurrentCommandId";

   function Memory_Context_Alloc
     (Context : Adagres.FFI_Types.Memory_Context; Size : Interfaces.C.size_t)
      return System.Address with
     Import, Convention => C, External_Name => "MemoryContextAlloc";

   function Memory_Context_Strdup
     (Context : Adagres.FFI_Types.Memory_Context; Str : Interfaces.C.char_array)
      return Interfaces.C.Strings.chars_ptr with
     Import, Convention => C, External_Name => "MemoryContextStrdup";

end Adagres.FFI;
