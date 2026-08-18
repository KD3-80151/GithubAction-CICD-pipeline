public class CreateOpportunityOnAgricultureHandler {
    public static void OpportunityIndustry(List<Account> accountList){
        List<Opportunity> oppo = new List<Opportunity>();
        
        for(Account acc: accountList){
            if(acc.Industry== System.Label.AccountTypeAgriculture){ 
                //to remove the lengthy process of deployment
                //similar to 'Agriculture'
               Opportunity opp = new Opportunity();
                opp.AccountId = acc.Id;
                opp.Name= acc.Name;
                opp.StageName = System.Label.StageNameProspecting;
                System.debug(System.Label.StageNameProspecting);
                opp.Amount =0;
                opp.CloseDate = Date.today().addDays(90);
                oppo.add(opp);
            }
        }
        
        if(!oppo.isEmpty()){
            insert oppo;
        }
    }

    public static void createOppoByAccount(List<Account> accList){

        List<Opportunity> oppo = new List<Opportunity>();
        for (Account acc : accList) {
            if (acc.Industry == 'Agriculture') {
                Opportunity opp = new Opportunity();
                opp.AccountId = acc.Id;
                //Stage = ‘Prospecting’, Amount = $0, CloseDate = ’90 days from today’.
                opp.StageName = 'Prospecting';
                opp.Amount = 0;
                opp.CloseDate = Date.today().addDays(90);
            }
        }

        if (!oppo.isEmpty()) {
            insert oppo;
        }
    }

}