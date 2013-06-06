@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="GetClientPrincipal", URI="/GetClientPrincipal", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : getclientprincipal.p
    Purpose     : Returns a base64-encoded client-principal/token
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
define input parameter pcContextId as character no-undo.
define output parameter pcToken as longchar no-undo.

run GetClientPrincipal(input pcContextId, output pcToken).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/GetClientPrincipal", alias="", mediaType="application/json").
procedure GetClientPrincipal:
    define input parameter pcContextId as character no-undo.
    define output parameter pcToken as longchar no-undo.
    
    define variable hClientPrincipal as handle no-undo.
    
    hClientPrincipal = Security.SecurityTokenService:Instance:GetClientPrincipal(pcContextId).
    pcToken = base64-encode(hClientPrincipal:export-principal()).
    
    error-status:error = no.
    return.
end procedure.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
