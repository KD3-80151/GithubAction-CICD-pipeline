public Interface ITrigger {
    

    /** 
    * This method is called prior to execution of a BEFORE trigger. Use this to cache 
    * any data required into maps prior execution of the trigger. 
    */ 
    void bulkBefore(); 


    /** 
    * This method is called prior to execution of an AFTER trigger. Use this to cache 
    * any data required into maps prior execution of the trigger. 
    */ 
    void bulkAfter(); 


    /** 
    * This method is called on the list of object specific records to be inserted during a BEFORE 
    * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods. 
    */ 
    void beforeInsert(List<SObject> newRecords);

    
    /** 
    * This method is called on the list of object specific records to be updated during a BEFORE trigger. 
    */ 
    void beforeUpdate(Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap);
  

    /** 
    * This method is called on the list of object specific records to be deleted during a BEFORE trigger. 
    */ 
    void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap);


    /** 
    * This method is called on the list of object specific records inserted during an AFTER 
    * trigger. Always put field validation in the 'After' methods in case another trigger 
    * has modified any values. The record is 'read only' by this point. 
    */ 
    void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap);


    /** 
    * This method is called on the list of object specific records updated during an AFTER trigger. 
    */ 
    void afterUpdate(Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap);


     /** 
    * This method is called on the list of object specific records deleted during an AFTER trigger. 
    */ 
    void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap);
 
    
    /** 
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records. 
    */ 
    void andFinally(List<SObject> newRecords, Map<ID, SObject> newRecordMap);
}