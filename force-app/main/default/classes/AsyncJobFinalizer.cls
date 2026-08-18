public class AsyncJobFinalizer implements System.Finalizer { 
    //runs after an asynchronous Apex job (like Queueable, Batchable, or Future) finishes, regardless of whether it succeeds or fails.
    //like finally block for async jobs 
    //useful for:
    //Logging job completion, Sending notifications when async jobs fail, Starting follow-up jobs (chaining with more control than normal), Cleaning up temporary data
    public void execute(System.FinalizerContext context){
		//context parameter gives you: context.getAsyncApexJobId() → Id of the job that just finished., 
		//context.getResult() → "SUCCESS", "FAILURE", or "UNHANDLED_EXCEPTION"., context.getException() → The exception if it failed.
		Id asyncJobId = context.getAsyncApexJobId();
        
        AsyncApexJob job = [SELECT Id, JobType, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ExtendedStatus FROM AsyncApexJob where Id =:asyncJobId];
        if(job.Status == 'Completed'){System.debug('Asynchronous job completed successfully');}
        else if(job.Status == 'Failed'){System.debug('Asynchronous job completed successfully' + job.ExtendedStatus);}
           
    }
    
    
}