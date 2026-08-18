public class CountSuccessfulOrNot implements Database.Batchable<sObject> {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Contact_Count_Batch__c, Oppo_Count_Batch__c FROM Account');
    }
   
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
         Integer countC =0;
        Integer oCount=0;
        List<Account> accList = (List<Account>) scope;
        Set<Id> accountIds = new Set<Id>();
        
        for (Account acc : accList) {
            accountIds.add(acc.Id);
        }

        List<Contact> contactList = [SELECT AccountId FROM Contact WHERE AccountId IN :accountIds];
        Map<Id, Integer> contactCounts = new Map<Id, Integer>();
        for (Contact con : contactList) {
            if (!contactCounts.containsKey(con.AccountId)) {
                contactCounts.put(con.AccountId, 0);
            }
            contactCounts.put(con.AccountId, contactCounts.get(con.AccountId) + 1);
        }
        
        
        
        List<Opportunity> oppoList = [SELECT AccountId FROM Opportunity WHERE AccountId IN :accountIds];
        Map<Id, Integer> oppoCounts = new Map<Id, Integer>();
        
        for (Opportunity opp : oppoList) {
            if (!oppoCounts.containsKey(opp.AccountId)) {
                oppoCounts.put(opp.AccountId, 0);
            }
            oppoCounts.put(opp.AccountId, oppoCounts.get(opp.AccountId) + 1);
        }
        
        for (Account acc : accList) {
            
            if (contactCounts.containsKey(acc.Id)) {
                acc.Contact_Count_Batch__c = contactCounts.get(acc.Id);
                countC++;
               
            } else {
                acc.Contact_Count_Batch__c = 0;
            }
            
            

                    
                    if (oppoCounts.containsKey(acc.Id)) {
                acc.Oppo_Count_Batch__c = oppoCounts.get(acc.Id);
                        oCount++;
            } else {
                acc.Oppo_Count_Batch__c = 0;
            }
            

}
        

        Database.update(accList, false);
        System.debug('no. of successful contact: '+countC);
         System.debug('no. of successful opportunity: '+oCount);
    }
    
    public void finish(Database.BatchableContext bc) {
       
       
    }
}