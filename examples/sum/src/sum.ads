with Adagres;       use Adagres;
with Adagres.Datum; use Adagres.Datum;
with Adagres.Fun;   use Adagres.Fun;

package Sum is

   function Sum (FCI : Function_Call_Info) return Any_Datum with
     Inline_Always;

   function Sum_NF is new Native_Function (Sum) with
     Export, Convention => C, External_Name => "sum";

end Sum;
