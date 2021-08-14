public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String recordId) {
        return [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE Person_1__c = :recordId OR Person_2__c = :recordId
            ORDER BY Contact_Date__c DESC NULLS LAST
        ];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces) {
        // unique records ids
        Set<Id> recordIds = new Set<Id>();
        for (People_Tracing__c trace : peopleTraces) {
            recordIds.add(trace.Person_1__c);
            recordIds.add(trace.Person_2__c);
        }
        //list of duplicate records
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
        // map of existing records to match
        Map<Id, Set<Id>> mapOfExistingRecord = new Map<Id, Set<Id>>();

        List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c IN :recordIds OR Person_2__c IN :recordIds];

        if (existingRecords != null && existingRecords.size() > 0) {
            for (People_Tracing__c trace : existingRecords) {
                // build map for person 1
                if (!mapOfExistingRecord.containsKey(trace.Person_1__c)) {
                    mapOfExistingRecord.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecord.get(trace.Person_1__c).add(trace.Person_2__c);
                // build map for person 2
                if (!mapOfExistingRecord.containsKey(trace.Person_2__c)) {
                    mapOfExistingRecord.put(trace.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecord.get(trace.Person_2__c).add(trace.Person_1__c);
            }

            // loop over all the records to find duplicate
            for (People_Tracing__c trace : peopleTraces) {
                // check if record is duplicate
                if (
                    (mapOfExistingRecord.containsKey(trace.Person_1__c) && mapOfExistingRecord.get(trace.Person_1__c).contains(trace.Person_2__c)) ||
                    (mapOfExistingRecord.containsKey(trace.Person_2__c) && mapOfExistingRecord.get(trace.Person_2__c).contains(trace.Person_1__c))
                ) {
                    duplicates.add(trace);
                }
            }
        }
        return duplicates;
    }

}