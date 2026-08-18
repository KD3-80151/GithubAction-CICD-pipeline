public class FutureClass {
    
    public static void CallTheFutureMethod(List<Account> accList, Map<Id, Account> oldMap){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc: accList){
            Account oldAcc = oldMap.get(acc.Id);
            if(acc.Name != oldAcc.Name){
				accountIds.add(acc.Id);            	
            }
           
            }
        }
 
    
    @future
    public static void updateContacts(Set<Id> accountIds){
		List<Contact> contactList = [select Id, AccountId from Contact where AccountId IN: accountIds];
        Account acc = new Account();
        
        for(Contact cont: contactList){
            cont.Status__c ='updated by future ' + acc.Name;
        }
        update contactList;
    }

}