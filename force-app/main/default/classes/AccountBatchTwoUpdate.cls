/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 20/06/2024
 * Last Modified Date: 
 * 
 * -----------------------------------------------------------------------------------------------------
 */

//class is used To Invoke Batch Apex From Another Batch Apex In Salesforce
public class AccountBatchTwoUpdate implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator ('select Id,Name, Description from Account where ');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope){
        for(Account acc: scope){
            acc.Description ='2nd time batch updating';
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Completed');
    }

}