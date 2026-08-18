public with sharing class OpportunityValidationTrigger {
    public static void opportunityValidation(List<Opportunity> oppList, Map<Id,Opportunity> oldMap) {
        
      for (Opportunity opp : oppList) {
        Opportunity oldOpp = oldMap.get(opp.Id);
        if (opp.CloseDate < Date.today()) {
            String message = 'Opportunity cannot have a Close Date in the past.';
            opp.CloseDate.addError(message);
        }

        if (oldOpp.StageName =='Prospecting'  && opp.StageName == 'Closed Won') {
            opp.StageName.addError('Opportunity cannot transition directly from Prospecting to Closed Won');
        }

        if (opp.StageName =='Closed Won'  && opp.Amount < 10000) {
            opp.Amount.addError('Opportunity Amount must be graeter than 10000');
        }
      }

    }
}