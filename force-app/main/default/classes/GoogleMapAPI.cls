public with sharing class GoogleMapAPI implements IGeoCodeAPI{
    public GoogleMapAPI() {

    }

    public static List<Decimal> getLatLong (String address){
        System.debug('Google map APi');
        return new List<Decimal> {01.23, -4.34};
    }

    public static String getAddress(Decimal lat, Decimal lng){
        return 'Jind Google';
    }
}