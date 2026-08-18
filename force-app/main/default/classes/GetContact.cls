@RestResource(urlMapping='/getContactIds')
global with sharing class GetContact {
    
    @HttpGet
    global static List<Contact> getContactIds() {
        List<Contact> contacts = [SELECT Id, LastName FROM Contact LIMIT 10];
        List<String> contactIds = new List<String>();
        for (Contact c : contacts) {
            contactIds.add(c.Id);
        }
        return contacts;
    }
}