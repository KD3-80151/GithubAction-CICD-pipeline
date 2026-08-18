public with sharing class AccountAndPermissionService {
    public static Id createAccountAndAssignPs(String accountName, Id userId, String permissionDeveloperName){
        Account a = new Account(Name = accountName);
        insert a;
        
        System.enqueueJob(new AssignPermissionSetJob(userId, permissionDeveloperName));
        return a.Id;
        
    }
    
    public class AssignPermissionSetJob implements Queueable, Database.AllowsCallouts{
        private Id userId;
        private String psDeveloperName;
        public AssignPermissionSetJob(Id userId, String psDeveloperName){
            this.userId = userId;
            this.psDeveloperName = psDeveloperName;
            
        }
        
        public void execute(QueueableContext qc){
            PermissionSet ps = [select Id from PermissionSet where Name = :psDeveloperName limit 1];
            insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);
        }
    }
}