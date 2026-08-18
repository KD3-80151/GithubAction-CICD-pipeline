public with sharing class CaseTimelineController {
    @AuraEnabled(cacheable=true)
    public static List<TimelineItem> getCaseHistory(Id caseId) {
        List<TimelineItem> timeline = new List<TimelineItem>();

        List<CaseHistory> histories = [
            SELECT Id, CreatedDate, Field, OldValue, NewValue 
            FROM CaseHistory 
            WHERE CaseId = :caseId 
            ORDER BY CreatedDate DESC
        ];

        for (CaseHistory ch : histories) {
            timeline.add(new TimelineItem(
                ch.CreatedDate.format(),
                ch.Field,
                String.valueOf(ch.OldValue),
                String.valueOf(ch.NewValue)
            ));
        }
        return timeline;
    }

    public class TimelineItem {
        @AuraEnabled public String timestamp;
        @AuraEnabled public String field;
        @AuraEnabled public String oldValue;
        @AuraEnabled public String newValue;

        public TimelineItem(String timestamp, String field, String oldValue, String newValue) {
            this.timestamp = timestamp;
            this.field = field;
            this.oldValue = oldValue;
            this.newValue = newValue;
        }
    }
}