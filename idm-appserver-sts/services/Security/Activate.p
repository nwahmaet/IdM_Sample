/*------------------------------------------------------------------------
    File        : Security/Activate.p
    Purpose     : AppServer activate procedure for Security Token Service
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.AppError.
  
/* logins and server registration are free to all to attempt. All other operations require a registered connection */
if lookup(session:current-request-info:ProcedureName,
          'Security/Login.p,Security/LoginSSO.p,Security/RegisterServer.p') eq 0 then
    Security.SecurityTokenService:Instance:ValidateToken(
        Security.SecurityTokenService:Instance:GetClientPrincipal(session:current-request-info:ClientContextId)).

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
