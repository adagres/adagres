with Adagres.FFI_Types; use Adagres.FFI_Types;
with Interfaces.C;      use Interfaces.C;

package Adagres.SetJmp with
  Preelaborate
is

   function sigsetjmp (B : access Sig_Jmp_Buf; Mask : int) return Interfaces.C.int with
     Import, Convention => C;

end Adagres.SetJmp;
