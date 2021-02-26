/**
 * @description       : Class Test of OpportunityHelper
 * @author            : Alejandro Rodriguez Cruz
 * @last modified on  : 02-26-2021
**/
@IsTest
private class OpportunityHelperTest {
    private static final String NAME_ACCOUNT = 'testAccount';
    private static final String NAME_PRODUCT = 'testProduct';
    private static final String FAMILY_PRODUCT = 'Hardware';
    private static final String NAME_OPPORTUNITY = 'testOpportunity';
    private static final String STAGE_OPPORTUNITY = 'Qualification';


    @TestSetup
    static void Setup() {
        Account acc = new Account(Name = NAME_ACCOUNT);
        insert acc;

        Opportunity opp = new Opportunity(Name = NAME_OPPORTUNITY,
                                        CloseDate = System.today(),
                                        AccountId = acc.Id,
                                        Pricebook2Id = Test.getStandardPricebookId(),
                                        StageName = STAGE_OPPORTUNITY);
        insert opp;

        List<Product2> listProducts = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            Product2 prod = new Product2(Name = NAME_PRODUCT + i, Family = FAMILY_PRODUCT);
            listProducts.add(prod);
        }
        insert listProducts;

        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> listPricebookEntry = new List<PricebookEntry>();
        for (Product2 productRecord : listProducts) {
            PricebookEntry standardPrice = new PricebookEntry(
                                            Pricebook2Id = pricebookId, Product2Id = productRecord.Id,
                                            UnitPrice = 10000, IsActive = true);
            listPricebookEntry.add(standardPrice);
        }
        insert listPricebookEntry;

        List<OpportunityLineItem> listLineItems = new List<OpportunityLineItem>();
        for (Product2 productRecord : listProducts) {
            OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.Id,
                                        PricebookEntryId = listPricebookEntry[0].Id, Product2Id = productRecord.Id,
                                        Quantity = 10, TotalPrice = 100);
            listLineItems.add(lineItem);
        }
        insert listLineItems;
    }

    @IsTest
    static void getProductsListTest() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =: NAME_OPPORTUNITY];
        Test.startTest();
            List<OpportunityLineItem> listOppLineItems = OpportunityHelper.getProductsList(opp.Id);
        Test.stopTest();

        System.assertNotEquals(listOppLineItems.size(), 0);
    }

    @IsTest
    static void removeProductsListTest() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name =: NAME_OPPORTUNITY];
        List<OpportunityLineItem> listOppLineItems = OpportunityHelper.getProductsList(opp.Id);
        System.assertNotEquals(listOppLineItems.size(), 0);

        Test.startTest();
            OpportunityHelper.removeProductsList(opp.Id);
        Test.stopTest();

        listOppLineItems = OpportunityHelper.getProductsList(opp.Id);
        System.assertEquals(listOppLineItems.size(), 0);
    }
}