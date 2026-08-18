public with sharing class EditableTableController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Phone, Industry FROM Account LIMIT 20];
    }

    @AuraEnabled
    public static void updateAccounts(List<Account> updatedAccountList) {
        update updatedAccountList;
    }
}