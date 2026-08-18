public class UpdateConFnameWithAccName {
    public void UpdateContactName(){
        List<Contact> contactList = [select Id, FirstName, Account.Name from Contact where AccountId!=null];
        for(Contact c: contactList){
		c.FirstName = c.Account.Name;
            
        }
        update contactList;
    
    }
}