with Ada.Text_IO;         use Ada.Text_IO;
with Adagres.Error;
with Adagres.Memory_Context;
with Adagres.Checked_FFI; use Adagres.Checked_FFI;
with Ada.Exceptions;
with System;
with System.Address_Image;

package body Sum is

   function Sum (FCI : Function_Call_Info) return Any_Datum is
      S : System.Address;
   begin
      --  Doing this just for a test of FFI
      declare
         use Ada.Exceptions;
         Fail : constant Boolean := True; -- set to True to make this fail
      begin
         S :=
           Memory_Context_Alloc
             (Adagres.Memory_Context.Current_Memory_Context,
              (if Fail then 1_000_000_000_000 else 1_000));
      exception
         when E : Adagres.Error.Postgres_Error =>
            Put_Line ("can't allocate: " & Exception_Message (E));
         --  Uncomment to re-raise
         --  Reraise_Occurrence (E);
      end;
      Put_Line ("addr: " & System.Address_Image (S));
      --  Print the number of arguments
      Put_Line ("args: " & FCI.Num_Args'Image);
      --  Sum 1st and 3rd arguments.
      return
        To_Any_Datum
          (To_Datum_Int32 (To_Datum (FCI.Args (1))) + To_Datum_Int32 (To_Datum (FCI.Args (3))));
   end Sum;

end Sum;
