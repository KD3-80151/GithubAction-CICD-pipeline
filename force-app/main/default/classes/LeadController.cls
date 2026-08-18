public class LeadController {
    @AuraEnabled(cacheable = true)
    public static List<Lead> getLeads(){
        return [ select Id, Name, Company, Status from Lead];
    }
}