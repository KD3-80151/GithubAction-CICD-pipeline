public with sharing class SchemaObject {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCustomObjects() {
        List<Map<String, String>> customObjects = new List<Map<String, String>>();

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        
        for (Schema.SObjectType sObjectType : globalDescribe.values()) {
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();

            if (describeResult.isCustom() && !describeResult.isCustomSetting()) {
                Map<String, String> objectInfo = new Map<String, String>();
                objectInfo.put('apiName', describeResult.getName());
                objectInfo.put('label', describeResult.getLabel());
                objectInfo.put('description', describeResult.getName());
                customObjects.add(objectInfo);
            }
        }
        
        return customObjects;
    }
}