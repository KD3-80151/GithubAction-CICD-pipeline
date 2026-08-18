@isTest
private class PipelineTestClassTest {
    @isTest
    static void testSayHello() {
        System.assertEquals('Hello from the pipeline', PipelineTestClass.sayHello());
    }
}