@isTest
private class AccountTriggerTest {
    @isTest
    static void testBeforeInsert() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type = 'CPF';
        acc.AccountNumber = '10';
        insert acc;
        Test.stopTest();
        Account insertedAcc = [SELECT Id, AccountNumber FROM Account WHERE Id = :acc.Id];
        System.assertEquals('10', insertedAcc.AccountNumber);
        
        Task[] tasks = [SELECT Subject, WhatId, Status FROM Task WHERE WhatId = :insertedAcc.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals('Consumidor Final', tasks[0].Subject);
        System.assertEquals(insertedAcc.Id, tasks[0].WhatId);
        System.assertEquals('Not Started', tasks[0].Status);
        
    }
    @isTest
    static void testErrorCPF() {
        
        Test.startTest();
        Account acc2 = new Account();
        acc2.Name = 'Test Account2';
        acc2.Type = 'CPF';
        acc2.AccountNumber = '11';
        insert acc2;
        Test.stopTest();
        
        Account insertedAcc2 = [SELECT Id, AccountNumber FROM Account WHERE Id = :acc2.Id];
        System.assertEquals('11', insertedAcc2.AccountNumber);
    }
    
    @isTest
    static void testBeforeUpdate() {
        
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type = 'CNPJ';
        acc.AccountNumber = '10';
        insert acc;
        Test.stopTest();
        
        acc.AccountNumber = '11';
        try {
            update acc;
        } catch (DmlException e) {
            System.assertEquals('Invalid CNPJ', e.getDmlMessage(0));
        }
        
        Test.startTest();
        acc.AccountNumber = '10';
        update acc;
        Test.stopTest();
        
        Opportunity[] opps = [SELECT Name, CloseDate, StageName FROM Opportunity WHERE Name LIKE 'Test Account'];
        System.assertEquals(1, opps.size());
        System.assertEquals('Test Account– opp Parceiro', opps[0].Name);
        System.assertEquals(System.today().addDays(30), opps[0].CloseDate);
        System.assertEquals('Qualification', opps[0].StageName);
    }
}