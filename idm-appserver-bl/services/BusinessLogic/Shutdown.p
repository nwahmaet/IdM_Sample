/*------------------------------------------------------------------------
    File        : BusinessLogic/Shutdown.p
    Purpose     : AppServer shutdown for Business Logic Service
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define variable hStartupProc as handle no-undo.
define variable hSecurityTokenService as handle no-undo.

hStartupProc = session:first-procedure.
do while valid-handle(hStartupProc) and hStartupProc:name ne 'BusinessLogic/Startup.p':
    hStartupProc = hStartupProc:next-sibling.
end.

if valid-handle(hStartupProc) and hStartupProc:name eq 'BusinessLogic/Startup.p' then
    hSecurityTokenService = dynamic-function('GetSecurityTokenService' in hStartupProc).
    
run Security/Logout.p on hSecurityTokenService (dynamic-function('GetAgentSessionId' in hStartupProc)).

run Security/DeregisterServer.p on hSecurityTokenService (
        input hSecurityTokenService:request-info:ClientContextId).

error-status:error = no.
return.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.

finally:
    hSecurityTokenService:disconnect().
    delete object hSecurityTokenService no-error.
end finally.
/** -- eof -- **/
