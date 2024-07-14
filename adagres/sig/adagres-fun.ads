with Adagres.Datum;   use Adagres.Datum;
with Interfaces.C;    use Interfaces.C;
with Adagres.Codegen; use Adagres.Codegen;

package Adagres.Fun with
  Preelaborate
is

   type Function_Call_Info is access all Function_Call_Info_Base_Data;

   generic
      with function Fun (FCI : Function_Call_Info) return Any_Datum;
   function Native_Function (FCI : Function_Call_Info) return Any_Datum;

private

   Local_Sig_Jmp_Buf : aliased Sig_Jmp_Buf;

end Adagres.Fun;
