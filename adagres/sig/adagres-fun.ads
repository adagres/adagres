with Adagres.Datum;     use Adagres.Datum;
with Adagres.FFI_Types; use Adagres.FFI_Types;

package Adagres.Fun with
  Preelaborate
is

   type Function_Call_Info is access all Function_Call_Info_Base_Data;

   generic
      with function Fun (FCI : Function_Call_Info) return Any_Datum;
   function Native_Function (FCI : Function_Call_Info) return Any_Datum;

end Adagres.Fun;
