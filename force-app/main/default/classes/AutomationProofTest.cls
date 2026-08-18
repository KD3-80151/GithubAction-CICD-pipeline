@isTest
private class AutomationProofTest {
    @isTest
    static void testMessage() {
        System.assertEquals('Deployed entirely by GitHub Actions', AutomationProof.message());
    }
}