({
	doInit : function(component, event, helper) {
        var action = component.get("c.getPicklistValuesFromType");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var picklistValues = response.getReturnValue();
                var items = [];
                for (var i in picklistValues) {
                    var item = {
                        "value": picklistValues[i].toString(),
                        "label" : picklistValues[i].toString()
                    };
                    
                    
                    items.push(item);
                }
        		component.set("v.options", items);
            }
        });
        $A.enqueueAction(action);
    
	},    
    
    handleChange: function (component, event, helper) {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.type", selectedValue);
    },
    
    cancel : function (component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    save : function (component, event, helper){
        var idAcc = component.get("v.recordId").toString();
        var name =component.get("v.name");
        var type = component.get("v.type");
        var AccNumber = component.get("v.accNum").toString();
       	helper.updateData(component,idAcc,name,type,AccNumber,helper); 
    }
})