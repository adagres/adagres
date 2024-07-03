with Interfaces; use Interfaces;

package body Adagres.Datum is

   function To_Datum (I : Interfaces.Integer_16) return Datum_Int16 is (Datum_Int16 (I));
   function To_Datum (I : Interfaces.Integer_32) return Datum_Int32 is (Datum_Int32 (I));
   function To_Datum (I : Interfaces.Integer_64) return Datum_Int64 is (Datum_Int64 (I));

   function To_Any_Datum (D : Datum_Int16) return Any_Datum is (Any_Datum (D));
   function To_Any_Datum (D : Datum_Int32) return Any_Datum is (Any_Datum (D));
   function To_Any_Datum (D : Datum_Int64) return Any_Datum is (Any_Datum (D));

   function To_Datum_Int16 (D : Any_Datum) return Datum_Int16 is (Datum_Int16 (D));

   function To_Datum_Int32 (D : Any_Datum) return Datum_Int32 is (Datum_Int32 (D));

   overriding function "+" (A, B : Datum_Int32) return Datum_Int32 is
     (Datum_Int32 (Interfaces.Integer_32 (A) + Interfaces.Integer_32 (B)));

   function From_Datum (D : Datum_Int16) return Interfaces.Integer_16 is
     (Interfaces.Integer_16 (D));
   function From_Datum (D : Datum_Int32) return Interfaces.Integer_32 is
     (Interfaces.Integer_32 (D));
   function From_Datum (D : Datum_Int64) return Interfaces.Integer_64 is
     (Interfaces.Integer_64 (D));

   function To_Datum (ND : Nullable_Datum) return Any_Datum is (ND.Value);

end Adagres.Datum;
