public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(){
        try {
            return[select Id, FirstName, LastName, Email, Phone, Title from Contact];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     @AuraEnabled
    public static void deleteContact(Id contactId) {
        delete [SELECT Id FROM Contact WHERE Id = :contactId];
    }
}