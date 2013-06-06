/*------------------------------------------------------------------------
    File        : test_login.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Sep 27 15:35:00 EDT 2012
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

{BusinessLogic/dsCustomerOrder.i}

run BusinessLogic/GetCustomerList.p (output dataset dsCustomerOrder).

find first ttCustomer.
displ ttCustomer.CustNum.

catch oAppError as Progress.Lang.AppError :
    message oAppError:ReturnValue
    view-as alert-box.
end catch.
catch oError as Progress.Lang.Error :
    message oError:GetMessage(1)
    view-as alert-box.
end catch.