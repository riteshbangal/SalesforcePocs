({
    loadVoiceLineItems : function(component) {
    	var voiceId = component.get("v.childAttribute");
        var action = component.get('c.getItemsByVoiceId');
        // Set parameters
        action.setParams ({   
            pVoiceId : voiceId
        });
        action.setCallback(this, function(response) {
            var responseData = response.getReturnValue();
            var dataBeans = responseData.dataBeans;
            var billingGroupNames = responseData.billingGroupNames;
            
            component.set('v.dataBeans', dataBeans);
            component.set('v.billingGroupNames', billingGroupNames);
            
            if (null == dataBeans || dataBeans.length == 0) {
                component.set("v.isInvalidSelection", true);
            } else {
                component.set("v.isInvalidSelection", false);
            }
        });
        $A.enqueueAction(action);
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
    }
})