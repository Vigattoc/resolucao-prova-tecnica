public with sharing class picklistValuesController {
    @AuraEnabled
    public static List<string> getPicklistValuesFromType() {
        try{ 
            Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
            System.debug('DescribeFieldResult: '+Account.Type.getDescribe());
            List<Schema.PicklistEntry> pickListValuesList = fieldResult.getPicklistValues();
            list<string> types = new list<string>();
            for(Schema.PicklistEntry pickVal: pickListValuesList){
                types.add(pickVal.getLabel());
                System.debug('pickListValue: '+pickVal.getLabel());
            }
            System.debug('types: '+types);
            return types;
        }catch(exception e){
            
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            
            list<string> erro = new list<string>();
            
            return erro;
        }
    }
    
    @AuraEnabled
    public static boolean updateData(String recordId, String newName, String newType, String newAccNum) {
        try{ 
            system.debug(recordId+ '-' + newName + '-' + newType + '-' + newAccNum);
            Account acc = [SELECT id, name, type, AccountNumber FROM Account WHERE id =:recordId];
            system.debug(recordId+ '-' + newName + '-' + newType + '-' + newAccNum);
            acc.Name = newName;
            acc.Type = newType;
            acc.AccountNumber = newAccNum;
            
            update acc;
            
            return true;
            
        }catch(exception e){
            
            system.debug('Exception Line Number' + e.getLineNumber());
            system.debug('Exception Message: ' + e.getMessage());
                
            return false;
        }
    }
}