public with sharing class OpportunityCountHandler {
    
    // public static void isInserted(List<Opportunity> oppList){
    //     Set<Id> setId = new Set<Id>();
    //     for(Opportunity opp: oppList){
    //         if (opp.AccountId != null) {
    //             setId.add(opp.AccountId);
    //         }
    //     }
    //         updateAccountCount(setId);
    // }

    // public static void isUpdated(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
    //     Set<Id> setId = new Set<Id>();
    //     for(Opportunity opp: oppList){
    //         if (opp.AccountId != null) {
    //             setId.add(opp.AccountId);
    //         }
    //         if (oldMap.get(opp.Id).AccountId != null && oldMap.get(opp.Id).AccountId != opp.AccountId ) {
    //             setId.add(oldMap.get(opp.Id).AccountId);
    //         }
    //     }
    //         updateAccountCount(setId);
    // }

    // public static void isDeleted(List<Opportunity> oppList){
    //     Set<Id> setId = new Set<Id>();
    //     for(Opportunity opp: oppList){
    //         if (opp.AccountId != null) {
    //             setId.add(opp.AccountId);
    //         }
    //     }
    //         updateAccountCount(setId);
    // }

    // public static void updateAccountCount(Set<Id> setId){
    //     Map<Id, Integer> mapId = new Map<Id, Integer>();

    //     for (Id acntId : setId) {
    //         mapId.put(acntId, 0);
    //     }

    //     for (Opportunity opp : [select AccountId from Opportunity where AccountId IN: setId]) {
    //         if (mapId.containsKey(opp.AccountId)) {
    //             mapId.put(opp.AccountId, mapId.get(opp.AccountId)+1);
    //         }
    //     }
        
    //     List<Account> accntCount = new List<Account>();

    //     Map<Id, Account> newCount = new Map<Id, Account>([select Id, OppoCount__c from Account where Id IN: setId]);

    //     for (Id countId : setId) {
    //         Account acc = newCount.get(countId);
    //         Integer i = mapId.get(countId);

    //             acc.OppoCount__c = i;
    //        
    //         accntCount.add(acc);
    //     }

    //     if (!accntCount.isEmpty()) {
    //         update accntCount;
    //     }
    // }

    // public static void updateAccountCount(Set<Id> setId) {
    //     // Map to store the Opportunity count per Account
    //     Map<Id, Integer> mapId = new Map<Id, Integer>();

    //     // Initialize the map with Account Ids, defaulting to 0
    //     for (Id acntId : setId) {
    //         mapId.put(acntId, 0);
    //     }

    //     // Query all Opportunities that are associated with the Account Ids in setId
    //     for (Opportunity opp : [SELECT AccountId FROM Opportunity WHERE AccountId IN :setId]) {
    //         if (mapId.containsKey(opp.AccountId)) {
    //             mapId.put(opp.AccountId, mapId.get(opp.AccountId) + 1);
    //         }
    //     }

    //     // List to store the Accounts that need to be updated
    //     List<Account> accntCount = new List<Account>();

    //     // Query the current Account records for the given setId
    //     Map<Id, Account> newCount = new Map<Id, Account>([SELECT Id, OppoCount__c FROM Account WHERE Id IN :setId]);

    //     // Update the OppoCount__c field for each Account
    //     for (Id countId : setId) {
    //         Account acc = newCount.get(countId);
    //         Integer oppCount = mapId.get(countId);

    //         // Set the OppoCount__c field to the calculated count (including 0)
    //         acc.OppoCount__c = oppCount;

    //         accntCount.add(acc);
    //     }

    //     // Perform the update if there are Accounts to update
    //     if (!accntCount.isEmpty()) {
    //         update accntCount;
    //     }
    // }


    public static void onInsertionOpportunityUpdateCountInAccount(List<Opportunity> newOppList){
        Set<Id> accountIds=new Set<Id>();
        for(Opportunity oppObj : newOppList){
            if(oppObj.AccountId!=null) {
                accountIds.add(oppObj.AccountId);
            }
        }

        List<Account> accList=[Select Id ,OppoCount__c,(Select Id from Opportunities) from Account where Id IN : accountIds];
        for(Account accObj : accList){
            accObj.OppoCount__c = accObj.Opportunities.size();
        }
        update accList;
    }

    public static void onUpdationOpportunityUpdateCountInAccount(Map<Id,Opportunity> newOppMap,List<Opportunity> oldOppList){
        Set<Id> accountIds=new Set<Id>();
        for(Opportunity oldOppObj : oldOppList){
            Opportunity newOppObj =newOppMap.get(oldOppObj.Id);
            if(oldOppObj.AccountId!=newOppObj.AccountId){
                if(oldOppObj.AccountId!=null) accountIds.add(oldOppObj.AccountId);
                if(newOppObj.AccountId!=null) accountIds.add(newOppObj.AccountId);
            }else if(oldOppObj.AccountId!=null) accountIds.add(oldOppObj.AccountId);
        }


        List<Account> accList=[Select Id ,OppoCount__c ,(Select Id from Opportunities) from Account where Id in : accountIds];

        for(Account accObj : accList){
            accObj.OppoCount__c = accObj.Opportunities.size();
        }
        update accList;
    }

    public static void onDeletionOpportunityUpdateCountInAccount(List<Opportunity> oldOppList){
        Set<Id> accountIds=new Set<Id>();
        for(Opportunity oppObj : oldOppList){
            if(oppObj.AccountId!=null) accountIds.add(oppObj.AccountId);
        }

        List<Account> accList=[Select Id ,OppoCount__c,(Select Id from Opportunities) from Account where Id In : accountIds];
        for(Account accObj : accList){
            accObj.OppoCount__c=accObj.Opportunities.size();
        }

        update accList;
    }
    
    
}