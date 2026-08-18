public with sharing class SearchAccountsController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        // SalesforceSourceIntegration.getDetails(searchKey);
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

        List<Account> accounts = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
            return accounts;
    }
}

// SearchAccountsController.searchAccounts('test');