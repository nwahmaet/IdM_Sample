/*------------------------------------------------------------------------
    File        : Security/Shutdown.p
    Purpose     : AppServer shutdown for Security Token Service
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define variable hStartupProc as handle no-undo.

hStartupProc = session:first-procedure.
do while valid-handle(hStartupProc) and hStartupProc:name ne 'Security/Startup.p':
    hStartupProc = hStartupProc:next-sibling.
end.

Security.SecurityTokenService:Instance:LogoutUser(
        dynamic-function('GetAgentSessionId' in hStartupProc)).
    
error-status:error = no.
return.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
