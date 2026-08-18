public class AssignTaskQueueable implements Queueable {
	private List<Id> accIds;
    public AssignTaskQueueable(List<Id> accIds){
        this.accIds = accIds;
    }
    
    public void execute (QueueableContext qc){
        List<Task> taskToInsert = new List<Task>();
        List<Contact> conList = [select id, LastName, AccountId from Contact where AccountId IN :accIds];
        
        for(Contact con : conList){
            taskToInsert.add(new Task(
            	Subject = 'Follow-up with High priority task',
                WhoId = con.Id,
                WhatId = con.AccountId,
                Status = 'Not Started',
                Priority ='High'
            ));
        }
        
        if(!taskToInsert.isEmpty()){
           insert taskToInsert;
        }
    }
}