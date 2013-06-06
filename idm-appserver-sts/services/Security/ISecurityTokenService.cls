/** ------------------------------------------------------------------------
    File        : ISecurityTokenService
    Purpose     : Defines the interface for the Security Token Service 
    @author pjudge
    Notes       : 
  ---------------------------------------------------------------------- */
interface Security.ISecurityTokenService:
    /** Logs a user into the application
        
        @param character The user's login nameW
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted. 
        @return character If the login succeeded, the context id of the logged-in
                user. */
    method public character LoginUser(input pcUserName as character,
                                      input pcUserDomain as character,
                                      input pcPassword as character).

    /** Logs a user into the application
        
        @param handle An unsealed Client-principal containing the user credentials. 
        @return character If the login succeeded, the context id of the logged-in
                user. */
    method public character LoginUser(input phCredentials as handle).
    
    /** Relogs a user into the application, after a timeout.
        
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted.
        @param character The current context context id. */
    method public void ReloginUser(input pcUserName as character,
                                   input pcUserDomain as character,
                                   input pcPassword as character,
                                   input pcContextId as character).
    
    /** Logs a user out of the application.
        
        @param character The user context ID. */
    method public void LogoutUser(input pcContextId as character).
    
    /** Validates a client-principal.
        
        @param handle A client-principal handle
        @return logical True if the token is valid */
    method public logical ValidateToken(input phClientPrincipal as handle).
    
    /** Validates a client-principal.
        
        @param handle An exported, BASE64-ENCODED client-principal 
        @return logical True if the token is valid */
    method public logical ValidateToken(input pcClientPrincipal as longchar).
    
    /** Returns the client-principal corresponding to an existing context id,
        if one exists.  
        
        @param character A client's context id
        @return handle A valid client-principal */
    method public handle GetClientPrincipal(input pcContextId as character).
    
    /** Registers a named server as being able to perform operations against the
        Secure Token Service. 
        
        @param character A server name
        @return character A token representing the registered server instance */
    method public character RegisterServer(input pcName as character).
    
    /** unregisters a server from being able to perform operations.
        
        @param character A server token. */
    method public void DeregisterServer(input pcServerToken as character).
        
end interface.