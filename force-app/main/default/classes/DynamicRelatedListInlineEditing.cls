public with sharing class DynamicRelatedListInlineEditing {

    public class OpportunityWrapper {
        @AuraEnabled public Id oppId;
        @AuraEnabled public String name;
        @AuraEnabled public String stageName;
        @AuraEnabled public Decimal amount;
        @AuraEnabled public Date closeDate;
        @AuraEnabled public List<OpportunityLineItem> lineItems;
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityWrapper> getOpportunitiesWithLineItemsForTab() {
        List<OpportunityWrapper> result = new List<OpportunityWrapper>();

        List<Opportunity> opps = [SELECT Id, Name, StageName, Amount, CloseDate, (SELECT Id, Quantity, UnitPrice, TotalPrice, PricebookEntry.Name FROM OpportunityLineItems ORDER BY CreatedDate DESC) FROM Opportunity
            WHERE IsClosed = false  ORDER BY LastModifiedDate DESC LIMIT 10];

        for (Opportunity opportunityToSHow : opps) {
            OpportunityWrapper wrapperOpportunityTOShow = new OpportunityWrapper();
            wrapperOpportunityTOShow.oppId =        opportunityToSHow.Id;
            wrapperOpportunityTOShow.name =         opportunityToSHow.Name;
            wrapperOpportunityTOShow.stageName =    opportunityToSHow.StageName;
            wrapperOpportunityTOShow.amount =       opportunityToSHow.Amount;
            wrapperOpportunityTOShow.closeDate =    opportunityToSHow.CloseDate;
            wrapperOpportunityTOShow.lineItems =    opportunityToSHow.OpportunityLineItems;
            result.add(wrapperOpportunityTOShow);
        }

        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityLineItems (Id opportunityId) {
        System.debug('getOpportunityLineItems opportunityId :: ' + opportunityId);
        if (opportunityId == null) {
            return new List<OpportunityLineItem>();
        }

        return [SELECT Id, Quantity, UnitPrice, TotalPrice, PricebookEntry.Name FROM OpportunityLineItem WHERE OpportunityId = :opportunityId ORDER BY CreatedDate DESC];
    }

    @AuraEnabled
    public static void updateOppLi(List<OpportunityLineItem> updateProducts){
        System.debug('updateOppLi input :: ' + JSON.serialize(updateProducts));
        try {
            if (updateProducts != null && !updateProducts.isEmpty()) {
                update updateProducts;
            }
        } catch (Exception e) {
            System.debug('updateOppLi ERROR :: ' + e.getMessage() + 'at lien number:::' + e.getLineNumber());
        }
    }
}