({
    loadVoiceLineItems: function(component, event) {
        console.log('Helper.loadVoiceLineItems() starts');
        var voiceId = component.get("v.childAttribute");
        
        // Call apex class method
        var action = component.get('c.fetchVoiceLineItems');
        // Set parameters
        action.setParams ({   
            pVoiceId : voiceId
        })
        // Call action
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
               	var returnedResponse = response.getReturnValue();
               	component.set('v.ListOfVoiceLineItemBean', returnedResponse.voiceLineItemBeans);
                console.log('ListOfVoiceLineItemBean: ' + returnedResponse.voiceLineItemBeans);
               	component.set('v.billingGroupNames', returnedResponse.billingGroupNames);
                console.log('billingGroupNames: ' + returnedResponse.billingGroupNames);
                // set deafult count and select all checkbox value to false on load 
                component.set("v.selectedItemsCount", 0);
                component.find("selectAllCheckBox").set("v.value", false);
            }
        });
        $A.enqueueAction(action);
		console.log('Helper.loadVoiceLineItems() ends');
    },
    
    // For count the selected checkboxes. 
    checkboxSelect: function(component, event, helper) {
        
        // Get the selected checkbox value  
        var selectedValue = event.getSource().get("v.value");

        // Get the selectedItemsCount attrbute value(default is 0) for add/less numbers. 
        var selectedItemsCount = component.get("v.selectedItemsCount");

        /*
         * Check, if selected checkbox value is true 
         * then increment getSelectedNumber with 1 else Decrement the getSelectedNumber with 1     
         */
        if (selectedValue == true) {
            selectedItemsCount++;
        } else {
            selectedItemsCount--;
            component.find("selectAllCheckBox").set("v.value", false);
        }
        // set the actual value on selectedItemsCount attribute to show on header part. 
        component.set("v.selectedItemsCount", selectedItemsCount);
    },
    
    // For select all Checkboxes 
    selectAll: function(component, event, helper) {
        
        // Get the header checkbox value  
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        /*
         * Get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
         * return the List of all checkboxs element 
         */
        var getAllId = component.find("boxPack");
        
        /*
         * Check if select all (header checkbox) is true then true all checkboxes on table in a for loop
         * and set the all selected checkbox length in selectedItemsCount attribute.
         * If value is false then make all checkboxes false in else part with play for loop and select count as 0
         */
        if (selectedHeaderCheck == true) {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", true);
                component.set("v.selectedItemsCount", getAllId.length);
            }
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", false);
                component.set("v.selectedItemsCount", 0);
            }
        }
    },
    
    deleteSelectedItems: function(component, event, deleteRecordsIds) {
        
        // Call apex class method
        var action = component.get('c.deleteVoiceLineItem');
        // Set parameters
        action.setParams({
            "pRecordIds": deleteRecordsIds
        });
        // Call action
        action.setCallback(this, function(response) {
            var returnedResponse = response.getReturnValue();
            if(returnedResponse.isSuccess) {
                component.set("v.isDataDeleted", true);
                component.set("v.deleteMessage", returnedResponse.successMsg);
                console.log('Deleted voice line items.');
                
                // call the onLoad function for refresh the List view    
                this.loadVoiceLineItems(component, event);
            } else {
                component.set("v.isDataDeleted", false);
                component.set("v.deleteMessage", returnedResponse.errorMsg);
                console.log('Not able to delete voice line items.');
            }
        });
        $A.enqueueAction(action);
    }
})