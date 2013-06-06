/*------------------------------------------------------------------------
    File        : Web/GetCustomerList.p
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using Progress.Lang.Error.

{src/web/method/cgidefs.i}
{dsCustomerOrder.i}

/** -- main -- **/
define variable oObject as JsonObject no-undo.
define variable oArray as JsonArray no-undo.
define variable oDetailArray as JsonArray no-undo.
define variable oMessages as JsonArray no-undo.
define variable oResponse as JsonObject no-undo.
define variable hAppServer as handle no-undo.
define variable iMsgLoop as integer no-undo.
define variable cChildURL as character no-undo.
define variable lcCustomerData as longchar no-undo.
define variable iPageSize as integer no-undo.
define variable iStartRow as integer no-undo.

define query qryCustomer for ttCustomer scrolling.

iPageSize = integer(get-field('pageSize')) no-error.

iStartRow = integer(get-field('startRow')) no-error.

oResponse = new JsonObject().

oResponse:Add('error', false).
oObject = new JsonObject().
oResponse:Add('request', oObject).
oObject:Add('startRow', iStartRow).
oObject:Add('pageSize', iPageSize).

hAppServer = dynamic-function('getAppServer' in web-utilities-hdl, 'asBusinessLogicService'). 

run BusinessLogic/GetCustomerList.p on hAppServer (output dataset dsCustomerOrder).        

oObject = new JsonObject().
oArray = new JsonArray().
oResponse:Add('customers', oArray).

/* now the data. */
open query qryCustomer preselect each ttCustomer by ttCustomer.CustNum.
if iPageSize eq 0 then
    iPageSize = query qryCustomer:num-results. 

query qryCustomer:reposition-to-row(iStartRow).
query qryCustomer:get-next().

do while available ttCustomer and iPageSize gt 0:
    oObject = new JsonObject().
    oArray:Add(oObject).
    oObject:Read(buffer ttCustomer:handle).
    oObject:Add('id', ttCustomer.CustNum).
    
    iPageSize = iPageSize - 1.
    
    query qryCustomer:get-next().
end.

oObject = oResponse:GetJsonObject('request').
oObject:Add('endRow', query qryCustomer:current-result-row - 1).
oObject:Add('allReturned', query qryCustomer:current-result-row ge query qryCustomer:num-results).

/* softly, softly */
catch oAppError as AppError :
    oResponse:Set('error', true).

    oMessages = new JsonArray().
    oResponse:Add('messages', oMessages).
    
    oMessages:Add(oAppError:ReturnValue).

    do iMsgLoop = 1 to oAppError:NumMessages:
        oMessages:Add(oAppError:GetMessage(iMsgLoop)).
    end.
end catch.

catch oError as Error:
    oResponse:Set('error', true).
    
    oMessages = new JsonArray().
    oResponse:Add('messages', oMessages).
    do iMsgLoop = 1 to oError:NumMessages:
        oMessages:Add(oError:GetMessage(iMsgLoop)).
    end.
end catch.

finally:
    close query qryCustomer.
    
    output-content-type("application/json":U).
    oResponse:WriteStream('WEBSTREAM').
end finally.
/** -- eof -- **/
