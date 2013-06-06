/*------------------------------------------------------------------------
    File        : BusinessLogic/Deactivate.p
    Purpose     : AppServer deactivate procedure for Business Logic Service
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define variable hClientPrincipal as handle no-undo.
define variable hStartupProc as handle no-undo.

hStartupProc = session:first-procedure.
do while valid-handle(hStartupProc) and hStartupProc:name ne 'BusinessLogic/Startup.p':
    hStartupProc = hStartupProc:next-sibling.
end.

if valid-handle(hStartupProc) and hStartupProc:name eq 'BusinessLogic/Startup.p' then
    security-policy:set-client(
        widget-handle(
            dynamic-function('GetAgentClientPrincipal' in hStartupProc))).

error-status:error = no.
return.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
