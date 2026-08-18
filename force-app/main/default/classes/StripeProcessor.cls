public class StripeProcessor extends PaymentProcessor {
    public override void processPayment(Decimal amount){
        System.debug('payment sucessfull' + amount);
        logTransaction('SUCESS');
    }
}