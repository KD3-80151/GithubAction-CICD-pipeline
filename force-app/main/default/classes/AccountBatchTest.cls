@isTest
public with sharing class AccountBatchTest {
    public AccountBatchTest() {

    }

    @isTest
    public static void getTestAccount(){
        List<Account> accList = new List<Account>();
        for(Integer i =1; i<10; i++){
            accList.add(new Account(Name = 'Test' +i));
        } 
    //testing 
        insert accList;
        

        String searchName = 'Test';

        Test.startTest();
        AccountContactShow.searchName(searchName);
        Test.stopTest();

        List<Account> acc = [select Name, Type from Account where Name like :('%' + searchName + '%')];
        
    }


}