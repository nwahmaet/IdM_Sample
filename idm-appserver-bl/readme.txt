Identity Management Sample: Setting up the Separate Business Logic AppServer
===========================================================================

0) In this document, 
    - $DLC refers to the location of your OE 11.2+ install
    - $WORKSPACE_ROOT refers to the folder where you installed this sample 

1) Create a sports2000 database instance
    - In proenv, run prodb $WORKSPACE_ROOT/idm-appserver-bl/db/sports2000 sports2000 
    - Start a DB server 
    - Run idm-appserver-bl/db/load_sec-auth_tables.p via the available Run 
      Config ("Separate BL - load_sec-auth_tables").

    
2) Open idm-appserver-bl/cfg/ubroker.properties
    - Replace $DLC with the location of your OE 11.2+ install
    - Replace $WORKSPACE_ROOT with the folder where you installed this sample 

3) Run proenv and $DLC/bin/mergeprop.bat with the following arguments
    - mergeprop.bat -action update -type ubroker -delta $WORKSPACE_ROOT/idm-appserver-bl/cfg/ubroker.properties
    
4) Start the Business Logic Service AppServer via OE Management/Explorer ("asBusinessLogicService")
   or the command line (proenv -> asbman -i asBusinessLogicService -x)
    Note: The Security Token Service AppServer MUST be started before this AppServer can
          be started.
    Note: If this AppServer is to be used, then the single AppServer ("asBusinessAndSecurity")
          CANNOT be used.
              
 
.
@last-mod=13:36 Friday, October 12, 2012   