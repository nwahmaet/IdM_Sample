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

define variable cCCID as character no-undo.

run Security/startup.p ('sports2000').

run Security/login.p (
    'holly_atkins', 'employee', 'letmein',
    output cCCID).
    
catch oError as Progress.Lang.Error :
message
oError:GetMessage(1) 

view-as alert-box.
		
end catch.    

finally:
    run Security/shutdown.p.	
end finally.