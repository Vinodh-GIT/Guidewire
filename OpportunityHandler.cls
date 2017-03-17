public without sharing class OpportunityHandler extends ObjectHandler {

	//The class constructor, initializes the super class
    public OpportunityHandler(List<Opportunity> sObjectList) {
        // Initializes the ObjectHandler
        super(sObjectList);
    }
//  ------------------------------------------------------------------------------------------------------------------
	// Constructor class, this is used to allow the ObjectHandler to dynamically instantiate the target object handler class, in this case OpportunityHandler.
    public class Constructor implements ObjectHandler.IConstructable {
        public ObjectHandler construct(List<SObject> sObjectList) {
            return new OpportunityHandler(sObjectList);
        }
    }
//---------------------------------------------------------------------------------------------------------------------

    // Override of ObjectHandler onBeforeInsert.
    public override void onBeforeInsert() {

        convertCurrency((List<Opportunity>) Records);
    }

//---------------------------------------------------------------------------------------------------------------------
	//Override of ObjectHandler onBeforeUpdate
    public override void onBeforeUpdate(Map<Id, SObject> mapOldOppty) {
        Map<Id, Opportunity> oldOpptyMap = (Map<Id, Opportunity>)mapOldOppty;
        List<Opportunity> oppList = (List<Opportunity>) Records;
    	for (Opportunity opp : oppList) {
        	if (oldOpptyMap.get(opp.Id).Amount == opp.Amount){
         		convertCurrency((List<Opportunity>) Records);	       
            }
        }       
    }

//  ------------------------------------------------------------------------------------------------------------------
    //This method sets Global_Region__c on Opportunity from the related account.
    private static void convertCurrency(List<Opportunity> Records) {
        
    	List<DatedConversionRate> dcrList = new List<DatedConversionRate>();
        dcrList = [select id, ConversionRate, IsoCode, NextStartDate, StartDate from DatedConversionRate];
        for (Opportunity opp : Records) {
        	List<DatedConversionRate> dList = new List<DatedConversionRate>();
            for (DatedConversionRate d : dcrList) {
            	if (opp.CloseDate != null && opp.Local_Currency__c != null) {
                	if (opp.CloseDate >= d.StartDate && opp.CloseDate < d.NextStartDate && opp.CurrencyIsoCode.equalsIgnoreCase(d.IsoCode)) {
                    	dList.add(d);
                     }
                 }
             }
			if (dList.size() > 0 && opp.Amount > 0 && opp.Amount != null) {
            	opp.Amount_USD__c = opp.Amount / dList.get(0).ConversionRate ;
            }
        }
 	}

//  -------------------------------------------------------------------------------------------------------------------
}