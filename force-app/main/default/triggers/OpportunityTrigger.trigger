trigger OpportunityTrigger on Opportunity (after insert, before insert, after update, before update, after delete, before delete, after undelete) {
//     if(Trigger.isBefore && Trigger.isDelete){
//        OpportunityTriggerHandler.OpportunityClosed(Trigger.old);
//    }
    
//     if(Trigger.isAfter && Trigger.isInsert){
//         OpportunityCrudHandler.isInserted(Trigger.new);
//     }
    	
//     if(Trigger.isAfter && Trigger.isUpdate){
//         OpportunityCrudHandler.isUpdated(Trigger.new, Trigger.oldMap);
//     }
//     if(Trigger.isAfter && Trigger.isDelete){
//         OpportunityCrudHandler.isDeleted(Trigger.old);
//     }

    // if(Trigger.isAfter && Trigger.isUpdate){
    //     OpportunityTotalAmountOnAccount.OpportunityTotalAmountOnAccount(Trigger.new, Trigger.oldMap);
    // }

    // if(Trigger.isBefore && Trigger.isUpdate){
    //     OpportunityValidationTrigger.opportunityValidation(Trigger.new, Trigger.oldMap);
    // }


    // if(Trigger.isInsert && Trigger.isAfter){
    //     OpportunityCountHandler.onInsertionOpportunityUpdateCountInAccount(Trigger.new);
    // }


    //     if(Trigger.isUpdate && Trigger.isAfter){
    //     OpportunityCountHandler.onUpdationOpportunityUpdateCountInAccount(Trigger.newMap,Trigger.old);
    // }

    //     if(Trigger.isDelete && Trigger.isAfter){
    //     OpportunityCountHandler.onDeletionOpportunityUpdateCountInAccount(Trigger.old);
    // }

    // if (Trigger.isUpdate && Trigger.isAfter) {
    //     OpportunityTotalAmountOnAccount.calculateTotalOppSumRelWithAccnt(Trigger.new, Trigger.oldMap);
    // }
    
    // this is also a way to handle trigger in bulk 
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
            //OpportunityTriggerHandler.updateAccountRollup(trigger.newMap.keySet());
            //OpportunityTriggerHandler.updateSelfLookupProductName(trigger.new , trigger.oldMap);
           // OpportunityTriggerHandler.sendEmailToOpp(trigger.new, trigger.oldMap);
           //OpportunityTriggerHandler.accntNotMoreTwentyOpp(trigger.nzew, trigger.oldMap);
            OpportunityTriggerHandler.updateMaxOppAmountOnAcnt(trigger.new, trigger.oldMap);
            
        }
        //if(trigger.isDelete){
        //    OpportunityTriggerHandler.updateAccountRollup(trigger.newMap.keySet());
        //}
    }
    
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            //OpportunityTriggerHandler.ceckDupName(trigger.new, trigger.oldMap.keySet());
            //OpportunityTriggerHandler.preventOppToCloseLostWhenCOntractIsActive(trigger.new);
        }
    }
    
    if(trigger.isAfter){
        
        //OpportunityTriggerHandler.updateAccountFromOpp(trigger.new);
    }
    
    
    
 }