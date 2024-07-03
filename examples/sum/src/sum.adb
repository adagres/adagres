with Ada.Text_IO;      use Ada.Text_IO;
with Adagres.Memory_Context;
with Adagres.Safe_FFI; use Adagres.Safe_FFI;
with System;
with System.Address_Image;

package body Sum is

   function Sum (FCI : Function_Call_Info) return Any_Datum is
      S : System.Address;
   begin
      --  Doing this just for a test of FFI
      S := Memory_Context_Alloc (Adagres.Memory_Context.Current_Memory_Context, 1_000);
      Put_Line ("addr: " & System.Address_Image (S));
      --  Print the number of arguments
      Put_Line ("args: " & FCI.Num_Args'Image);
      --  Sum 1st and 3rd arguments.
      return
        To_Any_Datum
          (To_Datum_Int32 (To_Datum (FCI.Args (1))) + To_Datum_Int32 (To_Datum (FCI.Args (3))));
   end Sum;

end Sum;
