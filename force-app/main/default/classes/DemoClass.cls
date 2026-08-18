public class DemoClass{
    static{
        System.debug('inside static block');
    }
    {
        system.debug('instance init block');
    }
    public DemoClass(){
		System.debug('Inside constructor');
    }
}

//First class will load then class instance will create then constructor will load