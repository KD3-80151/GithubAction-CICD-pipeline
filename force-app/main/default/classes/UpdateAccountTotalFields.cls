public class UpdateAccountTotalFields {
    public static void updateAccount(Id acntId){
        Account acnt = [select Id, Name from Account where Id =:acntId];
            if(acnt !=null){
            Integer opCount = [select count() from Opportunity where AccountId =: acntId];
            Integer contCount = [select count() from Contact where AccountId =: acntId];
            if(acnt.Total_No_of_Opportunities__c != null || acnt.Total_No_of_Contacts__c != null){
                        acnt.Total_No_of_Opportunities__c = opCount;
            acnt.Total_No_of_Contacts__c = contCount;
            }    else {
                        acnt.Total_No_of_Opportunities__c = 0;
            acnt.Total_No_of_Contacts__c = 0;
            }
                
                update acnt;
                System.debug('Found with id-> ' + acntId+ 'opp count '+ acnt.Total_No_of_Opportunities__c 
                            +'contact count is '+acnt.Total_No_of_Contacts__c);
            } 
            else{
                System.debug('not found');

            }
        
    }

    public static void insertContact(List<Contact> contList){
        Set<Id> setId = new Set<Id>();
        for (Contact cont : contList) {
            if (cont.AccountId != null) {
                setId.add(cont.AccountId);
            }

            updateContactCount(setId);
        }
    }

    public static void updateContact(List<Contact> contList, Map<Id,Contact> oldMap){
        Set<Id> setId = new Set<Id>();
        for (Contact cont : contList) {
            if (cont.AccountId != null) {
                setId.add(cont.AccountId);
            }

            if (oldMap.get(cont.Id).AccountId != null && oldMap.get(cont.Id).AccountId != cont.AccountId) {
                setId.add(oldMap.get(cont.Id).AccountId);
            }

            updateContactCount(setId);
        }
    }

    public static void deleteContact(List<Contact> contList){
        Set<Id> setId = new Set<Id>();
        for (Contact cont : contList) {
            if (cont.AccountId != null) {
                setId.add(cont.AccountId);
            }
            updateContactCount(setId);
        }
    }

    public static void updateContactCount(Set<Id> contId){
        //1. to hold the contact count per account
        Map<Id, Integer> mapId= new Map<Id, Integer>();
        //initialize the map with accountId
        for(Id setId : contId){
            mapId.put(setId, 0);
        }

        //2. query all contact that are associated with that account
        for (Contact cont : [select AccountId from Contact where AccountId IN: contId]) {
            if (mapId.containsKey(cont.AccountId)) {
                mapId.put(cont.AccountId, mapId.get(cont.AccountId) +1 ); //increment the count for each account
            }
        }

        //3. List to store the accounts that need to be updated
        List<Account> updateAcc = new List<Account>();

        //4. query the current custom opportunity counts for the accounts in the contList
        Map<Id, Account> currentAccnt = new Map<Id, Account>([select Id, Total_No_of_Contacts__c from Account where Id IN: contId]);

        //5 update the contact count for each account
        for (Id acntId : contId) {
            Account acc1 = currentAccnt.get(acntId);
            Integer newContCount = mapId.get(acntId); 
            
            if (acc1.Total_No_of_Contacts__c != null) {
                acc1.Total_No_of_Contacts__c = newContCount;
            }
            else {
                acc1.Total_No_of_Contacts__c = 0;
            }

            updateAcc.add(acc1);
        }

        if (!updateAcc.isEmpty()) {
            update updateAcc;            
        }

        

    }
}