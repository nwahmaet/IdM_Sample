@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="true", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="RegisterServer", URI="/RegisterServer", schemaName="", schemaFile="").
/*------------------------------------------------------------------------
    File        : RegisterServer.p
    Purpose     : Service interface for SecureTokenService:RegisterServer
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input  parameter pcName as character no-undo.
define output parameter pcContextId as character no-undo.

run RegisterServer(input pcName, output pcContextId).

@openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resourceMapping(type="REST", operation="invoke", URI="/RegisterServer", alias="", mediaType="application/json").
procedure RegisterServer:
    define input  parameter pcName as character no-undo.
    define output parameter pcContextId as character no-undo.
    
    pcContextId = Security.SecurityTokenService:Instance:RegisterServer(pcName).
    
    error-status:error = no.
    return.
end procedure.

/** -- error handling -- **/
catch oAppError as Progress.Lang.AppError:
    message oAppError:ReturnValue.
    return error oAppError:ReturnValue. 
end catch.

catch oError as Progress.Lang.Error:
    message oError:GetMessage(1).
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
