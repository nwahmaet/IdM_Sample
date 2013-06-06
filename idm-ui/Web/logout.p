/** ----------------------------------------------------------------------
    File        : userlogout.p
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using Progress.Lang.Error.

{src/web/method/cgidefs.i}

/** -- main -- **/
define variable cContextId as character no-undo.
define variable oObject as JsonObject no-undo.
define variable oMessages as JsonArray no-undo.
define variable oResponse as JsonObject no-undo.
define variable hAppServer as handle no-undo.
define variable iMsgLoop as integer no-undo.

oResponse = new JsonObject().
oObject = new JsonObject().
oResponse:Add('error', false).

hAppServer = dynamic-function('getAppServer' in web-utilities-hdl, 'asSecurityTokenService'). 

cContextId = get-cookie('OECCID').
run Security/Logout.p on hAppServer (input cContextId).

/* Input: Name, path, domain */
delete-cookie ('OECCID', ?, ?).

oMessages = new JsonArray().
oResponse:Add('messages', oMessages).
oMessages:Add('Logout succeeded').

error-status:error = no.
return.

/* softly, softly */
catch oAppError as AppError :
    oResponse:Set('error', true).

    oMessages = new JsonArray().
    oResponse:Add('messages', oMessages).
    
    oMessages:Add(oAppError:ReturnValue).
    
    do iMsgLoop = 1 to oAppError:NumMessages:
        oMessages:Add(oAppError:GetMessage(iMsgLoop)).
    end.
end catch.

catch oError as Error:
    oResponse:Set('error', true).
    
    oMessages = new JsonArray().
    oResponse:Add('messages', oMessages).
    
    do iMsgLoop = 1 to oError:NumMessages:
        oMessages:Add(oError:GetMessage(iMsgLoop)).
    end.
end catch.

finally:
    output-content-type("application/json":U).
    oResponse:WriteStream('WEBSTREAM').
end finally.
/** -- eof -- **/
