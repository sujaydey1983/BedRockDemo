@isTest
public with sharing class PolicyBulkUpdateTest {
    @isTest
    public static void testMethod1() {
        //Create Account
        Account accnt = new Account();
        accnt.Name = 'ABC Corp Ltd.';
        insert accnt;
        //Create Insurance Policy
        Insurance_policy__c ip = new Insurance_policy__c();
        ip.Name = '4000000570';
        ip.Effective_Date__c = Date.valueOf('2022-04-04');
        ip.Expiration_Date__c = Date.valueOf('2023-04-04');
        ip.Issuing_Date__c = Date.valueOf('2022-04-04');
        ip.Premium__c = 1000000;
        ip.Premium_Frequency__c = 'Yearly';
        ip.Status__c = 'Active';
        ip.contact_email__c = 'sujay.dey@salesforce.com';
        ip.Account__c = accnt.Id;
        insert ip;

        Test.startTest();
        PolicyBulkUpdate obj = new PolicyBulkUpdate();
        Database.executeBatch(obj, 100);
        test.stopTest();
    }
}