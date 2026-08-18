public class UpdateMailingCity {
    public static void MailCity(List<Account> accList, Map<Id, Account> oldMapId){
		Set<Id> setId = new Set<Id>();
        for(Account newAcc: accList){
            Account oldAcc = oldMapId.get(newAcc.Id);
            if(newAcc.BillingCity != oldAcc.BillingCity){
                setId.add(newAcc.Id);
            }
        }
        if(!setId.isEmpty()){
        updateContact(setId, accList);
                    }
            }
    
    
    public static void updateContact(Set<Id> idSet, List<Account> mapCont){
        Map<Id, String> accntBc = new Map<Id, String>();
        
        for(Account acc: mapCont){
            accntBc.put(acc.Id, acc.BillingCity);
        }
        
        List<Contact> cotList = [select Id, AccountId, MailingCity from Contact where AccountId IN: idSet];
        
        for(Contact c: cotList){
            c.MailingCity = accntBc.get(c.AccountId);
        }
        
        if(!cotList.isEmpty()){
	        update cotList;
        }

        
    }
 }