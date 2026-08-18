/**
 * ----------------------------------------------------------------------------------------------------
 * @description         : to get and set Account Name
 * @author              : Sagar Kumar
 * @last modified on    : 20/06/2024
 * @last modified date  :  
 * -----------------------------------------------------------------------------------------------------
 **/

public with sharing class SingletonExample {
    // static variable to hold the single instance of class
    private static SingletonExample instance;
    public SingletonExample() {
        //initialization code

    }

    //public static method to provide the single instance of the class
    public static SingletonExample getInstance(){
        if (instance == null) {
            instance = new SingletonExample();
        }
        return instance;
    }

    public void calledMethodByInstance(){
        System.debug('Singleton class method called');
    }
    
}