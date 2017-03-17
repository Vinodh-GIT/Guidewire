@isTest
public class OpportunityHandler_Test {
    
    @isTest static void testOpportunityCurrencyConversion(){
        Test.startTest();
		Account testAccount = getAccountInstance();
        insert testAccount;
        Opportunity testOppty = getOpportunityInstance(testAccount.Id);
        insert testOppty;
        testOppty.Amount = 8000;
        update testOppty;
        Test.stopTest();
    }
   
	public static Account getAccountInstance() {
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test Account';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Jersey City';
        oAccount.BillingState = 'NJ';
        oAccount.BillingPostalCode = '07310';
        oAccount.BillingCountry='US';
        oAccount.Industry = 'Government - Federal';
        oAccount.ShippingStreet ='123 Unit Test Street'; 
        oAccount.ShippingState = 'NJ';
        oAccount.ShippingPostalCode = '07310';
        oAccount.ShippingCountry ='US';
        oAccount.ShippingCity='Jersey City';
        //oAccount.CurrencyIsoCode = 'USD';
        return oAccount;
    }
    
    public static Opportunity getOpportunityInstance(Id accountId) {
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = accountId;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Closed Won';
		oOpportunity.Amount = 5000;
        return oOpportunity;
    }
    
}

