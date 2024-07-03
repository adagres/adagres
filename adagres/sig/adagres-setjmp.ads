with Adagres.Codegen; use Adagres.Codegen;
with Interfaces.C;    use Interfaces.C;

private package Adagres.SetJmp with
  Preelaborate
is

   Local_Sig_Jmp_Buf : aliased Sig_Jmp_Buf;

   PG_exception_stack : access Sig_Jmp_Buf with
     Import, Convention => C, External_Name => "PG_exception_stack";

   function sigsetjmp (B : access Sig_Jmp_Buf; Mask : int) return Interfaces.C.int with
     Import, Convention => C;

   procedure Re_Throw with
     Import, Convention => C, External_Name => "pg_re_throw", No_Return;

end Adagres.SetJmp;
