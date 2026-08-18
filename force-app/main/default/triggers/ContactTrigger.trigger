trigger ContactTrigger on Contact (after insert, before insert,after delete, before delete,after update, before update) {
//   if(trigger.isInsert && trigger.isAfter)    ContactTriggerHandler.handlerContact(Trigger.new);
  
    // if(trigger.isDelete && trigger.isAfter){
    //     ContactTriggerCrudHandler.isContactDeleted(Trigger.old);
    // }
    
    // if(trigger.isUpdate && trigger.isAfter){
    //     ContactTriggerCrudHandler.IsContactUpdated(Trigger.new, Trigger.oldMap);
    // }
    
    // if(trigger.isInsert && trigger.isAfter){
    //     ContactTriggerCrudHandler.IsContactCreated(Trigger.new);
    // }
    
   
//    if(trigger.isInsert && trigger.isAfter)
//        ContactCreatedWithAccountHandler.ContactCreated(Trigger.new);

    // if(trigger.isInsert && trigger.isAfter){
    //     UpdateAccountTotalFields.insertContact(Trigger.new);
    // }

    // if (trigger.isUpdate && trigger.isAfter) {
    //     UpdateAccountTotalFields.updateContact(Trigger.new, Trigger.oldMap);
    // }

    // if (trigger.isDelete && trigger.isAfter) {
    //     UpdateAccountTotalFields.deleteContact(Trigger.old);
    // }
    // 
    
   /* if(trigger.isAfter){
        if(trigger.isInsert){
            ContactTriggerCrudHandler.countInsertedContact(null, trigger.new);
        }
        else if(trigger.isUpdate){
            ContactTriggerCrudHandler.countInsertedContact(trigger.old, trigger.new);
        }
        else if(trigger.isDelete){
             ContactTriggerCrudHandler.countInsertedContact(trigger.old, null);
        }
    }*/
    
    /*
    if(trigger.isBefore){
        if(trigger.isInsert){
            ContactTriggerHandler.notMorethaTwoCOntacts(null,trigger.new);
        }
        if(trigger.isUpdate){
            ContactTriggerHandler.notMorethaTwoCOntacts(trigger.old, trigger.new);
        }
    }
    */
    /*
    if(trigger.isAfter){
        set<Id> parentIds = new set<Id>();
        if(trigger.isInsert || trigger.isUndelete){
            for(Contact c : trigger.new){
                if(c.AccountId != null){
                    parentIds.add(c.AccountId);
                }
            }
			
        }*/
        
        /*if(trigger.isUpadte){
            for(Contact c : trigger.new){
                if(c.AccountId != null){
                    parentIds.add(c.AccountId);
                }
            }
            
            for(Contact abc : trigger.old){
                if(abc.AccountId != null){
                    parentIds.add(abc.AccountId);
                }
            }
        }*/
        /*
        if(trigger.isDelete){
            for(Contact oldCont : trigger.old){
                if(oldCOnt.AccountId != null){
                    parentIds.add(oldCont.AccountId);
                }
            }
        }*/
        
      //  if(!parentIds.isEmpty()){
        //    ContactTriggerHandler.countNumberANdStoreOnAccount(parentsIds);
      //  }
	//}
	//
    if(trigger.isAfter && trigger.isInsert){
        ContactTriggerHandler.createTaskWelcome(trigger.new);
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            ContactTriggerHandler.updateAccountContactCount(trigger.new, null);
        }
        if(trigger.isUpdate){
            ContactTriggerHandler.updateAccountContactCount(trigger.new, trigger.old);            
        }
        if(trigger.isDelete){
            ContactTriggerHandler.updateAccountContactCount(null, trigger.old);            
        }
        if(trigger.isUndelete){
            ContactTriggerHandler.updateAccountContactCount(trigger.new, null);            
        }
    }
    

}