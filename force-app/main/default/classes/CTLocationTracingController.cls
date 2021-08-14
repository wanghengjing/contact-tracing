public with sharing class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitors(String locationId){
        List<Location_Tracing__c> locaTracingList= [SELECT Id, Location__c, Person__c, Visit_Date__c 
                                                    FROM Location_Tracing__c
                                                    WHERE Location__r.id = :locationId
                                                    ORDER BY Visit_Date__c DESC NULLS LAST
                                                    ];
        return locaTracingList;
    }

    public static List<Location_Tracing__c> getLocationByPersonIds(Set<id> personIds){
        List<Location_Tracing__c> locaTracingList= [SELECT Id, Location__c, Person__c, Visit_Date__c 
                                                    FROM Location_Tracing__c
                                                    WHERE Person__r.id IN :personIds
                                                    AND Visit_Date__c = LAST_N_DAYS:10
                                                    ];
        return locaTracingList;
    }

    public static List<Location_Tracing__c> getLocationByLocationIds(Set<id> LocationIds){
        List<Location_Tracing__c> locaTracingList= [SELECT Id, Location__c, Person__c, Visit_Date__c 
                                                    FROM Location_Tracing__c
                                                    WHERE Location__r.id IN :LocationIds
                                                    AND Person__r.Health_Status__c = 'Green'
                                                    AND Visit_Date__c = LAST_N_DAYS:10
                                                    ];
        return locaTracingList;
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces){
        Set<Id> personIdSet = new Set<Id>();
        Set<Id> locationIdSet = new Set<Id>();
        Map<Id,Set<Id>> exitstIdMap = new Map<Id,Set<Id>>();

        for(Location_Tracing__c locationTracing: locationTraces){
            personIdSet.add(locationTracing.Person__c);
            locationIdSet.add(locationTracing.Location__c);
        }

        List<Location_Tracing__c> locationTracingList = [SELECT Id, Person__c, Location__c, Visit_Date__c 
                                                            FROM Location_Tracing__c
                                                            WHERE Person__c IN :personIdSet
                                                            AND Location__c IN :locationIdSet
                                                            ];
        List<Location_Tracing__c> finalTracingList = new List<Location_Tracing__c>();

        if (locationTracingList != NULL && locationTracingList.size()>0) {
            /*for(Location_Tracing__c locationTracing:locationTraces){
                for(Location_Tracing__c locationOrinal:locationTracingList){
                    if(locationTracing.Person__c == locationOrinal.Person__c && locationTracing.Location__c == locationOrinal.Location__c){
                        finalTracingList.add(locationTracing);
                    }
                }
            }*/
            for(Location_Tracing__c locationTracing:locationTracingList){
                if (!exitstIdMap.containsKey(locationTracing.Location__c)) {
                    exitstIdMap.put(locationTracing.Location__c, new Set<Id>());
                }
                exitstIdMap.get(locationTracing.Location__c).add(locationTracing.Person__c);
            }

            for(Location_Tracing__c locationTracing:locationTraces){
                if (exitstIdMap.containsKey(locationTracing.Location__c) && exitstIdMap.get(locationTracing.Location__c).contains(locationTracing.Person__c)) {
                    finalTracingList.add(locationTracing);
                }
            }

        }
        return finalTracingList;

    }

}