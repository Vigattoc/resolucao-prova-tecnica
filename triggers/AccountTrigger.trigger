trigger AccountTrigger on Account (before insert, before update) {
    
    if (Trigger.isInsert || Trigger.isUpdate){
        
        boolean validation;
        
        List<Opportunity> newOppList = new List<Opportunity>();
        List<Task> newTskList = new List<Task>();
        
        for(Account acc : Trigger.new){
            if (acc.Type == 'CPF'){
                validation = Utils.validaCPF(acc.AccountNumber);
                system.debug('validation '+ acc.Type);
                if (!validation) {
                    acc.AccountNumber.addError('Invalid CPF');
                } else {
                    Task newTsk = new Task();
                    newTsk.Subject = 'Consumidor Final';
                    newTsk.WhatId = acc.Id;
                    newTsk.Status = 'Not Started';
                    newTskList.add(newTsk);
                }
            }else{
                if (acc.Type == 'CNPJ'){
                    validation = Utils.validaCNPJ(acc.AccountNumber);
                    if (!validation) {
                        // add an error message to the account
                        acc.AccountNumber.addError('Invalid CNPJ');
                    } else {
                        Opportunity newOpp = new Opportunity();
                        newOpp.name = acc.Name + ' – opp Parceiro';
                        newOpp.CloseDate = System.today().addDays(30);
                        newOpp.StageName = 'Qualification';
                        newOppList.add(newOpp);
                    }
                }
            }
        }
        if(newTskList.size()>0){
            insert newTskList;
        }
        if(newOppList.size()>0){
            insert newOppList;
        }
    }
}