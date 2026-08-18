public with sharing class DisplayAccountRecords {
    public DisplayAccountRecords() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> displayAccount(){
        try {
            return [select Id, FirstName, LastName, Email, Phone, Account.Name from Contact];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}