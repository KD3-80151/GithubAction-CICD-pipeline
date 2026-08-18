public class OpportunityController {
    @AuraEnabled(cacheable = true)
    public static List<Opportunity> getOppo(){
        return[ select Id, Name, Amount from Opportunity where Amount != null];
    }
}