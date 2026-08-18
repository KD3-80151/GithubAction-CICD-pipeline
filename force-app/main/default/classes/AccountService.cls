//org a // managed app
@RestResource(urlMapping='/accounts')
global with sharing class AccountService {
    @HttpGet
    global static List<Account> getAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 100];
        return accounts;
    }
}