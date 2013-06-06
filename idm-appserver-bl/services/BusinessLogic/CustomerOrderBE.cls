/*------------------------------------------------------------------------
    File        : CustomerOrderBE
    Notes          
  ----------------------------------------------------------------------*/  
/*routine-level on error undo, throw.*/

using BusinessLogic.CustomerOrderDA.

class BusinessLogic.CustomerOrderBE:
    {BusinessLogic/dsCustomerOrder.i}
    
    define data-source srcCustomer for Customer.
    define data-source srcOrder for Order.

    
    define public property DataAccess as CustomerOrderDA no-undo get. private set.

    constructor public CustomerOrderBE():
        this-object:DataAccess = new CustomerOrderDA().
    end constructor.
    
    method public void CreateCustomer(input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create one or more new customers                                                                    
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:CreateCustomer(input dataset dsCustomerOrder by-reference).
    end method.
    
    method public void CreateOrder (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create one or more new Orders                                                                   
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:CreateOrder(input dataset dsCustomerOrder by-reference).
    end method.
    
    method public void CreateCustomersOrders (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create set of Customers and Orders                                                                      
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:CreateCustomersOrders(input dataset dsCustomerOrder by-reference).
    end method.
    
    method public void GetCustomers (output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get all Customers                                                                   
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:GetCustomers(output dataset dsCustomerOrder by-reference).
    end method.
    
    method public void GetCustomersOrders (output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get all Customers and Orders                                                                    
                Notes:                                                               
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:GetCustomersOrders(output dataset dsCustomerOrder by-reference).
    end method.
    
    method public void GetCustomerByName(input pcCustName as character,
                                         output dataset dsCustomerOrder):
        this-object:DataAccess:GetCustomerByName(input pcCustName, output dataset dsCustomerOrder by-reference).                                             
    end method.
        
    method public void GetCustomerByCustNum (input piCustNum as integer,
                                             output dataset dsCustomerOrder):
        this-object:DataAccess:GetCustomerByCustNum(input piCustNum, output dataset dsCustomerOrder by-reference).                                                 
    end method.
    
    method public void GetOrderByOrdernum (input piCustNum as integer,
                                           input piOrderNum as integer,
                                           output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get an Order based on primary key Ordernum                                                                      
                Notes:                                                                
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:GetOrderByOrderNum(piCustNum, piOrderNum, output dataset dsCustomerOrder by-reference).
    end method.

    method public void GetCustomerOrders(input pcCustName as character,
                                         output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get a customer based on primary key CustNum
                          and all of its orders                                                                   
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:GetCustomerOrders(input pcCustName, output dataset dsCustomerOrder by-reference).
    end method.

    method public void GetCustomerOrders(input piCustNum as integer,
                                         output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get a customer based on primary key CustNum
                          and all of its orders                                                                   
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:GetCustomerOrders(input piCustNum, output dataset dsCustomerOrder by-reference).
    end method.
    
    method public void UpdateCustomer (input piCustNum as integer,
                                       input table ttCustomer):
        /*------------------------------------------------------------------------------
                Purpose:  Update a Customer                                                                   
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:UpdateCustomer(input piCustNum, input dataset dsCustomerOrder by-reference).    
    end method.
    
    method public void UpdateOrder (input piOrderNum as integer,
                                    input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Update an Order                                                                     
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:UpdateOrder(input piOrderNum, input dataset dsCustomerOrder by-reference).
    end method.
    
    method public void UpdateCustomersOrders (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose: update a set of customers and orders                                                                     
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:UpdateCustomersOrders(input dataset dsCustomerOrder by-reference).            
    end method.
    
    method public void DeleteCustomer(input piCustNum as integer):
        /*------------------------------------------------------------------------------
                Purpose:  Delete a customer record                                                                    
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:DeleteCustomer(piCustNum).    
    end method.
    
    method public void DeleteOrder (input piOrderNum as integer):
        /*------------------------------------------------------------------------------
                Purpose:  Delete an order                                                                     
                Notes:                                                                    
        ------------------------------------------------------------------------------*/
        this-object:DataAccess:DeleteOrder(input piOrderNum).
    end method.
end class.
