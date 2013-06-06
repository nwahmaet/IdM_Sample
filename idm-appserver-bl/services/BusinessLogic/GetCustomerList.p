/*------------------------------------------------------------------------
    File        : BusinessLogic/GetCustomerList.p
    Purpose     : Service interface to get all customer records 
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using BusinessLogic.CustomerOrderBE.

{BusinessLogic/dsCustomerOrder.i}

define output parameter dataset for dsCustomerOrder.

define variable oBusinessEntity as CustomerOrderBE no-undo.

oBusinessEntity  = new CustomerOrderBE().

oBusinessEntity:GetCustomers(output dataset dsCustomerOrder by-reference).

error-status:error = no.
return.

/** -- error handling -- **/
catch oError as Progress.Lang.Error:
    return error oError:GetMessage(1). 
end catch.
/** -- eof -- **/
