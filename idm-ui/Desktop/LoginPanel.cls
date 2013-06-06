/*------------------------------------------------------------------------
    File        : LoginPanel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 09 08:10:42 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
 
using Desktop.MainForm.

using Progress.Windows.Form.
using Progress.Windows.UserControl.

using Progress.Lang.Error.
using Progress.Lang.AppError.

class Desktop.LoginPanel inherits UserControl:
    
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable lblDomain as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable ultraToolTipManager1 as Infragistics.Win.UltraWinToolTip.UltraToolTipManager no-undo.
    define private variable uxDomain as Infragistics.Win.UltraWinEditors.UltraComboEditor no-undo.
    define private variable uxInputPanel as Infragistics.Win.Misc.UltraPanel no-undo.
    define private variable uxUser as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.
    define private variable uxPassword as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.
    define private variable uxLogin as Infragistics.Win.Misc.UltraButton no-undo.
    define private variable uxCancel as Infragistics.Win.Misc.UltraButton no-undo.
    define private variable lblUser as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable lblPassword as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable imageList1 as System.Windows.Forms.ImageList no-undo.

    define private variable moMainForm as MainForm no-undo.
    
    constructor public LoginPanel(input poMainForm as MainForm):
        this-object().
        
        /* Employee */
        uxDomain:SelectedIndex = 1.
        uxPassword:Text = 'letmein'.
        moMainForm = poMainForm.
    end constructor.
    
    constructor public LoginPanel (  ):
        super().
        InitializeComponent().
        
        /* throws to wait-for */
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

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
        define variable appearance2 as Infragistics.Win.Appearance no-undo.
        appearance2 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance3 as Infragistics.Win.Appearance no-undo.
        appearance3 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable valueListItem1 as Infragistics.Win.ValueListItem no-undo.
        valueListItem1 = new Infragistics.Win.ValueListItem().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable valueListItem14 as Infragistics.Win.ValueListItem no-undo.
        valueListItem14 = new Infragistics.Win.ValueListItem().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable valueListItem4 as Infragistics.Win.ValueListItem no-undo.
        valueListItem4 = new Infragistics.Win.ValueListItem().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance4 as Infragistics.Win.Appearance no-undo.
        appearance4 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance5 as Infragistics.Win.Appearance no-undo.
        appearance5 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("Desktop.LoginPanel").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance6 as Infragistics.Win.Appearance no-undo.
        appearance6 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance7 as Infragistics.Win.Appearance no-undo.
        appearance7 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraToolTipInfo1 as Infragistics.Win.UltraWinToolTip.UltraToolTipInfo no-undo.
        ultraToolTipInfo1 = new Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("", Infragistics.Win.ToolTipImage:Info, "User Login Information", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance8 as Infragistics.Win.Appearance no-undo.
        appearance8 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraToolTipInfo2 as Infragistics.Win.UltraWinToolTip.UltraToolTipInfo no-undo.
        ultraToolTipInfo2 = new Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("", Infragistics.Win.ToolTipImage:Info, "Password Hints", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance9 as Infragistics.Win.Appearance no-undo.
        appearance9 = new Infragistics.Win.Appearance().
        this-object:lblUser = new Infragistics.Win.Misc.UltraLabel().
        this-object:uxInputPanel = new Infragistics.Win.Misc.UltraPanel().
        this-object:uxDomain = new Infragistics.Win.UltraWinEditors.UltraComboEditor().
        this-object:lblDomain = new Infragistics.Win.Misc.UltraLabel().
        this-object:uxLogin = new Infragistics.Win.Misc.UltraButton().
        this-object:imageList1 = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxCancel = new Infragistics.Win.Misc.UltraButton().
        this-object:uxUser = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:uxPassword = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:lblPassword = new Infragistics.Win.Misc.UltraLabel().
        this-object:ultraToolTipManager1 = new Infragistics.Win.UltraWinToolTip.UltraToolTipManager(this-object:components).
        this-object:uxInputPanel:ClientArea:SuspendLayout().
        this-object:uxInputPanel:SuspendLayout().
        cast(this-object:uxDomain, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxUser, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxPassword, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* lblUser */
        /*  */
        appearance1:FontData:Name = "Segoe UI".
        appearance1:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        appearance1:TextVAlignAsString = "Middle".
        this-object:lblUser:Appearance = appearance1.
        this-object:lblUser:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle("8.25")).
        this-object:lblUser:Location = new System.Drawing.Point(9, 9).
        this-object:lblUser:Name = "lblUser".
        this-object:lblUser:Size = new System.Drawing.Size(382, 31).
        this-object:lblUser:TabIndex = 0.
        this-object:lblUser:Text = "User Name".
        /*  */
        /* uxInputPanel */
        /*  */
        appearance2:BackColor = System.Drawing.Color:Silver.
        appearance2:BorderColor = System.Drawing.Color:Black.
        appearance2:ImageBackgroundStyle = Infragistics.Win.ImageBackgroundStyle:Stretched.
        this-object:uxInputPanel:Appearance = appearance2.
        this-object:uxInputPanel:AutoSize = true.
        /*  */
        /* uxInputPanel.ClientArea */
        /*  */
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxDomain).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblDomain).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxLogin).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxCancel).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxUser).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblUser).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxPassword).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblPassword).
        this-object:uxInputPanel:Location = new System.Drawing.Point(0, 0).
        this-object:uxInputPanel:Name = "uxInputPanel".
        this-object:uxInputPanel:Size = new System.Drawing.Size(403, 162).
        this-object:uxInputPanel:TabIndex = 21.
        /*  */
        /* uxDomain */
        /*  */
        appearance3:FontData:Name = "Segoe UI".
        appearance3:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        this-object:uxDomain:Appearance = appearance3.
        valueListItem1:DataValue = "customer".
        valueListItem1:DisplayText = "Customer".
        valueListItem14:DataValue = "employee".
        valueListItem14:DisplayText = "Employee".
        valueListItem4:DataValue = "system".
        valueListItem4:DisplayText = "System".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as Infragistics.Win.ValueListItem extent 3 no-undo.
        arrayvar0[1] = valueListItem1.
        arrayvar0[2] = valueListItem14.
        arrayvar0[3] = valueListItem4.
        this-object:uxDomain:Items:AddRange(arrayvar0).
        this-object:uxDomain:Location = new System.Drawing.Point(151, 46).
        this-object:uxDomain:Name = "uxDomain".
        this-object:uxDomain:Size = new System.Drawing.Size(242, 31).
        this-object:uxDomain:SortStyle = Infragistics.Win.ValueListSortStyle:Ascending.
        this-object:uxDomain:TabIndex = 30.
        /*  */
        /* lblDomain */
        /*  */
        appearance4:FontData:Name = "Segoe UI".
        appearance4:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        appearance4:TextVAlignAsString = "Middle".
        this-object:lblDomain:Appearance = appearance4.
        this-object:lblDomain:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle("8.25")).
        this-object:lblDomain:Location = new System.Drawing.Point(9, 46).
        this-object:lblDomain:Name = "lblDomain".
        this-object:lblDomain:Size = new System.Drawing.Size(382, 31).
        this-object:lblDomain:TabIndex = 0.
        this-object:lblDomain:Text = "Domain".
        /*  */
        /* uxLogin */
        /*  */
        appearance5:FontData:Name = "Segoe UI".
        appearance5:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        appearance5:Image = "accept_32x32.png".
        this-object:uxLogin:Appearance = appearance5.
        this-object:uxLogin:DialogResult = System.Windows.Forms.DialogResult:OK.
        this-object:uxLogin:ImageList = this-object:imageList1.
        this-object:uxLogin:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxLogin:Location = new System.Drawing.Point(148, 117).
        this-object:uxLogin:Name = "uxLogin".
        this-object:uxLogin:Size = new System.Drawing.Size(120, 40).
        this-object:uxLogin:TabIndex = 50.
        this-object:uxLogin:Text = "Login".
        this-object:uxLogin:Click:Subscribe(this-object:uxLogin_Click).
        /*  */
        /* imageList1 */
        /*  */
        this-object:imageList1:ImageStream = cast(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageList1:Images:SetKeyName(0, "portal_silver_icon.png").
        this-object:imageList1:Images:SetKeyName(1, "portal_silver.png").
        this-object:imageList1:Images:SetKeyName(2, "").
        this-object:imageList1:Images:SetKeyName(3, "accept_32x32.png").
        this-object:imageList1:Images:SetKeyName(4, "cancel_32x32.png").
        /*  */
        /* uxCancel */
        /*  */
        appearance6:FontData:Name = "Segoe UI".
        appearance6:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        appearance6:Image = "cancel_32x32.png".
        this-object:uxCancel:Appearance = appearance6.
        this-object:uxCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        this-object:uxCancel:ImageList = this-object:imageList1.
        this-object:uxCancel:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxCancel:Location = new System.Drawing.Point(273, 118).
        this-object:uxCancel:Name = "uxCancel".
        this-object:uxCancel:Size = new System.Drawing.Size(120, 40).
        this-object:uxCancel:TabIndex = 60.
        this-object:uxCancel:Text = "Cancel".
        this-object:uxCancel:Click:Subscribe(this-object:uxCancel_Click).
        /*  */
        /* uxUser */
        /*  */
        appearance7:FontData:Name = "Segoe UI".
        appearance7:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        this-object:uxUser:Appearance = appearance7.
        this-object:uxUser:Location = new System.Drawing.Point(151, 9).
        this-object:uxUser:Name = "uxUser".
        this-object:uxUser:Size = new System.Drawing.Size(242, 31).
        this-object:uxUser:TabIndex = 20.
        ultraToolTipInfo1:ToolTipImage = Infragistics.Win.ToolTipImage:Info.
        ultraToolTipInfo1:ToolTipTextStyle = Infragistics.Win.ToolTipTextStyle:Formatted.
        ultraToolTipInfo1:ToolTipTitle = "User Login Information".
        this-object:ultraToolTipManager1:SetUltraToolTip(this-object:uxUser, ultraToolTipInfo1).
        /*  */
        /* uxPassword */
        /*  */
        appearance8:FontData:Name = "Segoe UI".
        appearance8:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        this-object:uxPassword:Appearance = appearance8.
        this-object:uxPassword:Location = new System.Drawing.Point(149, 80).
        this-object:uxPassword:Name = "uxPassword".
        this-object:uxPassword:PasswordChar = '*'.
        this-object:uxPassword:Size = new System.Drawing.Size(242, 31).
        this-object:uxPassword:TabIndex = 40.
        ultraToolTipInfo2:ToolTipImage = Infragistics.Win.ToolTipImage:Info.
        ultraToolTipInfo2:ToolTipTextFormatted = "<span style=~"font-style:italic;~">letmein </span>&edsp;is a good guess for users.".
        ultraToolTipInfo2:ToolTipTextStyle = Infragistics.Win.ToolTipTextStyle:Formatted.
        ultraToolTipInfo2:ToolTipTitle = "Password Hints".
        this-object:ultraToolTipManager1:SetUltraToolTip(this-object:uxPassword, ultraToolTipInfo2).
        /*  */
        /* lblPassword */
        /*  */
        appearance9:FontData:Name = "Segoe UI".
        appearance9:FontData:SizeInPoints = Progress.Util.CastUtil:ToSingle("12").
        appearance9:TextVAlignAsString = "Middle".
        this-object:lblPassword:Appearance = appearance9.
        this-object:lblPassword:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle("8.25")).
        this-object:lblPassword:Location = new System.Drawing.Point(9, 81).
        this-object:lblPassword:Name = "lblPassword".
        this-object:lblPassword:Size = new System.Drawing.Size(382, 31).
        this-object:lblPassword:TabIndex = 0.
        this-object:lblPassword:Text = "Password".
        /*  */
        /* ultraToolTipManager1 */
        /*  */
        this-object:ultraToolTipManager1:ContainingControl = this-object.
        /*  */
        /* LoginPanel */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle("6"), Progress.Util.CastUtil:ToSingle("13")).
        this-object:AutoSize = true.
        this-object:AutoSizeMode = System.Windows.Forms.AutoSizeMode:GrowAndShrink.
        this-object:BackColor = System.Drawing.Color:Transparent.
        this-object:Controls:Add(this-object:uxInputPanel).
        this-object:Name = "LoginPanel".
        this-object:Size = new System.Drawing.Size(406, 165).
        this-object:uxInputPanel:ClientArea:ResumeLayout(false).
        this-object:uxInputPanel:ClientArea:PerformLayout().
        this-object:uxInputPanel:ResumeLayout(false).
        this-object:uxInputPanel:PerformLayout().
        cast(this-object:uxDomain, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxUser, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxPassword, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        this-object:PerformLayout().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.


    method override protected void OnLoad(input e as System.EventArgs ):
        super:OnLoad(input e).
        
        this-object:ActiveControl = uxUser.
    end method.

    method private void uxCancel_Click( input sender as System.Object, input e as System.EventArgs ):
        cast(this-object:Parent, Form):Close().
        
        catch oAppError as AppError:
            message oAppError:ReturnValue
                view-as alert-box error.                        
        end catch.

        catch oError as Error:
            message oError:GetMessage(1)
                view-as alert-box error.
        end catch.
    end method.
    
    method private void uxLogin_Click( input sender as System.Object, input e as System.EventArgs ):
        define variable hClientPrincipal as handle no-undo.
        
        if uxDomain:SelectedIndex eq -1 then
            undo, throw new AppError('Please select a domain').

        create client-principal hClientPrincipal.
        hClientPrincipal:initialize(
            substitute('&1@&2', uxUser:Text, uxDomain:Value:ToString()),  /* qualified username */
            ?,  /* session-id */
            ?,  /* timeout/expiration */
            uxPassword:Text).
        
        if moMainForm:LoginUser(hClientPrincipal) then
            cast(this-object:Parent, Form):Close().
        
        catch oAppError as AppError:
            message oAppError:ReturnValue
                view-as alert-box error.                        
        end catch.

        catch oError as Error:
            message oError:GetMessage(1)
                view-as alert-box error.
        end catch.
    end method.

    destructor public LoginPanel ( ):
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.

end class.