global class AccountCleaner implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Account> inactiveAccounts = new List<Account>();
        List<Account> accounts = [SELECT Id, Inactive__c FROM Account WHERE Inactive__c = false];
        
        for(Account acc : accounts){
            if(shouldMarkInactive(acc)){
                acc.Inactive__c= true;
                inactiveAccounts.add(acc);
            }
        }
        update inactiveAccounts;
    }
    
    global boolean shouldMarkInactive(Account acc){
        Date last90Days = Date.today()-90;
        system.debug('last90Days:'+last90Days);
        system.debug('last90Days Value of:'+Date.valueOf(last90Days));        
        Date last120Days = Date.today()-120;
        system.debug('last120Days:'+last120Days);
        system.debug('last90Days Value of:'+Date.valueOf(last120Days));   
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :acc.Id AND ActivityDate >= :(last90Days)];
        List<Opportunity> wonOpps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id AND IsWon = true AND CloseDate >= :last120Days];
        List<Opportunity> openOpps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id AND IsClosed = false];
        if(tasks.isEmpty() && wonOpps.isEmpty() && openOpps.isEmpty()){
        return true;
        }
        return false;
    }
    global void scheduleMe(){
        String cron = '0 0 0/6 ? * 2-6';
        AccountCleaner accountCleaner = new AccountCleaner();
        System.schedule('Account Cleaner', cron, accountCleaner);
    }
}