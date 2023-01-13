({
    updateData : function (component,idAcc,name,type,accNumber,helper){
        var self = this;
        
        var action = component.get("c.updateData");
        
        action.setParams({
            recordId :idAcc ,
            newName : name,
            newType: type,
            newAccNum : accNumber
            
        });
        
        action.setCallback(self, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {               
                
                if(response.getReturnValue()){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Atualizado com sucesso",   
                        "type":"success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    
                }else{
                    console.log("erro");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Erro!",
                        "message": "Número de Cliente Inválido",   
                        "type":"error"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }
                
            }else {
                console.log("erro");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Erro!",
                    "message": "Número de Cliente Inválido",   
                    "type":"error"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });                
        $A.enqueueAction(action);
    }
})