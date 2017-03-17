# Guidewire
Guidewire software has sales offices across the globe to support global business. Sales rep create opportunities to track deals and record opportunity amount. For example, sales rep in US creates opportunity & records amount in USD, and sales rep in UK records amount in GBP.  The Account owner should be able to see the total amount from all opportunities in USD.
 
In salesforce, the corporate currency is set to USD. Multicurrency and dated exchange rate are enabled too to support global business model.
 
Task :
Create Rollup summary field Total Value of Won Opportunities (label), Total_Value_of_Won_Opps_derived__c (Api) in Account Object.
Use sum(Amount_USD__c) in the rollup field for Closed won opportunities.
 
Create currency field (15,2) Amount_USD__c in opportunity object.
 
Create before insert, before update trigger on Opportunity to convert opportunity amount that are in different currencies to USD and update the USD in Amount_USD__c based on the dated exchange rate tied to closed date on the opportunity. The trigger should invoke apex class which will contain all the code. 
 
Create test class for 90% code coverage.
