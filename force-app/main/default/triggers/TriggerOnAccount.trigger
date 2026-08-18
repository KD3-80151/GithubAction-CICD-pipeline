trigger TriggerOnAccount on Account (before insert,after insert, before delete) {
    //if(Trigger.isAfter && Trigger.isInsert){
        //System.debug('Anoiket');
        //AccountTriggerHelper.linkContactToAccount(Trigger.new);
   // }
   // 
   
     //   if(trigger.isInsert && trigger.isAfter) ContactCreated.createContact(Trigger.new);

      //   if(trigger.isUpdate && trigger.isAfter) AccountOwnerTriggerHandler.updateContactOwner(Trigger.new, Trigger.oldMap);

      //   if ((trigger.isInsert || trigger.isUpdate)  && trigger.isAfter) 
      //         CreateOpportunityOnAgricultureHandler.createOppoByAccount(Trigger.new);
        
        //if (trigger.isUpdate && trigger.isAfter) CreateOpportunityOnAgricultureHandler.OpportunityIndustry(Trigger.new, Trigger.old);

       // if(trigger.isDelete && trigger.isBefore) ErrorAccountDelete.errorMessageDisplay(Trigger.old);

      //   if(trigger.isDelete && trigger.isBefore) ErrorAccountDelete.AccountContactError(Trigger.old);

     // if(trigger.isInsert && trigger.isBefore) ErrorAccountDelete.fieldErrorMessage(Trigger.new);

    if(trigger.isAfter && trigger.isInsert){
        //System.debug('Sagar');
        //AccountChildClass.linkParentWithChild(Trigger.new);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
       // AccountTriggerHandler.handleIndustryChanges(Trigger.new, Trigger.oldMap);
    }
      /*  
    if(trigger.isBefore && trigger.isDelete){
        system.debug('before delete get called');
        AccountTriggerHandler.protectAcntDeleteWhenNoOpp(trigger.old);
    }*/
    
    if(trigger.isBefore && trigger.isDelete){
        //AccountTriggerHandler.preventAcntFromGettingDeletedActiveOpp(trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
       // AccountTriggerHandler.updateChildAcc(trigger.new, trigger.oldMap);
    }
    
   if(trigger.isBefore && trigger.isDelete){
        system.debug('before delete get called');
        //AccountTriggerHandler.protectAcntDeleteWhenNoOpp(trigger.old);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
		//AccountTriggerHandler.closedAllrelatedOpp(trigger.new, trigger.oldMap);
		//AccountTriggerHandler.updateContactOwnerToAccOwner(trigger.new, trigger.oldMap);
		AccountTriggerHandler.updateOwnerContatc(trigger.new, trigger.oldMap);
    }
    
    


}