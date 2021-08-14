public with sharing class CTLocationTriggerHander {
    public static void afterUpdate(List<Location__c> locations, Map<Id, Location__c> oldLocations) {
        Set<Id> redLocationIds = new Set<Id>();
        for (Location__c location : locations) {
            if (location.Status__c == 'Red' && oldValues.get(location.Id).Status__c != 'Red') {
                redLocationIds.add(location.Id);
            }
        }
        [SELECT  name 
            FROM Location_Tracing__c
            WHERE Id IN :redLocationIds
            AND Visit_Date__c = LAST_N_DAYS:10
        ];
    }
}
