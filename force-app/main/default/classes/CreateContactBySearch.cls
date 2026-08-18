public class CreateContactBySearch {
    public static List<Contact> CreateContact(String contactName, Boolean isCreate) {
        String searchName = '%' + contactName + '%';

        List<Contact> contactList = [SELECT Id, FirstName, LastName FROM Contact WHERE Name LIKE :searchName];

        if (contactList.isEmpty() && isCreate) {
            Contact newContact = new Contact(FirstName = contactName, LastName = 'abc');
            insert newContact;
            contactList.add(newContact);

            System.debug(newContact);
            System.debug(contactName);
        }
        return contactList;
    }
}