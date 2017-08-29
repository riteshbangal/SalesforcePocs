({
    loadVoiceLineItems: function(component, event, helper) {
        // call the helper function for fetch contact from apex class 
        helper.loadVoiceLineItems(component, event);
        
        // Check for empty records
        var voiceLineItems = component.get('v.ListOfVoiceLineItemBean');
        /*if (voiceLineItems.length < 1) {
            component.set("v.displayErrorMessage", 'No record found.');
            component.set("v.isEmptyRecord", true);
        } else {
            component.set("v.isEmptyRecord", false);
        }*/
        console.log('voiceLineItems: ' + voiceLineItems);
    },
    
    refreshVoiceLineItems: function(component, event, helper) {
        // Reset success/error message realated attributes
        component.set("v.isDataDeleted", null);
        component.set("v.deleteMessage", "");
        
        // call the helper function for fetch contact from apex class 
        helper.loadVoiceLineItems(component, event);
    },
    
    // For count the selected checkboxes. 
    checkboxSelect: function(component, event, helper) {
        // call the helper function for checkboxSelect
        helper.checkboxSelect(component, event);
    },
    
    // For select all Checkboxes 
    selectAll: function(component, event, helper) {
        // call the helper function for checkboxSelect
        helper.selectAll(component, event);
    },
    
    //For Delete selected records 
    deleteSelectedItems: function(component, event, helper) {
        console.log('Controller.deleteSelectedItems() Starts');
        var selectedItemsCount = component.get("v.selectedItemsCount");
        if (selectedItemsCount > 0) {
            // create var for store record id's for selected checkboxes  
            var selectedIdsForDelete = [];
            // get all checkboxes 
            var getAllId = component.find("boxPack");
            
            /*
             * Play a for loop and check every checkbox values if value is checked(true) 
             * then add those Id (store in Text attribute on checkbox) in delId var.
             */
            for (var i = 0; i < getAllId.length; i++) {
                //console.log('getAllId['+ i + '].value: ' + getAllId[i].get("v.value"));
                //console.log('getAllId['+ i + '].text: ' + getAllId[i].get("v.text"));
                if (getAllId[i].get("v.value")) {
                    selectedIdsForDelete.push(getAllId[i].get("v.text"));
                }
            }
            console.log('Selected Record Ids for Delete: ' + selectedIdsForDelete);
            // call the helper function and pass all selected record id's.    
            helper.deleteSelectedItems(component, event, selectedIdsForDelete);
        }
        console.log('Controller.deleteSelectedItems() Ends');
    }     
})