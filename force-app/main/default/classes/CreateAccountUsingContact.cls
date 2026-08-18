public class CreateAccountUsingContact {
    public void CreateAccountWithContact(){
	List<Contact> contactList = [select Id, FirstName, LastName from Contact where AccountId = null];
    Map<Id, Account> acntMap = new Map<Id,Account>();
        List<Account> acntList = new List<Account>();
    
        for (Contact c : contactList) {
		Account a = new Account();
        a.Name=c.Id;
        acntList.add(a);
        acntMap.put(c.Id,a);
		}
    if(!acntList.isEmpty()){
        insert acntList;
    }
    
    for (Contact c : contactList) {
            c.AccountId = acntMap.get(c.Id).Id;
        }

        if (!contactList.isEmpty()) {
            update contactList;
        }
    
    }
}