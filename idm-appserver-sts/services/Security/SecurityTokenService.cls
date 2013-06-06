/** ------------------------------------------------------------------------
    File        : SecurityTokenService
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:54:05 EDT 2010
    Notes       : * http://msdn.microsoft.com/en-us/magazine/dd278426.aspx
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using Security.ISecurityTokenService.
using Security.SecurityTokenService.

using Progress.Lang.AppError.

class Security.SecurityTokenService implements ISecurityTokenService:
    /** Random, unique key for sealing the client-principals used to identify the registered servers */
    define static private property SecureTokenServiceDomainKey as character no-undo get. set.
    
    /** makes this service into a singleton (cf. http://en.wikipedia.org/wiki/Singleton_pattern) */
    define static public property Instance as ISecurityTokenService no-undo get. private set.
    
    constructor static SecurityTokenService():  
        Security.SecurityTokenService:SecureTokenServiceDomainKey = base64-encode(generate-random-key).
        Security.SecurityTokenService:Instance = new Security.SecurityTokenService().
    end constructor.

    constructor private SecurityTokenService():
        /* private default ctor for singleton purposes. */
    end constructor. 
    
    /** Logs a user into the application
        
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted. 
        @return character If the login succeeded, the context id of the logged-in
                user. */
    method public character LoginUser(input pcUserName as character,
                                      input pcUserDomain as character,
                                      input pcPassword as character):
        define variable hClientPrincipal as handle no-undo.
        
        create client-principal hClientPrincipal.
        hClientPrincipal:initialize(
            substitute('&1@&2', pcUserName, pcUserDomain),  /* qualified username */
            guid,   /* unique session id*/
            add-interval(now, 8, 'hours'),  /* default timeout/expiration */
            pcPassword).
        
        return AuthenticateCredentials(hClientPrincipal).
    end method.

    /** Logs a user into the application
        
        @param handle An unsealed Client-principal containing the user credentials. 
        @return character If the login succeeded, the context id of the logged-in
                user. */
    method public character LoginUser(input phCredentials as handle):
        /* set the session id to a new guid n case this C-P came from a client.
           we want to make sure we return a completely unique C-P to prevent 
           spoofing */
        phCredentials:session-id = guid.
        
        return AuthenticateCredentials(phCredentials).
    end method.
    
    /** Relogs a user into the application, after a timeout.
        
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted.
        @param longchar The current context context id. */
    method public void ReloginUser(input pcUserName as character,
                                   input pcUserDomain as character,
                                   input pcPassword as character,
                                   input pcContextId as character):
        define variable hClientPrincipal as handle no-undo.
                                           
        /* validate that we're not being spoofed */
        hClientPrincipal = GetClientPrincipal(pcContextId).
        if not valid-handle(hClientPrincipal) then
            undo, throw new AppError('No existing session for re-login'). 
        
        /* if the session is already logged on, then error */
        if hClientPrincipal:login-state eq 'login' then
            undo, throw new AppError('User still logged in').
        
        create client-principal hClientPrincipal.
        hClientPrincipal:initialize(
            substitute('&1@&2', pcUserName, pcUserDomain),  /* qualified username */
            pcContextId,   /* re-use the old unique session id */
            add-interval(now, 8, 'hours'),  /* timeout/expiration */
            pcPassword).
        
        AuthenticateCredentials(hClientPrincipal).    
    end method.
    
    /** Worker method for performing user login off a C-P

        @param handle The unsealed client-principal
        @return character If the login succeeded, the context id of the logged-in
                user. */
    method private character AuthenticateCredentials(input phCredentials as handle):
        /* passes authentication work off to authentication system */    
        security-policy:set-client(phCredentials).
        
        /* writes security context into DB */
        WriteClientPrincipalToStore(phCredentials).
        
        return phCredentials:session-id.
    end method.    
    
    /** Logs a user out of the application.
        
        @param character The user context ID. */
    method public void LogoutUser(input pcContextId as character):
        define variable hClientPrincipal as handle no-undo.
        
        hClientPrincipal = GetClientPrincipal(pcContextId).
        if valid-handle(hClientPrincipal) then
            hClientPrincipal:logout().
        
        RemoveClientPrincipalFromStore(pcContextId).
    end method.
    
    /** Validates a client-principal.
        
        @param handle A client-principal handle
        @return logical True if the token is valid */
    method public logical ValidateToken(input phClientPrincipal as handle):
        case phClientPrincipal:domain-name:
            /* special case: this STS acts as its own domain for registered servers */
            when 'Security.SecurityTokenService' then
                phClientPrincipal:validate-seal(Security.SecurityTokenService:SecureTokenServiceDomainKey).
            /* validates against the C-P's domain in the session domain registry */
            otherwise
                phClientPrincipal:validate-seal().
        end case.
        
        /* if an error is thrown, we won't get here. */
        return true.
    end method.
    
    /** Validates a client-principal.
        
        @param handle An exported, BASE64-ENCODED client-principal 
        @return logical True if the token is valid */
    method public logical ValidateToken(input pcClientPrincipal as longchar):
        define variable hClientPrincipal as handle no-undo.
        define variable rClientPrincipal as raw no-undo.
        
        rClientPrincipal = base64-decode(pcClientPrincipal).
        
        create client-principal hClientPrincipal.
        hClientPrincipal:import-principal(rClientPrincipal).
        
        return ValidateToken(hClientPrincipal).        
    end method.
    
    /** Returns the client-principal corresponding to an existing context id,
        if one exists.  
        
        @param character A client's context id
        @return handle A valid client-principal */
    method public handle GetClientPrincipal(input pcContextId as character):
        define variable hClientPrincipal as handle no-undo.
        define variable rClientPrincipal as raw no-undo.
        
        define buffer lbSecurityContext for SecurityContext.
        
        /* scope this transaction as small as possible */
        do for lbSecurityContext transaction:
            find lbSecurityContext where 
                 lbSecurityContext.SessionId eq pcContextId
                 exclusive-lock no-wait no-error.
            if not available lbSecurityContext then
                undo, throw new AppError('Context does not exist').
            assign rClientPrincipal = lbSecurityContext.ClientPrincipal
                   lbSecurityContext.LastAccess = now.
        end.
        
        create client-principal hClientPrincipal.
        hClientPrincipal:import-principal(rClientPrincipal).
        
        return hClientPrincipal.
    end method.
    
    /** Adds a security context to the SecurityContext table. 
        
        @param handle A client-principal object (any state) */
    method protected void WriteClientPrincipalToStore(input phClientPrincipal as handle):
        define buffer lbSecurityContext for SecurityContext.
        
        /* scope this transaction as small as possible */
        do for lbSecurityContext transaction:
            find lbSecurityContext where 
                 lbSecurityContext.SessionId eq phClientPrincipal:session-id
                 exclusive-lock no-wait no-error.
            if not available lbSecurityContext then
            do:
                create lbSecurityContext.
                lbSecurityContext.SessionId = phClientPrincipal:session-id.
            end.
            assign lbSecurityContext.ClientPrincipal = phClientPrincipal:export-principal()
                   lbSecurityContext.LastAccess = now.
        end.
    end method.
    
    /** Removes stored security context from the SecurityContext table. 
        
        @param character A client's context id */
    method protected void RemoveClientPrincipalFromStore(input pcContextId as character):
        define buffer lbSecurityContext for SecurityContext.
        
        /* scope this transaction as small as possible */
        do for lbSecurityContext transaction:
            find lbSecurityContext where
                 lbSecurityContext.SessionId eq pcContextId
                 exclusive-lock no-wait no-error.
            if available lbSecurityContext then
                delete lbSecurityContext.
        end.
    end method.
    
    /** Registers a named server as being able to perform operations against the
        Secure Token Service.
        
        @param character A server name
        @return character A token representing the registered server instance */
    method public character RegisterServer(input pcName as character):
        define variable hClientPrincipal as handle no-undo.
        
        define buffer lbSecurityContext for SecurityContext.
        
        create client-principal hClientPrincipal.
        hClientPrincipal:user-id = pcName.
        hClientPrincipal:domain-name = 'Security.SecurityTokenService'.
        hClientPrincipal:session-id = guid.
        
        hClientPrincipal:seal(Security.SecurityTokenService:SecureTokenServiceDomainKey).
        
        WriteClientPrincipalToStore(hClientPrincipal).
        
        return hClientPrincipal:session-id.
    end method.
    
    /** unregisters a server from being able to perform operations.
        
        @param character A server token. */
    method public void DeregisterServer(input pcServerToken as character):
        RemoveClientPrincipalFromStore(pcServerToken).
    end method.
    
end class.