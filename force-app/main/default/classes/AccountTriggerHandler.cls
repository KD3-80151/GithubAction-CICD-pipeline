public class AccountTriggerHandler {
    public static void AccountTriggerContact(List<Account> accountList){
        
        List<Contact> contactList = new List<Contact>();
        //Set<Id> contactIdSet = new Set<Id>();
        
        for(Account a: accountList){
            Contact c = new Contact();
            c.LastName = a.Name;
            c.AccountId = a.Id;
            contactList.add(c);
            
        }
        if (!contactList.isEmpty()) {
            insert contactList;
        }
        
    }
    
    //If the Industry changes, all related Open Opportunities should update their Industry__c field.
    public static void handleIndustryChanges(list<Account> accList, Map<Id,	Account> oldMap){
        Set<Id> accIdsforOppUpdate = new Set<Id>();
        Set<Id> accIdsforTask = new Set<Id>();
        
        if(accList != null){
            for(Account acc: accList){
                Account oldAcc = oldMap.get(acc.Id);
                if(acc.Industry != oldAcc.Industry){
                    accIdsforOppUpdate.add(acc.Id);
                }
                
                //If the Account Rating becomes High, automatically assign follow-up Tasks to all related Contacts.
                if(acc.Rating == 'High' && oldAcc.Rating != 'High'){
                    accIdsforTask.add(acc.Id);
                }
            }
            if(!accIdsforOppUpdate.isEmpty()){
                updateOpp(accIdsforOppUpdate, accList);
            }
            //if(!accIdsforTask.isEmpty()){
            //   System.enqueJob(new AssignTaskQueueable(new List<Id>(accIdsforTask))
            //}
        }
        
    }
    
    //accIdsforOppUpdate, accList
    private static void updateOpp(Set<Id> accIds, List<Account> accList){
        Map<Id, String> accIndustryMap = new Map<Id, String>(); // to take picklist values and update the opp
        for(Account acc: accList){
            if(accIds.contains(acc.Id)){
                accIndustryMap.put(acc.Id, acc.Industry);
            }
        }
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Opportunity> oppList = [select Id, Name, Industry__c from Opportunity where AccountId IN :accIds and StageName != 'Closed Won'];
        
        for(Opportunity opp: oppList){
            String newIndustry = accIndustryMap.get(opp.AccountId);
            if(newIndustry != null && opp.Industry__c != newIndustry){
                opp.Industry__c = newIndustry;
                oppsToUpdate.add(opp);
            }
        }
        
        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
    
    public static void protectAcntDeleteWhenNoOpp(List<Account> oldAccount){
        system.debug('oldAccount::>>' + oldAccount);
        set<Id> oldAccountIds = new Set<Id>();
        
        for(Account acc : oldAccount){
            oldAccountIds.add(acc.Id);
            
        }
        
        Map<Id, Integer> countNumberOdOpp = new Map<Id, Integer>();
        for(AggregateResult ar: [select count(Id) oppCount, AccountId acntId from Opportunity where AccountId IN :oldAccountIds group by AccountId]){
            countNumberOdOpp.put((Id) ar.get('acntId'), (Integer) ar.get('oppCount'));
        }
        for(Account acc1 : oldAccount){
            if(countNumberOdOpp.containsKey(acc1.Id) && countNumberOdOpp.get(acc1.Id) > 0){
                acc1.addError('you cant delete this Account');
            }
            
        }
        
    }
    
    public static void preventAcntFromGettingDeletedActiveOpp(Map<Id, Account> oldOpp){
        
        map<Id, Account> checkActiveOpp = new Map<Id, Account>([select Id from Account where Id IN: oldOpp.keySet() 
                                                                AND ID IN (Select AccountId from Opportunity  where IsClosed = false)]);
        
        for(Account ea : oldOpp.values()){
            if(checkActiveOpp.containsKey(ea.Id)){
                ea.addError('not allowed to delete becasue opportunity is active');
            }
        }
    }
    
    
    
    public static void updateChildContactMailingAddress(List<Account> newAcc, Map<Id, Account> oldMapAcc) {
        Set<Id> accIdsToProcess = new Set<Id>();
        List<Contact> contToUpdate = new List<Contact>();
        
        for (Account acc : newAcc) {
            Account oldAcc = oldMapAcc.get(acc.Id);
            
            if (acc.BillingCity != oldAcc.BillingCity || acc.BillingCountry != oldAcc.BillingCountry || acc.BillingPostalCode != oldAcc.BillingPostalCode) {
                accIdsToProcess.add(acc.Id);
            }
        }
        
        if (!accIdsToProcess.isEmpty()) {
            for (Contact con : [SELECT Id, AccountId, MailingCity, MailingCountry, MailingPostalCode, Account.BillingCity, Account.BillingCountry, Account.BillingPostalCode FROM Contact WHERE AccountId IN :accIdsToProcess]) {
                con.MailingCity = con.Account.BillingCity;
                con.MailingCountry = con.Account.BillingCountry;
                con.MailingPostalCode = con.Account.BillingPostalCode;
                contToUpdate.add(con);
            }
            
            if (!contToUpdate.isEmpty()) {
                update contToUpdate;
            }
        }
    }
    
    
    public static void closedAllrelatedOpp(List<Account> newList, Map<Id, Account> oldMap){
        
        Set<Id> accountSet = new Set<Id>();
        for(Account acntLoop : newList){
            if(acntLoop.Close_All_Opp__c == true && oldMap.get(acntLoop.Id).Close_All_Opp__c == false){
                accountSet.add(acntLoop.Id);
            }
        }
        
        if(accountSet.isEmpty()) return;
        
        list<Opportunity> quryOppToUpdate = [select Id, AccountId, StageName, IsClosed from Opportunity where AccountId IN : accountSet and IsClosed = false];
        list<Opportunity> toUpdate = new List<Opportunity>();
        if(quryOppToUpdate.isEmpty()) return;
        for(Opportunity opp : quryOppToUpdate){
            opp.StageName = 'C;osed Won';
            opp.CloseDate = Date.today();
            toUpdate.add(opp);
        }
        
        if(!toUpdate.isEmpty()){
            update toUpdate;
        }
    }
    
    
    public static void updateMailAddressOfALlRelatedContacts(list<Account> newAccList, Map<Id,Account> oldMapAcc){
		if(newAccList.isEmpty()) return;

		set<Id> accNtsIds = new Set<Id>();
        for(Account acc : newAccList){
            Account oldAccId = oldMapAcc.get(acc.Id);
            if(acc.BillingCity != oldAccId.BillingCity || acc.BillingState != oldAccId.BillingState || acc.BillingPostalCode != oldAccId.BillingPostalCode){
                accNtsIds.add(acc.Id);
            }
        }
        
        list<Contact> contToUpdate = new List<Contact>();
        
        if(!accNtsIds.isEmpty()){
            for(Contact con : [select Id, FirstName, LastName from Contact where AccountId IN : accNtsIds  order by CreatedDate desc Limit 1000]){
                con.MailingCity = con.Account.BillingCity;
                con.MailingState = con.Account.BillingState;
                con.MailingPostalCode = con.Account.BillingPostalCode;
                contToUpdate.add(con);
            }
        }

        if(!contToUpdate.isEMpty()){
			update contToUpdate;
        }        
    }
    
    public static void updateOwnerContatc(List<Account> newList, Map<Id, Account> oldMapAcc){
        system.debug('updateOwnerContatc get called');
        Set<Id> listOfAccIds = new Set<Id>();
        if(newList.isEmpty()) return;
        
        for(Account acc : newList){
            Account oldAcc = oldMapAcc.get(acc.Id);
            if(!newList.isEmpty() && acc.OwnerId != oldAcc.OwnerId){
                listOfAccIds.add(acc.Id);
            }
        }
        
        if(listOfAccIds.isEmpty()) return;
       
        list<Contact> contactUnderTheAcc = [select Id, Name from Contact where AccountId IN: listOfAccIds];
        
        for(Contact con : contactUnderTheAcc){
            con.OwnerId = oldMapAcc.get(con.AccountId).OwnerId; // con.Account.OwnerId;
        }
        
        if(!contactUnderTheAcc.isEmpty())
        {
            update contactUnderTheAcc;
        }
        
    }
    
    public static void preventDeletionOFAnAccoutnOnClosedWon(List<Account> newList, Map<Id, Account> oldMap){
        try{
            
        }
        catch(Exception e){
            System.debug('error at line :::' + e.getLineNumber());
            System.debug('error message :::' + e.getMessage());
            
        }
    }
    
    
  
}