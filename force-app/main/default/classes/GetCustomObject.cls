public with sharing class GetCustomObject {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCustomObject() {
        List<Map<String, String>> customObjects = new List<Map<String, String>>();

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

        for (Schema.SObjectType sObjectType : globalDescribe.values()) {
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
            System.debug('describeResult'+ describeResult); 

            if (describeResult.isCustom() && !describeResult.isCustomSetting()) {
                Map<String, String> objectInfo = new Map<String, String>();
                System.debug('objectInfo'+ objectInfo);
                objectInfo.put('apiName', describeResult.getName());
                objectInfo.put('label', describeResult.getLabel());
                System.debug('describeResult.getName()'+ describeResult.getName());
                customObjects.add(objectInfo);
            }
        }

        return customObjects;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFields(String objectName) {
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
        System.debug('sObjectType'+ sObjectType);
        if (sObjectType != null) {
            Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
            System.debug('fieldsMap'+ fieldsMap);
            for (Schema.SObjectField field : fieldsMap.values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                Map<String, String> fieldInfo = new Map<String, String>();
                fieldInfo.put('apiName', fieldDescribe.getName());
                fieldInfo.put('label', fieldDescribe.getLabel());
                System.debug('fieldInfo'+ fieldInfo);
                
                String fieldType = fieldDescribe.getType().name();
                if (fieldType == 'REFERENCE') {
                    fieldType = 'TEXT';
                }
                System.debug('fieldType'+ fieldType);
                fieldInfo.put('type', fieldType);
                fieldsList.add(fieldInfo);
            }
        }
        return fieldsList;
    }
   /* 
    public static List<Map<String, Object>>getCustomPicklistValues{
        List<Map<String, SObject>> storePicklistValues = new List<Map<String, SObject>>();
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
    }*/
    
    /*
// Replace 'Account' with your object API name
// Replace 'Industry' with your picklist field API name
Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();

// Get all picklist values
List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

// Print the number of values
System.debug('Number of picklist values: ' + picklistValues.size());

// Optional: Print each picklist value
for (Schema.PicklistEntry entry : picklistValues) {
    System.debug('Picklist Value: ' + entry.getLabel() + ' (' + entry.getValue() + ')');
}

*/

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecords(String objectName, List<String> fieldNames) {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        System.debug('objectName'+ objectName);
        System.debug('fieldNames'+ fieldNames);
        
        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + objectName + ' LIMIT 100';
        List<SObject> sObjectRecords = Database.query(query);
        for (SObject record : sObjectRecords) {
            Map<String, Object> recordMap = new Map<String, Object>();
            for (String fieldName : fieldNames) {
                recordMap.put(fieldName, record.get(fieldName));
            }
            records.add(recordMap);
        }
        System.debug(records);
        return records;
    }
}