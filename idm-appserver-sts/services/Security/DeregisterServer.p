@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="DeregisterServer", URI="/DeregisterServer", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : Security/DeregisterServer.p
    Purpose     : Service interface for SecurityTokenService:DeregisterServer
    Author(s)   : pjudge
    Created     : Wed Jun 06 16:35:52 EDT 2012
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input parameter pcContextId as character no-undo.

run DeregisterServer (input pcContextId).

@openapi.openedge.export(type="REST", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/DeregisterServer", alias="", mediaType="application/json").
procedure DeregisterServer:
    define input parameter pcContextId as character no-undo.
    
    Security.SecurityTokenService:Instance:DeregisterServer(pcContextId).
    
    error-status:error = no.
    return.
end procedure.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
