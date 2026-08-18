public class ErrorAccountDelete {
    public static void AccountContactError(List<Account> accountList){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc: accountList){
            accountIds.add(acc.Id);
        }

        List<Contact> contactList = [select Id from Contact where AccountId IN: accountIds];
       
        if(!contactList.isEmpty()){
            String message = ' Account with associated Contact can not be deleted.';
            for(Account a:accountList){
                a.addError(message);
            }
        }
    }

    public static void errorMessageDisplay(List<Account> accList){
        Set<Id> accountIds = new Set<Id>(); 
        for(Account acc : accList){
            accountIds.add(acc.Id);
        }
        List<Contact> cont = [select Id from Contact where AccountId IN : accountIds];

        if (!cont.isEmpty()) {
            String message = 'Contact exist for this account';
            for (Account a: accList) {
                a.addError(message);
            }
        }
    }

    public static void fieldErrorMessage(List<Account> accntList){
        
        for (Account acc : accntList) {
            if (acc.AccountNumber == null) {
                acc.AccountNumber.addError('Account Number is required');
            }
        }

        
    }

}