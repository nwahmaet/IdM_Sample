/*------------------------------------------------------------------------
    File        : load_users.p
    Purpose     : Creates user credential records from Sports2000 data. 
    Author(s)   : pjudge
    Notes       : * You must be connected to Sports2000 to load the users.
                    Do not connect to Sports2000 for runtime use in the STS
                  * There are 3 domains that use this authentication system:
                        employee, customer, system.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define variable cLoginName   as character no-undo.
define variable cDomain      as character no-undo.
define variable iLoop        as integer   no-undo.
define variable iMax         as integer   no-undo.
define variable cPassword    as character no-undo.
define variable cUsers       as character extent no-undo.

define buffer lbUser      for ApplicationUser.

cPassword = 'letmein'.

cDomain  = 'customer'.
for each Customer no-lock:
    cLoginName = entry(1, Customer.Name, ' ').
    
    if can-find(lbUser where lbUser.LoginDomain = cDomain and lbUser.LoginName = cLoginName) then
        assign cLoginName = replace(lc(Customer.Name), ' ', '_')
            cLoginName = replace(cLoginName, '__', '_')
            cLoginName = replace(cLoginName, '.', '').
    
    /* allow for reloads */
    if can-find(ApplicationUser where
        ApplicationUser.LoginDomain eq cDomain and
        ApplicationUser.LoginName eq cLoginName) then next. 
    
    create ApplicationUser.
    assign 
        ApplicationUser.LoginDomain        = lc(cDomain)
        ApplicationUser.LoginName          = lc(cLoginName)
        ApplicationUser.Password           = encode(cPassword)
        .
end.

cDomain  = 'employee'.
for each Employee no-lock,
    first Department where Department.DeptCode = Employee.DeptCode no-lock:
    
    cLoginName = Employee.FirstName + '_' + Employee.LastName.
    if can-find(lbUser where lbUser.LoginDomain eq cDomain and lbUser.LoginName eq cLoginName) then
        cLoginName = cLoginName + substitute('-&1-&2', Employee.EmpNum, Department.DeptCode).
    
    /* allow for reloads */
    if can-find(ApplicationUser where
        ApplicationUser.LoginDomain eq cDomain and
        ApplicationUser.LoginName eq cLoginName) then next. 
    
    create ApplicationUser.
    assign 
        ApplicationUser.LoginDomain = lc(cDomain)
        ApplicationUser.LoginName   = lc(cLoginName)
        ApplicationUser.Password    = encode(cPassword)
        .
end.

/* whole-system-level system users */
cDomain  = 'system'.
extent(cUsers) = 3.
cUsers[1] = 'administrator'.
cUsers[2] = 'agent'.
cUsers[3] = 'batch'.

do iLoop = 1 to extent(cUsers):
    /* allow for reloads */
    if can-find(ApplicationUser where
                ApplicationUser.LoginDomain eq lc(cDomain) and
                ApplicationUser.LoginName eq lc(cUsers[iLoop]) ) then next. 
    
    create ApplicationUser.
    assign ApplicationUser.LoginDomain = lc(cDomain)
           ApplicationUser.LoginName = lc(cUsers[iLoop])
           ApplicationUser.Password = encode(cPassword)
           .
end.