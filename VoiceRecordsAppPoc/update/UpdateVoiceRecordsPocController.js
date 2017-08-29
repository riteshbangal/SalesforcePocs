({
    scriptsLoaded : function(component, event, helper) {
        console.log('Update component loaded successfully');
    },
    
    refreshVoiceLineItems: function(component, event, helper) {
     	// Reset success/error message realated attributes
        component.set("v.isDataSaved", null);
        component.set("v.savedMessage", "");
        
        // Fetch and initialize records 
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
    },
    
    doInit: function(component, event, helper) {
        // Fetch and initialize records 
        helper.loadVoiceLineItems(component)
        helper.populatepVoiceRoundingData(component);
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
        var dataBeans = component.get("v.dataBeans");
        var billingGroupNames = component.get("v.billingGroupNames");
        
        var savedRecordsCount = 0;
        var dataArrayIndex = 0;
        for (var zoneIndex in dataBeans) {
            console.log('Row[' + zoneIndex + ']: BillingZone:  ' + dataBeans[zoneIndex].billingZoneName);
            console.log('BillingZoneId:  ' + dataBeans[zoneIndex].billingZoneId);
            var voiceLineItemId = dataBeans[zoneIndex].voiceLineItemId;
            console.log('VoiceLineItemId: ' + voiceLineItemId);
            
            var groupMinPriceArray = [];
            dataArrayIndex ++;
            for (var groupIndex in billingGroupNames) {
                var groupMinPrice = dataArray[dataArrayIndex];
                console.log('Group-Price: ' + billingGroupNames[groupIndex] + ' : ' + groupMinPrice);
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
            var action = component.get("c.updateVoiceLineItems");
            // Set parameters
            action.setParams ({   
                pZoneIndex : zoneIndex,
                pVoiceLineItemId : voiceLineItemId,
                pBillingZoneId : dataBeans[zoneIndex].billingZoneId,
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
                    //component.set("v.savedMessage", selectedBillingZones.length + ' record(s) has been saved.');
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