public class CaseTriggerHandler {
    public static void handleAfter(List<Case> newCase, Map<Id, Case> oldMap){
		List<Task> insertTask = new List<Task>();
		Set<Id> accntIds = new Set<Id>();
        
        for(Case cs : newCase){
            Case oldCs = oldMap != null ? oldMap.get(cs.Id) : null; // updated record came here oldCs Id
            Boolean isHighPrio = (cs.Priority == 'High' && cs.Status == 'New');
            Boolean wasNewHigh = oldCs != null && oldCs.Priority == 'High' && oldCs.Status == 'New'; 
            
            if(isHighPrio && !wasNewHigh){
                insertTask.add(new Task(
                	WhatId = cs.Id,
                    OwnerId =cs.OwnerId ,
                    Subject = 'follow up on high priority task',
                    Status = 'Not Started',
                    Priority = 'High'
                ));
            }
            if(cs.AccountId != null){
				accntIds.add(cs.AccountId);
            }
            if(!insertTask.isEmpty()){
                insert insertTask;
            }
            
            //if(!accountIds.isEmpty()){
             //   updateAccountsHealth(accntIds);	
            //}
        }        
    }
    
    public static void updateAccountsHealth(Map<Id, Case> oldMaPcase, Map<Id, case> newMapCase){
    
        Set<Id> newSetStoreCaseIds = new Set<Id>();
        Map<Id, String> updateKey = new Map<Id, String>();
        //for(Case c : newSetStoreCaseIds){
	
        //}
    }
}