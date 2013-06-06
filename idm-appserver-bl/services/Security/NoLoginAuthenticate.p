using Progress.Security.PAMStatus.

procedure AuthenticateUser:
    /* a handle to the Client-Principal object containing the user�s identity 
       information. This is the object that was passed into the SET-DB-CLIENT()
       function or SECURITY-POLICY:SET-CLIENT() method. */
    define input parameter phClientPrincipal as handle no-undo.
    
    /* a character array holding the plug-in �System options� configured for 
       the domain. This is taken from the authentication domain configuration,
       and it is user-defined 
       
       The �System options� array will contain any options defined in the 
       authentication domain record for the domain set in the Client-Principal.
       The values in it are user-defined and contextual to the callback and the
       only requirement is on what format they should follow. They must follow
       the startup parameter syntax, where a parameter is always pre-fixed with
       dash (-) and an optional argument can be specified. Each token must 
       separated by a space character (for example, -myparam1 �myparam2 value2).
       Each element of the array will contain a single parameter followed by an
       argument (if one was specified) as defined in _sec-authentication-domain
       record.  If the value specified in the �System Options� field does not 
       meet the requirement, you will get a configuration error when you try to
       authenticate the user using that domain. There are two options reserved
       by OpenEdge so that it can tell the callback whether the application is
       authenticating the user for the session or for an OpenEdge database 
       connection. The options are:
            -setClient: this is present if the application is executing 
                        SECURITY-POLICY:SET-CLIENT() during authentication,
                        and if we are setting the credentials for the session
                        during the �AfterSetIdentity� operation.
            -db <logical-db-name>: this the logical database name that is being
                        processed by SET-DB-CLIENT() or the CONNECT statement, 
                        or if we are trying to set the credentials for a 
                        database connection while executing 
                        SECURITY-POLICY:SET-CLIENT().               */
    define input parameter pcSystemOptions as character extent no-undo.
    
    /* an integer status code returned to the ABL runtime to inform whether the
       action succeeded or not. This should be one of the pre-defined values
       represented by the members of Progress.Security.PAMStatus.
       If a status code other than Success is returned from �AuthenticateUser�,
       the authentication process ends with failure, and the AVM does not 
       process the next actions. */
    define output parameter piPAMStatus as integer init ? no-undo.
    
    /* You can specify your own user-defined error message that is used in the 
       error message generated by SET-DB-CLIENT or SET-CLIENT(), if the return
       status (iPAMStatus) is a specific status code (Custom). The error can be
       suppressed with NO-ERROR and queried with the ERROR-STATUS system 
       handle. If you don�t return the Custom status code, the error message 
       set in this parameter is ignored and a default error message based on
       the return status is displayed, as it happens today with the built-in
       plug-ins. */
    define output parameter pcErrorMsg as character no-undo.
    
    /* we're not allowed to do any logins here */
    piPAMStatus = PAMStatus:InvalidConfiguration.
    return.
end.

procedure AfterSetIdentity:
    /* a handle to the Client-Principal object containing the user�s identity 
       information. This is the object that was passed into the SET-DB-CLIENT()
       function or SECURITY-POLICY:SET-CLIENT() method. */
    define input parameter phClientPrincipal  as handle no-undo.
    
    /* a character array holding the plug-in �System options� configured for 
       the domain. This is taken from the authentication domain configuration,
       and it is user-defined 
       
       The �System options� array will contain any options defined in the 
       authentication domain record for the domain set in the Client-Principal.
       The values in it are user-defined and contextual to the callback and the
       only requirement is on what format they should follow. They must follow
       the startup parameter syntax, where a parameter is always pre-fixed with
       dash (-) and an optional argument can be specified. Each token must 
       separated by a space character (for example, -myparam1 �myparam2 value2).
       Each element of the array will contain a single parameter followed by an
       argument (if one was specified) as defined in _sec-authentication-domain
       record.  If the value specified in the �System Options� field does not 
       meet the requirement, you will get a configuration error when you try to
       authenticate the user using that domain. There are two options reserved
       by OpenEdge so that it can tell the callback whether the application is
       authenticating the user for the session or for an OpenEdge database 
       connection. The options are:
            -setClient: this is present if the application is executing 
                        SECURITY-POLICY:SET-CLIENT() during authentication,
                        and if we are setting the credentials for the session
                        during the �AfterSetIdentity� operation.
            -db <logical-db-name>: this the logical database name that is being
                        processed by SET-DB-CLIENT() or the CONNECT statement, 
                        or if we are trying to set the credentials for a 
                        database connection while executing 
                        SECURITY-POLICY:SET-CLIENT().               */
    define input parameter pcSystemOptions as character extent no-undo.

    /* no-op here. we trust that the STS has done its job */
end.