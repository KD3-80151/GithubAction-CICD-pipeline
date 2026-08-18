public class ContactCreationOnAccount {
    public static void contactCreation(List<Account> accList){
        List<Contact> cont = new List<Contact>();
        for(Account acc: accList){
            Contact c = new Contact();
            c.LastName=acc.Name;
            c.AccountId = acc.Id;
            cont.add(c);
        }
        if(!cont.isEmpty()){
        	insert cont;   
        }
    }
}