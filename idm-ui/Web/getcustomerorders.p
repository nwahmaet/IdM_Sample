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
define variable iCustNum as integer no-undo.

iCustNum = integer(get-field('customerId')) no-error.

oResponse = new JsonObject().

oResponse:Add('error', false).
oObject = new JsonObject().
oResponse:Add('request', oObject).
oObject:Add('CustNum', iCustNum).

hAppServer = dynamic-function('getAppServer' in web-utilities-hdl, 'asBusinessLogicService'). 

run BusinessLogic/GetCustomerOrders.p on hAppServer (
    input iCustNum,
    output dataset dsCustomerOrder).

oObject = new JsonObject().
oArray = new JsonArray().
oResponse:Add('customers', oArray).
oArray:Read(temp-table ttCustomer:handle).

oArray = new JsonArray().
oResponse:Add('orders', oArray).
oArray:Read(temp-table ttOrder:handle).

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
    output-content-type("application/json":U).
    oResponse:WriteStream('WEBSTREAM').
end finally.
/** -- eof -- **/
