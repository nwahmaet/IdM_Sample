/*------------------------------------------------------------------------
    File        : BusinessLogic/Activate.p
    Purpose     : AppServer activate procedure for Business Logic Service
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.AppError.

define variable hClientPrincipal as handle no-undo.
define variable hSecurityTokenService as handle no-undo.
define variable hStartupProc as handle no-undo.
define variable cToken as longchar no-undo.
define variable rClientPrincipal as raw no-undo.

hStartupProc = session:first-procedure.
do while valid-handle(hStartupProc) and hStartupProc:name ne 'BusinessLogic/Startup.p':
    hStartupProc = hStartupProc:next-sibling.
end.

if valid-handle(hStartupProc) and hStartupProc:name eq 'BusinessLogic/Startup.p' then
    hSecurityTokenService = dynamic-function('GetSecurityTokenService' in hStartupProc). 

if session:current-request-info:ClientContextId eq '' then
    undo, throw new AppError('No client context provided').
    
run Security/GetClientPrincipal.p on hSecurityTokenService (
    session:current-request-info:ClientContextId, output cToken).

rClientPrincipal = base64-decode(cToken).

create client-principal hClientPrincipal.
hClientPrincipal:import-principal(rClientPrincipal).
/* now user is set to requesting user */
security-policy:set-client(hClientPrincipal).

error-status:error = no.
return.
/** -- error handling -- **/
catch oAppError as Progress.Lang.AppError:
    message oAppError:ReturnValue.
    return error oAppError:ReturnValue.
end catch.

catch oError as Progress.Lang.Error:
    message oError:GetMessage(1).
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
