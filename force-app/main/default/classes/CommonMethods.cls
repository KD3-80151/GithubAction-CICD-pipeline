public with sharing class CommonMethods {
    
    @AuraEnabled(cacheable = true )
    public static Map<String, String> getAllObjects(){
        Map<String, String> mapOfAllObject = new Map<String, String>();

        for (Schema.SObjectType objType : Schema.getGlobalDescribe().values()) { // give me the local name and label
            //SObjectType - The list of SObject types to describe // type - List<String>

            //getGlobalDescribe()
            //Returns a map of all sObject names (keys) to sObject tokens (values) for the standard and custom objects defined in your organization.
            //Schema.DescribeSObjectResult describeSObjectResultObj = objType.getDescribe();
            String name = objType.getDescribe().getLocalName();
            String label = objType.getDescribe().getLabel();
            mapOfAllObject.put(name, label);
        }
        return mapOfAllObject;
    }


}