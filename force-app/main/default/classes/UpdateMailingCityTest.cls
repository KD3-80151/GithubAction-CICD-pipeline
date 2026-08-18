@isTest
public class UpdateMailingCityTest {
    @testSetup
    static void TestMailingCity(){
        List<Account> accList = new List<Account>{
            new Account(Name = 'Account1', BillingCity='City A'),
            new Account(Name = 'Account2', BillingCity='City B'),
            new Account(Name = 'Account3', BillingCity='City C')
        };
    /*        
       accList[0].Name = 'Account1';
        accList[0].BillingCity='City A';
                accList[1].Name = 'Account2';
        accList[1].BillingCity='City B';
                accList[2].Name = 'Account3';
        accList[2].BillingCity='City C';
 */       
            insert accList;
        
         List<Contact> conList = new List<Contact>{
            new Contact(LastName = 'Contact 1', AccountId = accList[0].Id, MailingCity = 'Old A'),
            new Contact(LastName = 'Contact 2', AccountId = accList[1].Id, MailingCity = 'Old B'),
            new Contact(LastName = 'Contact 3', AccountId = accList[2].Id, MailingCity = 'Old C')
        };
        insert conList;
        
    }
    
    @isTest
    static void testUpdateMailingCity(){
        List<Account> acc = [select Id, BillingCity from Account];
        acc[0].BillingCity = 'New A';
        acc[1].BillingCity = 'New B';
        
        update acc;
        
        Map<Id, Account> accMap = new Map<Id, Account>([select Id, BillingCity from Account where Id IN: acc ]);
        
        Test.startTest();
        UpdateMailingCity.MailCity(acc, accMap);
        Test.stopTest();
        
        List<Contact> cotList = [select Id, MailingCity from Contact where AccountId IN: acc];
        
        System.assertEquals('New A', cotList[0].MailingCity);
        System.assertEquals('New B', cotList[1].MailingCity);
        //System.assertEquals(' New', cotList[2].MailingCity);
        
    }

}