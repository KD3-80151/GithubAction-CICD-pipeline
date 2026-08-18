public class AccountWithOpportunities {
    public static Map<Id, List<Opportunity>> MapAcntWithOpp(List<Id> accountIdList){
        Map<Id, List<Opportunity>> acntMap = new Map<Id, List<Opportunity>>();
         List<Opportunity> oppo = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId IN :accountIdList];
         
        for (Opportunity opp : oppo) {
            if (!acntMap.containsKey(opp.AccountId)) {
                acntMap.put(opp.AccountId, new List<Opportunity>());
            }
            acntMap.get(opp.AccountId).add(opp);
        }
        
        for (Id accId : accountIdList) {
            if (!acntMap.containsKey(accId)) {
                acntMap.put(accId, new List<Opportunity>());
            }
        }
        
        return acntMap;
        
        

    }
}