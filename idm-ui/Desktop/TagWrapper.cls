/** ------------------------------------------------------------------------
    File        : TagWrapper
    Purpose     : Simple wrapper for non-.NETGUI PABLO's so that they can be
                  used for Tags.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jul 08 14:48:22 EDT 2010
    Notes       : * PABLO = Plain ABL Object
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.
  
/* No USING to make it clear which Object is which */

class Desktop.TagWrapper final inherits System.Object:
    /** The ABL Object being stored in the .NET Object's Tag property. */
    define public property PABLO as Progress.Lang.Object no-undo get. private set.  
    
    constructor public TagWrapper(poPABLO as Progress.Lang.Object):
        this-object:PABLO = poPABLO.
    end constructor.
    
end class.