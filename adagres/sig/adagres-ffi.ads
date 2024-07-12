with Interfaces;
with Interfaces.C.Extensions;
with System;

with Adagres.FFI_Types; use Adagres.FFI_Types;

package Adagres.FFI with
  Preelaborate
is

   function Get_Current_Command_Id (Used : Interfaces.C.Extensions.bool) return Command_Id with
     Import, Convention => C, External_Name => "GetCurrentCommandId";

   function Memory_Context_Alloc
     (Context : Memory_Context; Size : Interfaces.C.size_t) return System.Address with
     Import, Convention => C, External_Name => "MemoryContextAlloc";

end Adagres.FFI;
