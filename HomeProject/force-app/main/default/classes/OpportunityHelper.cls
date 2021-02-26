/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-26-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-25-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class OpportunityHelper {

    @AuraEnabled
    public static List<OpportunityLineItem> getProductsList(String opportunityId) {
        return  [SELECT Id, Name, ProductCode, UnitPrice
                FROM OpportunityLineItem
                WHERE OpportunityId =: opportunityId
                WITH SECURITY_ENFORCED];
    }

    @AuraEnabled
    public static Void removeProductsList(String opportunityId) {
        List<OpportunityLineItem> lineItemsList = [SELECT Id
                                                   FROM OpportunityLineItem
                                                   WHERE OpportunityId =: opportunityId
                                                   ];
        if (!lineItemsList.isEmpty()) {
            delete lineItemsList;
        }
    }
}