public with sharing class BatchAlike {
    @AuraEnabled(cacheable = true)
    public static List<Claim__c> fetchClaims(){
        try {
            List<Claim__c> claims = [select Id, Name, Total_Claim_Amount__c from Claim__c where Status__c = 'Submitted' and Batch__c =null];
            System.debug('Fetched Claims::==>>>' + claims);
            return claims;
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to fetch claims' + e.getMessage());
        }
    }

    // @AuraEnabled
    // public static Id createBatchAndTagClaims(
    //     List<Id> claimsIds, 
    //     ){
    //     try {
        
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

}