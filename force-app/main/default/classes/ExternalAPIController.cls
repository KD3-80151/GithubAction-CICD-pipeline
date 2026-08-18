public with sharing class ExternalAPIController {
    @AuraEnabled
    public static String getExternalData() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://jsonplaceholder.typicode.com/posts/1');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            throw new AuraHandledException('Callout failed: ' + response.getStatus());
        }
    }
}