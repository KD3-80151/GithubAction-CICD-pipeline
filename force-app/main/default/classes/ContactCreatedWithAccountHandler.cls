public class ContactCreatedWithAccountHandler {
    public static void ContactCreated(List<Account> accntList){
        List<Contact> contactList = new List<Contact>();
        
        for(Account acc: accntList){
            Contact c = new Contact();
            c.AccountId = acc.Id;
            c.LastName = acc.Name;
            contactList.add(c);
        }
        
        if(!contactList.isEmpty()){
			insert contactList;
        }

    }

}