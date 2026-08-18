public abstract class PaymentProcessor {
	public abstract void processPayment(Decimal amount);
    
    public void logTransaction(String status){
        System.debug('transaction sucessfull' + status);
    }
}