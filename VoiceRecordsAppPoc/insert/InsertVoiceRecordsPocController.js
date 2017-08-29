({
    scriptsLoaded : function(component, event, helper) {
        console.log('Insert component loaded successfully');
        // active/call select2 plugin function after load jQuery and select2 plugin successfully    
        $(".select2Class").select2({
            placeholder: "Select Multiple values"
        });
    },
    
    doInit: function(component, event, helper) {
        helper.fetchBillingGroupDetails(component);
        helper.fetchBillingZoneDetails(component);
        //helper.existingVoiceRecordValidation(component);
    },
    
    populateBillingData : function(component, event, helper) {        
        console.log('populateBillingData starts');
        helper.populateBillingData(component);
        helper.populatepVoiceRoundingData(component);
        
        helper.fetchBillingZonesByIds(component);
        helper.fetchBillingGroupsByIds(component);
        
        helper.validateSelectedInputs(component);
        helper.existingVoiceRecordValidation(component);
        console.log('populateBillingData ends');
    },
    
    saveVoiceLineItems : function(component, event, helper) {
        
        console.log('saveVoiceLineItems starts');
        event.preventDefault();
        var dataArray = $("#billingTable tr.data").map(function (index, element) {
            var returnValues = [];
            $('.billingTableData', this).each(function () {
                var data = $(this).val() || $(this).text();
                //console.log(data);
                returnValues.push(data);
            });
            return returnValues;
        });
        //console.log('dataArray: ' + dataArray);
       
        /*
         * Do a apex call, to save records into db.
         * Return true or false, based on that display error/success message.
         */
        var voiceId = component.get("v.childAttribute");
        console.log('VoiceId: ' + voiceId);
        //var dataBeans = component.get("v.dataBeans");
        //var billingGroupNames = component.get("v.billingGroupNames");
        
        var selectedBillingZones = component.get("v.selectedBillingZones");
        var selectedBillingGroups = component.get("v.selectedBillingGroups");
        
        var savedRecordsCount = 0;
        var dataArrayIndex = 0;
        for (var zoneIndex in selectedBillingZones) {
            console.log('Row[' + zoneIndex + ']: BillingZone: ' + selectedBillingZones[zoneIndex].Name);
            console.log('BillingZoneId:  ' + selectedBillingZones[zoneIndex].Id);
            
            var billingGroupNames = [];
            var groupMinPriceArray = [];
            dataArrayIndex ++;
            for (var groupIndex in selectedBillingGroups) {
                var billingGroupName = selectedBillingGroups[groupIndex].Name;
                billingGroupNames.push(billingGroupName);
               
                var groupMinPrice = dataArray[dataArrayIndex];
                console.log('Group-Price: ' + billingGroupName + ' : ' + groupMinPrice);
                if (groupMinPrice == null || groupMinPrice == "") {
                    groupMinPrice = '0.00';
                }
                groupMinPriceArray.push(groupMinPrice);
                dataArrayIndex++;
            }  	
            
            var voiceMTMin = dataArray[dataArrayIndex];
            console.log('VoiceMTMin: ' + voiceMTMin);
            dataArrayIndex++;
            var voiceMTIncludedServ = dataArray[dataArrayIndex];
            console.log('voiceMTIncludedServ: ' + voiceMTIncludedServ);
            dataArrayIndex++;
            var voiceRounding = dataArray[dataArrayIndex];
            console.log('voiceRounding: ' + voiceRounding);
            dataArrayIndex++;
            
            console.log('saveVoiceLineItems() | ---------------------');
            var action = component.get("c.insertVoiceLineItems");
            // Set parameters
            action.setParams ({   
                pZoneIndex : zoneIndex,
                pVoiceId : voiceId,
                pBillingZoneId : selectedBillingZones[zoneIndex].Id,
                pVoiceMTMin : voiceMTMin,
                pVoiceMTMinInclServ : voiceMTIncludedServ,
                pBillingGroupNames : billingGroupNames,
                pGroupMinPriceArray: groupMinPriceArray,
                pVoiceRounding : voiceRounding
            });
            
            // Save data
            action.setCallback(this, function(response) {
                var returnedResponse = response.getReturnValue();
                if(returnedResponse.isSuccess) {
                    component.set("v.isDataSaved", true);
                    component.set("v.savedMessage", returnedResponse.successMsg);
                    console.log('Saved BillingData.');
                    savedRecordsCount++;
                } else {
                    component.set("v.isDataSaved", false);
                    component.set("v.savedMessage", returnedResponse.errorMsg);
                    console.log('Not able to save BillingData.');
                }
            });
            $A.enqueueAction(action);
        }
        console.log('saveVoiceLineItems ends');
    }
})