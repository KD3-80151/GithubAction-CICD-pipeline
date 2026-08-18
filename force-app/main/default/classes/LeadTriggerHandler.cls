public class LeadTriggerHandler {
    public static void handleBeforeInsert(List<Lead> newLeads) {
        Set<String> phoneNumbers = new Set<String>();
        for (Lead newLead : newLeads) {
            if (newLead.Phone != null) {
                phoneNumbers.add(newLead.Phone);
            }
        }

        Map<String, Lead> existingLeadsMap = new Map<String, Lead>();
        if (!phoneNumbers.isEmpty()) {
            for (Lead existingLead : [
                SELECT Id, Phone, Status 
                FROM Lead 
                WHERE Phone IN :phoneNumbers
            ]) {
                existingLeadsMap.put(existingLead.Phone, existingLead);
            }
        }

        System.debug('Existing Leads with matching phone numbers: ' + existingLeadsMap);

        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead newLead : newLeads) {
            if (newLead.Phone != null && existingLeadsMap.containsKey(newLead.Phone)) {
                Lead existingLead = existingLeadsMap.get(newLead.Phone);

                System.debug('Matching existing Lead: ' + existingLead);

                if (existingLead.Status == 'New' && newLead.Status == 'New') {
                    existingLead.Status = 'Active';
                    leadsToUpdate.add(existingLead);
                    System.debug('Updating existing Lead status to Active: ' + existingLead);

                    newLead.addError('A lead with this phone number already exists and has been updated to Active status.');
                }
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
            System.debug('Updated Leads: ' + leadsToUpdate);
        }
    }
}