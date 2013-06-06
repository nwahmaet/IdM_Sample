/*------------------------------------------------------------------------
    File        : BusinessLogic/GetCustomerOrders.p
    Purpose     : Service interface to get all customer records 
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using BusinessLogic.CustomerOrderBE.

{BusinessLogic/dsCustomerOrder.i}

define input  parameter piCustNum as integer no-undo.
define output parameter dataset for dsCustomerOrder.

run GetCustomerOrders (input piCustNum, output dataset dsCustomerOrder by-reference).

procedure GetCustomerOrders:
    define input  parameter piCustNum as integer no-undo.
    define output parameter dataset for dsCustomerOrder.
    
    define variable oBusinessEntity as CustomerOrderBE no-undo.
    
    oBusinessEntity  = new CustomerOrderBE().
    
    oBusinessEntity:GetCustomerOrders(input piCustNum, output dataset dsCustomerOrder by-reference).
    
    error-status:error = no.
    return.
end procedure.
/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
