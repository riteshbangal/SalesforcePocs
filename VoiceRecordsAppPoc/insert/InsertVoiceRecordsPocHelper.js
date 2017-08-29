({
    fetchBillingZoneDetails : function(component){
        var action = component.get("c.getBillingZoneDetails");
        action.setCallback(this, function(response){
            var billingZones = response.getReturnValue();
            component.set("v.billingZoneRecs", billingZones);
        })
        $A.enqueueAction(action);
    },
    
    fetchBillingGroupDetails: function(component){
        var action = component.get("c.getBillingGroupDetails");
        action.setCallback(this, function(response){
            var billingGroups = response.getReturnValue();
            component.set("v.billingGroupRecs", billingGroups);
        })
        $A.enqueueAction(action);
    },
    
    fetchBillingZonesByIds : function(component) {
        var selectedBillingZoneIds = component.get("v.selectedBillingZoneIds");
        var action = component.get("c.getBillingZonesByIds");
        // Set parameters
        action.setParams ({          
            pSelectedBillingZoneIds: selectedBillingZoneIds
        });
        
        action.setCallback(this, function(response){
            var billingZones = response.getReturnValue();
            component.set("v.selectedBillingZones", billingZones);
        })
        $A.enqueueAction(action);
    },
    
    fetchBillingGroupsByIds: function(component) {
        var selectedBillingGroupIds = component.get("v.selectedBillingGroupIds");
        var action = component.get("c.getBillingGroupsByIds");
        // Set parameters
        action.setParams ({          
            pSelectedBillingGroupIds: selectedBillingGroupIds
        });
        
        action.setCallback(this, function(response){
            var billingGroups = response.getReturnValue();
            component.set("v.selectedBillingGroups", billingGroups);
        })
        $A.enqueueAction(action);
    },
    
    populateBillingData : function(component, event, helper) {
        var billingGroups = component.get("v.billingGroupRecs");
        console.log('populateBillingData() | billingGroups:  ' + billingGroups);
        
        console.log('populateBillingData starts');
        var selectedBillingZoneIds = $('[id$=billingZones]').select2("val");
        var selectedBillingGroupIds = $('[id$=billingGroups]').select2("val");
        
        component.set("v.selectedBillingZoneIds", selectedBillingZoneIds);
        component.set("v.selectedBillingGroupIds", selectedBillingGroupIds);
    },
    
    populatepVoiceRoundingData : function(component, event, helper) {
        var action = component.get("c.getVoiceRounding");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.options", opts);
        });
        $A.enqueueAction(action); 
    },
    
    existingVoiceRecordValidation: function(component) {
        var voiceId = component.get("v.childAttribute");
        console.log('VoiceId: ' + voiceId);
        var action = component.get("c.isVoiceRecordExists");
        // Set parameters
        action.setParams ({   
            pVoiceId : voiceId,
        });
        // Apex call for existing VoiceRecord validation
        action.setCallback(this, function(response){
            var isVoiceRecordExists = response.getReturnValue();
            component.set("v.isInvalidSelection", isVoiceRecordExists);
            if (isVoiceRecordExists) {
                component.set("v.invalidSelectionMessage", "Record(s) already exists for this voice (Id: " 
                              + voiceId + "). For further insertion, please remove all the existing record(s).");
                console.log('VoiceRecord exists');
            } else {
                console.log('VoiceRecord doesn\'t exists');
            }
        })
        $A.enqueueAction(action);
    },
    
    validateSelectedInputs: function(component) {
        var selectedBillingZoneIds = component.get("v.selectedBillingZoneIds");
        var selectedBillingGroupIds = component.get("v.selectedBillingGroupIds");
        
        // If there is no entry for billing zone or billing group, table should not be displayed
        var isInvalidSelection = false;
        if (null == selectedBillingZoneIds || selectedBillingZoneIds.length == 0
            || null == selectedBillingGroupIds || selectedBillingGroupIds.length == 0) {
            isInvalidSelection = true;
            component.set("v.invalidSelectionMessage", "Please select billing zone and billing groups.");
        } else if (selectedBillingZoneIds.length > component.get("v.billingZonesLimit")) {
            isInvalidSelection = true;
            component.set("v.invalidSelectionMessage", "Maximum selection limit for Billing Zones: " + component.get("v.billingZonesLimit"));
        } else if (selectedBillingGroupIds.length > component.get("v.billingGroupsLimit")) {
            isInvalidSelection = true;
            component.set("v.invalidSelectionMessage", "Maximum selection limit for Billing Groups: " + component.get("v.billingGroupsLimit"));
        }
        component.set("v.isInvalidSelection", isInvalidSelection);
    }
})