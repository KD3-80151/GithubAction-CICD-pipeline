public with sharing class USGeoCode implements IGeoCodeAPI{
    public static List<Decimal> getLatLong (String address){
        return new List<Decimal> {213.23, 154.34};
    } 

    public static String getAddress(Decimal lat, Decimal lng){
        return 'Delhi';
    }
}