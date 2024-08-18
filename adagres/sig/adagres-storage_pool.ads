with System.Storage_Pools.Subpools;
with System; use System;
with System.Storage_Elements;
with Adagres.FFI_Types;
with Adagres.Memory_Context;
with Adagres.Checked_FFI;

package Adagres.Storage_Pool with
  Preelaborate
is
   use System.Storage_Pools;
   use System.Storage_Elements;

   type Storage_Pool is new Subpools.Root_Storage_Pool_With_Subpools with private;
   type Storage_Subpool is new Subpools.Root_Subpool with private;
   type Storage_Subpool_Access is access all Storage_Subpool;

   subtype Subpool_Handle is Subpools.Subpool_Handle;

   function Default_Subpool_for_Pool (Pool : in out Storage_Pool) return not null Subpool_Handle;

   function Create_Subpool (Pool : in out Storage_Pool) return not null Subpools.Subpool_Handle;

   procedure Allocate_From_Subpool
     (Pool                     : in out Storage_Pool; Storage_Address : out Address;
      Size_In_Storage_Elements : in     Storage_Elements.Storage_Count;
      Alignment : in     Storage_Elements.Storage_Count; Subpool : in not null Subpool_Handle);

   procedure Deallocate_Subpool (Pool : in out Storage_Pool; Subpool : in out Subpool_Handle);

private

   type Storage_Pool is new Subpools.Root_Storage_Pool_With_Subpools with record
      null;
   end record;

   type Storage_Subpool is new Subpools.Root_Subpool with record
      Storage_Memory_Context : String (1 .. 10); --FFI_Types.Memory_Context;
   end record;

   Default_Storage_Subpool : aliased Storage_Subpool :=
     (Subpools.Root_Subpool with
      Storage_Memory_Context => "BxB1B2B3yB"); --Memory_Context.Current_Memory_Context)
end Adagres.Storage_Pool;
