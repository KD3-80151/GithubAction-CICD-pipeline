public interface IGeoCodeAPI {
    List<Decimal> getLatLong(String address);
    String getAddress(Decimal lat, Decimal lng);
}