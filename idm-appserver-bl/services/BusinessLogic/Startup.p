/*------------------------------------------------------------------------
    File        : BusinessLogic/Startup.p
    Purpose     : AppServer startup  for Business Logic AppServer
    Author(s)   : pjudge
    Notes       : * pcStartupData needs to contain the name of the DB containing
                  security domains.
                  *  this procedure is run persistently by the AppServer
                  * Flow
                    1) load domains
                    2) Restrict access to this server
                    3) register this agent as a client of the STS, and use
                       the resulting CCID for all requests from this agent to
                       the SYS
                    4) Log in as an agent/low-level user and set that user as
                       the authenticated user.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.ObjectModelParser.

define input parameter pcStartupData as character no-undo.

define variable cAgentSessionId as character no-undo.
define variable hClientPrincipal as handle no-undo.
define variable cToken as character no-undo.
define variable rClientPrincipal as raw no-undo.
define variable hSecurityTokenService as handle no-undo.
define variable cServerName as character no-undo.
define variable oParser as ObjectModelParser no-undo.
define variable oUser as JsonObject no-undo.
define variable oAllUsers as JsonArray no-undo.
define variable iLoop as integer no-undo.

/** 1) load domains */
security-policy:load-domains(pcStartupData).

/** 2) restrict access to these procedures only */
session:export('BusinessLogic/*').

/** 3) Connect to STS and register this server as a client */
create server hSecurityTokenService.
hSecurityTokenService:connect('-AppService asSecurityTokenService -sessionModel session-free').
hSecurityTokenService:request-info:ClientContextId = ''.

/* random name */
cServerName = substitute('BusinessLogicServer::&1', guid).

run Security/RegisterServer.p on hSecurityTokenService (
    input cServerName,
    output cToken).

/* this value will now be passed to and fro on every request */    
hSecurityTokenService:request-info:ClientContextId = cToken.

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

run Security/Login.p on hSecurityTokenService (
    'agent',
    oUser:GetCharacter('domain'),
    oUser:GetCharacter('passphrase'),
    output cAgentSessionId).
    
run Security/GetClientPrincipal.p on hSecurityTokenService (cAgentSessionId, output cToken).

rClientPrincipal = base64-decode(cToken).

create client-principal hClientPrincipal.
hClientPrincipal:import-principal(rClientPrincipal).

security-policy:set-client (hClientPrincipal).

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
    return hClientPrincipal.
end function.

function GetSecurityTokenService returns handle():
    return hSecurityTokenService.
end function.
/** -- eof -- **/
