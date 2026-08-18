@RestResource(urlMapping='/searchName/*')
global with sharing class SearchAccounts {

    @HttpGet
    global static List<Account> searchAccounts() {
        RestRequest req = RestContext.request;
        String searchKey = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('Search Key: ' + searchKey);
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :('%' + searchKey + '%')];
        return accounts;
    }
    
}