public with sharing class SalesforceIntegrationUsingRest {

        public static void accuWeather(String cityName){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            String endpoint = 'http://api.weatherapi.com/v1/current.json?key=194797a91da048ab9d350748240907&q=' + cityName;
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = http.send(req); 
            if (res.getStatusCode() == 200) {
                System.debug('Response: ' + res.getBody());
            }
        }

//194797a91da048ab9d350748240907
}