public with sharing class CTPersonController {


    public static String getToken(String mobile){
        // generate unique hash using md5 algorithm
        Blob value = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', value);
        // return encoded string
        return EncodingUtil.base64Encode(hash);
    }

    public static List<Person__c> getRecentHealthChanges(){
        List<Person__c> persons =  [SELECT Id, Mobile__c, Name, Status_Update_Date__c, Token__c, Health_Status__c 
                FROM Person__c 
                ORDER BY Status_Update_Date__c
                LIMIT 100];
        return persons;
    }

    public static List<Person__c> searchPeople(String searchTerm){
        String finalStr = '%'+searchTerm+'%';
        List<Person__c> persons =  [SELECT Id, Mobile__c, Name, Status_Update_Date__c, Token__c, Health_Status__c 
                FROM Person__c 
                WHERE name LIKE :finalStr or mobile__c LIKE :finalStr or token__c like :finalStr
                ORDER BY Status_Update_Date__c DESC NULLS LAST
                ];
        return persons;
    }

    public static Person__c getPersonById(String personId){
        List<Person__c> persons = [
                SELECT Id, Mobile__c, Name, Status_Update_Date__c, Token__c, Health_Status__c 
                FROM Person__c 
                WHERE Id =: personId
        ];
        Person__c person = new Person__c();
        if(persons != NUll && persons.size()>0){
            person = persons[0];
        }else {
            person = NUll;
        }
        return person;
    }

    public static Map<String, Integer> getHealthStatusCount() {
        AggregateResult[] healthStatusCount = [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c];

        if (healthStatusCount != null && healthStatusCount.size() > 0) {
            Map<String, Integer> healthCountMap = new Map<String, Integer>();
            for (AggregateResult ar : healthStatusCount) {
                String status = String.valueOf(ar.get('Health_Status__c'));
                Integer count = Integer.valueOf(ar.get('total'));
                healthCountMap.put(status, count);
            }
            return healthCountMap;
        }
        return null;
    }

    public static Set<Id> getCohabitants(Set<Id> personIds){
        List<String> healthStatuses = new List<String> {'Green','Yellow'};
        List<People_Tracing__c> relevantPeopleTracingList = [SELECT Person_1__c, Person_1__r.Name,Contact_Type__c, Person_2__c,Person_2__r.Name 
                                                        FROM People_Tracing__c
                                                        WHERE (Person_1__c IN :personIds OR Person_2__c IN :PersonIds)
                                                        AND Contact_Type__c = 'Cohabitant'
                                                        AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                    ];
        Set<Id> cohabitantIdSets = new Set<Id>();
        for (People_Tracing__c pt : relevantPeopleTracingList) {
            if(!PersonIds.contains(pt.Person_1__c)){
                cohabitantIdSets.add(pt.Person_1__c);
            }

            if(!PersonIds.contains(pt.Person_2__c)){
                cohabitantIdSets.add(pt.Person_2__c);
            }
        }
        return cohabitantIdSets;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds) {
        List<String> healthStatuses = new List<String> {'Green','Yellow'};
        List<People_Tracing__c> relevantPeopleTracingList = [SELECT Person_1__c, Person_1__r.Name, Contact_Type__c, Contact_Date__c,Person_2__c, Person_2__r.Name 
                                                                FROM People_Tracing__c
                                                                WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
                                                                AND Contact_Date__c = LAST_N_DAYS:10
                                                                AND Contact_Type__c = 'Other'
                                                                AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                                ];
        Set<Id> cohabitantIdSets = new Set<Id>();
        for (People_Tracing__c pt : relevantPeopleTracingList) {
            if(!PersonIds.contains(pt.Person_1__c)){
                cohabitantIdSets.add(pt.Person_1__c);
            }

            if(!PersonIds.contains(pt.Person_2__c)){
                cohabitantIdSets.add(pt.Person_2__c);
            }
        }
        return cohabitantIdSets;
    }

}