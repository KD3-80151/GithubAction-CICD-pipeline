public with sharing class AccountGeoCode {
    public AccountGeoCode() {

    }


     /*     //to integerate with different api
      * Geocoder Service- Picklist
      * Google API
      * US coder api
      */
      

    /*
     * @description :
     * @param       :
     * @return      :
     */

    public static void getLatLong(Account acc){
        
        List<Decimal> latLong =  GeoCode.getLatLang(acc.Geocode_Service__c);
        System.debug('latLong '+ latLong); 

        // IGeoCodeAPI googleGeoCode = new GoogleGeoCode();
        // List<Decimal> latLong = googleGeoCode.getLatLong('Jind');


        //List<Decimal> latLong;

        // if(acc.GeoCodeService__c = 'Google API'){
        //     latLong = GeoCode.getLatLong(acc.Address__c);
        // }

        // else if(acc.GeoCodeService__c = 'Google API'){
        //     latLong = GeoCode.getLatLongtOpenGeo();
        // }

        // else if(acc.GeoCodeService__c = 'Google API'){
        //     latLong = GeoCode.getLatLongtUSGeo();
        // }

    }


    



}