@isTest
public class ContactTriggerCrudHandlerTest {
    
    @isTest
    static void createTestAccount(){
        
        Account acc = new Account(Name='TestClass1');
        insert acc;        
        Contact c1 = new Contact();
        c1.AccountId = acc.Id;
        
        //System.assertEquals(3, acc.Contact_Count__c, 'after 1st update');
     
        
        
    }
    

}