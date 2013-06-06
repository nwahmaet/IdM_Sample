/*------------------------------------------------------------------------
    File        : test_customerlist.p
    Purpose     : 
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

{Desktop/dsCustomerOrder.i}

define variable cCCID as character no-undo.
define variable hSTS as handle no-undo.
define variable hBLS as handle no-undo.

run Init.

run Security/Login.p on hSTS (
    'holly_atkins', 'employee', 'letmein',
    output cCCID).
hBLS:request-info:ClientContextId = cCCID.

run BusinessLogic/GetCustomerList.p on hBLS (output table ttCustomer).

find first ttCustomer.
message ttCustomer.Name view-as alert-box.

catch oAppError as Progress.Lang.AppError :
    message oAppError:ReturnValue
    view-as alert-box.
end catch.    

catch oError as Progress.Lang.Error :
    message oError:GetMessage(1) 
    view-as alert-box.
end catch.    

finally:
    run Dispose.	
end finally.

procedure Init:
    define variable cToken as character no-undo.

    /** BLS **/
    /* this value will now be passed to and fro on every request */    
    create server hBLS.
    hBLS:connect('-AppService asBusinessLogicService -sessionModel Session-free').
    /* Set the value to BLANK until login */
    hBLS:request-info:ClientContextId = ''.

    /** STS **/
    /** Connect to STS and register this server as a client */
    create server hSTS.
    hSTS:connect('-AppService asSecurityTokenService -sessionModel Session-free').
    hSTS:request-info:ClientContextId = ''.
    
    /* we need to register as a client as only login and register are freebies, and we
       want to logout too */
    run Security/RegisterServer.p on hSTS  (
        input substitute('test_customerlist::&1', guid),
        output cToken).
    
    hSTS:request-info:ClientContextId = cToken.
end procedure.

procedure Dispose:
    run Security/Logout.p on hSTS (cCCID).
    
    hBLS:disconnect().
    delete object hBLS no-error.
    hBLS = ?.

    run Security/DeregisterServer.p on hSTS  (hSTS:request-info:ClientContextId).
    
    hSTS:disconnect().    
    delete object hSTS no-error.
    hSTS = ?.
end procedure.