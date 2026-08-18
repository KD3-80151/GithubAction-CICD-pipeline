public with sharing class ContactCreationLwc {
    
    @AuraEnabled
    public static String createContact(String firstName, String lastName, String email, String phone, Date birthDate) {
        try {
            Contact newCont = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone,
                Birthdate = birthDate
            );
            insert newCont;
            return 'Contact created' + newCont.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String createContactLwc(String firstName, String lastName, String email, String phone, Date birthDate){
        
        try {
            Contact c= new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone,
                Birthdate = birthDate
            );
            insert c;
            return 'new cont ' + c.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createContactPrac(String fName, String lName, String email, String phone, Date birthDate){
        try {
            Contact cont = new Contact(
                FirstName = fName,
                LastName = lName,
                Email = email,
                Phone = phone,
                Birthdate = birthDate
            );
            insert cont;
            return 'new cont ' + cont.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}