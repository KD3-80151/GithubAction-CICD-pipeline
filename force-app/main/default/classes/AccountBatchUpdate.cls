/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 20/06/2024
 * Last Modified Date: 
 * Purpose: Calling One batch from one to another
 * -----------------------------------------------------------------------------------------------------
 */


public class AccountBatchUpdate implements Database.Batchable<sObject>, Database.Stateful{
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator ('select Id, Name from Account');
    }
    
    public void execute (Database.BatchableContext bc, List<Account> scope){
        for(Account acc: scope){
            acc.Description = 'Updated by batch process';
        }  
        update scope;
    }
    //calling AccountBatchTwoUpdate 
    //To Invoke Batch Apex From Another Batch Apex In Salesforce
    public void finish (Database.BatchableContext bc){
        Database.executeBatch(new AccountBatchTwoUpdate());
    }
    
        

}