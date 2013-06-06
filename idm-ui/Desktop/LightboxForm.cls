/*------------------------------------------------------------------------
    File        : LightboxForm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 09 09:52:53 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using System.Drawing.Rectangle.
using System.Drawing.Point.
using System.Windows.Forms.Control.
using Progress.Lang.*.
using Progress.Windows.Form.

class Desktop.LightboxForm inherits Form: 
    
    define private variable components as System.ComponentModel.IContainer no-undo.
    
    define public property OverlaidForm as Form no-undo get. private set.          
    define public property BrightControl as Control extent no-undo get. private set.
    define private variable Overlay as Form no-undo. 
    define private variable uxClose as System.Windows.Forms.Button no-undo.
    
    constructor public LightboxForm(input poOverlaidForm as Form,
                                    input poBrightControl as Control extent):
        this-object().
        
        assign OverlaidForm = poOverlaidForm
               this-object:Owner = OverlaidForm               
               BrightControl = poBrightControl.
        
        CreateOverlay().
        ExposeBrightControls().
        ResizeMe().
        MoveMe().
        
        OverlaidForm:ResizeEnd:Subscribe(this-object:OverlaidForm_ResizeEnd).
        OverlaidForm:Move:Subscribe(this-object:OverlaidForm_Move).
    end constructor.
    
    method protected void CreateOverlay():
        this-object:Overlay = new Form().
        
        this-object:Overlay:Owner = this-object.
        this-object:Overlay:BackColor = System.Drawing.Color:Fuchsia.
        this-object:Overlay:TransparencyKey = this-object:Overlay:BackColor.
        this-object:Overlay:FormBorderStyle = System.Windows.Forms.FormBorderStyle:None.
        this-object:Overlay:MaximizeBox = false.
        this-object:Overlay:MinimizeBox = false.
        this-object:Overlay:ShowIcon = false.
        this-object:Overlay:ShowInTaskbar = false.
        this-object:Overlay:SizeGripStyle = System.Windows.Forms.SizeGripStyle:Hide.
        this-object:Overlay:StartPosition = System.Windows.Forms.FormStartPosition:Manual.
        
        this-object:Overlay:Closed:Subscribe(Overlay_Closed).
    end method.
    
    method protected void ExposeBrightControls():
        def var iLoop as int no-undo.
        def var iMax as int no-undo.
        
        iMax = extent(BrightControl).
        do iLoop = 1 to iMax:
            this-object:Overlay:Controls:Add(BrightControl[iLoop]).
        end.
    end method.
    
    method public void Overlay_Closed(sender as class System.Object, e as class System.EventArgs):
        /* Closing this-object will cause the Overlay form to fire the Close too. We don't 
           want to get stuck in a loop doing this. */
        this-object:Overlay:Closed:Unsubscribe(Overlay_Closed).
        
        this-object:Close().
    end method.
    
    method private void LightboxForm_Shown( input sender as System.Object, input e as System.EventArgs ):
        this-object:Overlay:BringToFront().
        this-object:Overlay:Show().
    end method.
    
    method protected void ResizeMe():
        this-object:Size = OverlaidForm:ClientRectangle:Size.
        this-object:Overlay:Size = this-object:Size. 
    end method.
    
    method public void OverlaidForm_ResizeEnd(poSender as System.Object, poArgs as System.EventArgs):
        ResizeMe().
    end method.
    
    method protected void MoveMe():
        def var oScreenRectangle as Rectangle no-undo. 
        
        oScreenRectangle = OverlaidForm:RectangleToScreen(OverlaidForm:ClientRectangle).
        
        this-object:Location = new Point(oScreenRectangle:X, oScreenRectangle:Y).
        this-object:Overlay:Location = this-object:Location.
    end method.
    
    method public void OverlaidForm_Move(poSender as System.Object, poArgs as System.EventArgs):
        MoveMe().
    end method.
    
    constructor public LightboxForm (  ):
        super().
        InitializeComponent().
        
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.

    end constructor.

    method private void InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:uxClose = new System.Windows.Forms.Button().
        this-object:SuspendLayout().
        /*  */
        /* uxClose */
        /*  */
        define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
        nestedvar0 = System.Windows.Forms.AnchorStyles:Top.
        this-object:uxClose:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        this-object:uxClose:BackColor = System.Drawing.Color:Transparent.
        this-object:uxClose:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        this-object:uxClose:FlatAppearance:BorderSize = 2.
        this-object:uxClose:FlatAppearance:MouseDownBackColor = System.Drawing.Color:Transparent.
        this-object:uxClose:FlatAppearance:MouseOverBackColor = System.Drawing.Color:DimGray.
        this-object:uxClose:FlatStyle = System.Windows.Forms.FlatStyle:Flat.
        this-object:uxClose:Font = new System.Drawing.Font("Verdana", 14.25, System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:uxClose:ForeColor = System.Drawing.Color:LightGray.
        this-object:uxClose:Location = new System.Drawing.Point(255, 12).
        this-object:uxClose:Name = "uxClose".
        this-object:uxClose:Size = new System.Drawing.Size(25, 26).
        this-object:uxClose:TabIndex = 0.
        this-object:uxClose:Text = "X".
        this-object:uxClose:UseCompatibleTextRendering = true.
        this-object:uxClose:UseVisualStyleBackColor = false.
        this-object:uxClose:Click:Subscribe(this-object:uxClose_Click).
        /*  */
        /* LightboxForm */
        /*  */
        this-object:BackColor = System.Drawing.Color:Black.
        this-object:BackgroundImageLayout = System.Windows.Forms.ImageLayout:Zoom.
        this-object:ClientSize = new System.Drawing.Size(292, 266).
        this-object:Controls:Add(this-object:uxClose).
        this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:None.
        this-object:MaximizeBox = false.
        this-object:MinimizeBox = false.
        this-object:Name = "LightboxForm".
        this-object:Opacity = 0.5.
        this-object:ShowIcon = false.
        this-object:ShowInTaskbar = false.
        this-object:SizeGripStyle = System.Windows.Forms.SizeGripStyle:Hide.
        this-object:StartPosition = System.Windows.Forms.FormStartPosition:Manual.
        this-object:Text = "LightboxForm".
        this-object:Shown:Subscribe(this-object:LightboxForm_Shown).
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    method private void uxClose_Click(input sender as System.Object, input e as System.EventArgs ):
        this-object:Overlay:Close().
        this-object:Close().
    end method.
    
    destructor public LightboxForm():
        this-object:OverlaidForm:ResizeEnd:Unsubscribe(OverlaidForm_ResizeEnd).
        this-object:OverlaidForm:Move:Unsubscribe(OverlaidForm_Move).
        this-object:Overlay:Closed:Unsubscribe(Overlay_Closed).
        
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.

end class.