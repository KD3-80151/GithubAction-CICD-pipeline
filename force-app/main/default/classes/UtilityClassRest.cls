public with sharing class UtilityClassRest {
    
    public static Map<String, String> getAccessToken() {
        Map<String, String> result = new Map<String, String>();

        try {
            RestCustomSetting__c settings = RestCustomSetting__c.getOrgDefaults();

            if (settings == null) {
                throw new AuraHandledException('Organization level custom settings are not found.');
            }

            String loginUrl = settings.Login_URL__c;
            String clientId = settings.Client_ID__c;
            String clientSecret = settings.Client_Secret__c;
            String username = settings.Username__c;
            String password = settings.Password__c;

            HttpRequest req = new HttpRequest();
            req.setEndpoint(loginUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody('grant_type=password' + 
                        '&client_id=' + clientId + 
                        '&client_secret=' + clientSecret + 
                        '&username=' + username + 
                        '&password=' + password);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> authResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                result.put('access_token', (String) authResponse.get('access_token'));
                result.put('instance_url', (String) authResponse.get('instance_url'));
            } else {
                Map<String, Object> errorResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String errorMessage = (String) errorResponse.get('error_description');
                result.put('error', errorMessage);
            }
        } catch (Exception e) {
            result.put('error', e.getMessage());
        }

        return result;
    }
}