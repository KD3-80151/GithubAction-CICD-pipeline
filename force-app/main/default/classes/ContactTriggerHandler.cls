public class ContactTriggerHandler {
    
    public static void handlerContact(List<Contact> contList) {
        Map<Id, Account> acctUp;
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> accListToBeUpdated = new List<Account>(); 
        
        for (Contact c : contList) {
            if (c.AccountId != null && c.LastName != null) {
                accountIdSet.add(c.AccountId);
            }
        }
        
        if(!accountIdSet.isEmpty()) {
            acctUp = new Map<Id, Account>([Select Id, Name from Account where Id In: accountIdSet]);
        }
        
        for(Contact contactObj : contList){
            if(contactObj.AccountId != null && acctUp.containsKey(contactObj.AccountId)) {
                Account accountObj = acctUp.get(contactObj.AccountId);
                accountObj.Name = contactObj.LastName;
                accListToBeUpdated.add(accountObj);
            }
        }
        
        
        if (!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
    }
    
    //not more than 2 contacts 
    public static void notMorethaTwoCOntacts(list<Contact> oldConList, list<Contact> newContList){
        
        set<Id> addContSet = new set<Id>();
        
        for(Contact contNew : newContList){
            if(contNew.AccountId != null ){
                addContSet.add(contNew.AccountId);                    
            }
        }
        
        // to handle this scenario also -- If update and Account changed, also include old AccountId so counts are accurate
        if(oldConList != null && !oldConList.isEmpty() ){
            for(Integer i = 0; i< newContList.size(); i++){
                Contact newListCont = newContList[i];
                Contact oldListCont = oldConList[i];
                system.debug('newListCont::>>' + newListCont + 'oldListCont::>>'+ oldListCont);
                if(newListCont.AccountId != oldListCont.AccountId && oldListCont.AccountId != null){
                    addContSet.add(oldListCont.AccountId);
                }
            }
        }
        
        if(addContSet.isEmpty()) return;
        
        map<Id, Integer> countExistingContactsMap = new map<Id, Integer>();
        for(AggregateResult aggForContCount : [select AccountId accId, count(Id) conCount from Contact where AccountId IN: addContSet group by AccountId]){
			countExistingContactsMap.put((Id) aggForContCount.get('accId'), (Integer) aggForContCount.get('conCount'));
        }
        
        // for incoming count to handle
        Map<Id, Integer> mapOfIncomingCounts = new Map<Id, Integer>();
        for(Integer i=0; i< newContList.size(); i++ ){
            Contact newCon = newContList[i];
            //Contact oldCon = oldListCont != null ? oldListCont[i] : null;
            
            if(newCon.AccountId == null) continue;
            
            //if(oldCon.AccountId = null) break;
        }
        
        //
        for(Contact cont : newContList ){
            if(cont.AccountId == null) return;
            Integer current = countExistingContactsMap.containsKey(cont.AccountId) ? countExistingContactsMap.get(cont.AccountId) : 0;
            Integer incoming = mapOfIncomingCounts.containsKey(cont.AccountId) ? mapOfIncomingCounts.get(cont.AccountId) : 0;
            system.debug('currenttt:::>>>' + current + 'incoming:::>>>' + incoming);
            
            if(current + incoming > 2){
				cont.addError('more than 2 contacts is already there');
            }
        }
    }
    
    public static void countNumberANdStoreOnAccount(Set<id> newContact){
        if(newContact == null && newContact.isEmpty()){
            return;
        }
        //list<AggregateResult> agR = [select count(AccountId) parentId, SUM(Contact_Count_New__c) conTCount from Contact where AccountId IN :newContact];
        
    }
    
    
    public static void updateUSerContact(List<Contact> newContList, Map<Id, Contact> oldMap){
        Set<Id> userIds = new Set<Id>();
        Map<Id, Contact> userPhoneMap = new Map<Id, Contact>();
        for(Contact cNew : newContList){
			Contact oldContId = oldMap.get(cNew.Id);
            if(cNew.Phone != oldContId.Phone && cNew.OwnerId != null){
                userIds.add(cNew.OwnerId);
               // userPhoneMap.put(cNew.OwnerId, cNew.Phone);
            }
        }
        if(userIds.isEmpty()) return;
        
        list<User> userToUpdate = [select Id, Name, Phone from User where Id IN :userIds];
    }
    
    public static void createTaskWelcome(List<Contact> newListCont){
        List<Task> taskToInsert = new List<Task>();
        
        for(Contact con : newListCont){
            Task t = new Task();
            t.WhoId = con.Id;
            t.Subject = 'Welcome Call';
            t.Status = 'Open';
            t.ActivityDate = Date.today() + 30;
            taskToInsert.add(t);
            
        }
        if(!taskToInsert.isEmpty()){
            insert taskToInsert;
        }
        
        
    }
    
    public static void updateAccountContactCount(List<Contact> newList, List<Contact> oldList){
        system.debug('method runn');
        try{
        
        Set<Id> accountIds = new Set<Id>();
        if(newList != null){
            for(Contact con : newList){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);
                }
            }
        }
        
        if(oldList != null){
            for(Contact con : oldList){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);
                }
            }
        }
        
        if(oldList != null){
            for(Contact con : oldList){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);
                }
            }
        }
        
        if(accountIds.isEmpty()) return;
        
        Map<Id, Integer> countContactAssociateWIthAccount = new Map<Id, Integer>();
        list<AggregateResult> countAccount = ([select count(Id) totalCounts, AccountId acntId from Contact where AccountId IN :accountIds group by AccountId]);
        for(AggregateResult agr : countAccount){
            countContactAssociateWIthAccount.put((Id) agr.get('acntId'), (Integer) agr.get('totalCounts'));
        }
        
        list<Account> acntUpdate = new list<Account>();
        
        for(Id accntIds : accountIds){
            Integer totalCount = countContactAssociateWIthAccount.containsKey(accntIds) ? countContactAssociateWIthAccount.get(accntIds) : 0;
            system.debug('totalCount::' + totalCount);
            acntUpdate.add( new Account ( 	Id 						= accntIds,
                                        	Total_No_of_Contacts__c = totalCount
                                        ));
        }
        
        if(!acntUpdate.isEmpty()){
            update acntUpdate;
        }
        }
        catch(Exception e){
            system.debug('error at line:::' + e.getLineNumber());
            system.debug('error message:::' + e.getMessage());
        }
        
    }
    
    
    public static void maintainData(List<Contact> newContList, List<Contact> oldContList, Boolean isDelete){
        
        try{
            Set<Id> accntIds = new Set<Id>();
            if(!isDelete){
                for(Contact c : newContList){
                    if(c.AccountId != null){
                        accntIds.add(c.AccountId);
                    }
                }
            }
            
            if(oldContList != null){
                for(Contact cNew : oldContList){
                    if(cNew.AccountId != null){
                        accntIds.add(cNew.AccountId);
                    }
                }
            }
            
            
            Map<Id,Integer> newMapData = new Map<Id,Integer>();
            for(AggregateResult agr : [select AccountId accountIdData, count(Id) total from Contact where AccountId IN : accntIds group by AccountId]){
                newMapData.put((Id) agr.get('accountIdData'), (Integer) agr.get('total'));
            }
            
            list<Account> accntToUpdate = new list<Account>();
            for(Id accountId : accntIds){
                Account acc = new Account(
                	Id = accountId,
                    Total_No_of_Contacts__c = newMapData.containsKey(accountId) ? newMapData.get(accountId) : 0
                );
                accntToUpdate.add(acc);
            }
            
            if(!accntToUpdate.isEmpty()){
                update accntToUpdate;
            }
            
        }
        catch(Exception e){
			system.debug('Error at line::'+ e.getLineNumber());
        }
    }
}