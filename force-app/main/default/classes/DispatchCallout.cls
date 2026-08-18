//my code
/*
public class DispatchCallout implements Queueable, Database.AllowsCallouts{
    public set<Id> caseIds;
    
    public DispatchCallout(set<Id> caseIds){
        this.caseIds = caseIds;
    }
    
    public static void sendBulkToDispatch(set<Id> caseIds){
        System.enqueueJob(new DispatchCallout(caseIds));
    }
    
    public void execute(QueueableContext context){
        list<Case> caseList = [select Id, CaseNumber, Priority, Customer_Name__c, Phone__c, GPS__Latitude__s, GPS__Longitude__s, Vehicle_Make__c, Issue_Description__c from Case where Id IN :caseIds];
        
        list<EmergencyWrapper> emergeWrper = new List<EmergencyWrapper>();
        
        for(Case c : caseList){
            emergeWrper.add(new EmergencyWrapper(c));
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DispatchAPI/bulk-emergency');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(emergeWrper));
            req.setTimeout(60000);
        
        try{
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if(res.getStatusCode() == 200){
                System.debug('Sucess::' + caseList.size() +':: dispatched');
            }
            else{
                System.debug('error::' + res.getStatusCode());
            }
        }
        catch(Exception e){
            system.debug('failed::' + e.getMessage());
        }
    }
    
    
    
    public class EmergencyWrapper{
        public String caseId;
        public String caseNumber;
        public String priority;
        public String customerName;
        public String phone;
        public Decimal latitude;
        public Decimal longitude;
        public String vehicleMake;
        public String issueDescription;
        
        public EmergencyWrapper(Case c){
            this.caseId = c.Id;
            this.caseNumber = c.CaseNumber;
            this.priority = c.Priority;
            this.customerName = c.Customer_Name__c;
            this.phone = c.Phone__c;
            this.latitude = c.GPS__Latitude__s;
            this.longitude = c.GPS__Longitude__s;
            this.vehicleMake = c.Vehicle_Make__c;
            this.issueDescription = c.Issue_Description__c;
        }
    }
}*/

//chatgpt code
public class DispatchCallout implements Queueable, Database.AllowsCallouts {

    public Set<Id> caseIds;

    public DispatchCallout(Set<Id> caseIds) {
        this.caseIds = caseIds;
    }

    public static void sendBulkToDispatch(Set<Id> caseIds) {
        if(caseIds == null || caseIds.isEmpty()) return;
        System.enqueueJob(new DispatchCallout(caseIds));
    }

    public void execute(QueueableContext context) {

        List<Case> caseList = [SELECT Id, CaseNumber, Priority, Customer_Name__c, Phone__c, GPS__Latitude__s, GPS__Longitude__s, Vehicle_Make__c, Issue_Description__c
            FROM Case WHERE Id IN :caseIds];

        if(caseList.isEmpty()) return;

        List<EmergencyWrapper> payload = new List<EmergencyWrapper>();
        for (Case c : caseList) {
            payload.add(new EmergencyWrapper(c));
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DispatchAPI/bulk-emergency');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(60000);
        req.setBody(JSON.serialize(payload));

        try {
            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                System.debug('SUCCESS: Dispatched ' + payload.size() + ' cases');
            } else {
                System.debug('FAILED: ' + res.getStatusCode() + ' - ' + res.getBody());
            }

        } catch (Exception e) {
            System.debug('CALLOUT ERROR: ' + e.getMessage());
        }
    }

    public class EmergencyWrapper {
        public String caseId;
        public String caseNumber;
        public String priority;
        public String customerName;
        public String phone;
        public Decimal latitude;
        public Decimal longitude;
        public String vehicleMake;
        public String issueDescription;

        public EmergencyWrapper(Case c) {
            caseId = c.Id;
            caseNumber = c.CaseNumber;
            priority = c.Priority;
            customerName = c.Customer_Name__c;
            phone = c.Phone__c;
            latitude = c.GPS__Latitude__s;
            longitude = c.GPS__Longitude__s;
            vehicleMake = c.Vehicle_Make__c;
            issueDescription = c.Issue_Description__c;
        }
    }
}

/*
“Triggers can’t make callouts and bulk operations can exceed callout limits.
So we collect Case IDs in the trigger and enqueue a Queueable job.
The Queueable performs one bulk callout with all emergency cases as a JSON array, ensuring governor limits are respected while maintaining near real-time dispatching.”
*/