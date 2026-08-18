public class AmountSumRelatedOpp {
    public void AmountWithMap(){
        Map<Id, Decimal> accountMap = new Map<Id, Decimal>();

        List<Opportunity> oppList = [SELECT AccountId, Amount FROM Opportunity WHERE Amount != null];
        
        for (Opportunity opp : oppList) {
            if (accountMap.containsKey(opp.AccountId)) {
                accountMap.put(opp.AccountId, accountMap.get(opp.AccountId) + opp.Amount);
            } else {
                accountMap.put(opp.AccountId, opp.Amount);
            }
        }
        
        Id highestId= null;  
        Decimal highestAmt = 0;  
        
        for (Id acntId : accountMap.keySet()) {
            Decimal totalAmt = accountMap.get(acntId);
            if (totalAmt > highestAmt) {
                highestAmt = totalAmt;
                highestId = acntId;
            }
        }
        
        if (highestId != null) {
            Account highestAcnt = [SELECT Name FROM Account WHERE Id = :highestId LIMIT 1];
            System.debug('Highest Account is: ' + highestAcnt.Name + ' with Amount: ' + highestAmt);
        } else {
            System.debug('No opportunities found.');
        }
    }
}