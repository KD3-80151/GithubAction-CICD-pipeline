/*
 * ----------------------------------------------------------------------------------------------------
 * @description         : Strategy Design Pattern
 * @author              : Sagar Kumar
 * @last modified on    : 29/07/2024
 * @last modified date  :  
 * -----------------------------------------------------------------------------------------------------
 **/
//this is called as Factory class called from another class AccountGeoCode
public with sharing class GeoCode {

    /*
     * @description :
     * @param       :
     * @return      :
     */

     //any implementor class is IGeoCodeAPI - that interface hold the reference to our concrete class 
     private static Map<String, IGeoCodeAPI> geoCodeApiMap;

     static{
        //going to execute before any method and constructor
        List<Geocode__mdt> classToImplement = Geocode__mdt.getAll().values();
        for(Geocode__mdt cls: classToImplement){
            if (geoCodeApiMap == null){
                geoCodeApiMap = new Map<String, IGeoCodeAPI>();
            }

            if (cls.Active__c) {
                            Type t = Type.forName(cls.ClassName__c);    
            geoCodeApiMap.put(cls.GeocodeService__c , (IGeoCodeAPI)t.newInstance());

            //newInstance only work when your class doesn't have constructor
            //if constructor is going to accept parameter then new \Instance doesnot going to work
                
            }

        }
     } 

    public static List<Decimal> getLatLang(String geoCodeServiceName){
        //geoCodeServiceName - value from our account picklist
        
        List<Decimal> latLong; 
        if(geoCodeApiMap.containsKey(geoCodeServiceName)){
            //it will find that if their is entry in your api or not i.e custom metadata
            IGeoCodeAPI igeoCodeObj = geoCodeApiMap.get(geoCodeServiceName); 
            latLong = igeoCodeObj.getLatLong('Delhi 123');
        }
        else {
            System.debug('No Gencode Service found');
            throw new NamedException('Please Contact your administrator ');
        }


        Type t = Type.forName(geoCodeServiceName);


        return latLong;
    }

    // public static List<Decimal> getLatLongtOpenGeo(){
    //     return new List<Decimal> {211.07, -3.08};
    // }

    // public static List<Decimal> getLatLongtUSGeo(){
    //     return new List<Decimal> {231.07, -213.08};
    // }


    public static String getAddress(String geoCodeServiceName, Decimal lat, Decimal lng){
        String address;
        Type t = Type.forName(geoCodeServiceName);

        IGeoCodeAPI igeoCodeObj = (IGeoCodeAPI)t.newInstance();

        address = igeoCodeObj.getAddress(lat, lng);

        return address;

    }


    public class NamedException extends Exception{

    } 




}