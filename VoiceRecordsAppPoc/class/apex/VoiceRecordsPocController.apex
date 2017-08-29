public class VoiceRecordsPocController {
	
    // Display voice line items
    public static Integer successCount = 0;
    
    @AuraEnabled
    public static ResponseData getItemsByVoiceId(String pVoiceId) {
        
        system.debug('Apex Controller: getItemsByVoiceId() starts');
        ResponseData responseData = new ResponseData();
        
        List<String> billingGroupNames = new List<String>();
        List <Voice_Line_Item__c> billingGroupItems = [SELECT Billing_Group_1__c, Billing_Group_2__c, 
                       Billing_Group_3__c, Billing_Group_4__c, Billing_Group_5__c 
                       From Voice_Line_Item__c where voice__c =:pVoiceId limit 1];
		Voice_Line_Item__c billingGroupItem = billingGroupItems[0];
        // Hard coding with static approach, due to bad database architecture
        if (null != billingGroupItem.Billing_Group_1__c) {billingGroupNames.add(billingGroupItem.Billing_Group_1__c);}
        if (null != billingGroupItem.Billing_Group_2__c) {billingGroupNames.add(billingGroupItem.Billing_Group_2__c);}
        if (null != billingGroupItem.Billing_Group_3__c) {billingGroupNames.add(billingGroupItem.Billing_Group_3__c);}
        if (null != billingGroupItem.Billing_Group_4__c) {billingGroupNames.add(billingGroupItem.Billing_Group_4__c);}
        if (null != billingGroupItem.Billing_Group_5__c) {billingGroupNames.add(billingGroupItem.Billing_Group_5__c);}
        responseData.billingGroupNames = billingGroupNames;
        
        List<DataBean> dataBeans = new List<DataBean>();
        List <Voice_Line_Item__c> voiceLineItems = [SELECT Id, Billing_Zone__c, Billing_Zone__r.name, Voice_MT_Min__c,
                       Voice_MT_Min_Included_Services__c,
                       Billing_Group_1__c, Value_1__c, Billing_Group_2__c, Value_2__c, Billing_Group_3__c, Value_3__c,
                       Billing_Group_4__c, Value_4__c, Billing_Group_5__c, Value_5__c 
                       From Voice_Line_Item__c where voice__c =:pVoiceId];
        system.debug('Apex Controller: getItemsByVoiceId() | voiceLineItems size: ' + voiceLineItems.size());

        for (Voice_Line_Item__c voiceLineItem: voiceLineItems) {
        	DataBean dataBean = new DataBean();
            dataBean.voiceLineItemId = voiceLineItem.Id;
            dataBean.billingZoneId = voiceLineItem.Billing_Zone__c;
            dataBean.billingZoneName = voiceLineItem.Billing_Zone__r.name;
            dataBean.voiceMTMin = String.valueOf(voiceLineItem.Voice_MT_Min__c);
            dataBean.voiceMTMinInclServ = String.valueOf(voiceLineItem.Voice_MT_Min_Included_Services__c);
            
            List<String> billingGroupVals = new List<String>();
            // Hard coding with static approach, due to bad database architecture
            if (null != voiceLineItem.Billing_Group_1__c) {billingGroupVals.add(String.valueOf(voiceLineItem.Value_1__c));}
            if (null != voiceLineItem.Billing_Group_2__c) {billingGroupVals.add(String.valueOf(voiceLineItem.Value_2__c));}
            if (null != voiceLineItem.Billing_Group_3__c) {billingGroupVals.add(String.valueOf(voiceLineItem.Value_3__c));}
            if (null != voiceLineItem.Billing_Group_4__c) {billingGroupVals.add(String.valueOf(voiceLineItem.Value_4__c));}
            if (null != voiceLineItem.Billing_Group_5__c) {billingGroupVals.add(String.valueOf(voiceLineItem.Value_5__c));}            
            dataBean.billingGroupValues = billingGroupVals;
            
            dataBeans.add(dataBean);
        }
        
        responseData.dataBeans = dataBeans;
        system.debug('Apex Controller: getItemsByVoiceId() ends');
        return responseData;
    }
    
    public class DataBean {
        @AuraEnabled public String voiceLineItemId;
        @AuraEnabled public String billingZoneName; 
        @AuraEnabled public String billingZoneId;
        @AuraEnabled public String voiceMTMin; 
        @AuraEnabled public String voiceMTMinInclServ; 
        @AuraEnabled public List<String> billingGroupValues; 
       	public DataBean() {
          	// Default constructor  
        }
    }
    
    public class ResponseData {
        @AuraEnabled public List<DataBean> dataBeans; 
        @AuraEnabled public List<String> billingGroupNames; 
       	public ResponseData() {
          	// Default constructor  
        }
    }
    
    @AuraEnabled
    public static FetchVoiceLineItemBean fetchVoiceLineItems(String pVoiceId) {
        FetchVoiceLineItemBean fetchVoiceLineItem = new FetchVoiceLineItemBean();
        List<VoiceLineItemBean> VoiceLineItemBeanList = new List<VoiceLineItemBean>();
        List <Voice_Line_Item__c> voiceLineItemList = [SELECT Id, Voice__c,Billing_Zone__c,Billing_Zone__r.name,Voice_MT_Min__c,Billing_Group_1__c,Value_1__c,Billing_Group_2__c,Value_2__c,Billing_Group_3__c,Value_3__c,Billing_Group_4__c,Value_4__c,Billing_Group_5__c,Value_5__c From Voice_Line_Item__c where voice__c =:pVoiceId];
        List <Voice_Line_Item__c> billingGroupItemList = [SELECT Billing_Group_1__c, Billing_Group_2__c, Billing_Group_3__c, Billing_Group_4__c, Billing_Group_5__c From Voice_Line_Item__c where voice__c =:pVoiceId limit 1];
        
        // populate billingGroupNames and include it into lineItemBean
        List<String> billingGroupNames = new List<String>();
        for (Voice_Line_Item__c billingGroupItem: billingGroupItemList) {            
            billingGroupNames.add(billingGroupItem.Billing_Group_1__c);
            billingGroupNames.add(billingGroupItem.Billing_Group_2__c);
            billingGroupNames.add(billingGroupItem.Billing_Group_3__c);
            billingGroupNames.add(billingGroupItem.Billing_Group_4__c);
            billingGroupNames.add(billingGroupItem.Billing_Group_5__c);
		}
        fetchVoiceLineItem.billingGroupNames = billingGroupNames;
        system.debug('billingGroupNames: ' + billingGroupNames);
        
        for (Voice_Line_Item__c voiceLineItem: voiceLineItemList) {
            VoiceLineItemBean lineItemBean= new VoiceLineItemBean();
            lineItemBean.voiceLineItemRecord = voiceLineItem;
            
            // populate billingGroupValues and include it into lineItemBean
            List<String> billingGroupValues = new List<String>();
            billingGroupValues.add(String.valueOf(voiceLineItem.Value_1__c));
            billingGroupValues.add(String.valueOf(voiceLineItem.Value_2__c));
            billingGroupValues.add(String.valueOf(voiceLineItem.Value_3__c));
            billingGroupValues.add(String.valueOf(voiceLineItem.Value_4__c));
            billingGroupValues.add(String.valueOf(voiceLineItem.Value_5__c));
            //lineItemBean.billingGroupValues.addAll(billingGroupValues);
            lineItemBean.billingGroupValues = billingGroupValues;
            
            VoiceLineItemBeanList.add(lineItemBean);
        }
        fetchVoiceLineItem.voiceLineItemBeans =  VoiceLineItemBeanList;
        return fetchVoiceLineItem ;
    }
    
    public class VoiceLineItemBean {
        @AuraEnabled public Voice_Line_Item__c voiceLineItemRecord;
        @AuraEnabled public List<String> billingGroupValues;       
        public VoiceLineItemBean() {
          	// Default constructor  
        }
    }
    
    public class FetchVoiceLineItemBean {
        @AuraEnabled public List<VoiceLineItemBean> voiceLineItemBeans;
        @AuraEnabled public List<String> billingGroupNames;
        public FetchVoiceLineItemBean() {
            // Default constructor
        }
    }
    
    // Check existing voice line items
    @AuraEnabled 
    public static boolean isVoiceRecordExists(String pVoiceId) {        
       	system.debug('Apex Controller.isVoiceRecordExists() starts');
        system.debug('pVoiceId: ' + pVoiceId);
        Integer existingVoiceRecordCount = Database.countQuery('SELECT COUNT() FROM Voice_Line_Item__c where Voice__c = \'' + pVoiceId + '\'');
		system.debug('Existing saved records count: ' + existingVoiceRecordCount);
        if (existingVoiceRecordCount > 0) {
            return true;
        }
       	system.debug('Apex Controller.isVoiceRecordExists() ends');
        return false;
   	}
    
    @AuraEnabled 
    public static AuraProcessingMessage insertVoiceLineItems(Integer pZoneIndex, String pVoiceId,
			String pBillingZoneId, Decimal pVoiceMTMin, Decimal pVoiceMTMinInclServ, List<String> pBillingGroupNames, 
            List<String> pGroupMinPriceArray, String pVoiceRounding) {
        
       	system.debug('Apex Controller.insertVoiceLineItems() starts');
        //Initializing the wrapper message 
        AuraProcessingMessage returnMessage = new AuraProcessingMessage();
        
        system.debug('pZoneIndex: ' + pZoneIndex);
        system.debug('pVoiceId: ' + pVoiceId);
        system.debug('pBillingZoneId: ' + pBillingZoneId);
        system.debug('pVoiceMTMin: ' + pVoiceMTMin);
        system.debug('pVoiceMTMinInclServ: ' + pVoiceMTMinInclServ);
        system.debug('pBillingGroupNames: ' + pBillingGroupNames);
        system.debug('pGroupMinPriceArray: ' + pGroupMinPriceArray);
        system.debug('pVoiceRounding: ' + pVoiceRounding);
        
     	List<Voice_Line_Item__c> voiceLineItemRec = [Select id from Voice_Line_Item__c where Voice__c =:pVoiceId and Billing_Zone__c =:pBillingZoneId];
		system.debug('To be saved records count: ' + voiceLineItemRec.size());
        if (voiceLineItemRec.size() == 0) {
            Voice_Line_Item__c voiceLineItem = new Voice_Line_Item__c();
            voiceLineItem.Voice__c = pVoiceId;
            voiceLineItem.Billing_Zone__c = pBillingZoneId;
            voiceLineItem.Voice_MT_Min__c = pVoiceMTMin;
            voiceLineItem.Voice_MT_Min_Included_Services__c = pVoiceMTMinInclServ;
            voiceLineItem.Voice_Rounding__c = pVoiceRounding;
            
            // Hard coding with static approach, due to bad database architecture
            if (pBillingGroupNames.size() > 0) {voiceLineItem.Billing_Group_1__c = pBillingGroupNames[0];voiceLineItem.Value_1__c = Decimal.valueOf(pGroupMinPriceArray[0]);}
            if (pBillingGroupNames.size() > 1) {voiceLineItem.Billing_Group_2__c = pBillingGroupNames[1];voiceLineItem.Value_2__c = Decimal.valueOf(pGroupMinPriceArray[1]);}
            if (pBillingGroupNames.size() > 2) {voiceLineItem.Billing_Group_3__c = pBillingGroupNames[2];voiceLineItem.Value_3__c = Decimal.valueOf(pGroupMinPriceArray[2]);}
            if (pBillingGroupNames.size() > 3) {voiceLineItem.Billing_Group_4__c = pBillingGroupNames[3];voiceLineItem.Value_4__c = Decimal.valueOf(pGroupMinPriceArray[3]);}           
            if (pBillingGroupNames.size() > 4) {voiceLineItem.Billing_Group_5__c = pBillingGroupNames[4];voiceLineItem.Value_5__c = Decimal.valueOf(pGroupMinPriceArray[4]);}   
            if (pBillingGroupNames.size() > 5) {voiceLineItem.Billing_Group_6__c = pBillingGroupNames[5];voiceLineItem.Value_6__c = Decimal.valueOf(pGroupMinPriceArray[5]);}             
            
            try {
                system.debug('VoiceLineItem: '+ voiceLineItem);
                insert voiceLineItem;
                successCount++;
                system.debug('successCount: ' + successCount);        	
                returnMessage.successMsg = successCount + ' record(s) has been saved.';
                returnMessage.isSuccess = true;
            } catch(Exception ex) {
                system.debug('Debug Exception Message' + ex.getMessage());
                // Adding the error message if an exception is occured
                returnMessage.errorMsg = 'Error while saving data: ' + ex.getMessage();
            }
        } else {
        	returnMessage.errorMsg = ' Error while saving data: Record(s) already exists for this voice (Id: ' + pVoiceId + '). '
                + 'For further insertion, please remove all the existing record(s).';
        }
        system.debug('Apex Controller.insertVoiceLineItems() ends');
        return returnMessage;
    }
    
    // Update voice line items
    @AuraEnabled 
    public static AuraProcessingMessage updateVoiceLineItems(Integer pZoneIndex, String pVoiceLineItemId,
			String pBillingZoneId, Decimal pVoiceMTMin, Decimal pVoiceMTMinInclServ, List<String> pBillingGroupNames, 
            List<String> pGroupMinPriceArray, String pVoiceRounding) {
        
       	system.debug('Apex Controller.updateVoiceLineItems() starts');
        //Initializing the wrapper message 
        AuraProcessingMessage returnMessage = new AuraProcessingMessage();
        
        system.debug('pZoneIndex: ' + pZoneIndex);
        system.debug('pVoiceLineItemId: ' + pVoiceLineItemId);
        system.debug('pBillingZoneId: ' + pBillingZoneId);
        system.debug('pVoiceMTMin: ' + pVoiceMTMin);
        system.debug('pVoiceMTMinInclServ: ' + pVoiceMTMinInclServ);
        system.debug('pBillingGroupNames: ' + pBillingGroupNames);
        system.debug('pGroupMinPriceArray: ' + pGroupMinPriceArray);
        system.debug('pVoiceRounding: ' + pVoiceRounding);
        
     	Integer recordCount = Database.countQuery('SELECT COUNT() FROM Voice_Line_Item__c where ID = \'' + pVoiceLineItemId + '\'');
		system.debug('To be saved records count: ' + recordCount);
        if (recordCount == 1) {
            Voice_Line_Item__c voiceLineItem = new Voice_Line_Item__c();
            voiceLineItem.Id = pVoiceLineItemId;
            voiceLineItem.Billing_Zone__c = pBillingZoneId;
            voiceLineItem.Voice_MT_Min__c = pVoiceMTMin;
            voiceLineItem.Voice_MT_Min_Included_Services__c = pVoiceMTMinInclServ;
            voiceLineItem.Voice_Rounding__c = pVoiceRounding;
            
            // Hard coding with static approach, due to bad database architecture
            if (pBillingGroupNames.size() > 0) {voiceLineItem.Billing_Group_1__c = pBillingGroupNames[0];voiceLineItem.Value_1__c = Decimal.valueOf(pGroupMinPriceArray[0]);}
            if (pBillingGroupNames.size() > 1) {voiceLineItem.Billing_Group_2__c = pBillingGroupNames[1];voiceLineItem.Value_2__c = Decimal.valueOf(pGroupMinPriceArray[1]);}
            if (pBillingGroupNames.size() > 2) {voiceLineItem.Billing_Group_3__c = pBillingGroupNames[2];voiceLineItem.Value_3__c = Decimal.valueOf(pGroupMinPriceArray[2]);}
            if (pBillingGroupNames.size() > 3) {voiceLineItem.Billing_Group_4__c = pBillingGroupNames[3];voiceLineItem.Value_4__c = Decimal.valueOf(pGroupMinPriceArray[3]);}           
            if (pBillingGroupNames.size() > 4) {voiceLineItem.Billing_Group_5__c = pBillingGroupNames[4];voiceLineItem.Value_5__c = Decimal.valueOf(pGroupMinPriceArray[4]);}   
            if (pBillingGroupNames.size() > 5) {voiceLineItem.Billing_Group_6__c = pBillingGroupNames[5];voiceLineItem.Value_6__c = Decimal.valueOf(pGroupMinPriceArray[5]);}             
            
            try {
                system.debug('VoiceLineItem: '+ voiceLineItem);
                update voiceLineItem;
                successCount++;
                system.debug('successCount: ' + successCount);        	
                returnMessage.successMsg = successCount + ' record(s) has been saved.';
                returnMessage.isSuccess = true;
            } catch(Exception ex) {
                system.debug('Debug Exception Message' + ex.getMessage());
                // Adding the error message if an exception is occured
                returnMessage.errorMsg = 'Error while saving data: ' + ex.getMessage();
            }
        } else {
        	returnMessage.errorMsg = 'Error while saving data: Record doesn\'t exist';
        }
        system.debug('Apex Controller.updateVoiceLineItems() ends');
        return returnMessage;
    }
    
    @AuraEnabled 
    public static List < Zone__c > getBillingGroupDetails(){
        List<Zone__c> billingGroups=[select Name,Id,Zone_Type__c from Zone__c where Zone_Type__c ='Billing Group'];
        return billingGroups;
    }
    
    @AuraEnabled 
    public static List < Zone__c > getBillingZoneDetails(){
        List<Zone__c> billingGroups=[select Name,Id,Zone_Type__c from Zone__c where Zone_Type__c ='Billing Zone'];
        return billingGroups;
    }
    
    @AuraEnabled 
    public static List < Zone__c > getBillingZonesByIds(List<String> pSelectedBillingZoneIds) {
        system.debug('pSelectedBillingZoneIds: ' + pSelectedBillingZoneIds);
        List<Zone__c> billingZones=[select Name, Id, Zone_Type__c from Zone__c where Id IN :pSelectedBillingZoneIds];
        system.debug('billingZones: ' + billingZones);
        return billingZones;
    }
    
    @AuraEnabled 
    public static List < Zone__c > getBillingGroupsByIds(List<String> pSelectedBillingGroupIds) {
        system.debug('pSelectedBillingGroupIds: ' + pSelectedBillingGroupIds);
        List<Zone__c> billingGroups=[select Name, Id, Zone_Type__c from Zone__c where Id IN :pSelectedBillingGroupIds];
        system.debug('billingGroups: ' + billingGroups);
        return billingGroups;
    }
    
    @AuraEnabled   
    public static List<String> getVoiceRounding(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Voice_Line_Item__c.Voice_Rounding__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    // This is our wrapper/container class.
    public class BillingData {
        public String billingZone {get; set;}
        public String billingGroup {get; set;}
        public String billingPrice {get; set;}
        
        //This is the contructor method. 
        public BillingData(String pZone, String pGroup, String pPrice) {
            billingZone = pZone;
            billingGroup = pGroup;
            billingPrice = pPrice;
        }
    }
    
    // Delete voice line items
    @AuraEnabled
    public static AuraProcessingMessage deleteVoiceLineItem(List<String> pRecordIds) {
        
        system.debug('Apex Controller: deleteVoiceLineItem() starts');
        system.debug('Parameter RecordIds: ' + pRecordIds);
        //Initializing the wrapper message 
        AuraProcessingMessage returnMessage = new AuraProcessingMessage();
        
        //Query Records for delete where id in lstRecordId [which is pass from client side controller] 
        List<Voice_Line_Item__c> voiceLineItemRecords = [SELECT Id FROM Voice_Line_Item__c where ID IN :pRecordIds];
        system.debug('voiceLineItemRecords: ' + voiceLineItemRecords);
        /*
         * Delete contact list with Database.DeleteResult[] database class.
         * It deletes some queried contacts using <samp class="codeph apex_code">Database.<span class="statement">delete</span></samp> 
         * with a false second parameter to allow partial processing of records on failure.
         * Next, it iterates through the results to determine whether the operation was successful or not
         * for each record. and check if delete contact successful so print msg on debug, 
         * else add error message to errorMsg List and return the list  
         */
        Database.DeleteResult[] DR_Dels = Database.delete(voiceLineItemRecords, false);
        
        Integer deletedRecordCount = 0;
        //Iterate through each returned result
        for (Database.DeleteResult dr: DR_Dels) {
            if (dr.isSuccess()) {
                deletedRecordCount++;
            }
        }
        
        system.debug('deletedRecordCount: ' + deletedRecordCount);
        // Compare totalCount with deletedRecordCount
        if (pRecordIds.size() == deletedRecordCount) {
            // Operation was successful
            returnMessage.isSuccess = true;
        }
        
        if (returnMessage.isSuccess) {
            returnMessage.successMsg = ' Delete operation is successful. ' + deletedRecordCount + ' record(s) deleted.';
            system.debug('Apex Controller: deleteVoiceLineItem() | Success message: ' + returnMessage.successMsg);
        } else {
            returnMessage.errorMsg = ' Delete operation has been failed.';
            system.debug('Apex Controller: deleteVoiceLineItem() | Failure message: ' + returnMessage.errorMsg);
        }
        system.debug('Apex Controller: deleteVoiceLineItem() ends');
       	return returnMessage;
    }
}