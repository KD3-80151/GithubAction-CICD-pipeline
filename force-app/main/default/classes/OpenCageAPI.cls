public with sharing class OpenCageAPI {

    //method name will be same in all the concrete classes 
    public static List<Decimal> getLatLong (String address){
        return new List<Decimal> {13.23, 54.34};
    } 

    public static String getAddress(Decimal lat, Decimal lng){
        return 'Agra, main chowk';
    }

}