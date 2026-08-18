@RestResource(urlMapping='/getContactId')
global with sharing class GetAccounts {

    @HttpGet
    global static List<Contact> getContactIds() {
        List<Contact> contacts = [SELECT Id, LastName FROM Contact LIMIT 10];
        List<Id> contactIds = new List<Id>();
        for (Contact c : contacts) {
            contactIds.add(c.Id);
        }
        return contacts;
    }
}