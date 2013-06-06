/*------------------------------------------------------------------------
    File        : dsCustomerOrder.i
    Description : Dataset definition for the BE prototype
    Author(s)   : pjudge 
    Notes       : * This include should ideally be in a common/shared location,
                    but duplicating it makes the code a little more 'followable'
                    I think. Not a best practice though. 
  ----------------------------------------------------------------------*/
define temp-table ttCustomer no-undo before-table btCustomer 
    field CustNum as integer 
    field Name as character 
    field Address as character 
    field Phone as character 
    field SalesRep as character 
    field Balance as decimal 
    field City as character
    field State as character 
    field Country as character 
    index CustNumIdx is unique primary CustNum.

define temp-table ttOrder no-undo before-table btOrder
    field Ordernum as integer 
    field CustNum as integer 
    field OrderDate as date 
    field SalesRep as character 
    field OrderStatus as character initial "Ordered" 
    index CustOrderIdx is unique CustNum Ordernum 
    index OrdernumIdx is unique primary Ordernum.

define dataset dsCustomerOrder  
    for ttCustomer, ttOrder
    data-relation custOrdRel for ttCustomer, ttOrder
        relation-fields (CustNum, CustNum) /*nested*/ .
