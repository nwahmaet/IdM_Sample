/*------------------------------------------------------------------------
    File        : sessionsuper.p
    Purpose     : Overrides form WebSpeed requests and startup.
    Author(s)   : pjudge
    Notes       : * Somewhat analgous to the AppServer activate and other
                    procedures.
  ----------------------------------------------------------------------*/
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

{src/web/method/cgidefs.i}

define variable moServers as JsonObject no-undo.
  
procedure init-request :
/*---------------------------------------------------------------------------
  Procedure:   init-request
  Description: Initializes WebSpeed environment for each web request
  Input:       Environment variables
  Output:      Sets global variables defined in src/web/method/cgidefs.i
---------------------------------------------------------------------------*/
    define variable hAppServer as handle no-undo.
    define variable oServer as JsonObject no-undo.
    define variable cCCID as character no-undo.
    
    run super.
    
    cCCID = get-cookie('OECCID').
    
    if cCCID ne '' and cCCID ne ? then
    do:
        oServer = moServers:GetJsonObject('asBusinessLogicService').
        hAppServer = oServer:GetHandle('handle').
        hAppServer:request-info:ClientContextId = cCCID.
    end.
end procedure.

procedure init-session :
/*---------------------------------------------------------------------------
  Procedure:   init-session
  Description: Initializes PROGRESS session variables from the environment. 
  Input:       <none>
  Output:      Sets global variables defined in src/web/method/cgidefs.i
  Notes:       These values should be the default values on a WEB-based client.
               (But it never hurts to make sure.)
----------------------------------------------------------------------------*/
    define variable oParser as ObjectModelParser no-undo.
    define variable oServers as JsonObject no-undo.
    define variable oServer as JsonObject no-undo.
    define variable hAppServer as handle no-undo.
    define variable cToken as character no-undo.
    
    
    oParser = new ObjectModelParser().
    moServers = cast(oParser:ParseFile('cfg/servers.json'), JsonObject).
    
    oServer = moServers:GetJsonObject('asBusinessLogicService').
    create server hAppServer.
    oServer:Set('handle', hAppServer).
    hAppServer:connect(substitute('-AppService asBusinessLogicService -H &1 -sessionModel &2',
                        oServer:GetCharacter('host'),
                        oServer:GetCharacter('sessionModel'))).
    /* Set the value to BLANK until login */
    hAppServer:request-info:ClientContextId = ''.
    
    /** Connect to STS and register this server as a client */
    oServer = moServers:GetJsonObject('asSecurityTokenService').
    create server hAppServer.
    oServer:Set('handle', hAppServer).
    hAppServer:connect(substitute('-AppService asSecurityTokenService -H &1 -sessionModel &2',
                        oServer:GetCharacter('host'),
                        oServer:GetCharacter('sessionModel'))).
    
    /* we need to register as a client as only login and register are freebies, and we
       want to logout too */
    run Security/RegisterServer.p on hAppServer (
        input substitute('wsIdM::&1', guid),
        output cToken).
     
    /* this value will now be passed to and fro on every request */    
    hAppServer:request-info:ClientContextId = cToken.
    
    run super.
end procedure.

procedure end-request :
/*------------------------------------------------------------------------------
  Purpose:     place-holder procedure for allowing other super procedures to run
               after a web request has completed
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable hAppServer as handle no-undo.
    define variable oServer as JsonObject no-undo.
    
    oServer = moServers:GetJsonObject('asBusinessLogicService').
    hAppServer = oServer:GetHandle('handle').
    
    /* Set the value to BLANK until login */
    hAppServer:request-info:ClientContextId = ''.

    run super.
end procedure.

procedure destroy :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    define variable iLoop as integer no-undo.
    define variable cNames as character extent no-undo.
    define variable hAppServer as handle no-undo.
    define variable oServer as JsonObject no-undo.
    
    oServer = moServers:GetJsonObject('asBusinessLogicService').
    hAppServer = oServer:GetHandle('handle').    
    if hAppServer:connected() then
        hAppServer:disconnect().
    delete object hAppServer no-error.
    hAppServer = ?.
    oServer:Set('handle', hAppServer).

    oServer = moServers:GetJsonObject('asSecurityTokenService').
    hAppServer = oServer:GetHandle('handle').
    if hAppServer:connected() then
    do:
        run Security/DeregisterServer.p on hAppServer (
                hAppServer:request-info:ClientContextId).
        
        hAppServer:request-info:ClientContextId = ''.                
        hAppServer:disconnect().
    end.
    
    delete object hAppServer no-error.
    hAppServer = ?.
    oServer:SetNull('handle').
end procedure.

function GetAppServer returns handle (input pcName as character):
    define variable hAppServer as handle no-undo.
    define variable oServer as JsonObject no-undo.
    
    oServer = moServers:GetJsonObject(pcName).
    hAppServer = oServer:GetHandle('handle').
    
    return hAppServer.
end function.

