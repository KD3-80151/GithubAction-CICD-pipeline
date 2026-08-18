public class GoogleGeoCode implements IGeoCodeAPI{
    
    public static List<Decimal> getLatLong (String address){
        return new List<Decimal> {23.23, 54.34};
    }

    public static String getAddress(Decimal lat, Decimal lng){
        return 'Jind';
    }
}