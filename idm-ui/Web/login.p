/** ----------------------------------------------------------------------
    File        : login.p
    Purpose     : Login via html request
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using Progress.Lang.Error.

{src/web/method/cgidefs.i}

/** -- params, defs -- **/
define variable cUserName as character no-undo.
define variable cDomain as character no-undo.
define variable cPassword as character no-undo.
define variable cContextId as character no-undo.

/** -- main -- **/
define variable oObject as JsonObject no-undo.
define variable oFieldArray as JsonArray no-undo.
define variable oMessages as JsonArray no-undo.
define variable oResponse as JsonObject no-undo.
define variable hAppServer as handle no-undo.
define variable iMsgLoop as integer no-undo.
define variable hClientPrincipal as handle no-undo.
define variable rClientPrincipal as raw no-undo.
define variable cClientPrincipal as longchar no-undo.
 
cUserName = get-field('user').
cDomain = get-field('domain').
cPassword = get-field('password').

oResponse = new JsonObject().
oObject = new JsonObject().
oResponse:Add('error', false).

/* populate request info */
oResponse:Add('request', oObject).
oObject:Add('User', cUserName).
oObject:Add('Domain', cDomain).

if cUserName eq '' or cUserName eq ? then
    undo, throw new AppError('User name must be specified').
if cDomain eq '' or cDomain eq ? then
    undo, throw new AppError('Domain must be specified').

hAppServer = dynamic-function('getAppServer' in web-utilities-hdl, 'asSecurityTokenService'). 

create client-principal hClientPrincipal.
hClientPrincipal:initialize(
    substitute('&1@&2', cUserName, cDomain),  /* qualified username */
    ?,  /* session-id */
    ?,  /* timeout/expiration */
    cPassword).

rClientPrincipal = hClientPrincipal:export-principal().
cClientPrincipal = base64-encode(rClientPrincipal).
                
run Security/LoginSSO.p on hAppServer (cClientPrincipal, output cContextId).

/* get the C-P so that we can display the logindate */
run Security/GetClientPrincipal.p on hAppServer (input cContextId, output cClientPrincipal).
create client-principal hClientPrincipal.
rClientPrincipal = base64-decode(cClientPrincipal).
hClientPrincipal:import-principal(rClientPrincipal). 

/* Javascript only likes cookies in its path.
   The WebSpeed default is the value of the AppURL global variable,
   which is /cgi-bin/cgiip.exe/WService=wsIdM/. The
   HTML page is under /IdM so we use that. */
   
/* Input: Name, Value, [Expires date], [Expires time], [Path], [Domain], [Secure,{Local|UTC}] */
/* set-cookie('OECCID', cContextId, ?, ?, '/', ?, ?). */
set-cookie('OECCID',
           cContextId,
           date(hClientPrincipal:login-expiration-timestamp),
           integer(mtime(hClientPrincipal:login-expiration-timestamp) / 1000),
           ?, ?, ?).

oObject = new JsonObject().
oResponse:Add('user', oObject).
oObject:Add('user', cUserName).
oObject:Add('domain', cDomain).
oObject:Add('logindate', hClientPrincipal:seal-timestamp).

error-status:error = no.
return.

/* softly, softly */
catch oAppError as AppError :
    oResponse:Set('error', true).

    oMessages = new JsonArray().
    oResponse:Add('messages', oMessages).
    
    message oAppError:ReturnValue.
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
    delete object hClientPrincipal no-error.
    
    output-content-type("application/json":U).
    oResponse:WriteStream('WEBSTREAM').
end finally.
/** -- eof -- **/
