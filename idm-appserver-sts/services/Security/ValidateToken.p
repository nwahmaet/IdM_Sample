@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="ValidateToken", URI="/ValidateToken", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : Security/ValidateToken.p
    Purpose     : Validates that a specified CCID 
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input parameter pcContextId as character no-undo.

run ValidateToken (input pcContextId).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/ValidateToken", alias="", mediaType="application/json").
procedure ValidateToken:
    define input parameter pcContextId as character no-undo.
    
    Security.SecurityTokenService:Instance:ValidateToken(pcContextId).
    
    error-status:error = no.
    return.
end procedure.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
