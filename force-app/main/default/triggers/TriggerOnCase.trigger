trigger TriggerOnCase on Case (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            System.debug('trigger get called');
			CaseTriggerHandler.handleAfter(Trigger.new, Trigger.oldMap);
            
        }
    }
}