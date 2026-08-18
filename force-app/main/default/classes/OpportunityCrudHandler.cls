public class OpportunityCrudHandler { //OppoCount__c
    public static void isInserted(List<Opportunity> oppList){
        Set<Id> oppSet = new Set<Id>();
        for(Opportunity opp: oppList){
            if(opp.AccountId != null){
                oppSet.add(opp.AccountId);
            }
        }
        updatedOppo(oppSet);
    }
    public static void isUpdated(List<Opportunity> oppList, Map<Id, Opportunity> oldOppo){
        Set<Id> setId = new Set<Id>();
        for(Opportunity opp: oppList){
            if(opp.AccountId != null){
                setId.add(opp.AccountId);
            }
            if(oldOppo.get(opp.Id).AccountId !=null && oldOppo.get(opp.Id).AccountId != opp.AccountId){
                setId.add(oldOppo.get(opp.Id).AccountId);
            }
        }
        updatedOppo(setId);
        
    }
    public static void isDeleted(List<Opportunity> oppoList){
        Set<Id> setId = new Set<Id>();
        for(Opportunity opp: oppoList ){
            if(opp.AccountId!=null){
                setId.add(opp.AccountId);
            }
        }
        updatedOppo(setId);
        
    }
    public static void updatedOppo(Set<Id> oppSet){
        Map<Id, Integer> mapId = new Map<Id, Integer>();
        for(Id accntId: oppSet){
            mapId.put(accntId, 0);
        }
        
        for(Opportunity cont :[select AccountId from Opportunity where AccountId IN: oppSet]){
            if(mapId.containsKey(cont.AccountId)){
                mapId.put(cont.AccountId, mapId.get(cont.AccountId)+1);
            }
        }
        
        List<Account> acc= new List<Account>();
        Map<Id, Account> currentCount = new Map<Id, Account>([select Id, OppoCount__c from Account where Id IN: oppSet]);
        
        for(Id acntId: oppSet){
            Account acc1 = currentCount.get(acntId);
            Integer newOppoCount = mapId.get(acntId);
            
            if(acc1.OppoCount__c != null){
                acc1.OppoCount__c = newOppoCount;
            }
            else{
                acc1.OppoCount__c=0;
            }
            acc.add(acc1);
        }
        
        if(!acc.isEmpty()){
            update acc;
        }
         
        
        
    }

}