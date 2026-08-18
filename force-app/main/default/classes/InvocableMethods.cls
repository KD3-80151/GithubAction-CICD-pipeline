public with sharing class InvocableMethods {
    public InvocableMethods() {

    }

    // @InvocableMethod(label='Get Addresses' description='Get the Address for the specified records') // allow apex methods to be called from Salesforce flow, PB , mainly to expose apex code 
    // // or external systems (like REST API via Flow).
    // public static List<String> getAddress(List<String> ids) {
    //     System.debug('---- Executing GetAddress InvocableMethod');
    //     return null;
    // }

    public class ContactInput{
        @InvocableVariable(label='Contact Record' required=true) // to use InvocableMethods.ContactInput
        public Id contactId;
    }

    @InvocableMethod(label='Update Contact Status' description='Set status fields of given  contact to active')
    public static void updateStatus(List<ContactInput> contactInputs) {
        List<Contact> contactToUpdate = new List<Contact>();

        for (ContactInput input : contactInputs) {
            contactToUpdate.add(new Contact(
                Id = input.contactId,
                Status__c = 'Active'
            ));
        }

        if(!contactToUpdate.isEmpty()) {
            update contactToUpdate;
        }
    }


}