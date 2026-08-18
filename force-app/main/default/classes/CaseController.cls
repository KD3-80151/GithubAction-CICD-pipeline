public with sharing class CaseController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getStatusPicklistValues() {
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        List<String> options = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            options.add(entry.getLabel());
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static Case getCase(String caseId) {
        try {
            return [SELECT Id, Subject, Description, Status FROM Case WHERE Id = :caseId LIMIT 1];
        } catch (Exception e) {
            return null;
        }
    }
    
    @AuraEnabled
    public static String updateCase(String caseId, String subject, String description, String status) {
        try {
            Case c = [SELECT Id, Subject, Description, Status FROM Case WHERE Id = :caseId LIMIT 1];
            
            if (c != null) {
                c.Subject = subject;
                c.Description = description;
                c.Status = status;
                
                update c;
                
                return 'Case updated successfully';
            } else {
                return 'Case not found';
            }
        } catch (Exception e) {
            return 'Error updating case: ' + e.getMessage();
        }
    }
}