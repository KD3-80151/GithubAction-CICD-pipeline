public with sharing class SalesforceSourceIntegration {
    //@future (callout=true)
    // public static void getDetails() {
        
    //     HttpRequest req = new HttpRequest();
    //     req.setEndpoint('callout:SalesforceSagar/services/apexrest/getAccountIds');
    //     req.setHeader('content-type', 'application/json; charset=UTF-8');
    //     req.setHeader('Accept', 'application/json');
    //     req.setMethod('GET');
    //     Http http = new Http();
    //     HttpResponse response = http.send(req);

    //     System.debug('response code: ' + response.getStatusCode());
    //     System.debug('response code: ' + response.getBody());
    // }

    // @future (callout=true)

    public static void getDetails(String searchKey) {
        
        HttpRequest req = new HttpRequest();
        String endpoint = 'callout:SalesforceSagar/services/apexrest/searchName/'+ EncodingUtil.urlEncode(searchKey, 'UTF-8');
        req.setEndpoint(endpoint);
        req.setHeader('content-type', 'application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(req);

        System.debug('response code: ' + response.getStatusCode());
        System.debug('response body: ' + response.getBody());
    }
}
// SalesforceSourceIntegration.getDetails('test');
// SalesforceSourceIntegration.getDetails();