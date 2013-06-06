/*------------------------------------------------------------------------
    File        : load_sec-auth_tables.p
    Purpose     : Loads security domains and auth systems in a DB
    Author(s)   : pjudge
    Created     : Thu Sep 27 12:29:04 EDT 2012
    Notes       :  
  ----------------------------------------------------------------------*/
/** Main Block **/
define variable iLoop as integer no-undo.
define variable cDomainType as character no-undo.
define variable cDomainKey as character no-undo.
define variable cAppTableDomains as character extent 3 no-undo
    initial ['employee', 'customer', 'system'].

cDomainType = 'TABLE-ApplicationUser'.
cDomainKey = 'SuperSecretPasswordKeyThatNooneShouldEverSee4'.
 
run CreateSecurityAuthenticationSystem (
        cDomainType, 'Security/NoLoginAuthenticate.p'). /* callback */

do iLoop = 1 to extent(cAppTableDomains):
    run CreateSecurityAuthenticationDomain(
            cDomainType,
            cDomainKey,
            cAppTableDomains[iLoop]).
end.

/** Internal Procedures **/
procedure CreateSecurityAuthenticationSystem:
    define input parameter pcDomainType as character no-undo.
    define input parameter pcCallbackProcedure as character no-undo.
    
    if can-find(_sec-authentication-system where
        _sec-authentication-system._Domain-type eq pcDomainType) then
        return.
    
    create _sec-authentication-system.
    assign 
        _sec-authentication-system._Domain-type             = pcDomainType
        _sec-authentication-system._Domain-type-description = 'The ApplicationUser table serves as the authentication domain'
        _sec-authentication-system._PAM-plug-in             = not (pcCallbackProcedure eq '')
        _sec-authentication-system._PAM-callback-procedure  = pcCallbackProcedure
        .
end procedure.

procedure CreateSecurityAuthenticationDomain:
    define input parameter pcDomainType as character no-undo.
    define input parameter pcDomainKey as character no-undo.
    define input parameter pcDomainName as character no-undo.
    
    if can-find(_sec-authentication-domain where
                _sec-authentication-domain._Domain-name eq lc(pcDomainName)) then
        return.
    
    create _sec-authentication-domain.
    assign 
        _sec-authentication-domain._Domain-name        = lc(pcDomainName)
        _sec-authentication-domain._Domain-type        = pcDomainType
        _sec-authentication-domain._Domain-description = substitute('Authentication Domain for &1 users', pcDomainName)
        _sec-authentication-domain._Domain-access-code = audit-policy:encrypt-audit-mac-key(pcDomainKey + pcDomainName)
        _sec-authentication-domain._Domain-enabled     = true
        .
end procedure.
