/*------------------------------------------------------------------------
    File        : start_desktop_ui.p
    Purpose     : Runs the Desktop UI
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Desktop.MainForm.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Windows.Form.
using Progress.Lang.Error.
using Progress.Lang.AppError.

/** -- defs  -- **/
define variable oMainForm as MainForm    no-undo.
define variable oParser as ObjectModelParser no-undo.
define variable oServers as JsonObject no-undo.

session:debug-alert = true.
session:error-stack-trace = true.
session:system-alert-boxes = true.
session:appl-alert-boxes = true.

/** -- main -- **/
oMainForm = new MainForm().

oParser = new ObjectModelParser().
oServers = cast(oParser:ParseFile('cfg/servers.json'), JsonObject).

oMainForm:Initialize(oServers).

wait-for System.Windows.Forms.Application:Run(oMainForm).

quit.

/** ----------------- **/
catch oAppError as AppError:
    message oAppError:ReturnValue
        view-as alert-box error.                        
end catch.

catch oError as Error:
    message oError:GetMessage(1)
        view-as alert-box error.
end catch.
