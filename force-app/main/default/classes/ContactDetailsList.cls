public class ContactDetailsList {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String searchKey) {
        String searchPattern = '%' + searchKey + '%';
        return [SELECT Id, Name, Email, Phone, Account.Name, Title FROM Contact WHERE Name LIKE :searchPattern];
    }

    @AuraEnabled
    public static void deleteContacts(List<Id> contactIds) {
            List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE Id IN :contactIds];
            delete contactsToDelete;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactPage(){
        try {
            return [SELECT Id, Name, Email, Phone, Title FROM Contact];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     @AuraEnabled(cacheable=true)
    public static List<Contact> getSortedContact() {
        try {
            return [SELECT Id, Name, Phone, Account.Name FROM Contact];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsSorted(String searchKey) {
        String searchPattern = '%' + searchKey + '%';
        return [SELECT Id, Name, Phone, Account.Name FROM Contact WHERE Name LIKE :searchPattern];
    }
        
}