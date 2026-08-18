public class AccuWeatherAPI {
public static void accuWeather(String cityName){
     Http http = new Http();
     HttpRequest req = new HttpRequest();
     String endpoint = 'http://api.weatherapi.com/v1/current.json?key=194797a91da048ab9d350748240907&q=' 
     					+ EncodingUtil.urlEncode(cityName, 'UTF-8') + '&aqi=no';
     req.setEndpoint(endpoint);
     req.setMethod('GET');
     HttpResponse res = http.send(req); 
          if (res.getStatusCode() == 200) {
                    System.debug('Response: ' + res.getBody());
                } else {
                    System.debug('Error: ' + res.getStatus());
                }
            }
}