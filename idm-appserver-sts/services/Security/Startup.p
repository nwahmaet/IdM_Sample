/*------------------------------------------------------------------------
    File        : Security/Startup.p
    Purpose     : AppServer startup  for Security Token Service
    Author(s)   : pjudge
    Notes       : * pcStartupData needs to contain the name of the DB containing
                  security domains.
                  *  this procedure is run persistently by the AppServer
                  * Flow
                    1) load domains
                    2) Restrict access to select procedures
                    3) Log in as an agent/low-level user and set that user as
                       the authenticated user.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.ObjectModelParser.

define input parameter pcStartupData as character no-undo.

define variable oParser as ObjectModelParser no-undo.
define variable oUser as JsonObject no-undo.
define variable oAllUsers as JsonArray no-undo.
define variable iLoop as integer no-undo.
define variable cAgentSessionId as character no-undo.
define variable hAgentClientPrincipal as handle no-undo.

/* 1) load domains */
security-policy:load-domains(pcStartupData).

/* 2) restrict access to these procedures only */
session:export(
       'Security/Login.p'
    + ',Security/LoginSSO.p'
    + ',Security/Logout.p'
    + ',Security/GetClientPrincipal.p'
    + ',Security/ValidateToken.p'
    + ',Security/ValidateClientPrincipal.p'
    + ',Security/RegisterServer.p'
    + ',Security/DeregisterServer.p').

/* 3) Set the session user to a low-privilege agent user */
/* password on disk, encrypted */
oParser = new ObjectModelParser().
oAllUsers = cast(oParser:ParseFile('cfg/serveruser.json'), JsonArray).

/* serveruser.json in form
 [{ "agent" : {"domain":"system", "passphrase": "oech1::3c373b2a372c3d"}},
 { "batch" : {"domain":"system", "passphrase": "oech1::3c373b2a372c3d"}}] */

do iLoop = 1 to oAllUsers:Length while not valid-object(oUser):
    oAllUsers:GetJsonObject(iLoop).
    if oAllUsers:GetJsonObject(iLoop):Has('agent') then
        oUser = oAllUsers:GetJsonObject(iLoop):GetJsonObject('agent').
end.

/* Sets the agent's user */
cAgentSessionId = Security.SecurityTokenService:Instance:LoginUser(
    'agent',
    oUser:GetCharacter('domain'),
    oUser:GetCharacter('passphrase')).

hAgentClientPrincipal = security-policy:get-client().

error-status:error = no.
return.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.

/* UDFs */
function GetAgentSessionId returns character():
    return cAgentSessionId.
end function.

function GetAgentClientPrincipal returns handle():
    return hAgentClientPrincipal.
end function.
/** -- eof -- **/
