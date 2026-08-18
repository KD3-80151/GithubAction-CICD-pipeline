public class MyQueueableJob implements Queueable{
    public void execute(QueueableContext q){
        System.attachFinalizer(new AsyncJobFinalizer());
    }
}