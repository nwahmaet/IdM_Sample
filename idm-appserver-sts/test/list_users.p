/*------------------------------------------------------------------------
    File        : list_users.p
    Purpose     : Lists the first 10 users found per domain 
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
define variable iCount as integer no-undo.
  
output to './users.txt'.

for each ApplicationUser no-lock break by ApplicationUser.LoginDomain:
    if first-of(ApplicationUser.LoginDomain) then
    do:
        put unformatted
            'Domain: ' ApplicationUser.LoginDomain skip.
        icount = 0.            
    end.

    if ApplicationUser.LoginDomain eq 'system' or 
      (iCount lt 10 and index(ApplicationUser.LoginName, '_') gt 0) then
    do:
        put unformatted
            '~t'
            ApplicationUser.LoginName
            skip.
        iCount = iCount + 1.            
    end.
    
    if last-of(ApplicationUser.LoginDomain) then
        put unformatted skip(2).
end.

finally:
    output close.
end finally.