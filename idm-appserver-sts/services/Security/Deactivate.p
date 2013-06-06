/*------------------------------------------------------------------------
    File        : Security/Deactivate.p
    Purpose     : AppServer deactivate procedure for Security Token Service
    Author(s)   : pjudge
    Notes       : Reset agent user to low-priviledge user. Logins will set the
                  user to a different user.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define variable hClientPrincipal as handle no-undo.
define variable hStartupProc as handle no-undo.

hStartupProc = session:first-procedure.
do while valid-handle(hStartupProc) and hStartupProc:name ne 'Security/Startup.p':
    hStartupProc = hStartupProc:next-sibling.
end.

if valid-handle(hStartupProc) and hStartupProc:name eq 'Security/Startup.p' then
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
            