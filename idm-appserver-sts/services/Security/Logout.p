@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="Logout", URI="/Logout", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : logout.p
    Purpose     : User logout procedure
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input parameter pcToken as character no-undo.

run Logout(input pcToken).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/Logout", alias="", mediaType="application/json").
procedure Logout:
    define input parameter pcToken as character no-undo.
    
    Security.SecurityTokenService:Instance:LogoutUser(pcToken).
    
    error-status:error = no.
    return.
end procedure.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
