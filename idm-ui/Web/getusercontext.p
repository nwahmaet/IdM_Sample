/*------------------------------------------------------------------------
    File        : getusercontext.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Mar 30 15:19:32 EDT 2012
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
define variable oFieldArray as JsonArray no-undo.
define variable oMessages as JsonArray no-undo.
define variable oResponse as JsonObject no-undo.
define variable hAppServer as handle no-undo.
define variable iMsgLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable hClientPrincipal as handle no-undo.
define variable cClientPrincipal as longchar no-undo.
define variable rClientPrincipal as raw no-undo.
define variable cProperties as character no-undo.
define variable cPropName as character no-undo.

cContextId = get-cookie('OECCID').

oResponse = new JsonObject().
oObject = new JsonObject().
oResponse:Add('error', false).

oObject = new JsonObject().
oResponse:Add('request', oObject).

if cContextId eq '' or cClientPrincipal eq ? then
    undo, throw new AppError('Invalid session').
    
hAppServer = dynamic-function('getAppServer' in web-utilities-hdl, 'asSecurityTokenService'). 

run Security/GetClientPrincipal.p on hAppServer (input cContextId, output cClientPrincipal).
if cClientPrincipal eq '' then
    undo, throw new AppError('Invalid session').

create client-principal hClientPrincipal.
rClientPrincipal = base64-decode(cClientPrincipal).
hClientPrincipal:import-principal(rClientPrincipal).

oObject = new JsonObject().
oResponse:Add('user', oObject).
oObject:Add('name', hClientPrincipal:user-id).
oObject:Add('domain', hClientPrincipal:domain-name).

cProperties = hClientPrincipal:list-property-names().
iMax = num-entries(cProperties).

oFieldArray = new JsonArray(iMax).
oObject:Add('userproperties', oFieldArray).

do iMsgLoop = 1 to iMax:
    oObject = new JsonObject().
    oFieldArray:Add(oObject).
    oObject:Add(
        entry(iMsgLoop, cProperties),
        hClientPrincipal:get-property(entry(iMsgLoop, cProperties))).
end.

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

    message oError:callStack.
    
    do iMsgLoop = 1 to oError:NumMessages:
        oMessages:Add(oError:GetMessage(iMsgLoop)).
    end.
end catch.

finally:
    delete object hClientPrincipal no-error.
    
    output-content-type("application/json":U).
    oResponse:WriteStream('WEBSTREAM').
end finally.
/** -- eof -- **/
