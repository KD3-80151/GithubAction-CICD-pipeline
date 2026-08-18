public with sharing class GetContactClass {
    
        @AuraEnabled(cacheable = true)
        public static List<Contact> getContact(){
            try {
                return [select Id, FirstName, LastName, Phone from Contact];
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        @AuraEnabled(cacheable = true)
        public static List<Contact> getContactSearch(String searchName){
            try {
                String searchKey = '%'+searchName+'%';
                return[select Id, FirstName, LastName, Phone, Account.Name from Contact where Name LIKE: searchKey];
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        

}