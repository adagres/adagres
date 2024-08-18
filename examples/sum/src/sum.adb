with Ada.Text_IO;         use Ada.Text_IO;
with Adagres.Error;
with Adagres.Memory_Context;
with Adagres.Checked_FFI; use Adagres.Checked_FFI;
with Ada.Exceptions;
with System;
with System.Address_Image;
with Adagres.Storage_Pool;

package body Sum is


   function Sum (FCI : Function_Call_Info) return Any_Datum is
    P : Adagres.Storage_Pool.Storage_Pool;
      S : System.Address;
   begin

if False then
      Put_Line("PG_Exception_Stack " & Adagres.Error.PG_Exception_Stack'Image);
      --  Doing this just for a test of FFI
      declare
         use Ada.Exceptions;
         Fail : constant Boolean := True; -- set to True to make this fail
         H : Adagres.Storage_Pool.Subpool_Handle;
      begin
      null;
         --  S :=
         --    Memory_Context_Alloc
            --   (Adagres.Memory_Context.Current_Memory_Context,
            --    (if Fail then 1_000_000_000_000 else 1_000));
           P.Allocate(S, 1_000, 1024);
           H := P.Default_Subpool_for_Pool;
           Put_Line("HEEE");
           Put_Line(H'Image);
         null;
      exception
      when E : Storage_Error =>
            Put_Line ("can't allocate! " & Exception_Message (E));
         Reraise_Occurrence (E);
         when E : Adagres.Error.Postgres_Error =>
            Put_Line ("can't allocate/ " & Exception_Message (E));
         --  Uncomment to re-raise
         Reraise_Occurrence (E);
      end;
      end if;
      Put_Line ("addr: " & System.Address_Image (S));
      --  Print the number of arguments
      Put_Line ("args: " & FCI.Num_Args'Image);
      --  Sum 1st and 3rd arguments.
      return
        To_Any_Datum (To_Datum_Int32 (FCI.Args (1).Value) + To_Datum_Int32 (FCI.Args (3).Value));
   end Sum;

end Sum;
