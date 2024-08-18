with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Bounded;
with Ada.Strings.Maps;

with GNAT.OS_Lib;

with Langkit_Support.Text;
with Libadalang.Analysis;
with Libadalang.Common;

procedure Main is

   package LAL renames Libadalang.Analysis;
   package LALCO renames Libadalang.Common;
   package Text renames Langkit_Support.Text;

   procedure Extract_Types_And_Constants with
     Import, Convention => C, External_Name => "extract_types_and_constants";

   Checked_FFI_Ads, Checked_FFI_Adb : File_Type;

   package Buf_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => 1_024);

   function Process_Node (Node : LAL.Ada_Node'Class) return LALCO.Visit_Status is
      use type LALCO.Ada_Node_Kind_Type;
      use type LAL.Subp_Kind;
      use LAL;
      Spec        : LAL.Base_Subp_Spec;
      Subp        : LAL.Subp_Decl;
      Is_Function : Boolean := False;

      FQ_Subp_Name, Subp_Name : Buf_Str.Bounded_String;
      Pass_Args               : Buf_Str.Bounded_String := Buf_Str.Null_Bounded_String;
      Signature, Ret_Type     : Buf_Str.Bounded_String;
   begin
      if Node.Kind = LALCO.Ada_Subp_Decl then
         Subp := Node.As_Subp_Decl;
         if Subp.P_Is_Imported then
            Spec         := Subp.P_Subp_Spec_Or_Null (True);
            Is_Function := Spec.As_Subp_Spec.F_Subp_Kind.Kind in LALCO.Ada_Subp_Kind_Function_Range;
            FQ_Subp_Name :=
              Buf_Str.To_Bounded_String
                (Text.Encode
                   (Spec.As_Subp_Spec.F_Subp_Name.P_Canonical_Fully_Qualified_Name, "utf8"));
            Subp_Name    :=
              Buf_Str.To_Bounded_String
                (Text.Encode
                   (Text.To_Text (Spec.As_Subp_Spec.F_Subp_Name.F_Name.P_Canonical_Text), "utf8"));
            for Param of Spec.As_Subp_Spec.F_Subp_Params.F_Params loop
               for Id of Param.F_Ids loop
                  Buf_Str.Append
                    (Pass_Args, Text.Encode (Text.To_Text (Id.F_Name.P_Canonical_Text), "utf8"));
                  Buf_Str.Append (Pass_Args, ",");
               end loop;
            end loop;
            Buf_Str.Trim
              (Pass_Args, Left => Ada.Strings.Maps.Null_Set,
               Right           => Ada.Strings.Maps.To_Set (','));
            Signature := Buf_Str.To_Bounded_String (Text.Encode (Spec.Text, "utf8"));
            Put_Line (Checked_FFI_Ads, Buf_Str.To_String (Signature) & " with Inline_Always;");

            Ret_Type :=
              Buf_Str.To_Bounded_String
                (Text.Encode
                   (Text.To_Text (Spec.As_Subp_Spec.F_Subp_Returns.P_Type_Name.P_Canonical_Text),
                    "utf8"));

            Put_Line
              (Checked_FFI_Adb,
               Text.Encode (Node.As_Basic_Decl.P_Subp_Spec_Or_Null (True).Text, "utf8") & " is " &
               "Result     : " & Buf_Str.To_String (Ret_Type) & ";" &
  "Local_Sig_Jmp_Buf : aliased Sig_Jmp_Buf;" &
               "Old_JB : access Sig_Jmp_Buf;" & "CB: access Error_Context_Callback;" &
               "Preceding_Memory_Context : Adagres.FFI_Types.Memory_Context := " &
               "Adagres.Memory_Context.Current_Memory_Context;" & "begin " &
               "if sigsetjmp (Local_Sig_Jmp_Buf'Access, 1) = 1 then " &
               "Adagres.Error.PG_exception_stack := Old_JB;" &
               "Adagres.Error.Error_Context_Stack := CB;" &
               "Raise_Postgres_Error (Preceding_Memory_Context);" & " else " &
               "Old_JB := Adagres.Error.PG_exception_stack;" &
               "CB := Adagres.Error.Error_Context_Stack;" &
               "Adagres.Error.PG_exception_stack := Local_Sig_Jmp_Buf'Unchecked_Access;" &
               (if Is_Function then "Result := " else "") & Buf_Str.To_String (FQ_Subp_Name) & "(" &
               Buf_Str.To_String (Pass_Args) & ");" &
               "Adagres.Error.PG_exception_stack := Old_JB;" &
               "Adagres.Error.Error_Context_Stack := CB;" & "return Result;" & "end if;" & "end " &
               Buf_Str.To_String (Subp_Name) & ";");
         end if;
      end if;
      return LALCO.Into;
   end Process_Node;
   Context : constant LAL.Analysis_Context := LAL.Create_Context;
   Unit    : LAL.Analysis_Unit;
begin
   Extract_Types_And_Constants;

   Create (File => Checked_FFI_Ads, Mode => Out_File, Name => "generated/adagres-checked_ffi.ads");
   Create (File => Checked_FFI_Adb, Mode => Out_File, Name => "generated/adagres-checked_ffi.adb");
   Put_Line (Checked_FFI_Ads, "with System;");
   Put_Line (Checked_FFI_Ads, "with Interfaces.C;");
   Put_Line (Checked_FFI_Ads, "with Interfaces.C.Strings;");
   Put_Line (Checked_FFI_Ads, "with Interfaces.C.Extensions;");

   Put_Line (Checked_FFI_Ads, "with Adagres.FFI_Types; use Adagres.FFI_Types;");
   Put_Line (Checked_FFI_Ads, "package Adagres.Checked_FFI with Preelaborate is");

   Put_Line (Checked_FFI_Adb, "with System;");
   Put_Line (Checked_FFI_Adb, "with Interfaces.C; use Interfaces.C;");
   Put_Line (Checked_FFI_Adb, "with Interfaces.C.Extensions; use Interfaces.C.Extensions;");
   Put_Line (Checked_FFI_Adb, "with Adagres.Memory_Context;");
   Put_Line (Checked_FFI_Adb, "with Adagres.FFI;");
   Put_Line (Checked_FFI_Adb, "with Adagres.SetJmp; use Adagres.SetJmp;");
   Put_Line (Checked_FFI_Adb, "with Adagres.Error; use Adagres.Error;");
   Put_Line (Checked_FFI_Adb, "with Adagres.FFI_Types; use Adagres.FFI_Types;");
   Put_Line (Checked_FFI_Adb, "package body Adagres.Checked_FFI is");

   Unit := Context.Get_From_File ("../adagres/sig/adagres-ffi.ads");
   --     Unit.Print;
   Unit.Root.Traverse (Process_Node'Access);

   Put_Line (Checked_FFI_Ads, "end Adagres.Checked_FFI;");
   Put_Line (Checked_FFI_Adb, "end Adagres.Checked_FFI;");

   Close (Checked_FFI_Ads);
   Close (Checked_FFI_Adb);

   declare
      use GNAT.OS_Lib;
      GnatPP : constant String_Access := Locate_Exec_On_Path ("gnatpp");
   begin
      if GnatPP /= null
        and then
          Spawn
            (Program_Name => GnatPP.all,
             Args         =>
               [new String'("generated/adagres-checked_ffi.ads"),
               new String'("generated/adagres-checked_ffi.adb")]) /=
          0
      then

         null; -- Ignore the error
      end if;
   end;

end Main;
