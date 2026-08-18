public class SoqlCheck {
    public static void GetContactDetails(){
        List <Contact> acc = [select FirstName, LastName, Email from Contact];
        for(Contact c:acc){
            String name = 'FirstName: ' + c.FirstName + 'LastName: ' + c.LastName + 'Email: ' + c.Email;
            System.debug(name);
            
        }
    }
    
    public static void GetMaxOppAmount(){
        Opportunity opp = [select Name, Account.Name,Amount from Opportunity where Amount !=null order by Amount desc limit 1 ];
        if(opp!=null){
            System.debug('Maximum amount in opportunity is: ' + opp);
        }
        else{
            System.debug('opportunity is not found: ' );
        }
    }
    
  /*   public static void GetMaxOppAmountUsingMax(){
 Opportunity opp1 = [select Name, Account.Name, max(Amount) from Opportunity where Amount !=null];
	if(opp1!=null){
	System.debug('Maximum amount in opportunity using max is: ' + opp1);
}
else{
System.debug('opportunity is not found: ' );
}
}*/
    public static void GetMaxOppAmountUsingMax(){
        List<Opportunity> oppo = [select Name, Account.Name, Amount from Opportunity where Amount != null];
        
        Double mAmount = 0;
        Opportunity mOpp = null;

        for(Opportunity opp : oppo){
            if(opp.Amount > mAmount){
                mAmount = opp.Amount;
                mOpp = opp;
            }
        }

        if(mOpp != null){
            System.debug('Maximum amount in opportunity using max is: ' + mOpp);
        } else {
            System.debug('Opportunity not found.');
        }
    }

}