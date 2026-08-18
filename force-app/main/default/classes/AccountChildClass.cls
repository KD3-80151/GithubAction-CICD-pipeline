public class AccountChildClass {
    public static void linkParentWithChild(List<Account> newAccounts) {
        Set<String> accEmails = new Set<String>();
        Map<String, Id> emailToAccountIdMap = new Map<String, Id>();

        if(!newAccounts.isEmpty()){
            for (Account acc : newAccounts) {
            if (acc.Account_Email__c != null) {
                accEmails.add(acc.Account_Email__c);
                emailToAccountIdMap.put(acc.Account_Email__c, acc.Id);
            }
        }
         System.debug('accEmail==>'+accEmails);
            System.debug('emailToAccountIdMap=>'+emailToAccountIdMap);

        List<Contact> contactQuery = [SELECT Id, Email, Email__c FROM Contact WHERE Email IN :accEmails AND Email__c = true];
        List<Contact> contactsToUpdate = new List<Contact>();

            if(!contactQuery.isEmpty()){
            for (Contact con : contactQuery) {
            	if (!emailToAccountIdMap.containsKey(con.Email)) {
                    Contact updatedCon = new Contact();
                    updatedCon.Id = con.Id;
                    updatedCon.AccountId = emailToAccountIdMap.get(con.Email);
                    contactsToUpdate.add(updatedCon);
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
            }

        }
        
    }
}