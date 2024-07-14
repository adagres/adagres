with Interfaces;
with Interfaces.C;
with Adagres.Constants;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

package Adagres.FFI_Types with
  Preelaborate
is

   type Command_Id is new Interfaces.Unsigned_32;

   type Memory_Context_Data is private;
   type Memory_Context is access Memory_Context_Data;

   package C renames Interfaces.C;
   package C_Ext renames Interfaces.C.Extensions;
   package C_Strings renames Interfaces.C.Strings;
   package Const renames Adagres.Constants;

   type Error_Level is
     (DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, LOG, LOG_SERVER_ONLY, INFO, NOTICE, WARNING,
      WARNING_CLIENT_ONLY, ERROR, FATAL, PANIC);

   for Error_Level use
     (DEBUG5          => Const.DEBUG5, DEBUG4 => Const.DEBUG4, DEBUG3 => Const.DEBUG3,
      DEBUG2          => Const.DEBUG2, DEBUG1 => Const.DEBUG1, LOG => Const.LOG,
      LOG_SERVER_ONLY => Const.LOG_SERVER_ONLY, INFO => Const.INFO, NOTICE => Const.NOTICE,
      WARNING         => Const.WARNING, WARNING_CLIENT_ONLY => Const.WARNING_CLIENT_ONLY,
      ERROR           => Const.ERROR, FATAL => Const.FATAL, PANIC => Const.PANIC);

   for Error_Level'Size use C.int'Size;

   type Error_Data is record
      Level            : Error_Level;
      Output_to_Server : C_Ext.bool;
      Output_to_Client : C_Ext.bool;
      Hide_Stmt        : C_Ext.bool;
      Hide_Ctx         : C_Ext.bool;
      Filename         : C_Strings.chars_ptr;
      Line_No          : C.int;
      Func_Name        : C_Strings.chars_ptr;
      Domain           : C_Strings.chars_ptr;
      Context_Domain   : C_Strings.chars_ptr;
      SQL_Error_Code   : C.int;
      Message          : C_Strings.chars_ptr;
      Detail           : C_Strings.chars_ptr;
      Detail_Log       : C_Strings.chars_ptr;
      Hint             : C_Strings.chars_ptr;
      Context          : C_Strings.chars_ptr;
      Backtrace        : C_Strings.chars_ptr;
      Message_Id       : C_Strings.chars_ptr;
      Schema_Name      : C_Strings.chars_ptr;
      Table_Name       : C_Strings.chars_ptr;
      Column_Name      : C_Strings.chars_ptr;
      Data_Type_Name   : C_Strings.chars_ptr;
      Constraint_Name  : C_Strings.chars_ptr;
      Cursor_Pos       : C.int;
      Internal_Pos     : C.int;
      Internal_Query   : C_Strings.chars_ptr;
      Saved_Errno      : C.int;
   end record with
     Convention => C_Pass_By_Copy;
   type Error_Data_Access is access Error_Data;

   type Error_Context_Callback_Procedure is
     access procedure (Arg : Interfaces.C.Extensions.void_ptr);

   type Error_Context_Callback is record
      Previous : access Error_Context_Callback;
      Callback : Error_Context_Callback_Procedure;
      Arg      : Interfaces.C.Extensions.void_ptr;
   end record with
     Convention => C_Pass_By_Copy;

private

   type Memory_Context_Data is null record;

end Adagres.FFI_Types;
