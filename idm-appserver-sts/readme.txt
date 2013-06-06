Identity Management Sample: Setting up the Separate Security Token Service AppServer
===========================================================================

0) In this document, 
    - $DLC refers to the location of your OE 11.2+ install
    - $WORKSPACE_ROOT refers to the folder where you installed this sample 

1) Create a Security database instance
    - In proenv, run prodb $WORKSPACE_ROOT/idm-appserver-sts/db/security empty 
    - Start a DB server
    - Using the Data Dictionary, load the $WORKSPACE_ROOT/idm-appserver-sts/db/security.df 
    - Run idm-appserver-sts/db/load_sec-auth_tables.p via the available Run 
      Config ("Separate STS - load_sec-auth_tables").
    - Run idm-appserver-sts/db/load_users.p via the available Run Config (
       "Separate STS - load_users.p").
    
    
2) Open idm-appserver-sts/cfg/ubroker.properties
    - replace $DLC with the location of your OE 11.2+ install
    - replace $WORKSPACE_ROOT with the folder where you installed this sample 

3) Run proenv and $DLC/bin/mergeprop.bat with the following arguments
    - mergeprop.bat -action update -type ubroker -delta $WORKSPACE_ROOT/idm-appserver-sts/cfg/ubroker.properties
    
4) Start the Security Token Service AppServer via OE Management/Explorer ("asSecurityTokenService")
   or the command line (proenv -> asbman -i asSecurityTokenService -x)
    Note: The Security Token Service AppServer MUST be started first, before the
          Business Logic AppServer can be started.
    Note: If this AppServer is to be used, then the single AppServer ("asBusinessAndSecurity")
          CANNOT be used.

.
@last-mod=13:36 Friday, October 12, 2012             