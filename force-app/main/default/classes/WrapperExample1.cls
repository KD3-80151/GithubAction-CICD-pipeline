public class WrapperExample1 {
    public static List<AccountInforWrapper> wrapperList {get; set;}
    
    public WrapperExample1() {
        getAccountDetailsBasedOnId();
    }
    
    public static List<AccountInforWrapper> getAccountDetailsBasedOnId() {
        wrapperList = new List<AccountInforWrapper>();
        List<String> accountIdList = new List<String>{'001dM00000CzwkmQAB','001dM00000BjTFgQAN','001dM00000FASVrQAP'};
        for(Account accountObj : [Select Id, Name, (Select Id, Name from Contacts), 
                                  (Select Id, Amount from Opportunities) from Account where Id IN: accountIdList]){
            String contactsName = '';
            Integer oppCount = 0;
            Decimal oppSum = 0;
            for(Contact contactObj : accountObj.Contacts) {
                contactsName += contactObj.Name + ';';
            }
            for(Opportunity oppObj : accountObj.Opportunities) {
                oppCount++;
                oppSum = oppObj.Amount != null ? oppSum + oppObj.Amount : oppSum;
            }
            wrapperList.add(new AccountInforWrapper(accountObj.Name, contactsName, oppCount, oppSum));
        }
        return wrapperList;
    }
    
    public class AccountInforWrapper {
        public String accountName {get; set;}
        public String contactName {get; set;}
        public Integer countOfOpp {get; set;}
        public Decimal totalOppAmountSum {get; set;}
        
        public AccountInforWrapper(String accountName, String contactName, Integer countOfOpp, Decimal totalOppAmountSum) {
            this.accountName 		= accountName;
            this.contactName		= contactName;
            this.countOfOpp			= countOfOpp;
            this.totalOppAmountSum	= totalOppAmountSum;
        }
    }
}