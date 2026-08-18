public class PicklistController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getPicklistTypeFields(String strObjectName) {
        Map<String, Schema.SObjectType> detail = Schema.getGlobalDescribe();
        Map<String, String> mapofPicklistFields = new Map<String, String>();
        for (Schema.SObjectField field : detail.get(strObjectName).getDescribe().fields.getMap().values()) {
            if (field.getDescribe().getType() == Schema.DisplayType.PICKLIST) {
                mapofPicklistFields.put(field.getDescribe().getName(), field.getDescribe().getName());
            }
        }
        return mapofPicklistFields;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getPickListvaluesByFieldName(String selectedObjectName, String selectedField) {
        try {
            Map<String, String> options = new Map<String, String>();
            Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(selectedObjectName).getDescribe().fields.getMap();
            Schema.DescribeFieldResult pickFieldResult = mapFields.get(selectedField).getDescribe();   
            List<Schema.PicklistEntry> picklistEntries = pickFieldResult.getPicklistValues();
            for (Schema.PicklistEntry entry : picklistEntries) {
                options.put(entry.getLabel(), entry.getValue());
            }
            return options;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving picklist values: ' + e.getMessage());
        }
    }
}