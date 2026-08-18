public class PayPalPayment extends PaymentProcessor{
    public override void processPayment(decimal amount){
        System.debug('payment via paypal' + amount);
        logTransaction('PayPal');
    }
}