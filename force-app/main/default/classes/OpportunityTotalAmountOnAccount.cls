public with sharing class OpportunityTotalAmountOnAccount {
    public static void OpportunityTotalAmountOnAccount(List<Opportunity> newOpp, Map<Id,Opportunity> oldOpp) {
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpp) {
            accountIds.add(opp.AccountId);
        }

        if (oldOpp != null) {
            for (Opportunity oldO : oldOpp.values()) {
                accountIds.add(oldO.AccountId);
            }
        }
        updateAccountTotalOpp(accountIds);

    }

    
    public static void updateAccountTotalOpp(Set<Id> accountIds){
        if (accountIds.isEmpty()) {
            return;
        }

        List<Opportunity> opps = [select AccountId, Amount from Opportunity where AccountId IN : accountIds and IsClosed 
        = TRUE and IsWon = TRUE];

        Map<Id,Decimal> accountOppSum = new Map<Id,Decimal>();
        for (Opportunity opp : opps) {
            if (accountOppSum.containsKey(opp.AccountId)) {
                accountOppSum.put(opp.AccountId, accountOppSum.get(opp.AccountId) + opp.Amount);
                
            }
            else {
                accountOppSum.put(opp.AccountId, opp.Amount);
            }
        }

        List<Account> accListUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Decimal totalOppAmount = accountOppSum.get(accountId);
            Account accToUpdate = new Account(Id = accountId, Total_Opportunity_Amount__c= (totalOppAmount != null ) ? totalOppAmount:0);
            accListUpdate.add(accToUpdate);
        }

        if (!accListUpdate.isEmpty()) {
            update accListUpdate;
        }

    }

    public static void calculateTotalOppSumRelWithAccnt(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){

        //Ids to store the account
        Set<Id> accntIds = new Set<Id>();
        
        //to store the old and new oppo ids
        for (Opportunity opp : oppList) {
            accntIds.add(opp.AccountId);
        }

        if (oppList.isEmpty()) {
            return;
        }

        //changing the old value of that 

        if (oldMap != null) {
            for (Opportunity opp : oldMap.values()) {
                accntIds.add(opp.AccountId);
            }
        }

        List<Opportunity> oppSoql = [select AccountId, Amount from Opportunity where AccountId IN:
        accntIds and StageName ='Closed Won'];

        Map<Id, Decimal> accountSum= new Map<Id, Decimal>();
        for (Opportunity opp : oppSoql) {
            if (accountSum.containsKey(opp.AccountId)) {
                accountSum.put(opp.AccountId, accountSum.get(opp.AccountId) + opp.Amount);
            }
            else {
                accountSum.put(opp.AccountId, opp.Amount);
            }
        }

        //Account list that need to be updated
        List<Account> accList = new List<Account>();
        for (Id acntId : accntIds) {

            Decimal totalAMount = accountSum.get(acntId);
            Account acntUpdate = new Account(Id= acntId, Total_Opportunity_Amount__c = (totalAMount != null) ? totalAMount : 0); 
            
            accList.add(acntUpdate);
            
        }

        if (!accList.isEmpty()) {
        update accList;   
        }

    }
}