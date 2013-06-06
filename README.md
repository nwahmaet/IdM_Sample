Identity Management AppServer Sample
=====================================

Introduction
------------
This repository contains sample code for a simple Security Token Service (STS) for an OpenEdge AppServer. It also contains clients that use the STS. These clients are another AppServer containing business logic, and GUI client.


Folder structure
------------
All of the folders below contain a readme.txt which describes in detail how to set them up. Each of these folders also contains a .project file, for easy import into Eclipse/PDSOE
+ idm-appserver-sts: Contains code, database and related stuff for the STS
+ idm-appserver-bl: Contains code, database and related stuff for the business logic. Based on the Sports2000 db, with modifications
+ idm-ui: Contains code and related bits for the desktop and web UI's. The web UI uses WebSpeed.

Setup & Install Prerequisites
-------------
1) OpenEdge Release 11.2, ideally. 11.0.0 can work, although needs extra steps, particularly for the Desktop UI. See the relevant readme.txt for more information.
   
   This sample requires Progress Developer Studio (in particular, AppServer and
   WebSpeed).

2) An HTTP server. Apache is recommended. The latest Windows version is
   2.2 and is available at http://httpd.apache.org/ .
   
   This web server needs to be configured for use with WebSpeed. 
   
Installation & Setup:
---------------------    
0) Start Progress Developer Studio and select a workspace path. You can use a
   new workspace or reuse an existing one.
   
1) Import the projects used. Select File > Import > Existing Projects into Workspace,
   and select the 'Select archive file' option. Select the root folder into which this repository has been cloned and select all of the available projects, including the 'Servers' project.
   
2) Each of the projects has a readme.txt in it that describes how to set that 
   project up. The idm-appserver-bl and idm-appserver-sts projects 
   have associated databases. Once these are set up, they should be added to 
   their respective projects via the Project > Properties > Progress OpenEdge >
   Database Connections dialog and the 'Configure database connections' link.

3) Set up the runtime environment for the HTTP server. Open the Window > 
   Preferences > Server > Runtime Environments page, and Add a new environment.
   Select Basic > HTTP Server. Add the Publishing Directory. For Apache on 64-bit
   Windows 7, this defaults to 
   C:\Program Files (x86)\Apache Software Foundation\Apache2.2\htdocs. You should,
   of course, select the WWW root.
   
   You can now publish to this HTTP server via the context menu (right-click) and
   selecting Publish or Clean.

