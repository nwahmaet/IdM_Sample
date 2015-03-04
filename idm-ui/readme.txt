Identity Management Sample: Setting up clients. There are 2 UI clients, an
    OpenEdge GUI for .NET desktop client, and a Web/HTML client. Each has its 
    own setup section
===========================================================================
0) In this document, 
    - $DLC refers to the location of your OE 11.2+ install
    - $WORKSPACE_ROOT refers to the folder where you installed this sample 

Desktop GUI for .NET client
----------------------------
0) The assemblies shipped in the idm-ui/Desktop/assemblies.xml file are for OE
   11.2+. If you're using another version of OE you will need to run the 
   $DLC/bin/updasmsref.exe tool to correct the references for that release.

1) Run idm-ui/start_desktop_ui.p via the available Run 
      Config ("start_desktop_ui").
      
2) Valid user names can be found in the users.txt file. All passwords are
   'letmein'.      
              
HTML/Web client
----------------------------
(http://karlsangabriel.com/2011/03/15/cgi-with-tomcat-7/)

 
1) Open idm-ui/cfg/ubroker.properties
    - replace $DLC with the location of your OE 11.2+ install
    - replace $WORKSPACE_ROOT with the folder where you installed this sample 

2) Run proenv and $DLC/bin/mergeprop.bat with the following arguments
    - mergeprop.bat -action update -type ubroker -delta $WORKSPACE_ROOT/idm-single/cfg/ubroker.properties
    
3) Start the WebSpeed broker  via OE Management/Explorer ("wsIdM") 
   or the command line (proenv -> wtbman -i wsIdM -x)
   
4) You will also need to have a webserver installed and configured for WebSpeed.
   Apache is recommended. The latest Windows version is
   2.2 and is available at http://httpd.apache.org/ . 
   
   In the Apache httpd.conf file, in the $APACHE/cfg folder, you should add
   a directive similar to the below.  
        ScriptAlias /cgi-bin/ "C:/Program Files (x86)/Apache Software Foundation/Apache2.2/cgi-bin/"
        
    You can also optionally add a directive to redirect index.html to the application's
    first page
        Redirect /IdM/index.html /IdM/customerlist.html

5) In Progress Developer Studio, set up an HTTP Server in the servers view. The 
   idm-ui project should already have a WebSpeed facet (Project > Properties > 
   Project Facets), but if not, one should be added.
   
   Make sure that the correct artifacts are being depployed to the HTTP server;
   in Project > Properties > Progress OpenEdge > Modules, you should see the 
   following setup:
		OpenEdge WebSpeed
		    idm-ui
		Static Web
		    idm-ui (OpenEdge Static Web)
		        Web\HTML
		        resources
    
    Note: there seems to be an issue in Dev Studio where the resource name doens't
          stick. Modify Static Web - idm-ui to be IdM and save. This is the folder 
          we'll publish to. 
          
6) In a Servers view, right-click the HTTP server and select the 'Clean' option.
   Say 'OK' to the question.          
 
7) You can now access the application at http://<YOUR-MACHINE-NAME>/IdM/customerlist.html.
    Note: You MUST use your machine name and NOT 'localhost' for the host name,
          since some browsers do not treat cookies from the localhost domain as
          expected or desired. This is especially if using the Chrome or Opera
          browser.
 
8) Valid user names can be found in the users.txt file. All passwords are
   'letmein'.      
 

.
@last-mod=13:36 Friday, October 12, 2012   