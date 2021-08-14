public with sharing class CTPersonTriggerHandler {
    public static void beforeInsert(List<Person__c> personList ){
        for (Person__c person : personList) {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    public static void beforeUpdate(List<Person__c> personList, Map<Id,Person__c > personMap){
        for (Person__c person : personList) {
            if (person.Health_Status__c != personMap.get(person.id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
        
    }

    public static void afterUpdate(List<Person__c> personList, Map<Id,Person__c > personMap){
        Set<Id> personIdSet = new Set<Id>();
        for (Person__c person : personList) {
            if(person.Health_Status__c =='Red' && personMap.get(person.id).Health_Status__c !='Red' ){
                personIdSet.add(person.Id);
            }
        }

        // List<Person__c> cohabitantList = [SELECT Health_Status__c 
        //                                     FROM Person__c
        //                                     WHERE Id IN :cohabitantSets
        //                                     ];
        // for(Person__c person:cohabitantList){
        //     person.Health_Status__c = 'Orange';
        // }           
        // update  cohabitantList;                    

        
    }
    public static void test(){
        Set<Id> paraIds = new Set<Id>();
        paraIds.add('a085g0000015ATGAA2');paraIds.add('a085g0000015ATLAA2');

        List<String> healthStatuses = new List<String> {'Green','Yellow'};
        List<People_Tracing__c> peopleTracingList = [SELECT Person_1__c, Person_1__r.Name,Contact_Type__c, Person_2__c,Person_2__r.Name 
                                                        FROM People_Tracing__c
                                                        WHERE (Person_1__c IN :paraIds OR Person_2__c IN :paraIds)
                                                        AND Contact_Type__c = 'Cohabitant'
                                                        AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                    ];
        Set<Id> cohabitantSets = new Set<Id>();
        for (People_Tracing__c peopleTracing : peopleTracingList) {
            if(!paraIds.contains(peopleTracing.Person_1__c)){
                cohabitantSets.add(peopleTracing.Person_1__c);
            }

            if(!paraIds.contains(peopleTracing.Person_2__c)){
                cohabitantSets.add(peopleTracing.Person_2__c);
            }
        }

        System.debug(cohabitantSets);
    }
    
}
