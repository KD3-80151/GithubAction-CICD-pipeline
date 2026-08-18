public class EnumPractice {
    
    public enum status {
    InProgress, Completed, Closed
    
}
     public static void enumPractice(){
        List<Status> enumValues = Status.values();
        System.debug('All enum values::' + enumValues);

        // to get name of an enum constants 
        System.debug('');
        System.debug('name of an enum constants ' + Status.Completed.name());

        System.debug('Position of ordinal value ' + Status.InProgress.ordinal());

    }
   
}