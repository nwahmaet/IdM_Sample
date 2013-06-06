/*------------------------------------------------------------------------
    File        : CustomerOrderDA
    Notes       
   
   * This is a sample Data Access Object that works with the sample
     Business Entity, CustomerOrderBE.    
  ----------------------------------------------------------------------*/  
routine-level on error undo, throw.

class BusinessLogic.CustomerOrderDA:
    {BusinessLogic/dsCustomerOrder.i}
    
    define data-source srcCustomer for Customer.
    define data-source srcOrder for Order.
    
    constructor public CustomerOrderDA():
        
    end constructor.
    
    method public void CreateCustomer (input dataset for dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create one or more new customers                                                                    
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitCustomers(dataset dsCustomerOrder by-reference,
                        string(true),
                        row-created).
    end method.
    
    method public void CreateOrder (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create one or more new Orders                                                                   
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitOrders(dataset dsCustomerOrder by-reference,
                     string(true),
                     row-created).
    end method.
    
    method public void CreateCustomersOrders (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Create set of Customers and Orders                                                                      
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitOrders(dataset dsCustomerOrder by-reference,
                     string(true),
                     row-created).
        
        CommitCustomers(dataset dsCustomerOrder by-reference,
                        string(true),
                        row-created).
    end method.
    
    method public void GetCustomers(output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get all Customers                                                               
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            'where true',
            'no-fill',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).
    end method.
    
    method protected void FillDataset(input pcCustomerWhere as character,
                                      input pcOrderFillMode as character,
                                      input pcOrderWhere as character,
                                      output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get all Customers                                                               
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        buffer ttCustomer:attach-data-source(data-source srcCustomer:handle).
        if pcCustomerWhere ne '' then
            data-source srcCustomer:fill-where-string = pcCustomerWhere.
        
        buffer ttOrder:attach-data-source(data-source srcOrder:handle).
        if pcOrderWhere ne '' then
            data-source srcOrder:fill-where-string = pcOrderWhere.
        
        buffer ttCustomer:fill-mode = 'empty'.
        buffer ttOrder:fill-mode = pcOrderFillMode.
        
        dataset dsCustomerOrder:fill().
        
        buffer ttCustomer:detach-data-source().
        buffer ttOrder:detach-data-source().
    end method.
    
    method public void GetCustomersOrders (output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get all Customers and Orders                                                                    
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            'where true',
            'empty',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).
    end method.

    method public void GetCustomerByName(input pcCustName as character,
                                         output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose: get a customer based on primary key CustNum                                                                      
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            substitute('where Customer.Name = &1', pcCustName),
            'no-fill',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).
    end method.
    
    method public void GetCustomerByCustNum(input piCustNum as integer,
                                            output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose: get a customer based on primary key CustNum                                                                      
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            substitute('where Customer.CustNum = &1', piCustNum),
            'no-fill',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).
    end method.
    
    method public void GetOrderByOrderNum(input piCustNum as integer, 
                                          input piOrdernum as integer,
                                          output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get an Order based on primary key Ordernum                                                                      
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            substitute('where Customer.CustNum = &1', piCustNum),
            'empty',      /* orders */
             substitute('where Order.OrderNum = &1', piOrdernum),
            output dataset dsCustomerOrder by-reference).        
    end method.
    
    method public void GetCustomerOrders (input piCustNum as integer,
                                          output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get a customer based on primary key CustNum
                          and all of its orders                                                                   
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            substitute('where Customer.CustNum = &1', piCustNum),
            'empty',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).        
    end method.

    method public void GetCustomerOrders (input pcCustName as character,
                                          output dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  get a customer based on primary key CustNum
                          and all of its orders                                                                   
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        FillDataset(
            substitute('where Customer.Name = &1', pcCustName),
            'empty',      /* orders */
            '',
            output dataset dsCustomerOrder by-reference).        
    end method.
    
    method public void UpdateCustomer (input piCustNum as integer,
                                       input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Update a Customer                                                                   
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitCustomers(dataset dsCustomerOrder by-reference,
                        substitute('where ttCustomer.CustNum eq &1', piCustNum),
                        row-modified).
    end method.
    
    method public void UpdateOrder (input piOrderNum as integer,
                                    input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  Update an Order                                                                     
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitOrders(dataset dsCustomerOrder by-reference,
                     substitute('where ttOrder.Ordernum eq &1', piOrderNum),
                     row-modified).
    end method.
    
    method public void UpdateCustomersOrders (input dataset dsCustomerOrder):
        /*------------------------------------------------------------------------------
                Purpose:  update a set of customers and orders                                                                    
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        CommitOrders(dataset dsCustomerOrder by-reference,
                     string(true),
                     row-modified).
        
        CommitCustomers(dataset dsCustomerOrder by-reference,
                        string(true),
                        row-modified).
    end method.
    
    method public void DeleteCustomer (input piCustNum as integer):
        /*------------------------------------------------------------------------------
                Purpose:  Delete a customer record                                                                    
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        create ttCustomer.
        assign ttCustomer.CustNum = piCustNum.
        
        CommitCustomers(dataset dsCustomerOrder by-reference,
                        substitute('where ttCustomer.CustNum eq &1', piCustNum),
                        row-deleted).
    end method.
    
    method public void DeleteOrder (input piOrderNum as integer):
        /*------------------------------------------------------------------------------
                Purpose:  Delete an order                                                                     
                Notes:                                                                        
        ------------------------------------------------------------------------------*/
        create ttOrder.
        assign ttOrder.OrderNum = piOrderNum.
        
        CommitOrders(dataset dsCustomerOrder by-reference,
                     substitute('where ttOrder.OrderNum eq &1', piOrderNum),
                     row-deleted).
    end method.

    method private void CommitCustomers(input dataset dsCustomerOrder,
                                        input pcWhereClause as character,   
                                        input piRowState as integer):
        define query qryCustomer for ttCustomer.
        
        temp-table ttCustomer:tracking-changes = true.
        buffer ttCustomer:attach-data-source(data-source srcCustomer:handle).
        
        query qryCustomer:query-prepare(substitute('for each ttCustomer where &1', pcWhereClause)).
        
        get first qryCustomer.
        do while available ttCustomer:
            buffer ttCustomer:mark-row-state(piRowState).            
            buffer ttCustomer:save-row-changes(1, 'CustNum').
            
            get next qryCustomer.
        end.
                                            
        temp-table ttCustomer:tracking-changes = false.
        buffer ttCustomer:detach-data-source().
        
        finally:
            close query qryCustomer.
        end finally.
    end method.
        
    method private void CommitOrders(input dataset dsCustomerOrder,
                                     input pcWhereClause as character,   
                                     input piRowState as integer):
        define query qryOrder for ttOrder.
        
        temp-table ttOrder:tracking-changes = true.
        buffer ttOrder:attach-data-source(data-source srcOrder:handle).
        
        query qryOrder:query-prepare(substitute('for each ttOrder where &1', pcWhereClause)).
        
        get first qryOrder.
        do while available ttOrder:
            buffer ttOrder:mark-row-state(piRowState).
            buffer ttOrder:save-row-changes().
            
            get next qryOrder.
        end.
                                            
        temp-table ttOrder:tracking-changes = false.
        buffer ttOrder:detach-data-source().
        
        finally:
            close query qryOrder.
        end finally.
    end method.    
end class.
