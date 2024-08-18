with Adagres.FFI_Types;
with Interfaces.C;
with Adagres.FFI;
--  with Ada.Text_IO;
package body Adagres.Storage_Pool is

   procedure Allocate_From_Subpool
     (Pool                     : in out Storage_Pool; Storage_Address : out Address;
      Size_In_Storage_Elements : in     Storage_Elements.Storage_Count;
      Alignment : in     Storage_Elements.Storage_Count; Subpool : in not null Subpool_Handle)
   is
   begin
      null;
      --  Ada.Text_IO.Put_Line(Storage_Subpool_Access(Subpool)'Image);
      --  Storage_Address :=
      --    Checked_FFI.Memory_Context_Alloc
      --   (Storage_Subpool_Access (Subpool).Storage_Memory_Context,
      --    Interfaces.C.size_t (Size_In_Storage_Elements));
   end Allocate_From_Subpool;

   procedure Deallocate_Subpool (Pool : in out Storage_Pool; Subpool : in out Subpool_Handle) is
   begin
      null;
   end Deallocate_Subpool;

   function Create_Subpool (Pool : in out Storage_Pool) return not null Subpool_Handle is

      New_Pool : Storage_Subpool_Access := new Storage_Subpool;
   begin
      return Subpool_Handle (New_Pool);
   end Create_Subpool;

   overriding function Default_Subpool_for_Pool
     (Pool : in out Storage_Pool) return not null Subpool_Handle
   is
      V : Storage_Subpool_Access := Default_Storage_Subpool'Access;
   begin
      V := Storage_Subpool_Access (Subpool_Handle (V));
      return Subpool_Handle (V);
   end Default_Subpool_for_Pool;

end Adagres.Storage_Pool;
