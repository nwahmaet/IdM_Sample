@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="LoginSSO", URI="/LoginSSO", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : Security/SSOLogin.p
    Purpose     : User login procedure
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input  parameter pcCredentials as longchar no-undo.
define output parameter pcToken as character no-undo.

run LoginSSO(input pcCredentials, output pcToken).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/LoginSSO", alias="", mediaType="application/json").
procedure LoginSSO:
    define input  parameter pcCredentials as longchar no-undo.
    define output parameter pcToken as character no-undo.
    
    define variable hClientPrincipal as handle no-undo.
    define variable rClientPrincipal as raw no-undo.
    
    create client-principal hClientPrincipal.
    rClientPrincipal = base64-decode(pcCredentials).
    hClientPrincipal:import-principal(rClientPrincipal).
    
    pcToken = Security.SecurityTokenService:Instance:LoginUser(hClientPrincipal).
    
    error-status:error = no.
    return.
end procedure.
    
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
