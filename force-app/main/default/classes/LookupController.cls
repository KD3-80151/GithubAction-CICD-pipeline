public with sharing class LookupController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchRecords(String searchKey, String objectApiName, String fieldApiName) {
        searchKey = '%' + searchKey + '%';
        String query = 'SELECT Id, ' + fieldApiName + ' FROM ' + objectApiName + 
                       ' WHERE ' + fieldApiName + ' LIKE :searchKey LIMIT 10';
        return Database.query(query);
    }
}