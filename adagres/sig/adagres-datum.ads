with Interfaces.C;            use Interfaces.C;
with Interfaces.C.Extensions; use Interfaces.C.Extensions;
with System.Storage_Elements;

package Adagres.Datum with
  Preelaborate
is
   type Any_Datum is private;
   type Datum_Int16 is private;
   type Datum_Int32 is private;
   type Datum_Int64 is private;

   type Nullable_Datum is private;

   function To_Datum (I : Interfaces.Integer_16) return Datum_Int16 with
     Inline_Always;
   function To_Datum (I : Interfaces.Integer_32) return Datum_Int32 with
     Inline_Always;
   function To_Datum (I : Interfaces.Integer_64) return Datum_Int64 with
     Inline_Always;

   function To_Any_Datum (D : Datum_Int16) return Any_Datum with
     Inline_Always;
   function To_Any_Datum (D : Datum_Int32) return Any_Datum with
     Inline_Always;
   function To_Any_Datum (D : Datum_Int64) return Any_Datum with
     Inline_Always;

   function To_Datum_Int16 (D : Any_Datum) return Datum_Int16 with
     Inline_Always;
   function To_Datum_Int32 (D : Any_Datum) return Datum_Int32 with
     Inline_Always;

   function "+" (A, B : Datum_Int32) return Datum_Int32 with
     Inline_Always;

   function From_Datum (D : Datum_Int16) return Interfaces.Integer_16 with
     Inline_Always;
   function From_Datum (D : Datum_Int32) return Interfaces.Integer_32 with
     Inline_Always;
   function From_Datum (D : Datum_Int64) return Interfaces.Integer_64 with
     Inline_Always;

   function To_Datum (ND : Nullable_Datum) return Any_Datum with
     Inline_Always;

private

   type Any_Datum is new System.Storage_Elements.Integer_Address;

   type Datum_Int16 is new Any_Datum;
   type Datum_Int32 is new Any_Datum;
   type Datum_Int64 is new Any_Datum;

   type Nullable_Datum is record
      Value   : Any_Datum;
      Is_Null : bool;
   end record with
     Convention => C_Pass_By_Copy;

end Adagres.Datum;
