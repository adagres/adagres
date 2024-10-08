with Interfaces.C;            use Interfaces.C;
with Interfaces.C.Extensions; use Interfaces.C.Extensions;
with System.Storage_Elements;

package Adagres.Datum with
  Preelaborate
is
   type Any_Datum is new System.Storage_Elements.Integer_Address;

   type Datum_Int16 is new Any_Datum;
   type Datum_Int32 is new Any_Datum;
   type Datum_Int64 is new Any_Datum;

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
   function To_Datum_Int64 (D : Any_Datum) return Datum_Int64 with
     Inline_Always;

   function From_Datum (D : Datum_Int16) return Interfaces.Integer_16 with
     Inline_Always;
   function From_Datum (D : Datum_Int32) return Interfaces.Integer_32 with
     Inline_Always;
   function From_Datum (D : Datum_Int64) return Interfaces.Integer_64 with
     Inline_Always;

   generic
      type Datum_Type is new Any_Datum;
   package A_Nullable_Datum is
      type Nullable_Datum (Is_Null : bool := False) is record
         case Is_Null is
            when False =>
               Value : Any_Datum;
            when True =>
               null;
         end case;
      end record;

      for Nullable_Datum use record
         Value   at 0 range              0 ..         Any_Datum'Size - 1;
         Is_Null at 0 range Any_Datum'Size .. Any_Datum'Size + bool'Size;
      end record;

      subtype Null_Datum is Nullable_Datum (True);

   end A_Nullable_Datum;

   package Any_Nullable_Datum is new A_Nullable_Datum (Any_Datum);
   package Nullable_Datum_Int16 is new A_Nullable_Datum (Datum_Int16);
   package Nullable_Datum_Int32 is new A_Nullable_Datum (Datum_Int32);
   package Nullable_Datum_Int64 is new A_Nullable_Datum (Datum_Int64);

end Adagres.Datum;
