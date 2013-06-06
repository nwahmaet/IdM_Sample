@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="Login", URI="/Login", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : Security/Login.p
    Purpose     : User login procedure
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
define input  parameter pcUser as character no-undo.
define input  parameter pcDomain as character no-undo.
define input  parameter pcPword as character no-undo.
define output parameter pcToken as character no-undo.

run Login(input pcUser, input pcDomain, input pcPword, output pcToken).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/Login", alias="", mediaType="application/json").
procedure Login:
    define input  parameter pcUser as character no-undo.
    define input  parameter pcDomain as character no-undo.
    define input  parameter pcPword as character no-undo.
    define output parameter pcToken as character no-undo.
    
    pcToken = Security.SecurityTokenService:Instance:LoginUser(pcUser, pcDomain, pcPword).

    error-status:error = no.
    return.
end procedure.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
