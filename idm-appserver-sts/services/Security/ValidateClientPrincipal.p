@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="ValidateClientPrincipal", URI="/ValidateClientPrincipal", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : Security/ValidateClientPrincial.p
    Purpose     : Returns a base64-encoded client-principal/token
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input parameter pcClientPrincipal as longchar no-undo.

run ValidateClientPrincipal (input pcClientPrincipal).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/ValidateClientPrincipal", alias="", mediaType="application/json").
procedure ValidateClientPrincipal:
    define input parameter pcClientPrincipal as longchar no-undo.
    
    define variable hClientPrincipal as handle no-undo.
    define variable rClientPrincipal as raw no-undo.
    
    create client-principal hClientPrincipal.
    rClientPrincipal = base64-decode(pcClientPrincipal).
    hClientPrincipal:import-principal(rClientPrincipal).
    
    Security.SecurityTokenService:Instance:ValidateToken(hClientPrincipal).
    
    error-status:error = no.
    return.
end procedure.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
