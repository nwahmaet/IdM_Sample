/** ------------------------------------------------------------------------
    File        : HelpAbout
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri Jun 03 14:18:58 EDT 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Infragistics.Win.UltraWinTabControl.UltraTab.
using Infragistics.Win.UltraWinGrid.UltraGridColumn.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Windows.Form.
using Progress.Lang.Class.
using Progress.Lang.Object.

class Desktop.HelpAbout inherits Form:

    define private temp-table mSettingData no-undo
        field SettingGroup as character
        field Order as integer
        field Key as character
        field SettingValue as character
        index idx1 as primary SettingGroup Key
        index idx2 SettingGroup Order.
    define private query mQrySettings for mSettingData scrolling.

    define private variable bsSettings as Progress.Data.BindingSource no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable imageList1 as System.Windows.Forms.ImageList no-undo.
    define private variable ultraPanel1 as Infragistics.Win.Misc.UltraPanel no-undo.
    define private variable ultraTabPageControl3 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable ultraTabSharedControlsPage1 as Infragistics.Win.UltraWinTabControl.UltraTabSharedControlsPage no-undo.
    define private variable ultraTabPageControl1 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable uxDetail as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.
    define private variable uxFormattedKeyText as Infragistics.Win.FormattedLinkLabel.UltraFormattedLinkLabel no-undo.
    define private variable uxFormattedValueText as Infragistics.Win.FormattedLinkLabel.UltraFormattedLinkLabel no-undo.
    define private variable uxLogo as Infragistics.Win.UltraWinEditors.UltraPictureBox no-undo.
    define private variable uxSettingsGroup as Infragistics.Win.UltraWinTabControl.UltraTabControl no-undo.
    define private variable uxVersionInfo as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.

    /** Shows help about a class.

        @param Class The caller of this dialog */
    constructor public HelpAbout(input phClientPrincipal as handle,
                                 input poServers as JsonObject):
        define variable iOrder as integer no-undo.
        this-object().
        
        InitVersionInfo().
        InitUserData(phClientPrincipal).

        iOrder = 1.
        InitServerData('asBusinessLogicService',
                       poServers:GetJsonObject('asBusinessLogicService'), 
                       input-output iOrder).
        InitServerData('asSecurityTokenService',
                       poServers:GetJsonObject('asSecurityTokenService'), 
                       input-output iOrder).
    end constructor.

    constructor public HelpAbout():
        super().

        InitializeComponent().

        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

    method protected void InitVersionInfo():
        define variable cVersionFile as character no-undo.
        define variable cVersion as character no-undo.
        
        cVersionFile = search('version.txt').
        if cVersionFile ne ? then
        do:                              
            input from value(cVersionFile).
                import unformatted cVersion.
            input close.
        end.
        else
            cVersion = 'Unable to determine version'.
        
        uxVersionInfo:Text = cVersion.
    end method.

    method private void InitServerData(input pcServerName as character,
                                       input poServer as JsonObject,
                                       input-output piOrder as integer):        
        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = 'AppServer Name'
               mSettingData.SettingValue = pcServerName.
        
        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = 'AppServer Host'
               mSettingData.SettingValue = poServer:GetCharacter('host').

        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = 'AppServer IsConnected'
               mSettingData.SettingValue = string(poServer:GetHandle('handle'):connected()).

        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = 'AppServer CCID'
               mSettingData.SettingValue = string(poServer:GetHandle('handle'):request-info:ClientContextId).

        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = 'AppServer SERVER:CLIENT-CONNECTION-ID'
               mSettingData.SettingValue = poServer:GetHandle('handle'):client-connection-id.

        /* spacer */
        create mSettingData.
        assign mSettingData.SettingGroup = 'SERVER'
               mSettingData.Order = piOrder
               piOrder = piOrder + 1
               mSettingData.Key = ''
               mSettingData.SettingValue = ''.
    end method.
    
    method protected void InitUserData(input phClientPrincipal as handle):
        define variable iLoop as integer no-undo.
        define variable iOrder as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cPropertyNames as character no-undo.

        if valid-handle(phClientPrincipal) then
        do:
            iOrder = 1.
            create mSettingData.
            assign mSettingData.SettingGroup = 'USER'
                   mSettingData.Order = iOrder
                   iOrder = iOrder + 1
                   mSettingData.Key = 'User Name'
                   mSettingData.SettingValue = phClientPrincipal:user-id.

            create mSettingData.
            assign mSettingData.SettingGroup = 'USER'
                   mSettingData.Order = iOrder
                   iOrder = iOrder + 1
                   mSettingData.Key = 'Domain Name'
                   mSettingData.SettingValue = phClientPrincipal:domain-name.

            create mSettingData.
            assign mSettingData.SettingGroup = 'USER'
                   mSettingData.Order = iOrder
                   iOrder = iOrder + 1
                   mSettingData.Key = 'State'
                   mSettingData.SettingValue = phClientPrincipal:login-state.

            create mSettingData.
            assign mSettingData.SettingGroup = 'USER'
                   mSettingData.Order = iOrder
                   iOrder = iOrder + 1
                   mSettingData.Key = 'Login Expiration'
                   mSettingData.SettingValue = iso-date(phClientPrincipal:login-expiration-timestamp).
            
            cPropertyNames = phClientPrincipal:list-property-names().
            iMax = num-entries(cPropertyNames).
            do iLoop = 1 to iMax:
                create mSettingData.
                assign mSettingData.SettingGroup = 'USER'
                       mSettingData.Order = iOrder
                       iOrder = iOrder + 1                     
                       mSettingData.Key = entry(iLoop, cPropertyNames)
                       mSettingData.SettingValue = phClientPrincipal:get-property(mSettingData.Key).
            end.

            /* spacer */
            create mSettingData.
            assign mSettingData.SettingGroup = 'USER'
                   mSettingData.Order = iOrder
                   iLoop = iOrder + 1
                   mSettingData.Key = ''
                   mSettingData.SettingValue = ''.
        end.
    end method.

    method private void InitializeComponent(  ):

        /* NOTE: The following method is automatically generated.

        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.

        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance1 as Infragistics.Win.Appearance no-undo.
        appearance1 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand1 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand1 = new Infragistics.Win.UltraWinGrid.UltraGridBand("mSettingData", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn5 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn5 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Key").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn6 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn6 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SettingValue").
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
        define variable appearance13 as Infragistics.Win.Appearance no-undo.
        appearance13 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance14 as Infragistics.Win.Appearance no-undo.
        appearance14 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("mSettingData").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("Desktop.HelpAbout").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance15 as Infragistics.Win.Appearance no-undo.
        appearance15 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab3 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab3 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance16 as Infragistics.Win.Appearance no-undo.
        appearance16 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab2 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab2 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance17 as Infragistics.Win.Appearance no-undo.
        appearance17 = new Infragistics.Win.Appearance().
        this-object:uxFormattedKeyText = new Infragistics.Win.FormattedLinkLabel.UltraFormattedLinkLabel().
        this-object:uxFormattedValueText = new Infragistics.Win.FormattedLinkLabel.UltraFormattedLinkLabel().
        this-object:ultraTabPageControl1 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:uxDetail = new Infragistics.Win.UltraWinGrid.UltraGrid().
        this-object:bsSettings = new Progress.Data.BindingSource(this-object:components).
        this-object:ultraTabPageControl3 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:ultraPanel1 = new Infragistics.Win.Misc.UltraPanel().
        this-object:uxLogo = new Infragistics.Win.UltraWinEditors.UltraPictureBox().
        this-object:uxVersionInfo = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:imageList1 = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxSettingsGroup = new Infragistics.Win.UltraWinTabControl.UltraTabControl().
        this-object:ultraTabSharedControlsPage1 = new Infragistics.Win.UltraWinTabControl.UltraTabSharedControlsPage().
        this-object:ultraTabPageControl1:SuspendLayout().
        cast(this-object:uxDetail, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bsSettings, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:ultraPanel1:ClientArea:SuspendLayout().
        this-object:ultraPanel1:SuspendLayout().
        cast(this-object:uxVersionInfo, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxSettingsGroup, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:uxSettingsGroup:SuspendLayout().
        this-object:ultraTabSharedControlsPage1:SuspendLayout().
        this-object:SuspendLayout().
        /*  */
        /* uxFormattedKeyText */
        /*  */
        this-object:uxFormattedKeyText:Location = new System.Drawing.Point(118, 129).
        this-object:uxFormattedKeyText:Name = "uxFormattedKeyText".
        this-object:uxFormattedKeyText:Size = new System.Drawing.Size(130, 23).
        this-object:uxFormattedKeyText:TabIndex = 2.
        this-object:uxFormattedKeyText:TabStop = true.
        this-object:uxFormattedKeyText:TreatValueAs = Infragistics.Win.FormattedLinkLabel.TreatValueAs:Auto.
        this-object:uxFormattedKeyText:Value = "".
        this-object:uxFormattedKeyText:Visible = false.
        this-object:uxFormattedKeyText:WrapText = false.
        /*  */
        /* uxFormattedValueText */
        /*  */
        this-object:uxFormattedValueText:Location = new System.Drawing.Point(208, 100).
        this-object:uxFormattedValueText:Name = "uxFormattedValueText".
        this-object:uxFormattedValueText:Size = new System.Drawing.Size(130, 23).
        this-object:uxFormattedValueText:TabIndex = 3.
        this-object:uxFormattedValueText:TabStop = true.
        this-object:uxFormattedValueText:TreatValueAs = Infragistics.Win.FormattedLinkLabel.TreatValueAs:Auto.
        this-object:uxFormattedValueText:Value = "".
        this-object:uxFormattedValueText:Visible = false.
        this-object:uxFormattedValueText:WrapText = false.
        /*  */
        /* ultraTabPageControl1 */
        /*  */
        this-object:ultraTabPageControl1:Controls:Add(this-object:uxFormattedValueText).
        this-object:ultraTabPageControl1:Controls:Add(this-object:uxFormattedKeyText).
        this-object:ultraTabPageControl1:Controls:Add(this-object:uxDetail).
        this-object:ultraTabPageControl1:Location = new System.Drawing.Point(38, 1).
        this-object:ultraTabPageControl1:Name = "ultraTabPageControl1".
        this-object:ultraTabPageControl1:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* uxDetail */
        /*  */
        this-object:uxDetail:DataSource = this-object:bsSettings.
        appearance1:BackColor = System.Drawing.SystemColors:Window.
        appearance1:BorderColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxDetail:DisplayLayout:Appearance = appearance1.
        this-object:uxDetail:DisplayLayout:AutoFitStyle = Infragistics.Win.UltraWinGrid.AutoFitStyle:ExtendLastColumn.
        ultraGridBand1:ColHeadersVisible = false.
        ultraGridColumn5:AutoSizeMode = Infragistics.Win.UltraWinGrid.ColumnAutoSizeMode:AllRowsInBand.
        ultraGridColumn5:CellActivation = Infragistics.Win.UltraWinGrid.Activation:ActivateOnly.
        ultraGridColumn5:EditorComponent = this-object:uxFormattedKeyText.
        ultraGridColumn5:Header:Fixed = true.
        ultraGridColumn5:Header:VisiblePosition = 0.
        ultraGridColumn5:Width = 183.
        ultraGridColumn6:AllowGroupBy = Infragistics.Win.DefaultableBoolean:False.
        ultraGridColumn6:CellActivation = Infragistics.Win.UltraWinGrid.Activation:NoEdit.
        ultraGridColumn6:EditorComponent = this-object:uxFormattedValueText.
        ultraGridColumn6:Header:Fixed = true.
        ultraGridColumn6:Header:VisiblePosition = 1.
        ultraGridColumn6:Width = 267.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Object extent 2 no-undo.
        arrayvar0[1] = ultraGridColumn5.
        arrayvar0[2] = ultraGridColumn6.
        ultraGridBand1:Columns:AddRange(arrayvar0).
        this-object:uxDetail:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
        this-object:uxDetail:DisplayLayout:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        appearance2:FontData:Name = "Segoe UI".
        appearance2:ForeColor = System.Drawing.SystemColors:InactiveCaptionText.
        appearance2:TextHAlignAsString = "Center".
        this-object:uxDetail:DisplayLayout:CaptionAppearance = appearance2.
        this-object:uxDetail:DisplayLayout:CaptionVisible = Infragistics.Win.DefaultableBoolean:True.
        appearance3:BackColor = System.Drawing.SystemColors:ActiveBorder.
        appearance3:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance3:BackGradientStyle = Infragistics.Win.GradientStyle:Vertical.
        appearance3:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:GroupByBox:Appearance = appearance3.
        appearance4:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxDetail:DisplayLayout:GroupByBox:BandLabelAppearance = appearance4.
        this-object:uxDetail:DisplayLayout:GroupByBox:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        this-object:uxDetail:DisplayLayout:GroupByBox:Hidden = true.
        appearance5:BackColor = System.Drawing.SystemColors:ControlLightLight.
        appearance5:BackColor2 = System.Drawing.SystemColors:Control.
        appearance5:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance5:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxDetail:DisplayLayout:GroupByBox:PromptAppearance = appearance5.
        this-object:uxDetail:DisplayLayout:MaxColScrollRegions = 1.
        this-object:uxDetail:DisplayLayout:MaxRowScrollRegions = 1.
        appearance6:BackColor = System.Drawing.SystemColors:Window.
        appearance6:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:uxDetail:DisplayLayout:Override:ActiveCellAppearance = appearance6.
        appearance7:BackColor = System.Drawing.SystemColors:Highlight.
        appearance7:ForeColor = System.Drawing.SystemColors:HighlightText.
        this-object:uxDetail:DisplayLayout:Override:ActiveRowAppearance = appearance7.
        this-object:uxDetail:DisplayLayout:Override:AllowAddNew = Infragistics.Win.UltraWinGrid.AllowAddNew:No.
        this-object:uxDetail:DisplayLayout:Override:AllowColSizing = Infragistics.Win.UltraWinGrid.AllowColSizing:Free.
        this-object:uxDetail:DisplayLayout:Override:AllowDelete = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxDetail:DisplayLayout:Override:AllowUpdate = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxDetail:DisplayLayout:Override:BorderStyleCell = Infragistics.Win.UIElementBorderStyle:None.
        this-object:uxDetail:DisplayLayout:Override:BorderStyleRow = Infragistics.Win.UIElementBorderStyle:None.
        appearance8:BackColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:Override:CardAreaAppearance = appearance8.
        appearance9:BorderColor = System.Drawing.Color:Silver.
        appearance9:TextTrimming = Infragistics.Win.TextTrimming:EllipsisCharacter.
        this-object:uxDetail:DisplayLayout:Override:CellAppearance = appearance9.
        this-object:uxDetail:DisplayLayout:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:EditAndSelectText.
        this-object:uxDetail:DisplayLayout:Override:CellPadding = 0.
        this-object:uxDetail:DisplayLayout:Override:ColumnSizingArea = Infragistics.Win.UltraWinGrid.ColumnSizingArea:EntireColumn.
        appearance10:BackColor = System.Drawing.SystemColors:Control.
        appearance10:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance10:BackGradientAlignment = Infragistics.Win.GradientAlignment:Element.
        appearance10:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance10:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:Override:GroupByRowAppearance = appearance10.
        appearance11:TextHAlignAsString = "Left".
        this-object:uxDetail:DisplayLayout:Override:HeaderAppearance = appearance11.
        this-object:uxDetail:DisplayLayout:Override:HeaderStyle = Infragistics.Win.HeaderStyle:WindowsXPCommand.
        appearance12:BackColor = System.Drawing.SystemColors:GradientInactiveCaption.
        this-object:uxDetail:DisplayLayout:Override:RowAlternateAppearance = appearance12.
        appearance13:BackColor = System.Drawing.SystemColors:Window.
        appearance13:BorderColor = System.Drawing.Color:Silver.
        this-object:uxDetail:DisplayLayout:Override:RowAppearance = appearance13.
        this-object:uxDetail:DisplayLayout:Override:RowSelectors = Infragistics.Win.DefaultableBoolean:False.
        appearance14:BackColor = System.Drawing.SystemColors:ControlLight.
        this-object:uxDetail:DisplayLayout:Override:TemplateAddRowAppearance = appearance14.
        this-object:uxDetail:DisplayLayout:RowConnectorStyle = Infragistics.Win.UltraWinGrid.RowConnectorStyle:None.
        this-object:uxDetail:DisplayLayout:ScrollBounds = Infragistics.Win.UltraWinGrid.ScrollBounds:ScrollToFill.
        this-object:uxDetail:DisplayLayout:ScrollStyle = Infragistics.Win.UltraWinGrid.ScrollStyle:Immediate.
        this-object:uxDetail:DisplayLayout:ViewStyle = Infragistics.Win.UltraWinGrid.ViewStyle:SingleBand.
        this-object:uxDetail:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxDetail:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle("8.25"), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:uxDetail:Location = new System.Drawing.Point(0, 0).
        this-object:uxDetail:Name = "uxDetail".
        this-object:uxDetail:Size = new System.Drawing.Size(452, 248).
        this-object:uxDetail:TabIndex = 1.
        this-object:uxDetail:Text = "User Detail".
        /*  */
        /* bsSettings */
        /*  */
        this-object:bsSettings:MaxDataGuess = 0.
        this-object:bsSettings:NoLOBs = false.
        this-object:bsSettings:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("Key", "Key", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = new Progress.Data.ColumnPropDesc("SettingValue", "Value", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar2.
        this-object:bsSettings:TableSchema = tableDesc1.
        /*  */
        /* ultraTabPageControl3 */
        /*  */
        this-object:ultraTabPageControl3:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabPageControl3:Name = "ultraTabPageControl3".
        this-object:ultraTabPageControl3:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* ultraPanel1 */
        /*  */
        /*  */
        /* ultraPanel1.ClientArea */
        /*  */
        this-object:ultraPanel1:ClientArea:Controls:Add(this-object:uxLogo).
        this-object:ultraPanel1:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:ultraPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:ultraPanel1:Name = "ultraPanel1".
        this-object:ultraPanel1:Size = new System.Drawing.Size(491, 55).
        this-object:ultraPanel1:TabIndex = 0.
        /*  */
        /* uxLogo */
        /*  */
        this-object:uxLogo:BorderShadowColor = System.Drawing.Color:Empty.
        this-object:uxLogo:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:uxLogo:Image = cast(resources:GetObject("uxLogo.Image"), System.Object).
        this-object:uxLogo:Location = new System.Drawing.Point(0, 0).
        this-object:uxLogo:Name = "uxLogo".
        this-object:uxLogo:Size = new System.Drawing.Size(491, 50).
        this-object:uxLogo:TabIndex = 1.
        /*  */
        /* uxVersionInfo */
        /*  */
        appearance15:BackColor = System.Drawing.Color:White.
        appearance15:BackColorDisabled = System.Drawing.Color:White.
        appearance15:ForeColorDisabled = System.Drawing.SystemColors:ControlText.
        appearance15:TextHAlignAsString = "Center".
        this-object:uxVersionInfo:Appearance = appearance15.
        this-object:uxVersionInfo:BackColor = System.Drawing.Color:White.
        this-object:uxVersionInfo:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:uxVersionInfo:Enabled = false.
        this-object:uxVersionInfo:Location = new System.Drawing.Point(0, 55).
        this-object:uxVersionInfo:Multiline = true.
        this-object:uxVersionInfo:Name = "uxVersionInfo".
        this-object:uxVersionInfo:ShowOverflowIndicator = true.
        this-object:uxVersionInfo:Size = new System.Drawing.Size(491, 32).
        this-object:uxVersionInfo:TabIndex = 0.
        this-object:uxVersionInfo:TabStop = false.
        /*  */
        /* imageList1 */
        /*  */
        this-object:imageList1:ImageStream = cast(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageList1:Images:SetKeyName(0, "aetf.ico").
        this-object:imageList1:Images:SetKeyName(1, "progress.ico").
        this-object:imageList1:Images:SetKeyName(2, "aetf_logo.png").
        this-object:imageList1:Images:SetKeyName(3, "source_p_32x32.png").
        this-object:imageList1:Images:SetKeyName(4, "services_32x32.png").
        this-object:imageList1:Images:SetKeyName(5, "bpmstudio_32x32.ico").
        this-object:imageList1:Images:SetKeyName(6, "system_info_32x32.png").
        this-object:imageList1:Images:SetKeyName(7, "user_info_32x32.png").
        this-object:imageList1:Images:SetKeyName(8, "certificate.png").
        this-object:imageList1:Images:SetKeyName(9, "conference.png").
        this-object:imageList1:Images:SetKeyName(10, "passport.png").
        /*  */
        /* uxSettingsGroup */
        /*  */
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabSharedControlsPage1).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl1).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl3).
        this-object:uxSettingsGroup:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxSettingsGroup:ImageList = this-object:imageList1.
        this-object:uxSettingsGroup:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxSettingsGroup:Location = new System.Drawing.Point(0, 87).
        this-object:uxSettingsGroup:Name = "uxSettingsGroup".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as System.Windows.Forms.Control extent 1 no-undo.
        arrayvar3[1] = this-object:uxDetail.
        this-object:uxSettingsGroup:SharedControls:AddRange(arrayvar3).
        this-object:uxSettingsGroup:SharedControlsPage = this-object:ultraTabSharedControlsPage1.
        this-object:uxSettingsGroup:Size = new System.Drawing.Size(491, 250).
        this-object:uxSettingsGroup:TabButtonStyle = Infragistics.Win.UIElementButtonStyle:Borderless.
        this-object:uxSettingsGroup:TabIndex = 1.
        this-object:uxSettingsGroup:TabOrientation = Infragistics.Win.UltraWinTabs.TabOrientation:LeftTop.
        appearance16:Image = "user_info_32x32.png".
        appearance16:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance16:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab3:Appearance = appearance16.
        ultraTab3:Key = "uxUserInfo".
        ultraTab3:TabPage = this-object:ultraTabPageControl1.
        ultraTab3:Text = "".
        ultraTab3:ToolTipText = "Application settings".
        appearance17:Image = "services_32x32.png".
        appearance17:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance17:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab2:Appearance = appearance17.
        ultraTab2:Key = "uxServerInfo".
        ultraTab2:TabPage = this-object:ultraTabPageControl3.
        ultraTab2:Text = "".
        ultraTab2:ToolTipText = "AppServer settings".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as Infragistics.Win.UltraWinTabControl.UltraTab extent 2 no-undo.
        arrayvar4[1] = ultraTab3.
        arrayvar4[2] = ultraTab2.
        this-object:uxSettingsGroup:Tabs:AddRange(arrayvar4).
        this-object:uxSettingsGroup:UseFlatMode = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxSettingsGroup:ViewStyle = Infragistics.Win.UltraWinTabControl.ViewStyle:Office2007.
        this-object:uxSettingsGroup:ActiveTabChanging:Subscribe(this-object:uxSettingsGroup_ActiveTabChanging).
        /*  */
        /* ultraTabSharedControlsPage1 */
        /*  */
        this-object:ultraTabSharedControlsPage1:Controls:Add(this-object:uxDetail).
        this-object:ultraTabSharedControlsPage1:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabSharedControlsPage1:Name = "ultraTabSharedControlsPage1".
        this-object:ultraTabSharedControlsPage1:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* HelpAbout */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(491, 337).
        this-object:Controls:Add(this-object:uxSettingsGroup).
        this-object:Controls:Add(this-object:uxVersionInfo).
        this-object:Controls:Add(this-object:ultraPanel1).
        this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        this-object:MinimumSize = new System.Drawing.Size(370, 325).
        this-object:Name = "HelpAbout".
        this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
        this-object:Text = "About".
        this-object:ultraTabPageControl1:ResumeLayout(false).
        cast(this-object:uxDetail, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bsSettings, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ultraPanel1:ClientArea:ResumeLayout(false).
        this-object:ultraPanel1:ResumeLayout(false).
        cast(this-object:uxVersionInfo, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxSettingsGroup, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:uxSettingsGroup:ResumeLayout(false).
        this-object:ultraTabSharedControlsPage1:ResumeLayout(false).
        this-object:ResumeLayout(false).
        this-object:PerformLayout().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    /*------------------------------------------------------------------------------
            Purpose:
            Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void uxSettingsGroup_ActiveTabChanging( input sender as System.Object, input e as Infragistics.Win.UltraWinTabControl.ActiveTabChangingEventArgs ):
        case string(e:Tab:Key):
            when 'uxUserInfo' then ShowDetailGrid('USER', 'User Detail', '').
            when 'uxServerInfo' then ShowDetailGrid('SERVER', 'Server Detail', '').
            when 'uxSessionInfo' then ShowDetailGrid('SESSION', 'Session Detail', '').
        end case.
    end method.

    method private void ShowDetailGrid(input pcGroup as character,
                                       input pcCaption as character,
                                       input pcHideColumns as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        iMax = uxDetail:DisplayLayout:Bands[0]:Columns:Count.
        do iLoop = 0 to (iMax - 1):
            uxDetail:DisplayLayout:Bands[0]:Columns[iLoop]:Hidden = lookup(pcHideColumns, uxDetail:DisplayLayout:Bands[0]:Columns[iLoop]:Key) gt 0.
        end.

        open query mQrySettings preselect each mSettingData where mSettingData.SettingGroup eq pcGroup by mSettingData.Order.
        bsSettings:Handle = query mQrySettings:handle.

        uxDetail:Text = pcCaption.
    end method.

    destructor public HelpAbout ( ):
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.

end class.