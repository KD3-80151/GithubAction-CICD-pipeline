public with sharing class LeadOpportunityStatsController {
   
    public class Bucket {
        @AuraEnabled public String label;
        @AuraEnabled public Integer count;
        public Bucket(String label, Integer count){
            this.label = label;
            this.count = count;
        }
    }

    public class StatusDto {
        @AuraEnabled public Integer totalLeads;
        @AuraEnabled public Integer totalOpps;
        @AuraEnabled public Integer totalAll;
        @AuraEnabled public List<Bucket> leadBuckets; 
        @AuraEnabled public List<Bucket> oppBuckets; 
    }

    @AuraEnabled
    public static StatusDto getStats(){

        StatusDto dto = new StatusDto();
        dto.leadBuckets = new List<Bucket>();
        dto.oppBuckets = new List<Bucket>();

        dto.totalLeads = [SELECT COUNT() FROM Lead where IsConverted = false];
        dto.totalOpps = [SELECT COUNT() FROM Opportunity];
        
        for(AggregateResult ar : [SELECT Status s, COUNT(Id) totalLeads FROM Lead where isConverted = false GROUP BY Status]){
            dto.leadBuckets.add(new Bucket((String)ar.get('s') == null ? 'Unknown' : (String)ar.get('s'), (Integer)ar.get('totalLeads')));
        }

        for(AggregateResult ar : [SELECT StageName s, COUNT(Id) totalOpps FROM Opportunity GROUP BY StageName]){
            dto.oppBuckets.add(new Bucket((String)ar.get('s') == null ? 'Unknown' : (String)ar.get('s'),(Integer)ar.get('totalOpps')));
        }

        return dto;
    }
}