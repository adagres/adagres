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

   PG_exception_stack : access Sig_Jmp_Buf with
     Import, Convention => C, External_Name => "PG_exception_stack";

   function sigsetjmp (B : access Sig_Jmp_Buf; Mask : int) return Interfaces.C.int with
     Import, Convention => C;

   procedure Re_Throw with
     Import, Convention => C, External_Name => "pg_re_throw", No_Return;

end Adagres.Fun;
