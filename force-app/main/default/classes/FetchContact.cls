public with sharing class FetchContact {
    public FetchContact() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(){
        try {
            return[select Id, FirstName, LastName, Phone, Email from Contact LIMIT 5];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}