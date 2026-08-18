public class PraacticeContactCreation {
    public void AccountUpdate(){
        Map<Id,Account> accountMap = new Map<Id,Account>();
        List<Contact> contList = [select Id, FirstName, LastName from Contact where AccountId=null];
        List<Account> acntList = new List<Account>();
        
        for(Contact c:contList){
            
        }

}

}