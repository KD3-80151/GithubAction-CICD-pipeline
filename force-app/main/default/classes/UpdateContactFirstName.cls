public class UpdateContactFirstName {
    public void UpdateName(){
	List<Contact> contactList = [Select Id, FirstName, LastName from Contact where AccountId= null];
        for(Contact c : contactList){
			c.FirstName = c.LastName;
        }
        update contactList;
    }

}