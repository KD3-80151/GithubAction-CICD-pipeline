public class PhoneNumberController {
    public static void PhoneNoRequired(List<Account> accntList){
        
        for(Account acc: accntList){
            if (acc.Phone==null) {
            String errors= 'Without phone number no account creation';
            acc.addError(errors);
            
        }

        } 

    }
}


















// I want to create a