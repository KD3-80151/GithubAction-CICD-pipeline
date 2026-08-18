public with sharing class ContactCreated {
    
    public static void createContact(List<Account> accList){

        List<Contact> cont = new List<Contact>();
        for (Account a : accList) {
            if (a.Name != null) {
                Contact c = new Contact();
                c.AccountId = a.Id;
                c.LastName = a.Name;
                cont.add(c);    
            }
            
        }

        if (!cont.isEmpty()) {
            insert cont;
        }

    }
}