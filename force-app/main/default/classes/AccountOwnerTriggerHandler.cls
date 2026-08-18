/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 29/06/2024
 * Last Modified Date: 
 * Purpose: Handler to get list of an account using owner Id
 * if we are changing the account owner then its contact owner should also get update
 * -----------------------------------------------------------------------------------------------------
 */
public class AccountOwnerTriggerHandler {
//     public static void AccountTriggerOwner(List<Account> accountList, Map<Id, Account> mapAccount){
//         List<Contact> contactListUpdate = new List<Contact>();
        
//         for(Account acc:accountList){
// 			Account oldAcc = mapAccount.get(acc.Id);
//             if(acc.OwnerId != oldAcc.OwnerId){
//                 List<Contact> contList = [select Id, OwnerId from Contact where AccountId= :acc.Id];
//                 for (Contact contact : contList) {
//                     contact.OwnerId = acc.OwnerId;
//                     contactListUpdate.add(contact);
//                 }
//             	}    
//         }
//         if (!contactListUpdate.isEmpty()) {
//             update contactListUpdate;
//         }  
// }

    public static void updateContactOwner(List<Account> accList, Map<Id, Account> oldAcc){
        
        List<Contact> contToUpdate = new List<Contact>();
        
        for (Account a : accList) {
            Account oldOwner = oldAcc.get(a.Id);
            if (a.OwnerId != oldOwner.Id) {
                List<Contact> contList = [select Id, OwnerId from Contact where AccountId =:a.Id];
                for (Contact c : contList) {
                    c.OwnerId = a.OwnerId;
                    contToUpdate.add(c);
                }
            }
        }
        if(!contToUpdate.isEmpty())  update contToUpdate;
    }


    public static void insertTest() {
        List<Account> acc = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            acc.add(new Account(Name = 'B Test:' + i)); 
        }
        insert acc;
}

    public static void deleteTestRecords() {
   
        List<Account> accToDelete = [SELECT Id,Name FROM Account WHERE Name LIKE 'Insert Test:%'];
            delete accToDelete;
        

}



    /*Execute from anonymous windows 
        AccountOwnerTriggerHandler.insertTest();

        AccountOwnerTriggerHandler.deleteTestRecords();

    */

}
/*
    
     
 */