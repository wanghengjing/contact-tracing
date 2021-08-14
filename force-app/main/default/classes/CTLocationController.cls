public with sharing class CTLocationController {

    public static List<Location__c> getRecentStatusChanges(){
        List<Location__c> locationList = [
            SELECT Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c
            ORDER BY Status_Update_Date__c NULLS LAST
            LIMIT 100
        ];
        return locationList;
    }

    public static List<Location__c> searchLocations(String searchTerm){
        String finalStr = '%'+searchTerm+'%';
        List<Location__c> locationList = [
            SELECT Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c
            WHERE Name LIKE :finalStr OR Pincode__c LIKE :finalStr OR Address__c LIKE :finalStr
            ORDER BY Status_Update_Date__c NULLS LAST
        ];
        return locationList;
    }

    public static Location__c getLocationById(String locationId){
        List<Location__c> locationList = [
            SELECT Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c
            WHERE Id = :locationId
        ];
        Location__c location = new Location__c();
        if (locationList != NULL && locationList.size()>0) {
            location = locationList[0];
        }else {
            location = NULL;
        }

        return location;
    }
    
}