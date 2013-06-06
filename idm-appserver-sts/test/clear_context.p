/*------------------------------------------------------------------------
    File        : clear_context.p
    Purpose     : 
    Author(s)   : pjudge
    Notes       :
  ----------------------------------------------------------------------*/
define variable hCP as handle no-undo.

current-window:width-chars = 256.
for each SecurityContext:
    create client-principal hCP.
    hCP:import-principal(SecurityContext.ClientPrincipal).
    
    displ
        SecurityContext.LastAccess 
        hCP:session-id form 'x(40)'
        hCp:user-id form 'x(40)'
        hCP:login-state form 'x(20)' 
        hcp:login-expiration-timestamp
        with width 255.
    
end.