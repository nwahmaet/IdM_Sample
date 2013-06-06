/** ------------------------------------------------------------------------
    File        : MainForm
    Purpose     :
    Syntax      :
    Description :
    @author pjudge
    Created     : Wed Jul 07 11:55:28 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using Desktop.HelpAbout.
using Desktop.LoginPanel.
using Desktop.TagWrapper.
using Desktop.LightboxForm.

using Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup.
using Infragistics.Win.UltraWinTabbedMdi.MdiTab.
using Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarItem.
using Infragistics.Win.Appearance.
using Infragistics.Win.UltraWinToolbars.ToolBase.
using Infragistics.Win.UltraWinToolbars.ButtonTool.
using System.Windows.Forms.DialogResult.
using System.Drawing.Point.
using System.Windows.Forms.FormClosedEventArgs.
using System.EventArgs.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Windows.Form.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Class.
using Progress.Lang.Object.

class Desktop.MainForm inherits Form :
    {Desktop/dsCustomerOrder.i}
    
    define private variable bsCustomer as Progress.Data.BindingSource no-undo.
    define private variable bsOrder as Progress.Data.BindingSource no-undo.
    define private variable imageListSmall as System.Windows.Forms.ImageList no-undo.
    define private variable imageListLarge as System.Windows.Forms.ImageList no-undo.
    define private variable m_MainForm_Toolbars_Dock_Area_Top as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea  no-undo.
    define private variable m_MainForm_Toolbars_Dock_Area_Right as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea  no-undo.
    define private variable m_MainForm_Toolbars_Dock_Area_Left as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea  no-undo.
    define private variable m_MainForm_Toolbars_Dock_Area_Bottom as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea  no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable splitter1 as System.Windows.Forms.Splitter no-undo.
    define private variable ultraTabbedMdiManager1 as Infragistics.Win.UltraWinTabbedMdi.UltraTabbedMdiManager no-undo.
    define private variable ultraToolbarsManager1 as Infragistics.Win.UltraWinToolbars.UltraToolbarsManager   no-undo.
    define private variable uxCustomer as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.
    define private variable uxOrders as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.
    define private variable uxStatus as Infragistics.Win.UltraWinStatusBar.UltraStatusBar        no-undo.
    
    define protected property Servers as JsonObject get. set.
    define protected property UserContextId as character no-undo get. set.
    define private variable mhTransportDataset as handle no-undo.
    
    define private query qryCustomer for ttCustomer scrolling.
    define private query qryOrder for ttOrder scrolling.
    
    /** constructors and other boilerplate */
    constructor public MainForm():
        super().
        
        InitializeComponent().
        
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

    destructor public MainForm ( ):
        define variable iLoop as integer no-undo.
        define variable cNames as character extent no-undo.
        define variable hAppServer as handle no-undo.
        define variable oServer as JsonObject no-undo.
    
        cNames = this-object:Servers:GetNames().
        do iLoop = 1 to extent(cNames):
            oServer = this-object:Servers:GetJsonObject(cNames[iLoop]).
            hAppServer = oServer:GetHandle('handle').
            
            if hAppServer:connected() then
                hAppServer:disconnect().
            delete object hAppServer no-error.
            hAppServer = ?.
            oServer:SetNull('handle').
        end.
        
        if valid-object(components) then 
        do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.
    
    method public void Initialize(input poServers as JsonObject):
        define variable oServer as JsonObject no-undo.
        define variable hAppServer as handle no-undo.
        define variable cToken as character no-undo.
        
        this-object:Servers = poServers.
        
        oServer = poServers:GetJsonObject('asBusinessLogicService').
        create server hAppServer.
        oServer:Set('handle', hAppServer).
        hAppServer:connect(substitute('-AppService asBusinessLogicService -H &1 -sessionModel &2',
                            oServer:GetCharacter('host'),
                            oServer:GetCharacter('sessionModel'))).
        /* Set the value to BLANK until login */    
        hAppServer:request-info:ClientContextId = ''.
        
        /** Connect to STS and register this server as a client */
        oServer = poServers:GetJsonObject('asSecurityTokenService').
        create server hAppServer.
        oServer:Set('handle', hAppServer).
        hAppServer:connect(substitute('-AppService asSecurityTokenService -H &1 -sessionModel &2',
                            oServer:GetCharacter('host'),
                            oServer:GetCharacter('sessionModel'))).
        
        /* we need to register as a client as only login and register are freebies, and we
           want to logout too */
        run Security/RegisterServer.p on hAppServer (
            input substitute('MainFormUI::&1', guid),
            output cToken).
        
        /* this value will now be passed to and fro on every request */    
        hAppServer:request-info:ClientContextId = cToken.
        
        ResetUI().
    end method.
    
    method private void ResetUI():
        define variable cTool as character extent no-undo.
        
        uxStatus:Panels['username']:Text = ''.
        uxStatus:Panels['ccid']:Text = ''.
        uxStatus:Panels['domain']:Text = ''.
        
        dataset dsCustomerOrder:empty-dataset().
        
        open query qryCustomer preselect each ttCustomer by ttCustomer.CustNum.
        bsCustomer:Handle = query qryCustomer:handle.

        open query qryOrder preselect each ttOrder by ttOrder.OrderNum.
        bsOrder:Handle = query qryOrder:handle.
        
        extent(cTool) = ?.
        extent(cTool) = 1.
        cTool[1] = 'Login'.
        SetToolState(cTool, true).

        extent(cTool) = ?.
        extent(cTool) = 1.
        cTool[1] = 'Logout'.
        SetToolState(cTool, false).
    end method.

    method private void InitializeComponent(  ):

        /* NOTE: The following method is automatically generated.

        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.

        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("Desktop.MainForm").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraToolbar1 as Infragistics.Win.UltraWinToolbars.UltraToolbar no-undo.
        ultraToolbar1 = new Infragistics.Win.UltraWinToolbars.UltraToolbar("UltraToolbar1").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool8 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool8 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Login").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool15 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool15 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Logout").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool3 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool3 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshCustomerList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool16 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool16 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Help").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool2 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool2 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Help").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance19 as Infragistics.Win.Appearance no-undo.
        appearance19 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool11 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool11 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Login").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance20 as Infragistics.Win.Appearance no-undo.
        appearance20 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance21 as Infragistics.Win.Appearance no-undo.
        appearance21 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool13 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool13 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Logout").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool1 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool1 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshCustomerList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance22 as Infragistics.Win.Appearance no-undo.
        appearance22 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance23 as Infragistics.Win.Appearance no-undo.
        appearance23 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel1 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel1 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel2 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel2 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel3 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel3 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel4 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel4 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel5 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel5 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel6 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel6 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel7 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel7 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel8 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel8 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance13 as Infragistics.Win.Appearance no-undo.
        appearance13 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand2 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand2 = new Infragistics.Win.UltraWinGrid.UltraGridBand("ttCustomer", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn1 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn1 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn2 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn2 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Name").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn3 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn3 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Address").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn4 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn4 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Phone").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn5 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn5 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SalesRep").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn6 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn6 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Balance").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance14 as Infragistics.Win.Appearance no-undo.
        appearance14 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance15 as Infragistics.Win.Appearance no-undo.
        appearance15 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance16 as Infragistics.Win.Appearance no-undo.
        appearance16 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance17 as Infragistics.Win.Appearance no-undo.
        appearance17 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance18 as Infragistics.Win.Appearance no-undo.
        appearance18 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc2 as Progress.Data.TableDesc no-undo.
        tableDesc2 = new Progress.Data.TableDesc("ttCustomer").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance1 as Infragistics.Win.Appearance no-undo.
        appearance1 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand1 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand1 = new Infragistics.Win.UltraWinGrid.UltraGridBand("ttOrder", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn7 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn7 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Ordernum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn8 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn8 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn9 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn9 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn10 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn10 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SalesRep").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn11 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn11 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderStatus").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance2 as Infragistics.Win.Appearance no-undo.
        appearance2 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance3 as Infragistics.Win.Appearance no-undo.
        appearance3 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance4 as Infragistics.Win.Appearance no-undo.
        appearance4 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance5 as Infragistics.Win.Appearance no-undo.
        appearance5 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance6 as Infragistics.Win.Appearance no-undo.
        appearance6 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance7 as Infragistics.Win.Appearance no-undo.
        appearance7 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance8 as Infragistics.Win.Appearance no-undo.
        appearance8 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance9 as Infragistics.Win.Appearance no-undo.
        appearance9 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance10 as Infragistics.Win.Appearance no-undo.
        appearance10 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance11 as Infragistics.Win.Appearance no-undo.
        appearance11 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance12 as Infragistics.Win.Appearance no-undo.
        appearance12 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("ttOrder").
        this-object:imageListLarge = new System.Windows.Forms.ImageList(this-object:components).
        this-object:ultraToolbarsManager1 = new Infragistics.Win.UltraWinToolbars.UltraToolbarsManager(this-object:components).
        this-object:imageListSmall = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxStatus = new Infragistics.Win.UltraWinStatusBar.UltraStatusBar().
        this-object:m_MainForm_Toolbars_Dock_Area_Left = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_MainForm_Toolbars_Dock_Area_Right = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_MainForm_Toolbars_Dock_Area_Top = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:ultraTabbedMdiManager1 = new Infragistics.Win.UltraWinTabbedMdi.UltraTabbedMdiManager(this-object:components).
        this-object:splitter1 = new System.Windows.Forms.Splitter().
        this-object:uxCustomer = new Infragistics.Win.UltraWinGrid.UltraGrid().
        this-object:bsCustomer = new Progress.Data.BindingSource(this-object:components).
        this-object:uxOrders = new Infragistics.Win.UltraWinGrid.UltraGrid().
        this-object:bsOrder = new Progress.Data.BindingSource(this-object:components).
        cast(this-object:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxStatus, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:ultraTabbedMdiManager1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxCustomer, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bsCustomer, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxOrders, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bsOrder, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* imageListLarge */
        /*  */
        this-object:imageListLarge:ImageStream = cast(resources:GetObject("imageListLarge.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageListLarge:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageListLarge:Images:SetKeyName(0, "date_error_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(1, "date_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(2, "system_emblem_32x29.png").
        this-object:imageListLarge:Images:SetKeyName(3, "cog_go32x32.png").
        this-object:imageListLarge:Images:SetKeyName(4, "date_go_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(5, "connect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(6, "disconnect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(7, "server_connect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(8, "help_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(9, "exclamation_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(10, "basket_go_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(11, "basket_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(12, "process_remove_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(13, "process_start_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(14, "assigned_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(15, "available_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(16, "process_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(17, "order_add_32x32.png").
        /*  */
        /* ultraToolbarsManager1 */
        /*  */
        this-object:ultraToolbarsManager1:AlwaysShowMenusExpanded = Infragistics.Win.DefaultableBoolean:True.
        this-object:ultraToolbarsManager1:DesignerFlags = 1.
        this-object:ultraToolbarsManager1:DockWithinContainer = this-object.
        this-object:ultraToolbarsManager1:DockWithinContainerBaseType = Progress.Util.TypeHelper:GetType("Progress.Windows.Form").
        this-object:ultraToolbarsManager1:ImageListLarge = this-object:imageListLarge.
        this-object:ultraToolbarsManager1:ImageListSmall = this-object:imageListSmall.
        this-object:ultraToolbarsManager1:ImageSizeLarge = new System.Drawing.Size(24, 24).
        this-object:ultraToolbarsManager1:ShowFullMenusDelay = 500.
        ultraToolbar1:DockedColumn = 0.
        ultraToolbar1:DockedRow = 0.
        buttonTool16:InstanceProps:IsFirstInGroup = true.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as Infragistics.Win.UltraWinToolbars.ToolBase extent 4 no-undo.
        arrayvar0[1] = buttonTool8.
        arrayvar0[2] = buttonTool15.
        arrayvar0[3] = buttonTool3.
        arrayvar0[4] = buttonTool16.
        ultraToolbar1:NonInheritedTools:AddRange(arrayvar0).
        ultraToolbar1:Settings:AllowCustomize = Infragistics.Win.DefaultableBoolean:False.
        ultraToolbar1:Settings:AllowFloating = Infragistics.Win.DefaultableBoolean:False.
        ultraToolbar1:Settings:FillEntireRow = Infragistics.Win.DefaultableBoolean:True.
        ultraToolbar1:Settings:ToolDisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        ultraToolbar1:Text = "UltraToolbar1".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Infragistics.Win.UltraWinToolbars.UltraToolbar extent 1 no-undo.
        arrayvar1[1] = ultraToolbar1.
        this-object:ultraToolbarsManager1:Toolbars:AddRange(arrayvar1).
        this-object:ultraToolbarsManager1:ToolbarSettings:UseLargeImages = Infragistics.Win.DefaultableBoolean:True.
        appearance19:Image = 8.
        buttonTool2:SharedPropsInternal:AppearancesSmall:Appearance = appearance19.
        buttonTool2:SharedPropsInternal:Caption = "Help".
        buttonTool2:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        appearance20:Image = cast(resources:GetObject("appearance20.Image"), System.Object).
        buttonTool11:SharedPropsInternal:AppearancesLarge:Appearance = appearance20.
        appearance21:Image = cast(resources:GetObject("appearance21.Image"), System.Object).
        buttonTool11:SharedPropsInternal:AppearancesSmall:Appearance = appearance21.
        buttonTool11:SharedPropsInternal:Caption = "Login".
        buttonTool13:SharedPropsInternal:Caption = "Logout".
        appearance22:Image = cast(resources:GetObject("appearance22.Image"), System.Object).
        buttonTool1:SharedPropsInternal:AppearancesLarge:Appearance = appearance22.
        appearance23:Image = cast(resources:GetObject("appearance23.Image"), System.Object).
        buttonTool1:SharedPropsInternal:AppearancesSmall:Appearance = appearance23.
        buttonTool1:SharedPropsInternal:Caption = "Refresh Customer List".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Infragistics.Win.UltraWinToolbars.ToolBase extent 4 no-undo.
        arrayvar2[1] = buttonTool2.
        arrayvar2[2] = buttonTool11.
        arrayvar2[3] = buttonTool13.
        arrayvar2[4] = buttonTool1.
        this-object:ultraToolbarsManager1:Tools:AddRange(arrayvar2).
        this-object:ultraToolbarsManager1:ToolClick:Subscribe(this-object:ultraToolbarsManager1_ToolClick).
        /*  */
        /* imageListSmall */
        /*  */
        this-object:imageListSmall:ImageStream = cast(resources:GetObject("imageListSmall.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageListSmall:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageListSmall:Images:SetKeyName(0, "date_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(1, "date_error_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(2, "system_emblem_16x15.png").
        this-object:imageListSmall:Images:SetKeyName(3, "date_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(4, "cog_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(5, "server_connect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(6, "connect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(7, "disconnect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(8, "help_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(9, "exclamation_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(10, "basket_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(11, "basket_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(12, "process_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(13, "process_remove_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(14, "process_start_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(15, "assigned_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(16, "available_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(17, "order_add_16x16.png").
        /*  */
        /* uxStatus */
        /*  */
        this-object:uxStatus:Location = new System.Drawing.Point(0, 530).
        this-object:uxStatus:Name = "uxStatus".
        ultraStatusPanel1:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel1:Text = "User:".
        ultraStatusPanel2:Key = "username".
        ultraStatusPanel2:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Spring.
        ultraStatusPanel3:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel3:Text = "CCID:".
        ultraStatusPanel4:Key = "ccid".
        ultraStatusPanel4:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Spring.
        ultraStatusPanel5:Text = "Domain:".
        ultraStatusPanel6:Key = "domain".
        ultraStatusPanel6:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Spring.
        ultraStatusPanel7:Style = Infragistics.Win.UltraWinStatusBar.PanelStyle:Date.
        ultraStatusPanel8:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel8:Style = Infragistics.Win.UltraWinStatusBar.PanelStyle:Time.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel extent 8 no-undo.
        arrayvar3[1] = ultraStatusPanel1.
        arrayvar3[2] = ultraStatusPanel2.
        arrayvar3[3] = ultraStatusPanel3.
        arrayvar3[4] = ultraStatusPanel4.
        arrayvar3[5] = ultraStatusPanel5.
        arrayvar3[6] = ultraStatusPanel6.
        arrayvar3[7] = ultraStatusPanel7.
        arrayvar3[8] = ultraStatusPanel8.
        this-object:uxStatus:Panels:AddRange(arrayvar3).
        this-object:uxStatus:Size = new System.Drawing.Size(974, 23).
        this-object:uxStatus:TabIndex = 0.
        this-object:uxStatus:Text = "ultraStatusBar1".
        /*  */
        /* m_MainForm_Toolbars_Dock_Area_Left */
        /*  */
        this-object:m_MainForm_Toolbars_Dock_Area_Left:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_MainForm_Toolbars_Dock_Area_Left:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_MainForm_Toolbars_Dock_Area_Left:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Left.
        this-object:m_MainForm_Toolbars_Dock_Area_Left:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_MainForm_Toolbars_Dock_Area_Left:Location = new System.Drawing.Point(0, 35).
        this-object:m_MainForm_Toolbars_Dock_Area_Left:Name = "m_MainForm_Toolbars_Dock_Area_Left".
        this-object:m_MainForm_Toolbars_Dock_Area_Left:Size = new System.Drawing.Size(0, 495).
        this-object:m_MainForm_Toolbars_Dock_Area_Left:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_MainForm_Toolbars_Dock_Area_Right */
        /*  */
        this-object:m_MainForm_Toolbars_Dock_Area_Right:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_MainForm_Toolbars_Dock_Area_Right:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_MainForm_Toolbars_Dock_Area_Right:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Right.
        this-object:m_MainForm_Toolbars_Dock_Area_Right:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_MainForm_Toolbars_Dock_Area_Right:Location = new System.Drawing.Point(974, 35).
        this-object:m_MainForm_Toolbars_Dock_Area_Right:Name = "m_MainForm_Toolbars_Dock_Area_Right".
        this-object:m_MainForm_Toolbars_Dock_Area_Right:Size = new System.Drawing.Size(0, 495).
        this-object:m_MainForm_Toolbars_Dock_Area_Right:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_MainForm_Toolbars_Dock_Area_Top */
        /*  */
        this-object:m_MainForm_Toolbars_Dock_Area_Top:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_MainForm_Toolbars_Dock_Area_Top:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_MainForm_Toolbars_Dock_Area_Top:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Top.
        this-object:m_MainForm_Toolbars_Dock_Area_Top:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_MainForm_Toolbars_Dock_Area_Top:Location = new System.Drawing.Point(0, 0).
        this-object:m_MainForm_Toolbars_Dock_Area_Top:Name = "m_MainForm_Toolbars_Dock_Area_Top".
        this-object:m_MainForm_Toolbars_Dock_Area_Top:Size = new System.Drawing.Size(974, 35).
        this-object:m_MainForm_Toolbars_Dock_Area_Top:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_MainForm_Toolbars_Dock_Area_Bottom */
        /*  */
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Bottom.
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:Location = new System.Drawing.Point(0, 530).
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:Name = "m_MainForm_Toolbars_Dock_Area_Bottom".
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:Size = new System.Drawing.Size(974, 0).
        this-object:m_MainForm_Toolbars_Dock_Area_Bottom:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* ultraTabbedMdiManager1 */
        /*  */
        this-object:ultraTabbedMdiManager1:AllowMaximize = true.
        this-object:ultraTabbedMdiManager1:MdiParent = this-object.
        /*  */
        /* splitter1 */
        /*  */
        this-object:splitter1:Location = new System.Drawing.Point(244, 35).
        this-object:splitter1:Name = "splitter1".
        this-object:splitter1:Size = new System.Drawing.Size(13, 495).
        this-object:splitter1:TabIndex = 13.
        this-object:splitter1:TabStop = false.
        /*  */
        /* uxCustomer */
        /*  */
        this-object:uxCustomer:DataSource = this-object:bsCustomer.
        appearance13:BackColor = System.Drawing.Color:White.
        this-object:uxCustomer:DisplayLayout:Appearance = appearance13.
        this-object:uxCustomer:DisplayLayout:AutoFitStyle = Infragistics.Win.UltraWinGrid.AutoFitStyle:ExtendLastColumn.
        ultraGridBand2:ColHeadersVisible = false.
        ultraGridColumn1:Header:VisiblePosition = 0.
        ultraGridColumn2:Header:VisiblePosition = 1.
        ultraGridColumn3:Header:VisiblePosition = 2.
        ultraGridColumn3:Hidden = true.
        ultraGridColumn4:Header:VisiblePosition = 3.
        ultraGridColumn4:Hidden = true.
        ultraGridColumn5:Header:VisiblePosition = 4.
        ultraGridColumn5:Hidden = true.
        ultraGridColumn6:Header:VisiblePosition = 5.
        ultraGridColumn6:Hidden = true.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as System.Object extent 6 no-undo.
        arrayvar4[1] = ultraGridColumn1.
        arrayvar4[2] = ultraGridColumn2.
        arrayvar4[3] = ultraGridColumn3.
        arrayvar4[4] = ultraGridColumn4.
        arrayvar4[5] = ultraGridColumn5.
        arrayvar4[6] = ultraGridColumn6.
        ultraGridBand2:Columns:AddRange(arrayvar4).
        this-object:uxCustomer:DisplayLayout:BandsSerializer:Add(ultraGridBand2).
        this-object:uxCustomer:DisplayLayout:GroupByBox:Hidden = true.
        this-object:uxCustomer:DisplayLayout:MaxColScrollRegions = 1.
        this-object:uxCustomer:DisplayLayout:MaxRowScrollRegions = 1.
        this-object:uxCustomer:DisplayLayout:Override:AllowAddNew = Infragistics.Win.UltraWinGrid.AllowAddNew:No.
        this-object:uxCustomer:DisplayLayout:Override:AllowDelete = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxCustomer:DisplayLayout:Override:AllowUpdate = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxCustomer:DisplayLayout:Override:BorderStyleCell = Infragistics.Win.UIElementBorderStyle:None.
        appearance14:BackColor = System.Drawing.Color:Transparent.
        this-object:uxCustomer:DisplayLayout:Override:CardAreaAppearance = appearance14.
        this-object:uxCustomer:DisplayLayout:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:RowSelect.
        this-object:uxCustomer:DisplayLayout:Override:CellPadding = 3.
        appearance15:TextHAlignAsString = "Left".
        this-object:uxCustomer:DisplayLayout:Override:HeaderAppearance = appearance15.
        this-object:uxCustomer:DisplayLayout:Override:HeaderClickAction = Infragistics.Win.UltraWinGrid.HeaderClickAction:SortMulti.
        appearance16:BackColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxCustomer:DisplayLayout:Override:RowAlternateAppearance = appearance16.
        appearance17:BorderColor = System.Drawing.Color:LightGray.
        appearance17:TextVAlignAsString = "Middle".
        this-object:uxCustomer:DisplayLayout:Override:RowAppearance = appearance17.
        this-object:uxCustomer:DisplayLayout:Override:RowSelectors = Infragistics.Win.DefaultableBoolean:False.
        appearance18:BackColor = System.Drawing.Color:LightSteelBlue.
        appearance18:BorderColor = System.Drawing.Color:Black.
        appearance18:ForeColor = System.Drawing.Color:Black.
        this-object:uxCustomer:DisplayLayout:Override:SelectedRowAppearance = appearance18.
        this-object:uxCustomer:DisplayLayout:RowConnectorStyle = Infragistics.Win.UltraWinGrid.RowConnectorStyle:None.
        this-object:uxCustomer:DisplayLayout:ScrollBounds = Infragistics.Win.UltraWinGrid.ScrollBounds:ScrollToFill.
        this-object:uxCustomer:DisplayLayout:ScrollStyle = Infragistics.Win.UltraWinGrid.ScrollStyle:Immediate.
        this-object:uxCustomer:DisplayLayout:ViewStyle = Infragistics.Win.UltraWinGrid.ViewStyle:SingleBand.
        this-object:uxCustomer:Dock = System.Windows.Forms.DockStyle:Left.
        this-object:uxCustomer:Location = new System.Drawing.Point(0, 35).
        this-object:uxCustomer:Name = "uxCustomer".
        this-object:uxCustomer:Size = new System.Drawing.Size(244, 495).
        this-object:uxCustomer:TabIndex = 19.
        this-object:uxCustomer:AfterRowActivate:Subscribe(this-object:uxCustomer_AfterRowActivate).
        /*  */
        /* bsCustomer */
        /*  */
        this-object:bsCustomer:MaxDataGuess = 0.
        this-object:bsCustomer:NoLOBs = false.
        this-object:bsCustomer:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar5 = new "Progress.Data.TableDesc[]"(0).
        tableDesc2:ChildTables = arrayvar5.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar6 as Progress.Data.ColumnPropDesc extent 6 no-undo.
        arrayvar6[1] = new Progress.Data.ColumnPropDesc("CustNum", "", Progress.Data.DataType:INTEGER).
        arrayvar6[2] = new Progress.Data.ColumnPropDesc("Name", "", Progress.Data.DataType:CHARACTER).
        arrayvar6[3] = new Progress.Data.ColumnPropDesc("Address", "", Progress.Data.DataType:CHARACTER).
        arrayvar6[4] = new Progress.Data.ColumnPropDesc("Phone", "", Progress.Data.DataType:CHARACTER).
        arrayvar6[5] = new Progress.Data.ColumnPropDesc("SalesRep", "", Progress.Data.DataType:CHARACTER).
        arrayvar6[6] = new Progress.Data.ColumnPropDesc("Balance", "", Progress.Data.DataType:DECIMAL).
        tableDesc2:Columns = arrayvar6.
        this-object:bsCustomer:TableSchema = tableDesc2.
        /*  */
        /* uxOrders */
        /*  */
        this-object:uxOrders:DataSource = this-object:bsOrder.
        appearance1:BackColor = System.Drawing.SystemColors:Window.
        appearance1:BorderColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxOrders:DisplayLayout:Appearance = appearance1.
        this-object:uxOrders:DisplayLayout:AutoFitStyle = Infragistics.Win.UltraWinGrid.AutoFitStyle:ResizeAllColumns.
        ultraGridColumn7:Header:VisiblePosition = 0.
        ultraGridColumn7:Width = 121.
        ultraGridColumn8:Header:VisiblePosition = 1.
        ultraGridColumn8:Hidden = true.
        ultraGridColumn8:Width = 102.
        ultraGridColumn9:Header:VisiblePosition = 2.
        ultraGridColumn9:Width = 186.
        ultraGridColumn10:Header:VisiblePosition = 3.
        ultraGridColumn10:Width = 204.
        ultraGridColumn11:Header:VisiblePosition = 4.
        ultraGridColumn11:Width = 204.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar7 as System.Object extent 5 no-undo.
        arrayvar7[1] = ultraGridColumn7.
        arrayvar7[2] = ultraGridColumn8.
        arrayvar7[3] = ultraGridColumn9.
        arrayvar7[4] = ultraGridColumn10.
        arrayvar7[5] = ultraGridColumn11.
        ultraGridBand1:Columns:AddRange(arrayvar7).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
        this-object:uxOrders:DisplayLayout:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        this-object:uxOrders:DisplayLayout:CaptionVisible = Infragistics.Win.DefaultableBoolean:False.
        appearance2:BackColor = System.Drawing.SystemColors:ActiveBorder.
        appearance2:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance2:BackGradientStyle = Infragistics.Win.GradientStyle:Vertical.
        appearance2:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:GroupByBox:Appearance = appearance2.
        appearance3:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxOrders:DisplayLayout:GroupByBox:BandLabelAppearance = appearance3.
        this-object:uxOrders:DisplayLayout:GroupByBox:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        appearance4:BackColor = System.Drawing.SystemColors:ControlLightLight.
        appearance4:BackColor2 = System.Drawing.SystemColors:Control.
        appearance4:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance4:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxOrders:DisplayLayout:GroupByBox:PromptAppearance = appearance4.
        this-object:uxOrders:DisplayLayout:MaxColScrollRegions = 1.
        this-object:uxOrders:DisplayLayout:MaxRowScrollRegions = 1.
        appearance5:BackColor = System.Drawing.SystemColors:Window.
        appearance5:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:uxOrders:DisplayLayout:Override:ActiveCellAppearance = appearance5.
        appearance6:BackColor = System.Drawing.SystemColors:Highlight.
        appearance6:ForeColor = System.Drawing.SystemColors:HighlightText.
        this-object:uxOrders:DisplayLayout:Override:ActiveRowAppearance = appearance6.
        this-object:uxOrders:DisplayLayout:Override:BorderStyleCell = Infragistics.Win.UIElementBorderStyle:Dotted.
        this-object:uxOrders:DisplayLayout:Override:BorderStyleRow = Infragistics.Win.UIElementBorderStyle:Dotted.
        appearance7:BackColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:Override:CardAreaAppearance = appearance7.
        appearance8:BorderColor = System.Drawing.Color:Silver.
        appearance8:TextTrimming = Infragistics.Win.TextTrimming:EllipsisCharacter.
        this-object:uxOrders:DisplayLayout:Override:CellAppearance = appearance8.
        this-object:uxOrders:DisplayLayout:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:EditAndSelectText.
        this-object:uxOrders:DisplayLayout:Override:CellPadding = 0.
        appearance9:BackColor = System.Drawing.SystemColors:Control.
        appearance9:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance9:BackGradientAlignment = Infragistics.Win.GradientAlignment:Element.
        appearance9:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance9:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:Override:GroupByRowAppearance = appearance9.
        appearance10:TextHAlignAsString = "Left".
        this-object:uxOrders:DisplayLayout:Override:HeaderAppearance = appearance10.
        this-object:uxOrders:DisplayLayout:Override:HeaderClickAction = Infragistics.Win.UltraWinGrid.HeaderClickAction:SortMulti.
        this-object:uxOrders:DisplayLayout:Override:HeaderStyle = Infragistics.Win.HeaderStyle:WindowsXPCommand.
        appearance11:BackColor = System.Drawing.SystemColors:Window.
        appearance11:BorderColor = System.Drawing.Color:Silver.
        this-object:uxOrders:DisplayLayout:Override:RowAppearance = appearance11.
        this-object:uxOrders:DisplayLayout:Override:RowSelectors = Infragistics.Win.DefaultableBoolean:False.
        appearance12:BackColor = System.Drawing.SystemColors:ControlLight.
        this-object:uxOrders:DisplayLayout:Override:TemplateAddRowAppearance = appearance12.
        this-object:uxOrders:DisplayLayout:ScrollBounds = Infragistics.Win.UltraWinGrid.ScrollBounds:ScrollToFill.
        this-object:uxOrders:DisplayLayout:ScrollStyle = Infragistics.Win.UltraWinGrid.ScrollStyle:Immediate.
        this-object:uxOrders:DisplayLayout:ViewStyle = Infragistics.Win.UltraWinGrid.ViewStyle:SingleBand.
        this-object:uxOrders:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxOrders:Location = new System.Drawing.Point(257, 35).
        this-object:uxOrders:Name = "uxOrders".
        this-object:uxOrders:Size = new System.Drawing.Size(717, 495).
        this-object:uxOrders:TabIndex = 20.
        this-object:uxOrders:Text = "ultraGrid1".
        /*  */
        /* bsOrder */
        /*  */
        this-object:bsOrder:MaxDataGuess = 0.
        this-object:bsOrder:NoLOBs = false.
        this-object:bsOrder:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar8 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar8 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar8.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar9 as Progress.Data.ColumnPropDesc extent 5 no-undo.
        arrayvar9[1] = new Progress.Data.ColumnPropDesc("Ordernum", "", Progress.Data.DataType:INTEGER).
        arrayvar9[2] = new Progress.Data.ColumnPropDesc("CustNum", "", Progress.Data.DataType:INTEGER).
        arrayvar9[3] = new Progress.Data.ColumnPropDesc("OrderDate", "", Progress.Data.DataType:DATE).
        arrayvar9[4] = new Progress.Data.ColumnPropDesc("SalesRep", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[5] = new Progress.Data.ColumnPropDesc("OrderStatus", "", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar9.
        this-object:bsOrder:TableSchema = tableDesc1.
        /*  */
        /* MainForm */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(974, 553).
        this-object:Controls:Add(this-object:uxOrders).
        this-object:Controls:Add(this-object:splitter1).
        this-object:Controls:Add(this-object:uxCustomer).
        this-object:Controls:Add(this-object:m_MainForm_Toolbars_Dock_Area_Left).
        this-object:Controls:Add(this-object:m_MainForm_Toolbars_Dock_Area_Right).
        this-object:Controls:Add(this-object:m_MainForm_Toolbars_Dock_Area_Bottom).
        this-object:Controls:Add(this-object:uxStatus).
        this-object:Controls:Add(this-object:m_MainForm_Toolbars_Dock_Area_Top).
        this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        this-object:IsMdiContainer = true.
        this-object:Name = "MainForm".
        this-object:Text = "Customer Order Review".
        this-object:TransparencyKey = System.Drawing.Color:Fuchsia.
        this-object:FormClosed:Subscribe(this-object:MainForm_FormClosed).
        cast(this-object:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxStatus, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:ultraTabbedMdiManager1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxCustomer, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bsCustomer, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxOrders, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bsOrder, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.


    method private void ultraToolbarsManager1_ToolClick( input sender as System.Object, input e as Infragistics.Win.UltraWinToolbars.ToolClickEventArgs ):
        case e:Tool:Key:
            when 'Login' then Login().
            when 'Logout' then Logout().
            when 'Help' then ShowHelp().
            when 'RefreshCustomerList' then RefreshCustomerList(). 
        end case.

        catch oAppError as AppError:
            message oAppError:ReturnValue
                view-as alert-box error.                        
        end catch.

        catch oError as Error:
            message oError:GetMessage(1)
                view-as alert-box error.
        end catch.
    end method.
    
    method protected void RefreshCustomerList():
        define variable hAppServer as handle no-undo.
        define variable oServer as JsonObject no-undo.
        
        oServer = this-object:Servers:GetJsonObject('asBusinessLogicService').
        hAppServer = oServer:GetHandle('handle').

        run BusinessLogic/GetCustomerList.p on hAppServer (output dataset dsCustomerOrder).

        open query qryCustomer preselect each ttCustomer by ttCustomer.CustNum.
        bsCustomer:Handle = query qryCustomer:handle.
        
        query qryCustomer:reposition-to-row(1).
        
        catch oAppError as Progress.Lang.AppError:
            message oAppError:ReturnValue
            view-as alert-box.
        end catch.
        catch oError as Progress.Lang.Error:
            message oError:GetMessage(1) skip
            oError:GetMessage(2)
            view-as alert-box.
        end catch.
    end method.

    method protected void RefreshOrderList(input piCustNum as integer):
        define variable hAppServer as handle no-undo.
        define variable oServer as JsonObject no-undo.
        define variable hTransportDataset as handle no-undo.
        
        oServer = this-object:Servers:GetJsonObject('asBusinessLogicService').
        hAppServer = oServer:GetHandle('handle').
        
        /* use a separate dataset on output because it'll only have a single customer's data */
        /* always go to get the customers' orders, because they may have changed since we last did so */
        run BusinessLogic/GetCustomerOrders.p on hAppServer (input piCustNum, output dataset-handle hTransportDataset).
        
        dataset dsCustomerOrder:copy-dataset(hTransportDataset,
                true,      /* append */
                true,      /* replace */
                true).     /* loose fill */
        
        open query qryOrder
            preselect each ttOrder where
                           ttOrder.CustNum eq piCustNum
                           by ttOrder.OrderNum.
        bsOrder:Handle = query qryOrder:handle.
        
        catch oAppError as Progress.Lang.AppError:
            message oAppError:ReturnValue
            view-as alert-box.
        end catch.
        
        catch oError as Progress.Lang.Error:
            message oError:GetMessage(1)
            view-as alert-box.
        end catch.
    end method.
    
    method protected void ShowHelp():
        define variable oHelpAbout       as HelpAbout no-undo.
        define variable hClientPrincipal as handle    no-undo.
        define variable cClientPrincipal as longchar  no-undo.
        define variable mClientPrincipal as memptr    no-undo.
        define variable rClientPrincipal as raw       no-undo.
        define variable hSecurityTokenService as handle no-undo.
        
        if this-object:UserContextId ne '' then
        do: 
            hSecurityTokenService = this-object:Servers:GetJsonObject('asSecurityTokenService'):GetHandle('handle').
            
            run Security/GetClientPrincipal.p on hSecurityTokenService (input this-object:UserContextId, output cClientPrincipal).
            
            if cClientPrincipal ne '' then
            do:
                create client-principal hClientPrincipal.
                mClientPrincipal = base64-decode(cClientPrincipal).
                rClientPrincipal = get-bytes(mClientPrincipal, 1, get-size(mClientPrincipal)).
                hClientPrincipal:import-principal(rClientPrincipal).
            end.
        end.
                
        oHelpAbout = new HelpAbout(hClientPrincipal, this-object:Servers).
                        
        wait-for oHelpAbout:ShowDialog().

        oHelpAbout = ?.
        finally:
            set-size(mClientPrincipal) = 0.
            delete object hClientPrincipal no-error.
        end.
    end method.
    
    method protected void Login():
        define variable oFrame     as LoginPanel extent 1 no-undo.
        define variable oLoginForm as LightboxForm     no-undo.

        oFrame[1] = new LoginPanel(this-object).

        /* position where we want it on *this* form */
        oFrame[1]:Location = new Point(
            int((this-object:Size:Width / 2) - (oFrame[1]:Size:Width / 2 )),
            int((this-object:Size:Height / 2) - (oFrame[1]:Size:Height / 2 ) )).

        oLoginForm = new LightboxForm(this-object, oFrame).
        oLoginForm:Show().
        
        oLoginForm:FormClosed:Subscribe(this-object:LoginFormClosedHandler).
    end method.
    
    method public void LoginFormClosedHandler(input sender as System.Object, input e as EventArgs ):
        cast(sender, LightboxForm):FormClosed:Unsubscribe(LoginFormClosedHandler).
        
        if this-object:UserContextId ne '' then
            RefreshCustomerList().
    end method.    
    
    /** Login and logout operations 
    */
    method public logical LoginUser(input phCredentials as handle):
        define variable hAppServer as handle no-undo.                                    
        define variable lLoginSucceeded as logical   no-undo.
        define variable cTool as character extent no-undo.
        define variable oServer as JsonObject no-undo.
        define variable rClientPrincipal as raw no-undo.
        define variable cClientPrincipal as longchar no-undo.
        
        oServer = this-object:Servers:GetJsonObject('asSecurityTokenService').
        hAppServer = oServer:GetHandle('handle').
        
        rClientPrincipal = phCredentials:export-principal().
        cClientPrincipal = base64-encode(rClientPrincipal).            
                
        run Security/LoginSSO.p on hAppServer (cClientPrincipal, output UserContextId).
        
        /* There is an alternate text-based login procedure. We use the SSO/CP
           one since it means we're not sending user credentials in clear text 
        run Security/Login.p on hAppServer (
                        pcUserName, pcDomain, pcPassword,
                        output UserContextId).  */

        lLoginSucceeded = (this-object:UserContextId ne '').
        
        if lLoginSucceeded then
        do:
            /* set the CCID on the business logic server so that it's transported
               with every request. we now no longer need to remember to do this. */
            oServer = this-object:Servers:GetJsonObject('asBusinessLogicService').
            hAppServer = oServer:GetHandle('handle').
            hAppServer:request-info:ClientContextId = this-object:UserContextId.
        
            /* get the UI in a ready state */
            extent(cTool) = ?.
            extent(cTool) = 1.
            cTool[1] = 'Login'.
            SetToolState(cTool, false).

            extent(cTool) = ?.
            extent(cTool) = 1.
            cTool[1] = 'Logout'.
            SetToolState(cTool, true).
            
            uxStatus:Panels['username']:Text = phCredentials:user-id.
            uxStatus:Panels['ccid']:Text = this-object:UserContextId.
            uxStatus:Panels['domain']:Text = phCredentials:domain-name.
        end.
        else
            undo, throw new AppError('User login failed').
        
        return lLoginSucceeded.
        
        catch oAppError as AppError:
            message oAppError:ReturnValue
                view-as alert-box error.                        
        end catch.
        catch oError as Error:
            message oError:GetMessage(1)
                view-as alert-box error.                        
        end catch.
    end method.
     
    method protected void Logout():
        define variable oServer as JsonObject no-undo.
        define variable hAppServer as handle no-undo.
        
        if UserContextId eq '' then
            return. 
        
        oServer = this-object:Servers:GetJsonObject('asSecurityTokenService').
        hAppServer = oServer:GetHandle('handle').
        run Security/Logout.p on hAppServer (input UserContextId).
        
        this-object:UserContextId = ''.
        /* unset the CCID on the business logic server so that it's not
           transported with every request.  */
        oServer = this-object:Servers:GetJsonObject('asBusinessLogicService').
        hAppServer = oServer:GetHandle('handle').
        hAppServer:request-info:ClientContextId = this-object:UserContextId.
        
        ResetUI().
    end method.
    
    method private void MainForm_FormClosed( input sender as System.Object, input e as System.Windows.Forms.FormClosedEventArgs ):
        define variable hAppServer as handle no-undo.
        define variable oServer as JsonObject no-undo.
        
        Logout().
            
        /* STS */
        oServer = this-object:Servers:GetJsonObject('asSecurityTokenService').
        hAppServer = oServer:GetHandle('handle').
        
        /* deregister this client and disconnect */
        run Security/DeregisterServer.p on hAppServer(input hAppServer:request-info:ClientContextId).
        
        hAppServer:disconnect().
        delete object hAppServer no-error.
        hAppServer = ?.
        oServer:Set('handle', hAppServer).
        
        /* business logic service */
        oServer = this-object:Servers:GetJsonObject('asBusinessLogicService').
        hAppServer = oServer:GetHandle('handle').
        hAppServer:disconnect().
        delete object hAppServer no-error.
        hAppServer = ?.
        oServer:Set('handle', hAppServer).
        
        return.
    end method.
    
    method protected void SetToolState(pcTool as character extent, plEnable as logical):
        def    var      iIndex as integer  no-undo.
        def    var      iLoop  as integer  no-undo.
        define variable oTool  as ToolBase no-undo.

        do iLoop = 1 to extent(pcTool):
            iIndex = ultraToolbarsManager1:Tools:IndexOf(pcTool[iLoop]).
            if iIndex ge 0 then
                oTool = cast(ultraToolbarsManager1:Tools:GetItem(iIndex), ButtonTool).

            if valid-object(oTool) then
                oTool:SharedProps:Enabled = plEnable.
        end.
    end method.
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void uxCustomer_AfterRowActivate( input sender as System.Object, input e as System.EventArgs ):
        if available ttCustomer then
            RefreshOrderList(ttCustomer.CustNum).
	end method.

end class.

