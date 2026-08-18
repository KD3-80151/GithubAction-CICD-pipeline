//get data
//json to apex 
//use custom setting


// make an user only api //restrict user 
//9msg - book - 
//named credentials


public with sharing class GetAccountRest {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        Map<String, String> authDetails = UtilityClassRest.getAccessToken();
        String accessToken = authDetails.get('access_token');
        String instanceUrl = authDetails.get('instance_url');

        if (accessToken == null) {
            throw new AuraHandledException('Failed to get access token: ' + authDetails.get('error'));
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(instanceUrl + '/services/apexrest/getAccountIds');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            List<Account> accounts = (List<Account>) JSON.deserialize(res.getBody(), List<Account>.class);
            return accounts;
        } else {
            throw new AuraHandledException('Failed to fetch accounts: ' + res.getBody());
        }
    }
}